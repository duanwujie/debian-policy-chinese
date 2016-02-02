all: debconf_specification.txt.gz debconf_specification.html

%.html: %.xml html.dsl
	openjade -V nochunks -t sgml -d html.dsl \
		/usr/share/xml/declaration/xml.dcl $< > $@
	-tidy -q -i -m -f /dev/null $@

%.txt: %.html
	links -dump $< | perl -pe 's/[\r\0]//g' > $@

%.txt.gz: %.txt
	gzip -ncf9 $< > $@

clean:
	rm -f *.css *.html *.txt *.txt.gz

.DELETE_ON_ERROR:
