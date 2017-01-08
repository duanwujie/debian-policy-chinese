MDWN ?= multimarkdown

all: autopkgtest.html autopkgtest.txt.gz

autopkgtest.html: autopkgtest.md.expanded
	$(MDWN) $< > $@

autopkgtest.txt.gz: autopkgtest.md.expanded
	gzip -ncf9 $< > $@

autopkgtest.md.expanded: autopkgtest.md version.txt
	cat $^ > $@

clean:
	rm -f autopkgtest.html autopkgtest.txt.gz $(wildcard *.expanded)
