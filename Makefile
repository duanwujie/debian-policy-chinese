# Build rules for Debian Policy.
#
# This is not completely standalone and independent of the Debian packaging
# in that it uses debian/changelog to get the version number and release
# date for incorporation into other documents.  Except for that, however,
# the design goal of these build rules is to build the Policy documents
# independent of their Debian packaging in the debian directory.

# Basic package information.
PACKAGE   := $(shell dpkg-parsechangelog -SSource)
TIMESTAMP := $(shell dpkg-parsechangelog -STimestamp)
DATE      := $(shell date -d '@$(TIMESTAMP)' +'%Y-%m-%d')
VERSION   := $(shell dpkg-parsechangelog -SVersion)

# Conversion programs to use.  Export these so that they're visible to
# submakes.
export DBLATEX  = dblatex -p xsl/dblatex.xsl
export MDWN     = multimarkdown
export XMLLINT  = xmllint --nonet --noout --postvalid --xinclude
export XSLTPROC = xsltproc --nonet --xinclude
export DIA      = dia

# Installation directories.  Normally this is only used by debian/rules
# build, which will set DESTDIR to put the installation under the temporary
# Debian packaging directory.
prefix      = /usr
datarootdir = $(prefix)/share
datadir     = $(datarootdir)
docdir      = $(datadir)/doc/$(PACKAGE)

# Installation programs to use.
INSTALL = install -p -o root -g root -m 644
MKDIR   = install -d -o root -g root -m 755

# Files included by debconf_specification.xml.
DEBCONF_INCLUDES := debconf/commands.xml debconf/priorities.xml	\
	            debconf/statuscodes.xml debconf/types.xml

# doc-base description files for the documents we include.
DESC_FILES  := autopkgtest copyright-format-1.0 debconf-spec debian-policy \
	       debian-menu-policy debian-perl-policy fhs

# Our local copy of the File Hierarchy Standard.  We don't build this from
# source, but we do have a copy of the source in FHS_ARCHIVE.
FHS_ARCHIVE := fhs-2.3-source.tar.gz
FHS_FILES   := fhs-2.3.html fhs-2.3.ps.gz fhs-2.3.txt.gz fhs-2.3.pdf.gz

# Markdown source files in the top-level directory.  We generate text and
# HTML versions from these.
MDWN_FILES  := README autopkgtest

# Dia diagrams in the dia/ subdirectory.
DIA_FILES   := dia/install.dia dia/install-conffiles.dia dia/upgrade.dia \
               dia/remove.dia dia/purge.dia dia/remove-purge.dia

# DocBook source files in the top-level directory.  We do some common actions
# with each of these: build text, HTML, and one-page HTML output.
XML_FILES   := menu-policy perl-policy policy

# DocBook source files in the top-level directory that should only generate
# single-page HTML output (no split HTML output).
XML_SINGLE_FILES := copyright-format-1.0 debconf_specification

# The upgrading-checklist used to be a document of its own, which was merged
# with the conversion to DocBook. Keep backwards compatibility files.
XML_SPLIT_FILES := upgrading-checklist

# XML document version files.  These are generated at build time from the
# current version and date information from the Debian changelog.
XML_VERSION := copyright-format/version.xml debconf_spec/include/version.xml \
	       version.xml

# A list of the simple Policy files that we build at the top level and in
# subdirectories and include in the documentation directory of the generated
# package.  The directories of HTML output are handled separately.
POLICY_FILES := $(MDWN_FILES:=.html)		\
		$(MDWN_FILES:=.txt)		\
		$(XML_FILES:=-1.html)		\
		$(XML_FILES:=.txt)		\
		$(XML_SINGLE_FILES:=.html)	\
		$(XML_SINGLE_FILES:=.txt)	\
		$(XML_SPLIT_FILES:=-1.html)	\
		$(XML_SPLIT_FILES:=.txt)	\
		README.css			\
		policy.ps policy.pdf		\
		virtual-package-names-list.txt

# Used by the clean rules.  FILES_TO_CLEAN are individual generated files to
# remove.  DIRS_TO_CLEAN are entire directories to remove.
DIRS_TO_CLEAN  := $(XML_FILES:=.html) fhs
FILES_TO_CLEAN := $(MDWN_FILES:=.html)			\
		  $(MDWN_FILES:=.txt)			\
		  $(XML_FILES:=.html.tar.gz)		\
		  $(XML_FILES:=-1.html)			\
		  $(XML_FILES:=.txt)			\
		  $(XML_FILES:=.validate)		\
		  $(XML_SINGLE_FILES:=.html)		\
		  $(XML_SINGLE_FILES:=.txt)		\
		  $(XML_SINGLE_FILES:=.validate)	\
		  $(XML_SPLIT_FILES:=-1.html)		\
		  $(XML_SPLIT_FILES:=.txt)		\
		  version.md version.xml		\
		  policy.pdf policy.ps


#
# General build targets.  These are the ones a human may build from the
# command line, or that are used by the Debian build system.
#

all: $(XML_FILES:=.validate) $(XML_SINGLE_FILES:=.validate) \
     $(XML_FILES:=.html.tar.gz) $(POLICY_FILES)

clean distclean:
	rm -f $(FILES_TO_CLEAN)
	rm -rf $(DIRS_TO_CLEAN)

install:
	$(MKDIR) $(DESTDIR)$(docdir)
	$(MKDIR) $(DESTDIR)$(docdir)/fhs
	$(INSTALL) $(POLICY_FILES) $(DESTDIR)$(docdir)
	$(INSTALL) $(FHS_FILES)    $(DESTDIR)$(docdir)/fhs
	@set -ex; for file in $(XML_FILES); do		\
	    tar -C $(DESTDIR)$(docdir) -zxf $$file.html.tar.gz;	\
	done

.PHONY: all clean distclean install


#
# Version files.  These incorporate the version and release date of the
# debian-policy package into the various specifications as their version and
# publication date.
#

version.md: debian/changelog
	rm -f $@
	echo					 > $@
	echo '---'				 >> $@
	echo 'Debian Policy $(VERSION), $(DATE)' >> $@

version.xml: debian/changelog
	rm -f $@
	echo '<?xml version="1.0" encoding="utf-8"?>' > $@
	echo '<!ENTITY version "$(VERSION)">'	     >> $@
	echo '<!ENTITY date    "$(DATE)">'	     >> $@


#
# Individual file and pattern build rules.
#

# There doesn't seem to be a better way of adding this include dependency.
debconf_specification.html: $(DEBCONF_INCLUDES)
debconf_specification.txt: $(DEBCONF_INCLUDES)
debconf_specification.validate: $(DEBCONF_INCLUDES)
policy-1.html: upgrading-checklist.xml
policy.html/index.html: upgrading-checklist.xml
policy.pdf: upgrading-checklist.xml
policy.ps: upgrading-checklist.xml
policy.txt: upgrading-checklist.xml
policy.validate: upgrading-checklist.xml

$(MDWN_FILES:=.txt): %.txt: %.md version.md
	cat $^ > $@
	test "$@" != "README.txt"  ||				\
           perl -pli -e 's,./Process.md,Process.txt,g' $@

$(MDWN_FILES:=.html): %.html: %.md version.md
	cat $^ | $(MDWN) > $@

$(DIA_FILES:=.png): %.png: %.dia
	dia -e $@ $^

# Suppress the table of contents for the standalone upgrading checklist.
upgrading-checklist-1.html: XSLPARAMS = --stringparam generate.toc ''
upgrading-checklist.txt: XSLPARAMS = --stringparam generate.toc ''

%.validate: %.xml version.xml
	$(XMLLINT) $<
	touch $@

%.html/index.html: %.xml xsl/html-chunk.xsl version.xml
	mkdir -p $(@D)
	$(XSLTPROC) $(XSLPARAMS)		\
	    --stringparam base.dir $(@D)/	\
	    xsl/html-chunk.xsl $<

$(XML_SINGLE_FILES:=.html): %.html: %.xml xsl/html-single.xsl version.xml
	$(XSLTPROC) $(XSLPARAMS) xsl/html-single.xsl $< > $@

%-1.html: %.xml xsl/html-single.xsl version.xml
	$(XSLTPROC) $(XSLPARAMS) xsl/html-single.xsl $< > $@

%.html.tar.gz: %.html/index.html
	tar -czf $(<:/index.html=.tar.gz) $(<:/index.html=)

$(XML_FILES:=.txt) $(XML_SINGLE_FILES:=.txt) $(XML_SPLIT_FILES:=.txt): \
%.txt: %.xml version.xml
	$(XSLTPROC) $(XSLPARAMS) xsl/text.xsl $< > $@.html
	links -codepage utf-8 -dump $@.html | perl -pe 's/[\r\0]//g' > $@
	rm -f $@.html

%.ps: %.xml version.xml
	$(DBLATEX) --ps $<

%.pdf: %.xml version.xml
	$(DBLATEX) --pdf $<


#
# GNU make configuration.
#

# If a rule bombs out, delete the target.
.DELETE_ON_ERROR:

# No default suffixes work here, don't waste time on them.
.SUFFIXES: 
