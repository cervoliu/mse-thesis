TECTONIC ?= tectonic
TECTONIC_FLAGS ?=
PYTHON ?= python3

.DEFAULT_GOAL := thesis
.PHONY: thesis view clean cleanall

# Tectonic fetches and caches missing packages and fonts automatically.
build:
	mkdir -p build

build/thuthesis.cls: thuthesis.ins thuthesis.dtx | build
	$(TECTONIC) $(TECTONIC_FLAGS) --pass tex --keep-intermediates --outdir build thuthesis.ins

thesis: build/thuthesis.cls
	$(PYTHON) scripts/tectonic.py build/tectonic.log $(TECTONIC) --color never $(TECTONIC_FLAGS) -Z search-path=build --keep-logs --synctex --outdir build thesis.tex

view: thesis
	open build/thesis.pdf

# Keep the PDF; only build/ contains generated files.
clean:
	find build -type f ! -name thesis.pdf -delete 2>/dev/null || test ! -d build

cleanall:
	rm -rf build
