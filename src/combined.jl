export replace_all

"""
    replace_all(path::AbstractString)
    replace_all(file::File)
    replace_all(dir::Dir)

Replace headers, bullets, blurbs, math inline and blocks and footnotes.
"""
replace_all(path::AbstractString) = replace_all(Path(path))

function replace_all(file::File)
    replace_lines(file)
    replace_blurbs(file)
    replace_math(file)
    replace_codeblocks(file)
    replace_replblocks(file)
    replace_footnotes(file)    
end

replace_all(dir::Dir) = visitdir(replace_all, dir.path)