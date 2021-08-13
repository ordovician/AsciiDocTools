using AsciiDocTools
using Documenter

DocMeta.setdocmeta!(AsciiDocTools, :DocTestSetup, :(using AsciiDocTools); recursive=true)

makedocs(;
    modules=[AsciiDocTools],
    authors="Erik Engheim <erik.engheim@mac.com> and contributors",
    repo="https://github.com/ordovician/AsciiDocTools.jl/blob/{commit}{path}#{line}",
    sitename="AsciiDocTools.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)
