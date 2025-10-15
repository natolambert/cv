# Makefile to build PDF and Markdown cv from YAML.
#
# Brandon Amos <http://bamos.github.io> and
# Ellis Michael <http://ellismichael.com>

# Read conda environment name from .env file, default to 'cv' if not found
CONDA_ENV_NAME ?= $(shell grep CONDA_ENV_NAME .env 2>/dev/null | cut -d '=' -f2 || echo "cv")
DATE ?= $(shell date +%Y-%m-%d)
PDF_BASENAME=natolambert-cv-$(DATE)
UV ?= $(shell command -v uv 2>/dev/null)
PYTHON_BIN ?= $(if $(wildcard .venv/bin/python3),.venv/bin/python3,python3)

WEBSITE_DIR=$(HOME)/repos/website
WEBSITE_PDF=$(WEBSITE_DIR)/data/cv.pdf
WEBSITE_MD=$(WEBSITE_DIR)/_includes/cv.md
WEBSITE_DATE=$(WEBSITE_DIR)/_includes/last-updated.txt

TEMPLATES=$(shell find templates -type f)

BUILD_DIR=build
TEX=$(BUILD_DIR)/cv.tex
PDF=$(BUILD_DIR)/$(PDF_BASENAME).pdf
MD=$(BUILD_DIR)/cv.md

ifneq ("$(wildcard cv.hidden.yaml)","")
	YAML_FILES = cv.yaml cv.hidden.yaml
else
	YAML_FILES = cv.yaml
endif

ifdef UV
uv.lock: pyproject.toml
	$(UV) lock
endif

.PHONY: all public viewpdf stage jekyll push clean

all: $(PDF) $(MD)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

ifdef UV
public: $(BUILD_DIR) $(TEMPLATES) $(YAML_FILES) generate.py uv.lock
	$(UV) run --frozen python ./generate.py cv.yaml
else
public: $(BUILD_DIR) $(TEMPLATES) $(YAML_FILES) generate.py
	$(PYTHON_BIN) ./generate.py cv.yaml
endif

ifdef UV
$(TEX) $(MD): $(TEMPLATES) $(YAML_FILES) generate.py uv.lock publications/*.bib
	$(UV) sync --frozen --no-dev
	$(UV) run --frozen python ./generate.py $(YAML_FILES)
else
$(TEX) $(MD): $(TEMPLATES) $(YAML_FILES) generate.py publications/*.bib
	@if command -v conda >/dev/null 2>&1; then \
		CONDA_PREFIX=$$(conda info --base) && \
		source $${CONDA_PREFIX}/etc/profile.d/conda.sh && \
		conda activate $(CONDA_ENV_NAME) && \
		python ./generate.py $(YAML_FILES); \
	else \
		$(PYTHON_BIN) ./generate.py $(YAML_FILES); \
	fi
endif

$(PDF): $(TEX)
	# TODO: Hack for biber on OSX.
	rm -rf /var/folders/8p/lzk2wkqj47g5wf8g8lfpsk4w0000gn/T/par-62616d6f73

	rm -f $(BUILD_DIR)/natolambert-cv-*.pdf
	latexmk -pdf -cd- -jobname=$(BUILD_DIR)/cv $(BUILD_DIR)/cv
	mv $(BUILD_DIR)/cv.pdf $(PDF)
	latexmk -c -cd $(BUILD_DIR)/cv

viewpdf: $(PDF)
	gnome-open $(PDF)

stage: $(PDF) $(MD)
	cp $(PDF) $(WEBSITE_PDF)
	cp $(MD) $(WEBSITE_MD)
	date +%Y-%m-%d > $(WEBSITE_DATE)

jekyll: stage
	cd $(WEBSITE_DIR) && bundle exec jekyll server

push: stage
	git -C $(WEBSITE_DIR) add $(WEBSITE_PDF) $(WEBSITE_MD) $(WEBSITE_DATE)
	git -C $(WEBSITE_DIR) commit -m "Update cv."
	git -C $(WEBSITE_DIR) push

clean:
	rm -rf $(BUILD_DIR)/cv*
	rm -f $(BUILD_DIR)/natolambert-cv-*.pdf
