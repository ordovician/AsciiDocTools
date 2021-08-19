# AsciiDoc Tools

[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

A colleciton of functions for converting Pandoc style Markdown to AsciiDoc format: [AsciiDoc Syntax Quick Reference](https://docs.asciidoctor.org/asciidoc/latest/syntax-quick-reference/).

Here is an example of how Asciidoc is typically generated on the commandline:

    $ asciidoctor-pdf -a pdf-style=manning -r asciidoctor-mathematical  ch05-text.adoc
    
To install and configure AsciiDoc look at this article: [AsciiDoc and Ruby on macOS](https://erik-engheim.medium.com/asciidoc-and-ruby-on-macos-2bad91088ea3)

The implementation here is in large parts derived from my MarkuaTools and PandocTools Julia packages.

## Quick Guide
Each file contains a function replace one logical group of items. All these are combined in the `combine.jl` file where you will find the `replace_all` function which replaces everything in a file.

    julia> replace_all("filename.md")
    
If you only want to replace e.g. blurbs, you would write:

    julia> replace_blurbs("filename.md")
    
For your .md files you will usually  have some image assets which you want to move over to your new project.

    julia> imagepaths(".", "~/NewProj/Images")
    cp ../assets/textmate-bundle.jpg ~/NewProj/Images
    cp ../assets/boxing-unboxing.svg ~/NewProj/Images
    
Then you can copy paste these copy commands to move the files.
