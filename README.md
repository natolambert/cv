# About
This repo contains the source I use to automatically generate
my curriculum vitae as a
[PDF](https://natolambert.com/cv)
from YAML and BibTeX input.
[generate.py](generate.py) reads from [cv.yaml](cv.yaml) and
[publications](publications) and outputs LaTeX and Markdown
by using Jinja templates.

**Credit: ** this is just a lowly fork, of the awesome code built by my colleague Brandon Amos.
The notable addition I added is getting stars for 🤗 HuggingFace models, datasets, and spaces.

# Building and running
Install dependencies with [uv](https://docs.astral.sh/uv/) (recommended):

```bash
uv sync --frozen
```

This creates/updates `.venv` using the pinned packages in `uv.lock`.
`make` will call [generate.py](generate.py) through uv and
build the LaTeX documents with `latexmk` and `biber`. (install with `sudo tlmgr install latexmk` with latex installed, e.g. `brew install --cask basictex` and `sudo tlmgr update --self`)
The Makefile can also:

1. Stage to my website with `make stage`,
2. Start a local jekyll server of my website with updated
  documents with `make jekyll`, and
3. Push updated documents to my website with `make push`.

The resulting PDF is written to `build/natolambert-cv-YYYY-MM-DD.pdf`; older dated PDFs in that directory are removed automatically so only the latest build is kept in git.

If you prefer `pip`, you can still install the same locked stack with:
```bash
python3 -m pip install -r requirements.txt
```
(`requirements.txt` is generated from `pyproject.toml` via `uv pip compile`.)

Note: If errors with:
```
! LaTeX Error: File `moderncv.cls' not found.
```
Install `moderncv` with:
```
sudo tlmgr update --self
sudo tlmgr install moderncv
sudo tlmgr install mathabx
```

**Python env**:

`uv sync` will provision a local `.venv` automatically. If you prefer conda, you can still:
1. Create and activate a conda environment:
   ```bash
   conda create -n YOUR_ENV_NAME python=3.10
   conda activate YOUR_ENV_NAME
   ```
2. Install required packages (see above)
3. Modify the `.env` file with `YOUR_ENV_NAME`



# What to modify
Change the content in `cv.yaml`.
You should also look through the template files to make sure there isn't any
special-case code that needs to be modified.
The `Makefile` can also start a Jekyll server and push the
new documents to another repository with `make jekyll` and `make push`.

## Warnings
1. Strings in `cv.yaml` should be LaTeX (though, the actual LaTeX formatting
   should be in the left in the templates as much as possible).
2. If you do include any new LaTeX commands, make sure that one of the
   `REPLACEMENTS` in `generate.py` converts them properly.
3. The LaTeX templates use modified Jinja delimiters to avoid overlaps with
   normal LaTeX. See `generate.py` for details.

## Automation
Pushes to `main` trigger the `Build CV` GitHub Action (`.github/workflows/build-cv.yml`) which installs LaTeX, syncs Python dependencies with uv, regenerates the CV, and commits the freshly dated PDF back to the repository when changes are detected. The workflow also runs on pull requests for verification without committing the artifact.
