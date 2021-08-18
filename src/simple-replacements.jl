export replace_lines

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
    
    open(file.path, "w") do io
       for line in lines
           if startswith(line, '#') && !endswith(line, '#')
              println(io, replace(line, '#' => '=')) 
           elseif startswith(line, "* ")
               println(io, "- ", line[3:end])
           elseif startswith(line, "![")
               m = match(r"!\[(.*)\]\((.+)\)", line)
               caption, imgpath = m.captures
               img = basename(imgpath)
               if !isempty(caption)
                   println(io, ".", caption)
               end
               println(io, "image::../../images/basics/", 
                      img, 
                      "[align=\"center\"]")
           else            
               println(io, line)
           end           
       end 
    end
end

replace_lines(dir::Dir) = replace_item(dir, replace_lines)