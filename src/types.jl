export Path
export visitdir

abstract type Path end

"""Represents a filepath"""
struct File <: Path
    path::String
end

"""Represents a dirpath"""
struct Dir <: Path
    path::String
end
    
function Path(s::AbstractString)
    if isdir(s)
        Dir(s)
    elseif isfile(s)
        File(s)
    else
        error("'$s' is neither a valid directory of file path")
    end
end

"""
    visitdir(fn, dir, args...)
    
Visits recursively every directory under `dir` and running function
`fn(file, args...)` for every `file` found in each subdirectory.

This means `args...` is an optional list of arguments. You don't have
to provide any. This only visists `.md` files.
"""
function visitdir(fn::Function, dir::AbstractString, args...)
    cd(dir) do
        for entry in readdir()
            if isdir(entry)
                visitdir(fn, entry, args...)
            elseif endswith(entry, ".md")
                fn(entry, args...)
            end
        end
    end
end