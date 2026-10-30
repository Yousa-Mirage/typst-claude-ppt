# Compile the 16:9 and 4:3 showcase PDFs and open them on macOS.
demo:
    mkdir -p build
    typst compile --root . examples/showcase.typ build/showcase.pdf
    typst compile --root . --input ratio=4:3 examples/showcase.typ build/showcase-4x3.pdf
    open build/showcase.pdf build/showcase-4x3.pdf
