# A set of tools to create nice book shelves from Calibre

We want to use TeX to create book shelves.

First, we want to create a list of fonts that support Latin and Cyrillic

``` shell
./listtexfonts.sh | ./selectfonts.pl > selectedfonts
```
Then we populate `fontsel`

``` shell
./mkdontsel.pl
```
Then we convert the book catalog to `entries.tex`

``` shell
./mkentries.sh > entries.tex
```
And then

``` shell
xelatex covers
biber covers
xelatex covers
```

