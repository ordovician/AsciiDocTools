export replace_footnotes

"""
    replace_footnotes(path::AbstractString)
    replace_footnotes(file::File)
    replace_footnotes(dir::Dir)

Replace footnotes such as `[^nibble]` with `{nibble}` and the actual text
description written as `[^nibble]: A nibble...` 
with `:nibble: footnote:[A nibble...`]`  
"""
replace_footnotes(path::AbstractString) = replace_footnotes(Path(path))

function replace_footnotes(file::File)
    out = IOBuffer()
    open(file.path) do io
        while !eof(io)
           s = readuntil(io, "[^")
           print(out, s)
           eof(io) && break
           tag = readuntil(io, "]")
           if peek(io, Char) == ':'
               skipchars(in(": "), io)
               note = readuntil(io, "\n")
               print(out, ':', tag, ": footnote:[", note, ']')
           else
               print(out, '{', tag, '}')
           end
        end
    end
    
    seekstart(out)
    s = read(out, String)
    open(file.path, "w") do io
        print(io, s)
    end 
end

replace_footnotes(dir::Dir) = visitdir(replace_footnotes, dir.path)