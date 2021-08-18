export replace_blurbs

"""
    replace_blurbs(path::AbstractString)
    replace_blurbs(file::File)
    replace_blurbs(dir::Dir)
    
    Replace sections looking like this:

        > **INFO Foobar**
        >
        > main text
    
    With AsciiDoc Sections looking like this:
    
        [NOTE]
        ====
        main text    
        ====
"""
replace_blurbs(path::AbstractString) = replace_blurbs(Path(path))

@enum State FindStart FindEnd

function replace_blurbs(file::File)
    state = FindStart
    lines = readlines(file.path)
    
    open(file.path, "w") do out
        for line in lines
            if state == FindStart && !startswith(line, "> **")
                println(out, line)
            elseif state == FindStart
                state = FindEnd
                tag = strip(in("> *"), line)
                println(out, "[$tag]")
                println(out, "====")
            elseif state == FindEnd && !startswith(line, '>')
                state = FindStart
                println(out, "====")
                println(out, line)
            elseif state == FindEnd
                println(out, lstrip(in("> "), line))
            else
                error("$state is not handled")                      
            end    
        end
    end
end

replace_blurbs(dir::Dir) = replace_item(dir, replace_blurbs)