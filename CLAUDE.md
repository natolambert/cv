# CV Repository

Academic CV for Nathan Lambert, built from YAML data + Jinja2 templates into LaTeX/PDF and Markdown.

## Architecture

- `cv.yaml` — All CV data (YAML). This is the primary file to edit.
- `publications/all.bib` — BibTeX file for publications.
- `generate.py` — Python script that renders templates with Jinja2.
- `templates/latex/` — LaTeX templates (custom Jinja delimiters: `~< >~` for blocks, `<< >>` for variables).
- `templates/markdown/` — Markdown templates (standard Jinja delimiters).
- `build/` — Generated output (cv.tex, cv.md, PDF).
- `stats/` — Cached Google Scholar stats.

## Build

```bash
make all       # Generate LaTeX + Markdown, compile PDF
make release   # Also update canonical natolambert-cv.pdf
make clean     # Remove build artifacts
```

Uses `uv` for Python dependency management. LaTeX compilation via `latexmk`.

## Adding entries

### Talks
```yaml
talks:
  - year: 2025
    month: March
    location: "Venue Name"
    title: "Talk Title"
    url: https://event-url.com/        # optional
    details: "(\\href{url}{slides})"   # optional, LaTeX-formatted
```
More info on talks usually available at natolambert.com/slides

### Service / Professional Activities
```yaml
service:
  - details: "Role, Organization (ACRONYM)"
    year: 2025
    url: https://org.com/    # optional
```

### Reviewing
```yaml
reviewing:
  - details: "Conference Name (ACRONYM)"
    year: "2025 (count)"
    sub_details: "(optional note)"   # optional
```

### Artifacts (HuggingFace models/datasets/spaces)
```yaml
artifacts:
  - id: "org/model-name"    # HuggingFace Hub ID
    year: 2025
    type: M                  # M=Model, D=Dataset, S=Space
    desc: "Description"      # optional
```
Stars/likes are fetched automatically from the HF API at build time.

### Publications
Add BibTeX entry to `publications/all.bib`. Key custom fields:
- `_venue` — Display name for venue
- `selected={true}` — Highlights the entry (yellow background in LaTeX)
- `codeurl` — Link to code repository
- `_note` — Small annotation text (e.g. "Best Paper Award")

Blog posts indexed on Google Scholar should NOT be included here.

Add co-author URLs to `author_urls` in `cv.yaml` if not already present.

## Related repos

- Website raw data is in the private repo: https://github.com/natolambert/new-homepage
- PRs should always target natolambert's fork, never upstream.

## Data sources

- Google Scholar ID: `O4jW7BsAAAAJ` — use the `scholarly` Python library (already a dependency) to scrape publications.
- Talk details (titles, slides links) can be found at natolambert.com/slides (data loaded from `data/slides-data.json`).

## Google Scholar Stats

Scholar stats (h-index, citations) are cached in `stats/google_scholar_stats.json`.
This must be refreshed **locally** — it hangs in CI because Google blocks cloud IPs.

```bash
REFRESH_SCHOLAR_STATS=1 make all
```

When updating the CV, check if scholar stats are stale (look at the `updated` field in the JSON) and refresh if older than ~1 month.

## Notes

- Text in `cv.yaml` uses LaTeX formatting (e.g. `\\href{url}{text}`, `\\textbf{}`).
- Optional `cv.hidden.yaml` is merged in for private entries.
- CI (GitHub Actions) auto-builds PDF on push to main; pins moderncv to v2.3.1.
- The `order` list in `cv.yaml` controls section ordering and visibility.
- Talks are grouped by year and numbered sequentially.
- Artifacts are ordered newest first (by year).
