# AsciiDoc Tools

[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

A colleciton of functions for converting Pandoc style Markdown to AsciiDoc format: [AsciiDoc Syntax Quick Reference](https://docs.asciidoctor.org/asciidoc/latest/syntax-quick-reference/).

Here is an example of how Asciidoc is typically generated on the commandline:

    $ asciidoctor-pdf -a pdf-style=manning -r asciidoctor-mathematical  ch05-text.adoc
    
To install and configure AsciiDoc look at this article: [AsciiDoc and Ruby on macOS](https://erik-engheim.medium.com/asciidoc-and-ruby-on-macos-2bad91088ea3)

The implementation here is in large parts derived from my MarkuaTools and PandocTools Julia packages.