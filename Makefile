TECTONIC ?= tectonic
TECTONIC_FLAGS ?=
PYTHON ?= python3

.DEFAULT_GOAL := thesis
.PHONY: thesis rebuild view clean cleanall
.DELETE_ON_ERROR:

# Track project inputs, including nested chapter, bibliography, and figure files.
THESIS_INPUTS := $(wildcard *.tex *.sty *.bst *.cls *.pdf) $(shell find data figures ref -type f)

# Tectonic fetches and caches missing packages and fonts automatically.
build:
	mkdir -p build

build/thuthesis.cls: thuthesis.ins thuthesis.dtx | build
	$(TECTONIC) $(TECTONIC_FLAGS) --pass tex --keep-intermediates --outdir build thuthesis.ins

thesis: build/thesis.pdf

build/thesis.pdf: $(THESIS_INPUTS) build/thuthesis.cls Makefile scripts/tectonic.py
	$(PYTHON) scripts/tectonic.py build/tectonic.log $(TECTONIC) --color never $(TECTONIC_FLAGS) -Z search-path=build --keep-intermediates --keep-logs --synctex --outdir build thesis.tex

# Force a build after changing compiler flags or installed fonts.
rebuild:
	$(MAKE) -B thesis

view: thesis
	open build/thesis.pdf

# Keep the PDF; only build/ contains generated files.
clean:
	find build -type f ! -name thesis.pdf -delete 2>/dev/null || test ! -d build

cleanall:
	rm -rf build
