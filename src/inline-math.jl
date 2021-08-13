export relace_inlinemath

"""
    relace_inlinemath(path::AbstractString)
    relace_inlinemath(file::File)
    relace_inlinemath(dir::Dir)
    
Replace markdown inline math such as `$x = 10$` with Markua equivalent.
"""
relace_inlinemath(path::AbstractString) = relace_inlinemath(Path(path))

function relace_inlinemath(file::File)
    out = IOBuffer()
    open(file.path) do io
        while !eof(io)
            s = readuntil(io, "`$")
            print(out, s)
            
            mark(io)
            s = readuntil(io, '`')
            
            # Finally ready to process
            print(out, "stem:[")
            print(out, s)
            print(out, "]")
        end
    end
    seekstart(out)
    s = read(out, String)
    open(file.path, "w") do io
        write(io, s)
    end    
end

relace_inlinemath(dir::Dir) = replace_item(dir, relace_inlinemath)