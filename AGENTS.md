# CV Build Notes

## LaTeX Setup

**moderncv version**: Must use v2.3.1. Version 2.4.1 has a color regression where custom `color1`/`color2`/`color3` definitions are ignored.

**Local setup** (new laptop):
```bash
brew install --cask basictex
sudo tlmgr update --self
sudo tlmgr install latexmk moderncv lastpage mathabx ...  # see CI workflow for full list

# Pin moderncv to v2.3.1
curl -L https://github.com/moderncv/moderncv/archive/refs/tags/v2.3.1.tar.gz | tar xz
sudo cp moderncv-2.3.1/*.sty moderncv-2.3.1/*.cls $(kpsewhich -var-value=TEXMFLOCAL)/tex/latex/moderncv/
sudo mktexlsr
```

## CI Notes

- Uses BasicTeX (faster than full MacTeX, ~100MB vs ~4GB)
- `brew update` skipped for speed; uncomment if install fails
- PDF artifact uploaded on PR builds for inspection

## Known Issues

- **moderncv v2.4.1 color bug**: Custom colors defined via `\definecolor{color1}` after `\moderncvcolor{blue}` are silently ignored. Affects headings and name color. Pinning to v2.3.1 fixes this.

## Bibliography

- `selected={true}` highlights a publication; `selected={false}` or omitting the field does not
- `_venue` is optional, defaults to "Preprint"
