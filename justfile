package_root := justfile_directory() / ".packages"
package_dir := package_root / "local/typst-claude-ppt/0.1.0"

# Compile the 16:9 and 4:3 showcase PDFs.
demo:
    mkdir -p build
    typst compile --root . examples/showcase.typ build/showcase.pdf
    typst compile --root . --input ratio=4:3 examples/showcase.typ build/showcase-4x3.pdf

# Compile the showcases and render each page as PNG.
preview: demo
    typst compile --root . examples/showcase.typ 'build/showcase-{p}.png'
    typst compile --root . --input ratio=4:3 examples/showcase.typ 'build/showcase-4x3-{p}.png'

# Check pagination, layout bounds and standalone package use.
check:
    python3 scripts/check.py

# Copy the package into a local Typst package directory.
package:
    mkdir -p {{quote(package_dir)}}
    cp typst.toml {{quote(package_dir)}}/
    cp -R src assets template {{quote(package_dir)}}/
    @echo {{quote('Local package ready. Use --package-path "' + package_root + '" with typst init/compile/watch.')}}
