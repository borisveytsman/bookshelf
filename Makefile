PACKAGE = bookshelf


DIRS = doc scripts

all:	${PACKAGE}.cls bookshelf-svgnam.tex
	for dir in ${DIRS}; do cd $$dir; ${MAKE} $@; cd ..; done

%.cls: %.ins %.dtx
	pdflatex $<

bookshelf-svgnam.tex:
	./svgnam.sh > bookshelf-svgnam.tex
	$(RM) svgnam.csv

%.pdf: %.dtx
	xelatex $<
	- biber $<
	xelatex $<
	- makeindex -s gind.ist -o $*.ind $*.idx
	- makeindex -s gglo.ist -o $*.gls $*.glo
	xelatex $<
	while ( grep -q '^LaTeX Warning: Label(s) may have changed' $*.log) \
	do xelatex $<; done


clean:
	$(RM) *.aux *.log *.bbl *.blg *.cls *.dvi *~ pickfont.tex \
	*.bcf *.glo *.gls *.hd *.idx *.ilg *.ind *.our *.xml *.toc \
	*.out  *.pdf *.tgz svgnam.csv
	for dir in ${DIRS}; do cd $$dir; ${MAKE} $@; cd ..; done

distclean: clean
	for dir in ${DIRS}; do cd $$dir; ${MAKE} $@; cd ..; done

archive:  all clean
	COPYFILE_DISABLE=1 tar -C .. -czvf ../$(PACKAGE).tgz --exclude '*~' --exclude '*.tgz' --exclude '*.zip'  --exclude CVS --exclude '.git*' --exclude books.bib $(PACKAGE); mv ../$(PACKAGE).tgz .
