export imagepaths

"""
    imagepaths(path::AbstractString)
    imagepaths(file::File)
    imagepaths(dir::Dir)
    
List the image assets found in given markdown `file` or all markdown files in
directory `dir`.
"""
imagepaths(path::AbstractString, dest=homedir()) = imagepaths(Path(path), dest)

function imagepaths(file::File, dest::AbstractString)
    lines = readlines(file.path)
    for line in lines
        if  startswith(line, "![")
            m = match(r"!\[(.*)\]\((.+)\)", line)
            caption, imgpath = m.captures
            println("cp ../", imgpath, " ", dest)
        end
    end   
end

imagepaths(dir::Dir, dest::AbstractString) = visitdir(imagepaths, dir.path, dest)