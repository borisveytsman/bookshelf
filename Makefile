PACKAGE = bookshelf


DIRS = doc scripts

all:	${PACKAGE}.cls 
	for dir in ${DIRS}; do cd $$dir; ${MAKE} all; cd ..; done

%.cls: %.ins %.dtx
	pdflatex $<

clean:
	$(RM) *.aux *.log *.bbl *.blg *.cls *.dvi *~ pickfont.tex \
	entries.tex

distclean: clean
	$(RM) *.pdf
