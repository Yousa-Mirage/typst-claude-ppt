# Compile the showcase PDF and open it.
demo:
    mkdir -p build
    typst compile --root . examples/showcase.typ build/showcase.pdf
    open build/showcase.pdf
