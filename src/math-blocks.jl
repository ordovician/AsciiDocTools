export replace_math
export findstemblocks
export Equation
export savelatexfiles

using LatexSVG, Printf

struct Equation
   text::String
   lineno::Int
   index::Int 
end

"""
    savelatexfiles(filepath, equations)
Use output from `findstemblocks` to create latex svg files in subdir with
same name as file in `filepath`.
"""
function savelatexfiles(filepath::AbstractString, equations::AbstractArray{Equation})
    dir = dirname(filepath)
    subdir, _ = splitext(basename(filepath))
    dstpath = mkpath(joinpath(dir, subdir))
    filesnames = String[]
    cd(dstpath) do
        for eq in equations
            svg = latexsvg(raw"$$" * eq.text * raw"$$")
            filename = @sprintf("%02d-%04d.svg", eq.index, eq.lineno)
            push!(filesnames, filename)
            savesvg(filename, svg)
        end
        open("mapping.txt", "w") do io
           for file in filesnames
               println(io, file)
           end 
        end
    end
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
    
    equations = Equation[]
    i = 1
    j = 0
    while i <= length(rows) - 2
       if startswith(lines[rows[i]], "[stem]") &&
          startswith(lines[rows[i+1]], "++++") &&
          startswith(lines[rows[i+2]], "++++")
          str = join(lines[rows[i+1]+1:rows[i+2]-1], "\n")
          j += 1
          equation = Equation(str, rows[i], j)
          push!(equations, equation)
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