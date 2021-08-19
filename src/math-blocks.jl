export replace_math

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

replace_math(dir::Dir) = replace_item(dir, replace_math)