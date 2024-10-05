SAMPLE = spines.tex

SAMPLEPDF = spines.pdf

MAINDOC = bookshelf.pdf

CLS = bookshelf.cls

PERLSCRIPTS = \
	../scripts/listallfonts.pl \
	../scripts/mkfontsel.pl

MAN = $(notdir ${PERLSCRIPTS:%.pl=%.1})

SCRIPTTEX = $(notdir ${PERLSCRIPTS:%.pl=%.tex})

SCRIPTPDF = $(notdir ${PERLSCRIPTS:%.pl=%.pdf})

all: ${MAN} allfonts ${SAMPLEPDF} ${SCRIPTPDF} ${MAINDOC}

%.1: ../scripts/%.pl
	pod2man $< > $@

%.tex: ../scripts/%.pl
	pod2latex -full $< > $@

%.pdf: %.tex bookshelf.cls svgnam.tex pickfont.tex bookshelf.bst
	lualatex $*
	- bibtex $*
	lualatex $*

bookshelf.cls: ../bookshelf.cls
	cp $< $@

bookshelf.bst: ../bookshelf.bst
	cp $< $@

bookshelf.pdf: ../bookshelf.pdf
	cp $< $@

../bookshelf.pdf: ../bookshelf.dtx
	cd .. && ${MAKE} bookshelf.pdf

%.tex: ../%.tex
	cp $< $@

../bookshelf.cls: ../bookshelf.ins ../bookshelf.dtx
	cd .. && ${MAKE} bookshelf.cls

pickfont.tex: allfonts
	../scripts/mkfontsel.pl allfonts

allfonts:
	luaotfload-tool --update --force
	../scripts/listallfonts.pl > allfonts

clean:
	$(RM) *.bst *.cls *.aux *.bbl *.blg *.idx *.toc *.log \
	pickfont.tex ${SCRIPTTEX}
	$(RM) -r fontsel 

distclean: clean
	$(RM) ${MAN} allfonts ${SAMPLEPDF} ${SCRIPTPDF} ${MAINDOC}
