# Bookshelf package by Peter Flynn, with changes by Boris Veytsman

TL;DR

Create your own BibTeX file and put its name in `spines.tex`

``` shell
luaotfoad-tool --update --force
listallfonts.pl > allfonts
mkfontsel allfonts
lualatex spines
bibtex spines
lualatex spines
```

