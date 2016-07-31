
PHONY=view, clean, ALL
FILTER=perl beamer.pl

ifneq (,$(wildcard /usr/bin/atril))
	PDFVIEWER=atril
endif
ifneq (,$(wildcard /usr/bin/evince))
	PDFVIEWER=evince
endif

VORTRAG=vortrag_kapital.pdf
SOURCES=\
  arbeit.tex \
  begriffe.tex \
  beamer.pl \
  Makefile \
  nachfolge.tex \
  philosophie.tex \
  soziologie.tex \
  studium.tex \
  theme.tex \
  vorwort.tex \
  vortrag_kapital.tex

.SUFFIXES: .txt

.txt.tex:
	$(FILTER) $< > $@

$(VORTRAG): $(SOURCES)
	pdflatex -no-halt vortrag_kapital.tex

view: $(VORTRAG)
	$(PDFVIEWER) vortrag_kapital.pdf &

clean:
	[ -f arbeit.tex ] && rm arbeit.tex
	[ -f begriffe.tex ] && rm begriffe.tex
	[ -f nachfolge.tex ] && rm nachfolge.tex
	[ -f philosophie.tex ] && rm philosophie.tex
	[ -f soziologie.tex ] && rm soziologie.tex
	[ -f studium.tex ] && rm studium.tex
	[ -f vorwort.tex ] && rm vorwort.tex

ALL: clean view
