



clean:
	$(RM) *.aux *.log *.bbl *.blg *.cls *.dvi *~ pickfont.tex \
	entries.tex

distclean: clean
	$(RM) *.pdf
