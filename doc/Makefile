SAMPLE = spines.tex

SAMPLEPDF = spines.pdf

MAINDOC = bookshelf.pdf

CLS = bookshelf.cls

PERLSCRIPTS = \
	../scripts/bookshelf-listallfonts \
	../scripts/bookshelf-mkfontsel

MAN = $(notdir ${PERLSCRIPTS:%=%.1})

SCRIPTTEX = $(notdir ${PERLSCRIPTS:%=%.tex})

SCRIPTPDF = $(notdir ${PERLSCRIPTS:%=%.pdf})

all: ${MAN} allfonts ${SAMPLEPDF} ${SCRIPTPDF} ${MAINDOC}

%.1: ../scripts/%
	pod2man $< > $@

%.tex: ../scripts/%
	pod2latex -full $< > $@

%.pdf: %.tex bookshelf.cls bookshelf-svgnam.tex pickfont.tex bookshelf.bst
	lualatex $*
	- bibtex $*
	lualatex $*

%.pdf: %.dtx spines.pdf bookshelf.cls
	xelatex $<
	- biber $*
	xelatex $<
	- makeindex -s gind.ist -o $*.ind $*.idx
	- makeindex -s gglo.ist -o $*.gls $*.glo
	xelatex $<
	while ( grep -q 'rerun LaTeX' $*.log) \
	do xelatex $<; done

bookshelf.dtx: ../bookshelf.dtx
	cp $< $@

bookshelf.cls: ../bookshelf.cls
	cp $< $@

bookshelf.bst: ../bookshelf.bst
	cp $< $@


%.tex: ../%.tex
	cp $< $@

../bookshelf.cls: ../bookshelf.ins ../bookshelf.dtx
	cd .. && ${MAKE} bookshelf.cls

../bookshelf-svgnam.tex: ../svgnam.sh
	cd .. && ${MAKE} bookshelf-svgnam.tex

pickfont.tex: allfonts
	../scripts/bookshelf-mkfontsel allfonts

allfonts:
	luaotfload-tool --update --force
	../scripts/bookshelf-listallfonts > allfonts

clean:
	$(RM) *.bst *.cls *.aux *.bbl *.blg *.idx *.toc *.log \
	*.bcf *.dtx *.dtx *.glo *.gls *.hd *.ilg *.ind *.out \
	*.xml pickfont.tex ${SCRIPTTEX} bookshelf-svgnam.tex svgnam.csv
	$(RM) -r fontsel 

distclean: clean
	$(RM) ${MAN} allfonts ${SAMPLEPDF} ${SCRIPTPDF} ${MAINDOC}
