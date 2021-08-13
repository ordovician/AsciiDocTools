export replace_sections

"""
    replace_lines(path::AbstractString)
    replace_lines(file::File)
    replace_lines(dir::Dir)
    
Replace part of the markdown file, which can be done an a per-line basis.
For instance you cannot do this with code blocks but you can do this with bullets
and section headings.
"""
replace_lines(path::AbstractString) = replace_lines(Path(path))

function replace_lines(file::File)
    lines = readlines(file.path)
    rlines = map(lines) do line
        if startswidth(line, '#') && !endswidth(line, '#')
           replace(line, '#' => '=') 
        elseif startswidth(line, "* ")
            replace(line, "* ", "- ")
        elseif startswidth(line, "![")
            m = match(r"!\[(.+)\]\((.+)\)", line)
            caption, imgpath = m.captures
            img = basename(imgpath)
            string(".", caption, "\n",
                   "image::../../images/basics/", 
                   img, 
                   "[align="center"]")
        else            
            line
        end
    end
    open(file.path, "w") do io
        for line in rlines
            println(io, line)
        end
    end
end

replace_lines(dir::Dir) = replace_item(dir, replace_lines)