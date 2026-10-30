.PHONY: demo preview check package

PACKAGE_ROOT := $(CURDIR)/.packages
PACKAGE_DIR := $(PACKAGE_ROOT)/local/typst-claude-ppt/0.1.0

demo:
	mkdir -p build
	typst compile --root . examples/showcase.typ build/showcase.pdf
	typst compile --root . --input ratio=4:3 examples/showcase.typ build/showcase-4x3.pdf

preview: demo
	typst compile --root . examples/showcase.typ 'build/showcase-{p}.png'
	typst compile --root . --input ratio=4:3 examples/showcase.typ 'build/showcase-4x3-{p}.png'

check:
	python3 scripts/check.py

package:
	mkdir -p "$(PACKAGE_DIR)"
	cp typst.toml "$(PACKAGE_DIR)/"
	cp -R src assets template "$(PACKAGE_DIR)/"
	@echo 'Local package ready. Use --package-path "$(PACKAGE_ROOT)" with typst init/compile/watch.'
