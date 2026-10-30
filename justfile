# Compile the showcase PDF and open it.
demo:
    typst compile --root . examples/showcase.typ examples/showcase.pdf
    open examples/showcase.pdf
