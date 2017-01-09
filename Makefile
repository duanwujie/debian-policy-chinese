include debian/rules

policy.xml: version.xml
menu-policy.xml: version.xml
perl-policy.xml: version.xml
upgrading-checklist.xml: version.xml

XSLTPROC = xsltproc --nonet --xinclude
XMLLINT  = xmllint --nonet --noout --postvalid --xinclude
DBLATEX  = dblatex -p xsl/dblatex.xsl

$(MDWN_FILES:=.txt): %.txt: %.md
	cat $^ > $@
	test "$@" != "README.txt"  ||                            \
           perl -pli -e 's,./Process.md,Process.txt,g' $@
$(MDWN_FILES:=.html): %.html: %.md
	$(MDWN) $< > $@

upgrading-checklist-1.html \
upgrading-checklist.html/index.html: XSLPARAMS = --stringparam generate.toc ''

%.validate: %
	$(XMLLINT) $<

%.html/index.html: %.xml xsl/html-chunk.xsl
	mkdir -p $(@D)
	$(XSLTPROC) $(XSLPARAMS) \
	  --stringparam base.dir $(@D)/ \
	  xsl/html-chunk.xsl $<

%-1.html: %.xml xsl/html-single.xsl
	$(XSLTPROC) $(XSLPARAMS) xsl/html-single.xsl $< > $@

%.html.tar.gz: %.html/index.html
	GZIP=-n9 tar -czf $(<:/index.html=.tar.gz) $(<:/index.html=)

$(XML_FILES:=.txt): %.txt: %.xml
	$(XSLTPROC) $(XSLPARAMS) xsl/text.xsl $< > $@.html
	links -dump $@.html | perl -pe 's/[\r\0]//g' > $@
	rm -f $@.html

%.txt.gz: %.txt
	gzip -ncf9 $< > $@

%.ps: %.xml
	$(DBLATEX) --ps $<

%.ps.gz: %.ps
	gzip -ncf9 $< > $@

%.pdf: %.xml
	$(DBLATEX) --pdf $<

%.pdf.gz: %.pdf
	gzip -ncf9 $< > $@

# This is a temporary hack to fold the upgrading-checklist into the Policy
# HTML directory so that it can be deployed alongside Policy on
# www.debian.org in a way that lets the cross-document links work properly.
# The correct solution is to make upgrading-checklist an appendix of Policy,
# which will probably be done as part of a general conversion to DocBook.
policy.html.tar.gz:: policy.html/upgrading-checklist.html
policy.html/upgrading-checklist.html: upgrading-checklist-1.html \
				      policy.html/index.html
	cp -p $< $@

# convenience aliases :)
html: policy.html/index.html
html-1: policy-1.html
txt text: policy.txt
ps: policy.ps
pdf: policy.pdf
policy: html txt ps pdf

leavealone :=	$(FHS_HTML) $(FHS_FILES) $(FHS_ARCHIVE) \
		libc6-migration.txt

.PHONY: distclean
distclean:
	rm -rf $(filter-out $(leavealone),$(wildcard *.html))
	rm -f $(filter-out $(leavealone),$(wildcard *.txt *.txt.gz *.html.tar.gz *.pdf *.ps))
	rm -f *.lout* lout.li *.sasp* *.tex *.aux *.toc *.idx *.log *.out *.dvi *.tpt
	rm -f `find . -name "*~" -o -name "*.bak" -o -name ".#*" -o -name core`
	rm -f version.xml
	rm -f *.rej *.orig

# if a rule bombs out, delete the target
.DELETE_ON_ERROR:
# no default suffixes work here, don't waste time on them
.SUFFIXES: 
