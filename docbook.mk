# Shared build rules for DocBook files built in subdirectories.  Keep these
# rules consistent with the top-level Makefile.

XSLDIR ?= ../xsl

%.html: %.xml $(XSLDIR)/html-single.xsl
	$(XSLTPROC) $(XSLPARAMS) $(XSLDIR)/html-single.xsl $< > $@

%.txt: %.xml $(XSLDIR)/text.xsl
	$(XSLTPROC) $(XSLPARAMS) $(XSLDIR)/text.xsl $< > $@.html
	links -dump $@.html | perl -pe 's/[\r\0]//g' > $@
	rm -f $@.html

%.validate: %.xml
	$(XMLLINT) $<
	touch $@
