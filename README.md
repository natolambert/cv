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
Typical workflow:

- `make all` regenerates the Markdown and a dated PDF (`build/natolambert-cv-YYYY-MM-DD.pdf`).
- `make release` (optional) updates the canonical tracked PDF at `build/natolambert-cv.pdf`; run this only when you actually want to commit a fresh artifact. (CI calls it automatically.)
- Google Scholar statistics are cached in `stats/google_scholar_stats.json`. To refresh them locally run `REFRESH_SCHOLAR_STATS=1 make all`, verify the new numbers, and commit the JSON file so CI and local builds stay in sync.
The Makefile can also:

1. Stage to my website with `make stage`,
2. Start a local jekyll server of my website with updated
  documents with `make jekyll`, and
3. Push updated documents to my website with `make push`.

Each build writes a dated artifact `build/natolambert-cv-YYYY-MM-DD.pdf` for convenience (older dated files are cleaned before rebuilding) and also refreshes `build/natolambert-cv.pdf`, which is the single PDF kept under version control.

If you prefer `pip`, generate a temporary requirements file from the lock when needed:
```bash
uv pip compile pyproject.toml -o requirements.txt
python3 -m pip install -r requirements.txt
rm requirements.txt
```

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
Pushes to `main` trigger the `Build CV` GitHub Action (`.github/workflows/build-cv.yml`) which installs LaTeX, syncs Python dependencies with uv, runs `make all` followed by `make release`, and commits the refreshed `build/natolambert-cv.pdf` when changes are detected. The workflow also runs on pull requests for verification without committing the artifact.
