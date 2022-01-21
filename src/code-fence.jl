export replace_codeblocks
export replace_replblocks

"""
    replace_codeblocks(path::AbstractString)
    replace_codeblocks(file::File)
    replace_codeblocks(dir::Dir)
    
Replaces Pandoc style code block fences with AsciiDoc style code fences.
So replaces code like this:

    ~~~
    x  = 10
    ~~~

With this style:

    [source,julia]
    ----
    x  = 10
    ----
"""
replace_codeblocks(path::AbstractString) = replace_codeblocks(Path(path))

function replace_codeblocks(file::File)
    out = IOBuffer()
    lineno = 0
    open(file.path) do io
        while !eof(io)
            s = readuntil(io, "~~~\n")
            print(out, s)
            lineno += count(==('\n'), s)
            
            if eof(io)
                break
            end
            
            println(out, "[source,julia]\n----")
            lineno += 1
            s = readuntil(io, "~~~")
            print(out, s)
            lineno += count(==('\n'), s)
            
            print(out, "----")
        end
    end
    seekstart(out)
    s = read(out, String)
    close(out)
    open(file.path, "w") do io
        write(io, s)
    end    
end


# TODO: Refactor as this is very similar to code above. Only difference is
# Searching for ```julia-repl instead of ~~~.

replace_codeblocks(dir::Dir) = visitdir(replace_codeblocks, dir.path)


"""
    replace_replblocks(path::AbstractString)
    replace_replblocks(file::File)
    replace_replblocks(dir::Dir)
    
Replaces Pandoc style REPL code block fences with AsciiDoc style code fences.
So replaces code like this:

    ```julia-repl
    x  = 10
    ```

With this style:

    ----
    x  = 10
    ----
"""
replace_replblocks(path::AbstractString) = replace_replblocks(Path(path))

function replace_replblocks(file::File)
    out = IOBuffer()
    lineno = 0
    open(file.path) do io
        while !eof(io)
            s = readuntil(io, "```julia-repl\n")
            print(out, s)
            lineno += count(==('\n'), s)
            
            if eof(io)
                break
            end
            
            println(out, "----")
            lineno += 1
            s = readuntil(io, "```")
            print(out, s)
            lineno += count(==('\n'), s)
            
            print(out, "----")
        end
    end
    seekstart(out)
    s = read(out, String)
    close(out)
    open(file.path, "w") do io
        write(io, s)
    end    
end

replace_replblocks(dir::Dir) = visitdir(replace_replblocks, dir.path)

