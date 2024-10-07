# Bookshelf package by Peter Flynn, with changes by Boris Veytsman

## TL;DR

Create your own BibTeX file `sample.tex` and put its name in `spines.tex`:

``` tex
% !TEX TS-program = lualatex
% !TEX encoding = UTF-8 Unicode
% !BIB TS-program = bibtex

\documentclass[landscape]{bookshelf}
\begin{document}
\nocite{*}
\bibliography{sample}
\bibliographystyle{bookshelf}
\end{document}
```

``` shell
luaotfload-tool --update --force
bookshelf-listallfonts > allfonts
bookshelf-mkfontsel allfonts
lualatex spines
bibtex spines
lualatex spines
```

## Changes

* Version 1.0 2024-10-05. New maintainer. Rewrite of scripts.  Multilanguage processing. Important change: now the package is LuaLaTeX only
	
