# A set of tools to create nice book shelves from Calibre

We want to use TeX to create book shelves.

If we want to create a list of fonts that support Latin and Cyrillic

``` shell
./listtexfonts.sh -x forbidden | ./selectfonts.pl > selectedfonts
```
Then we populate `fontsel`

``` shell
./mkdontsel.pl selectedfonts
```

If we want to use all fonts, then 

``` shell
./listtexfonts.sh   | ./listfontsfeatures.pl -d -x excluded_patterns -p otf_patterns > allfonts
./mkdontsel.pl selectedfonts
```
In this case we need `0.tex` file with reasonable default font, for example

``` tex
\setfontface{\SILmfont}{NotoSerif-Medium.ttf}[RawFeature=+onum]
\def\SILmfontname{NotoSerif-Medium.ttf onum}
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

