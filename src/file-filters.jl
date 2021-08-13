export files, mdfiles, svgfiles, adocfiles

files(suffix) = filter(endswith(suffix), readdir())
mdfiles() = files(".md")
svgfiles() = files(".svg")
adocfiles() = files(".adoc")

