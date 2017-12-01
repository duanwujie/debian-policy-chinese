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
export DIA      = dia
export MDWN     = multimarkdown
export SPHINX   = sphinx-build
export XMLLINT  = xmllint --nonet --noout --postvalid --xinclude
export XSLTPROC = xsltproc --nonet --xinclude

# Installation directories.  Normally this is only used by debian/rules
# build, which will set DESTDIR to put the installation under the temporary
# Debian packaging directory.
prefix      = /usr
datarootdir = $(prefix)/share
datadir     = $(datarootdir)
docdir      = $(datadir)/doc/$(PACKAGE)
infodir     = $(datarootdir)/info

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

# Dia diagrams in the policy/images subdirectory.
DIA_FILES   := $(wildcard policy/images/*.dia)

# Dia diagrams converted to PNG in images/ subdirectory.
DIA_PNGS    := $(DIA_FILES:.dia=.png)

# Dia diagrams converted to SVG in images/ subdirectory.
DIA_SVGS    := $(DIA_FILES:.dia=.svg)

# DocBook source files in the top-level directory.  We do some common actions
# with each of these: build text, HTML, and one-page HTML output.
XML_FILES   := menu-policy perl-policy

# DocBook source files in the top-level directory that should only generate
# single-page HTML output (no split HTML output).
XML_SINGLE_FILES := copyright-format-1.0 debconf_specification

# XML document version files.  These are generated at build time from the
# current version and date information from the Debian changelog.
XML_VERSION := copyright-format/version.xml debconf_spec/include/version.xml \
	       version.xml

# A list of the simple Policy files that we build at the top level and in
# subdirectories and include in the documentation directory of the generated
# package.  The directories of HTML output are handled separately.
POLICY_FILES := $(MDWN_FILES:=.html)				\
		$(MDWN_FILES:=.txt)				\
		$(XML_FILES:=-1.html)				\
		$(XML_FILES:=.txt)				\
		$(XML_SINGLE_FILES:=.html)			\
		$(XML_SINGLE_FILES:=.txt)			\
		README.css					\
		policy/_build/epub/policy.epub			\
		policy/_build/latex/policy.pdf			\
		policy/_build/policy.txt			\
		policy/_build/text/upgrading-checklist.txt	\
		virtual-package-names-list.txt

# A list of generated info files to install.
INFO_FILES := policy/_build/texinfo/debian-policy.info

# Source files that go into the Debian Policy manual.
POLICY_SOURCE := $(wildcard policy/*.rst) policy/conf.py policy/index.rst

# Used by the clean rules.  FILES_TO_CLEAN are individual generated files to
# remove.  DIRS_TO_CLEAN are entire directories to remove.
DIRS_TO_CLEAN  := $(XML_FILES:=.html) policy/_build fhs
FILES_TO_CLEAN := $(MDWN_FILES:=.html)			\
		  $(MDWN_FILES:=.txt)			\
		  $(XML_FILES:=.html.tar.gz)		\
		  $(XML_FILES:=-1.html)			\
		  $(XML_FILES:=.txt)			\
		  $(XML_FILES:=.validate)		\
		  $(XML_SINGLE_FILES:=.html)		\
		  $(XML_SINGLE_FILES:=.txt)		\
		  $(XML_SINGLE_FILES:=.validate)	\
		  $(DIA_PNGS)				\
		  policy/index.rst			\
		  version.md version.xml


#
# General build targets.  These are the ones a human may build from the
# command line, or that are used by the Debian build system.
#

all: $(XML_FILES:=.validate) $(XML_SINGLE_FILES:=.validate)		\
     $(XML_FILES:=.html.tar.gz) $(POLICY_FILES) $(INFO_FILES)		\
     policy/_build/singlehtml/index.html policy/_build/html/index.html

clean distclean:
	rm -f $(FILES_TO_CLEAN)
	rm -rf $(DIRS_TO_CLEAN)

install: all
	$(MKDIR) $(DESTDIR)$(docdir)
	$(MKDIR) $(DESTDIR)$(docdir)/fhs
	$(INSTALL) $(POLICY_FILES) $(DESTDIR)$(docdir)
	$(INSTALL) $(FHS_FILES)    $(DESTDIR)$(docdir)/fhs
	@set -ex; for file in $(XML_FILES); do			\
	    tar -C $(DESTDIR)$(docdir) -zxf $$file.html.tar.gz;	\
	done
	$(MKDIR) $(DESTDIR)$(docdir)/policy.html
	cp -dR policy/_build/html/* $(DESTDIR)$(docdir)/policy.html/
	$(INSTALL) policy/_build/singlehtml/index.html \
	    $(DESTDIR)$(docdir)/policy-1.html
	$(MKDIR) $(DESTDIR)$(docdir)/_images
	cp -dR policy/_build/singlehtml/_images/* $(DESTDIR)$(docdir)/_images/
	$(MKDIR) $(DESTDIR)$(docdir)/_static
	cp -dR policy/_build/singlehtml/_static/* $(DESTDIR)$(docdir)/_static/
	$(MKDIR) $(DESTDIR)$(infodir)
	$(INSTALL) $(INFO_FILES) $(DESTDIR)$(infodir)
	$(INSTALL) $(DIA_PNGS) $(DESTDIR)$(infodir)

.PHONY: all clean distclean install


#
# Version files.  These incorporate the version and release date of the
# debian-policy package into the various specifications as their version and
# publication date.
#

policy/conf.py policy/index.rst: %: %.in debian/changelog
	sed -e 's/@VERSION@/$(VERSION)/' -e 's/@DATE@/$(DATE)/' $< > $@

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

# The text version of the upgrading checklist come from the Policy text build.
policy/_build/text/upgrading-checklist.txt: policy/_build/policy.txt

policy/_build/epub/policy.epub: $(POLICY_SOURCE) $(DIA_PNGS)
	$(SPHINX) -M epub policy policy/_build

policy/_build/html/index.html: $(POLICY_SOURCE) $(DIA_PNGS)
	$(SPHINX) -M html policy policy/_build

prebuild_pdf:
	$(SPHINX) -M latex policy policy/_build

policy/_build/latex/policy.pdf: $(POLICY_SOURCE) $(DIA_PNGS) prebuild_pdf
	sed -i s/latexmk/xelatex/ policy/_build/latex/Makefile
	$(MAKE) -C policy/_build/latex


policy/_build/policy.txt: $(POLICY_SOURCE)
	rm -f $@
	$(SPHINX) -M text policy policy/_build
	cp policy/_build/text/index.txt $@
	set -e;								 \
	    files=$$(egrep '^   (ch-|ap-|upgrading-)' policy/index.rst); \
	    for f in $$files; do					 \
		printf "\n\n\n"                  >>$@;			 \
		cat policy/_build/text/"$$f".txt >>$@;			 \
	    done

policy/_build/singlehtml/index.html: $(POLICY_SOURCE) $(DIA_PNGS)
	$(SPHINX) -M singlehtml policy policy/_build
	perl -pli -e 's,href="index\.html#,href="#,g' $@
	perl -pli -e 's,(genindex|search)\.html,policy.html/$$1.html,' $@

policy/_build/texinfo/debian-policy.info: $(POLICY_SOURCE)
	$(SPHINX) -M info policy policy/_build

$(MDWN_FILES:=.txt): %.txt: %.md version.md
	cat $^ > $@
	test "$@" != "README.txt"  ||				\
           perl -pli -e 's,./Process.md,Process.txt,g' $@

$(MDWN_FILES:=.html): %.html: %.md version.md
	cat $^ | $(MDWN) > $@

$(DIA_PNGS): policy/images/%.png: policy/images/%.dia
	$(DIA) -e $@ $^

$(DIA_SVGS): policy/images/%.svg: policy/images/%.dia
	$(DIA) -e $@ $^

# Suppress the table of contents for the standalone upgrading checklist.
upgrading-checklist-1.html: XSLPARAMS = --stringparam generate.toc ''
upgrading-checklist.txt: XSLPARAMS = --stringparam generate.toc ''

%.validate: %.xml version.xml
	$(XMLLINT) $<
	touch $@

%.html/index.html: %.xml xsl/html-chunk.xsl version.xml
	mkdir -p $(@D)/images
	$(XSLTPROC) $(XSLPARAMS)		\
	    --stringparam base.dir $(@D)/	\
	    xsl/html-chunk.xsl $<

$(XML_SINGLE_FILES:=.html): %.html: %.xml xsl/html-single.xsl version.xml
	$(XSLTPROC) $(XSLPARAMS) xsl/html-single.xsl $< > $@

%-1.html: %.xml xsl/html-single.xsl version.xml $(DIA_PNGS)
	$(XSLTPROC) $(XSLPARAMS) xsl/html-single.xsl $< > $@

%.html.tar.gz: %.html/index.html
	tar -czf $(<:/index.html=.tar.gz) $(<:/index.html=)

$(XML_FILES:=.txt) $(XML_SINGLE_FILES:=.txt) $(XML_SPLIT_FILES:=.txt): \
%.txt: %.xml version.xml
	$(XSLTPROC) $(XSLPARAMS) xsl/text.xsl $< > $@.html
	links -codepage utf-8 -dump $@.html | perl -pe 's/[\r\0]//g' > $@
	rm -f $@.html


#
# GNU make configuration.
#

# If a rule bombs out, delete the target.
.DELETE_ON_ERROR:

# No default suffixes work here, don't waste time on them.
.SUFFIXES: 
