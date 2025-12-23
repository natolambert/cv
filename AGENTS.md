# CV Build Notes

## LaTeX Setup

**moderncv version**: Must use v2.3.1. Version 2.4+ changed internal color handling - custom `color1`/`color2`/`color3` definitions result in faded colors. CI pins to v2.3.1.

**Local setup** (new laptop):
```bash
# Install BasicTeX
brew install --cask basictex

# Add to PATH (or restart terminal)
eval "$(/usr/libexec/path_helper)"

# Install required packages
sudo tlmgr update --self
sudo tlmgr install latexmk moderncv lastpage mathabx fancyhdr etoolbox xcolor \
  fontaxes mweights microtype colortbl multirow arydshln changepage \
  pgf float fancybox academicons fontawesome5 lm tcolorbox environ \
  trimspaces iftex l3kernel l3packages

# Pin moderncv to v2.3.1 (for correct heading colors)
curl -L https://github.com/moderncv/moderncv/archive/refs/tags/v2.3.1.tar.gz | tar xz
sudo mkdir -p $(kpsewhich -var-value=TEXMFLOCAL)/tex/latex/moderncv
sudo cp moderncv-2.3.1/*.sty moderncv-2.3.1/*.cls $(kpsewhich -var-value=TEXMFLOCAL)/tex/latex/moderncv/
sudo mktexlsr
rm -rf moderncv-2.3.1

# Verify version
head -15 "$(kpsewhich moderncv.cls)" | grep ProvidesClass
# Should show: v2.3.1
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
