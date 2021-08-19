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

function visitdir(fn::Function, dir::AbstractString)
    cd(dir) do
        for entry in readdir()
            if isdir(entry)
                visitdir(fn, entry)
            elseif endswith(entry, ".md")
                fn(entry)
            end
        end
    end
end