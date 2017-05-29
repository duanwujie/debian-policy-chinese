all: copyright-format-1.0.validate copyright-format-1.0.txt \
     copyright-format-1.0.html

include ../docbook.mk

copyright-format-1.0.html: version.xml
copyright-format-1.0.txt: version.xml
copyright-format-1.0.validate: version.xml

clean:
	rm -f *.html *.txt *.validate

.DELETE_ON_ERROR:
