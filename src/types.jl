export Path

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

function replace_item(dir::Dir, replacer::Function)
    cd(dir.path) do
        entries = filter(readdir()) do entry
           isdir(entry) || endswith(entry, ".md")
        end
        for entry in entries
            replacer(entry)
        end
    end
end