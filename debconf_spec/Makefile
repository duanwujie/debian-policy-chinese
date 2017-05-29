all: debconf_specification.validate debconf_specification.txt \
     debconf_specification.html

include ../docbook.mk

# The document is divided into separate XML documents, all of which are
# included by the main XML file.
INCLUDES = include/commands.xml include/priorities.xml			 \
	   include/statuscodes.xml include/types.xml include/version.xml

debconf_specification.html: $(INCLUDES)
debconf_specification.txt: $(INCLUDES)
debconf_specification.validate: $(INCLUDES)

clean:
	rm -f *.html *.txt *.validate

.DELETE_ON_ERROR:
