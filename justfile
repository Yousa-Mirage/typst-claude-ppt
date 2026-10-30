# Default: List all available recipes.
default:
    @just --list

# Compile the showcase PDF; pass --no-preview to skip opening it.
demo option="":
    @if [ {{ quote(option) }} != '' ] && [ {{ quote(option) }} != '--no-preview' ]; then echo 'Usage: just demo [--no-preview]' >&2; exit 2; fi
    typst compile --root . examples/showcase.typ examples/showcase.pdf
    @if [ {{ quote(option) }} != '--no-preview' ]; then open examples/showcase.pdf; fi

# Render the Quarto example PDF without opening it.
quarto:
    quarto render examples/quarto.qmd

# Install the current package into the @local namespace.
install:
    typship install local
