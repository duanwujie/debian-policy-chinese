XSLDIR   ?= ../xsl
XSLTPROC = xsltproc --nonet --xinclude

%.html: %.xml $(XSLDIR)/html-single.xsl
	$(XSLTPROC) $(XSLPARAMS) $(XSLDIR)/html-single.xsl $< > $@

%.txt: %.xml $(XSLDIR)/text.xsl
	$(XSLTPROC) $(XSLPARAMS) $(XSLDIR)/text.xsl $< > $@.html
	links -dump $@.html | perl -pe 's/[\r\0]//g' > $@
	rm -f $@.html

%.txt.gz: %.txt
	gzip -ncf9 $< > $@
