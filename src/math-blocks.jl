export replace_math
export findstemblocks
export Equation
export savelatexfiles
export replace_equations_with_images
export renamefiles

using LatexSVG, Printf

"""
    replace_equations_with_images(filepath::AbstractString)
Find directory associated with `filepath` and find images of an filename
mappings there
"""
function replace_equations_with_images(filepath::AbstractString)
    subdir, _ = splitext(filepath)
    mappingfile = joinpath(subdir, "mapping.txt")
    filenames = map(filter(!isempty, readlines(mappingfile))) do line
        _, newname = split(line)
        newname
    end
    
    eqs = findstemblocks(filepath)
    
    lines = readlines(filepath)
    open(filepath, "w") do io
        i = 1
        for (eq, filename) in zip(eqs, filenames)
            j, k = first(eq), last(eq)
            
            map(lines[i:j-1]) do line
                println(io, line)
            end
            i = k + 1
            path = joinpath(subdir, filename)
            println(io, "image::$path[align=\"center\"]")
            map(lines[j:k]) do line
                println(io, "// ", line)
            end 
        end
        map(lines[i:end]) do line
            println(io, line)
        end
    end
    nothing
end

"""
    renamefiles(mappingfile::AbstractString
Rename files in current directory according the mapping file.

# Mapping file example

    01-0071.svg trigfuncs.svg
    02-0082.svg sinedef.svg

This will rename `01-0071.svg` to `trigfuncs.svg` and so on.
"""
function renamefiles(mappingfile::AbstractString)
    lines = filter(!isempty, readlines(mappingfile))
    for line in  lines
        oldname, newname = split(line)
        if !isfile(oldname)
            error("Cannot rename '$oldname' to '$newname' because file could not be found in current directory")
        end
        mv(oldname, newname)
    end
end

"""
    savelatexfiles(filepath, equations::AbstractArray{<:AbstractString})
Use output from `findstemblocks` to create latex svg files in subdir with
same name as file in `filepath`.
"""
function savelatexfiles(filepath::AbstractString, equations::AbstractArray{<:AbstractString})
    lines = readlines(filepath)
    dir = dirname(filepath)
    subdir, _ = splitext(basename(filepath))
    dstpath = mkpath(joinpath(dir, subdir))
    filesnames = String[]
    cd(dstpath) do
        for (i, eq) in enumerate(equations)
            svg = latexsvg(raw"$$" * eq * raw"$$")
            file = string(i, ".svg")
            push!(filesnames, file)
            savesvg(file, svg)
        end
        
        # Store name of files made in a mapping file
        open("mapping.txt", "w") do io
           for file in filesnames
               println(io, file)
           end 
        end
    end
    
    filesnames
end

function savelatexfiles(filepath::AbstractString)
    ranges = findstemblocks(filepath)
    lines = readlines(filepath)
    equations = map(ranges) do r
        i, j = first(r), last(r)
        join(lines[i+2:j-1], "\n")
    end
    savelatexfiles(filepath, equations)
end

"""
    findstemblocks(file::File)

This is for finding stem blocks in AsciiDoc itself so not in Markdown.

    [stem]
    ++++
    y = \\sin x 
    ++++
"""
function findstemblocks(filepath::AbstractString)
    lines = readlines(filepath)
    rows = findall(lines) do line
               startswith(line, "[stem]") || 
               startswith(line, "++++")
           end
    
    equations = UnitRange[]
    i = 1
    j = 0
    while i <= length(rows) - 2
       if startswith(lines[rows[i]], "[stem]") &&
          startswith(lines[rows[i+1]], "++++") &&
          startswith(lines[rows[i+2]], "++++")
          # str = join(lines[rows[i+1]+1:rows[i+2]-1], "\n")
          j += 1
          # equation = Equation(str, rows[i], j)
          push!(equations, rows[i]:rows[i+2])
          i += 3
       else
          i += 1
       end
    end
    equations    
end


"""
    replace_math(path::AbstractString)
    replace_math(file::File)
    replace_math(dir::Dir)
    
Replace markdown inline math such as `\$x = 10\$` with Markua equivalent,
as well as math blocks with double dollar sign.
"""
replace_math(path::AbstractString) = replace_math(Path(path))

function replace_math(file::File)
    out = IOBuffer()
    open(file.path) do io
        while !eof(io)
            s = readuntil(io, '$')
            print(out, s)
            
            eof(io) && break
            
            mark(io)
            s = readuntil(io, '$')
            if isempty(s)
                reset(io)
                s = readuntil(io, raw"$$")
                println(out, "[stem]")
                print(out, "++++")
                print(out, s[2:end])
                print(out, "++++")
            else
                # Finally ready to process
                print(out, "stem:[")
                print(out, s)
                print(out, "]")
            end
        end
    end
    seekstart(out)
    s = read(out, String)
    open(file.path, "w") do io
        write(io, s)
    end    
end

replace_math(dir::Dir) = visitdir(replace_math, dir.path)