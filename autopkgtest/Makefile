MDWN ?= multimarkdown

all: autopkgtest.html autopkgtest.txt

autopkgtest.html: autopkgtest.md.expanded
	$(MDWN) $< > $@

autopkgtest.txt: autopkgtest.md.expanded
	cat $< > $@

autopkgtest.md.expanded: autopkgtest.md version.txt
	cat $^ > $@

clean:
	rm -f autopkgtest.html autopkgtest.txt $(wildcard *.expanded)
