Control files and their fields
==============================

The package management system manipulates data represented in a common
format, known as *control data*, stored in *control files*. Control
files are used for source packages, binary packages and the ``.changes``
files which control the installation of uploaded files.  [#]_

.. _s-controlsyntax:

Syntax of control files
-----------------------

A control file consists of one or more paragraphs of fields.  [#]_ The
paragraphs are separated by empty lines. Parsers may accept lines
consisting solely of spaces and tabs as paragraph separators, but
control files should use empty lines. Some control files allow only one
paragraph; others allow several, in which case each paragraph usually
refers to a different package. (For example, in source packages, the
first paragraph refers to the source package, and later paragraphs refer
to binary packages generated from the source.) The ordering of the
paragraphs in control files is significant.

Each paragraph consists of a series of data fields. Each field consists
of the field name followed by a colon and then the data/value associated
with that field. The field name is composed of US-ASCII characters
excluding control characters, space, and colon (i.e., characters in the
ranges U+0021 (``!``) through U+0039 (``9``), and U+003B (``;``) through
U+007E (``~``), inclusive). Field names must not begin with the comment
character (U+0023 ``#``), nor with the hyphen character (U+002D ``-``).

The field ends at the end of the line or at the end of the last
continuation line (see below). Horizontal whitespace (spaces and tabs)
may occur immediately before or after the value and is ignored there; it
is conventional to put a single space after the colon. For example, a
field might be:

::

    Package: libc6

the field name is ``Package`` and the field value ``libc6``.

Empty field values are only permitted in source package control files
(``debian/control``). Such fields are ignored.

A paragraph must not contain more than one instance of a particular
field name.

There are three types of fields:

simple
    The field, including its value, must be a single line. Folding of
    the field is not permitted. This is the default field type if the
    definition of the field does not specify a different type.

folded
    The value of a folded field is a logical line that may span several
    lines. The lines after the first are called continuation lines and
    must start with a space or a tab. Whitespace, including any
    newlines, is not significant in the field values of folded fields.  [#]_

multiline
    The value of a multiline field may comprise multiple continuation
    lines. The first line of the value, the part on the same line as the
    field name, often has special significance or may have to be empty.
    Other lines are added following the same syntax as the continuation
    lines of the folded fields. Whitespace, including newlines, is
    significant in the values of multiline fields.

Whitespace must not appear inside names (of packages, architectures,
files or anything else) or version numbers, or between the characters of
multi-character version relationships.

The presence and purpose of a field, and the syntax of its value may
differ between types of control files.

Field names are not case-sensitive, but it is usual to capitalize the
field names using mixed case as shown below. Field values are
case-sensitive unless the description of the field says otherwise.

Paragraph separators (empty lines), and lines consisting only of U+0020
SPACE and U+0009 TAB, are not allowed within field values or between
fields. Empty lines in field values are usually escaped by representing
them by a U+0020 SPACE followed by a U+002E (``.``).

Lines starting with U+0023 (``#``), without any preceding whitespace,
are comment lines that are only permitted in source package control
files (``debian/control``). These comment lines are ignored, even
between two continuation lines. They do not end logical lines.

All control files must be encoded in UTF-8.

.. _s-sourcecontrolfiles:

Source package control files -- ``debian/control``
--------------------------------------------------

The ``debian/control`` file contains the most vital (and
version-independent) information about the source package and about the
binary packages it creates.

The first paragraph of the control file contains information about the
source package in general. The subsequent paragraphs each describe a
binary package that the source tree builds. Each binary package built
from this source package has a corresponding paragraph, except for any
automatically-generated debug packages that do not require one.

The fields in the general paragraph (the first one, for the source
package) are:

-  :ref:`Source <s-f-Source>` (mandatory)

-  :ref:`Maintainer <s-f-Maintainer>` (mandatory)

-  :ref:`Uploaders <s-f-Uploaders>`

-  :ref:`Section <s-f-Section>` (recommended)

-  :ref:`Priority <s-f-Priority>` (recommended)

-  :ref:`Build-Depends et al <s-sourcebinarydeps>`

-  :ref:`Standards-Version <s-f-Standards-Version>` (recommended)

-  :ref:`Homepage <s-f-Homepage>`

-  :ref:`Vcs-Browser, ``Vcs-Git``, et al. <s-f-VCS-fields>`

-  :ref:`Testsuite <s-f-Testsuite>`

The fields in the binary package paragraphs are:

-  :ref:`Package <s-f-Package>` (mandatory)

-  :ref:`Architecture <s-f-Architecture>` (mandatory)

-  :ref:`Section <s-f-Section>` (recommended)

-  :ref:`Priority <s-f-Priority>` (recommended)

-  :ref:`Essential <s-f-Essential>`

-  :ref:`Depends et al <s-binarydeps>`

-  :ref:`Description <s-f-Description>` (mandatory)

-  :ref:`Homepage <s-f-Homepage>`

-  :ref:`Built-Using <s-built-using>`

-  :ref:`Package-Type <s-f-Package-Type>`

The syntax and semantics of the fields are described below.

These fields are used by ``dpkg-gencontrol`` to generate control files
for binary packages (see below), by ``dpkg-genchanges`` to generate the
``.changes`` file to accompany the upload, and by ``dpkg-source`` when
it creates the ``.dsc`` source control file as part of a source archive.
Some fields are folded in ``debian/control``, but not in any other
control file. These tools are responsible for removing the line breaks
from such fields when using fields from ``debian/control`` to generate
other control files. They are also responsible for discarding empty
fields.

The fields here may contain variable references - their values will be
substituted by ``dpkg-gencontrol``, ``dpkg-genchanges`` or
``dpkg-source`` when they generate output control files. See
:ref:`s-substvars` for details.

.. _s-binarycontrolfiles:

Binary package control files -- ``DEBIAN/control``
--------------------------------------------------

The ``DEBIAN/control`` file contains the most vital (and
version-dependent) information about a binary package. It consists of a
single paragraph.

The fields in this file are:

-  :ref:`Package <s-f-Package>` (mandatory)

-  :ref:`Source <s-f-Source>`

-  :ref:`Version <s-f-Version>` (mandatory)

-  :ref:`Section <s-f-Section>` (recommended)

-  :ref:`Priority <s-f-Priority>` (recommended)

-  :ref:`Architecture <s-f-Architecture>` (mandatory)

-  :ref:`Essential <s-f-Essential>`

-  :ref:`Depends et al <s-binarydeps>`

-  :ref:`Installed-Size <s-f-Installed-Size>`

-  :ref:`Maintainer <s-f-Maintainer>` (mandatory)

-  :ref:`Description <s-f-Description>` (mandatory)

-  :ref:`Homepage <s-f-Homepage>`

-  :ref:`Built-Using <s-built-using>`

.. _s-debiansourcecontrolfiles:

Debian source control files -- ``.dsc``
---------------------------------------

This file consists of a single paragraph, possibly surrounded by a PGP
signature. The fields of that paragraph are listed below. Their syntax
is described above, in :ref:`s-controlsyntax`.

-  :ref:`Format <s-f-Format>` (mandatory)

-  :ref:`Source <s-f-Source>` (mandatory)

-  :ref:`Binary <s-f-Binary>`

-  :ref:`Architecture <s-f-Architecture>`

-  :ref:`Version <s-f-Version>` (mandatory)

-  :ref:`Maintainer <s-f-Maintainer>` (mandatory)

-  :ref:`Uploaders <s-f-Uploaders>`

-  :ref:`Homepage <s-f-Homepage>`

-  :ref:`Vcs-Browser, Vcs-Git, et al. <s-f-VCS-fields>`

-  :ref:`Testsuite <s-f-Testsuite>`

-  :ref:`Dgit <s-f-Dgit>`

-  :ref:`Standards-Version <s-f-Standards-Version>` (recommended)

-  :ref:`Build-Depends et al <s-sourcebinarydeps>`

-  :ref:`Package-List <s-f-Package-List>` (recommended)

-  :ref:`Checksums-Sha1 and Checksums-Sha256 <s-f-Checksums>`
   (mandatory)

-  :ref:`Files <s-f-Files>` (mandatory)

The Debian source control file is generated by ``dpkg-source`` when it
builds the source archive, from other files in the source package,
described above. When unpacking, it is checked against the files and
directories in the other parts of the source package.

.. _s-debianchangesfiles:

Debian changes files -- ``.changes``
------------------------------------

The ``.changes`` files are used by the Debian archive maintenance
software to process updates to packages. They consist of a single
paragraph, possibly surrounded by a PGP signature. That paragraph
contains information from the ``debian/control`` file and other data
about the source package gathered via ``debian/changelog`` and
``debian/rules``.

``.changes`` files have a format version that is incremented whenever
the documented fields or their meaning change. This document describes
format CHANGESVERSION.

The fields in this file are:

-  :ref:`Format <s-f-Format>` (mandatory)

-  :ref:`Date <s-f-Date>` (mandatory)

-  :ref:`Source <s-f-Source>` (mandatory)

-  :ref:`Binary <s-f-Binary>` (mandatory)

-  :ref:`Architecture <s-f-Architecture>` (mandatory)

-  :ref:`Version <s-f-Version>` (mandatory)

-  :ref:`Distribution <s-f-Distribution>` (mandatory)

-  :ref:`Urgency <s-f-Urgency>` (recommended)

-  :ref:`Maintainer <s-f-Maintainer>` (mandatory)

-  :ref:`Changed-By <s-f-Changed-By>`

-  :ref:`Description <s-f-Description>` (mandatory)

-  :ref:`Closes <s-f-Closes>`

-  :ref:`Changes <s-f-Changes>` (mandatory)

-  :ref:`Checksums-Sha1 and Checksums-Sha256 <s-f-Checksums>`
   (mandatory)

-  :ref:`Files <s-f-Files>` (mandatory)

.. _s-controlfieldslist:

List of fields
--------------

.. _s-f-Source:

``Source``
~~~~~~~~~~

This field identifies the source package name.

In ``debian/control`` or a ``.dsc`` file, this field must contain only
the name of the source package.

In a binary package control file or a ``.changes`` file, the source
package name may be followed by a version number in parentheses.  [#]_
This version number may be omitted (and is, by ``dpkg-gencontrol``) if
it has the same value as the ``Version`` field of the binary package in
question. The field itself may be omitted from a binary package control
file when the source package has the same name and version as the binary
package.

Package names (both source and binary, see
:ref:`s-f-Package`) must consist only of lower case
letters (``a-z``), digits (``0-9``), plus (``+``) and minus (``-``)
signs, and periods (``.``). They must be at least two characters long
and must start with an alphanumeric character.

.. _s-f-Maintainer:

``Maintainer``
~~~~~~~~~~~~~~

The package maintainer's name and email address. The name must come
first, then the email address inside angle brackets ``<>`` (in RFC822
format).

If the maintainer's name contains a full stop then the whole field will
not work directly as an email address due to a misfeature in the syntax
specified in RFC822; a program using this field as an address must check
for this and correct the problem if necessary (for example by putting
the name in round brackets and moving it to the end, and bringing the
email address forward).

See :ref:`s-maintainer` for additional requirements and
information about package maintainers.

.. _s-f-Uploaders:

``Uploaders``
~~~~~~~~~~~~~

List of the names and email addresses of co-maintainers of the package,
if any. If the package has other maintainers besides the one named in
the :ref:`Maintainer field <s-f-Maintainer>`, their names and email
addresses should be listed here. The format of each entry is the same as
that of the Maintainer field, and multiple entries must be comma
separated.

This is normally an optional field, but if the ``Maintainer`` control
field names a group of people and a shared email address, the
``Uploaders`` field must be present and must contain at least one human
with their personal email address.

The Uploaders field in ``debian/control`` can be folded.

.. _s-f-Changed-By:

``Changed-By``
~~~~~~~~~~~~~~

The name and email address of the person who prepared this version of
the package, usually a maintainer. The syntax is the same as for the
:ref:`Maintainer field <s-f-Maintainer>`.

.. _s-f-Section:

``Section``
~~~~~~~~~~~

This field specifies an application area into which the package has been
classified. See :ref:`s-subsections`.

When it appears in the ``debian/control`` file, it gives the value for
the subfield of the same name in the ``Files`` field of the ``.changes``
file. It also gives the default for the same field in the binary
packages.

.. _s-f-Priority:

``Priority``
~~~~~~~~~~~~

This field represents how important it is that the user have the package
installed. See :ref:`s-priorities`.

When it appears in the ``debian/control`` file, it gives the value for
the subfield of the same name in the ``Files`` field of the ``.changes``
file. It also gives the default for the same field in the binary
packages.

.. _s-f-Package:

``Package``
~~~~~~~~~~~

The name of the binary package.

Binary package names must follow the same syntax and restrictions as
source package names. See :ref:`s-f-Source` for the
details.

.. _s-f-Architecture:

``Architecture``
~~~~~~~~~~~~~~~~

Depending on context and the control file used, the ``Architecture``
field can include the following sets of values:

-  A unique single word identifying a Debian machine architecture as
   described in :ref:`s-arch-spec`.

-  An architecture wildcard identifying a set of Debian machine
   architectures, see :ref:`s-arch-wildcard-spec`.
   ``any`` matches all Debian machine architectures and is the most
   frequently used.

-  ``all``, which indicates an architecture-independent package.

-  ``source``, which indicates a source package.

In the main ``debian/control`` file in the source package, this field
may contain the special value ``all``, the special architecture wildcard
``any``, or a list of specific and wildcard architectures separated by
spaces. If ``all`` or ``any`` appears, that value must be the entire
contents of the field. Most packages will use either ``all`` or ``any``.

Specifying a specific list of architectures indicates that the source
will build an architecture-dependent package only on architectures
included in the list. Specifying a list of architecture wildcards
indicates that the source will build an architecture-dependent package
on only those architectures that match any of the specified architecture
wildcards. Specifying a list of architectures or architecture wildcards
other than ``any`` is for the minority of cases where a program is not
portable or is not useful on some architectures. Where possible, the
program should be made portable instead.

In the Debian source control file ``.dsc``, this field contains a list
of architectures and architecture wildcards separated by spaces. When
the list contains the architecture wildcard ``any``, the only other
value allowed in the list is ``all``.

The list may include (or consist solely of) the special value ``all``.
In other words, in ``.dsc`` files unlike the ``debian/control``, ``all``
may occur in combination with specific architectures. The
``Architecture`` field in the Debian source control file ``.dsc`` is
generally constructed from the ``Architecture`` fields in the
``debian/control`` in the source package.

Specifying only ``any`` indicates that the source package isn't
dependent on any particular architecture and should compile fine on any
one. The produced binary package(s) will be specific to whatever the
current build architecture is.

Specifying only ``all`` indicates that the source package will only
build architecture-independent packages.

Specifying ``any all`` indicates that the source package isn't dependent
on any particular architecture. The set of produced binary packages will
include at least one architecture-dependent package and one
architecture-independent package.

Specifying a list of architectures or architecture wildcards indicates
that the source will build an architecture-dependent package, and will
only work correctly on the listed or matching architectures. If the
source package also builds at least one architecture-independent
package, ``all`` will also be included in the list.

In a ``.changes`` file, the ``Architecture`` field lists the
architecture(s) of the package(s) currently being uploaded. This will be
a list; if the source for the package is also being uploaded, the
special entry ``source`` is also present. ``all`` will be present if any
architecture-independent packages are being uploaded. Architecture
wildcards such as ``any`` must never occur in the ``Architecture`` field
in the ``.changes`` file.

See :ref:`s-debianrules` for information on how to get
the architecture for the build process.

.. _s-f-Essential:

``Essential``
~~~~~~~~~~~~~

This is a boolean field which may occur only in the control file of a
binary package or in a per-package fields paragraph of a source package
control file.

If set to ``yes`` then the package management system will refuse to
remove the package (upgrading and replacing it is still possible). The
other possible value is ``no``, which is the same as not having the
field at all.

.. _s5.6.10:

Package interrelationship fields: ``Depends``, ``Pre-Depends``, ``Recommends``, ``Suggests``, ``Breaks``, ``Conflicts``, ``Provides``, ``Replaces``, ``Enhances``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

These fields describe the package's relationships with other packages.
Their syntax and semantics are described in
:doc:`Declaring relationships between packages <ch-relationships>`.

.. _s-f-Standards-Version:

``Standards-Version``
~~~~~~~~~~~~~~~~~~~~~

The most recent version of the standards (the policy manual and
associated texts) with which the package complies.

The version number has four components: major and minor version number
and major and minor patch level. When the standards change in a way that
requires every package to change the major number will be changed.
Significant changes that will require work in many packages will be
signaled by a change to the minor number. The major patch level will be
changed for any change to the meaning of the standards, however small;
the minor patch level will be changed when only cosmetic, typographical
or other edits are made which neither change the meaning of the document
nor affect the contents of packages.

Thus only the first three components of the policy version are
significant in the *Standards-Version* control field, and so either
these three components or all four components may be specified. [#]_

.. _s-f-Version:

``Version``
~~~~~~~~~~~

The version number of a package. The format is:
``[epoch:]upstream_version[-debian_revision]``.

The three components here are:

``epoch``
    This is a single (generally small) unsigned integer. It may be
    omitted, in which case zero is assumed. If it is omitted then the
    ``upstream_version`` may not contain any colons.

    It is provided to allow mistakes in the version numbers of older
    versions of a package, and also a package's previous version
    numbering schemes, to be left behind.

``upstream_version``
    This is the main part of the version number. It is usually the
    version number of the original ("upstream") package from which the
    ``.deb`` file has been made, if this is applicable. Usually this
    will be in the same format as that specified by the upstream
    author(s); however, it may need to be reformatted to fit into the
    package management system's format and comparison scheme.

    The comparison behavior of the package management system with
    respect to the ``upstream_version`` is described below. The
    ``upstream_version`` portion of the version number is mandatory.

    The ``upstream_version`` may contain only alphanumerics [#]_ and
    the characters ``.`` ``+`` ``-`` ``~`` (full stop, plus, hyphen,
    tilde) and should start with a digit. If there is no
    ``debian_revision`` then hyphens are not allowed.

``debian_revision`` This part of the version number specifies the
    version of the Debian package based on the upstream version. It
    may contain only alphanumerics and the characters ``+`` ``.``
    ``~`` (plus, full stop, tilde) and is compared in the same way as
    the ``upstream_version`` is.

    It is optional; if it isn't present then the ``upstream_version``
    may not contain a hyphen. This format represents the case where a
    piece of software was written specifically to be a Debian package,
    where the Debian package source must always be identical to the
    pristine source and therefore no revision indication is required.

    It is conventional to restart the ``debian_revision`` at ``1``
    each time the ``upstream_version`` is increased.

    The package management system will break the version number apart
    at the last hyphen in the string (if there is one) to determine
    the ``upstream_version`` and ``debian_revision``. The absence of a
    ``debian_revision`` is equivalent to a ``debian_revision`` of
    ``0``.

When comparing two version numbers, first the epoch of each are
compared, then the ``upstream_version`` if epoch is equal, and then
``debian_revision`` if ``upstream_version`` is also equal. epoch is compared
numerically. The ``upstream_version`` and ``debian_revision`` parts are
compared by the package management system using the following algorithm:

The strings are compared from left to right.

First the initial part of each string consisting entirely of non-digit
characters is determined. These two parts (one of which may be empty)
are compared lexically. If a difference is found it is returned. The
lexical comparison is a comparison of ASCII values modified so that all
the letters sort earlier than all the non-letters and so that a tilde
sorts before anything, even the end of a part. For example, the
following parts are in sorted order from earliest to latest: ``~~``,
``~~a``, ``~``, the empty part, ``a``. [#]_

Then the initial part of the remainder of each string which consists
entirely of digit characters is determined. The numerical values of
these two parts are compared, and any difference found is returned as
the result of the comparison. For these purposes an empty string (which
can only occur at the end of one or both version strings being compared)
counts as zero.

These two steps (comparing and removing initial non-digit strings and
initial digit strings) are repeated until a difference is found or both
strings are exhausted.

Note that the purpose of epochs is to allow us to leave behind mistakes
in version numbering, and to cope with situations where the version
numbering scheme changes. It is *not* intended to cope with version
numbers containing strings of letters which the package management
system cannot interpret (such as ``ALPHA`` or ``pre-``), or with silly
orderings.  [#]_

.. _s-f-Description:

``Description``
~~~~~~~~~~~~~~~

In a source or binary control file, the ``Description`` field contains a
description of the binary package, consisting of two parts, the synopsis
or the short description, and the long description. It is a multiline
field with the following format:

::

    Description: single line synopsis
     extended description over several lines

The lines in the extended description can have these formats:

-  Those starting with a single space are part of a paragraph.
   Successive lines of this form will be word-wrapped when displayed.
   The leading space will usually be stripped off. The line must contain
   at least one non-whitespace character.

-  Those starting with two or more spaces. These will be displayed
   verbatim. If the display cannot be panned horizontally, the
   displaying program will line wrap them "hard" (i.e., without taking
   account of word breaks). If it can they will be allowed to trail off
   to the right. None, one or two initial spaces may be deleted, but the
   number of spaces deleted from each line will be the same (so that you
   can have indenting work correctly, for example). The line must
   contain at least one non-whitespace character.

-  Those containing a single space followed by a single full stop
   character. These are rendered as blank lines. This is the *only* way
   to get a blank line.  [#]_

-  Those containing a space, a full stop and some more characters. These
   are for future expansion. Do not use them.

Do not use tab characters. Their effect is not predictable.

See :ref:`s-descriptions` for further information on
this.

In a ``.changes`` file, the ``Description`` field contains a summary of
the descriptions for the packages being uploaded. For this case, the
first line of the field value (the part on the same line as
``Description:``) is always empty. It is a multiline field, with one
line per package. Each line is indented by one space and contains the
name of a binary package, a space, a hyphen (``-``), a space, and the
short description line from that package.

.. _s-f-Distribution:

``Distribution``
~~~~~~~~~~~~~~~~

In a ``.changes`` file or parsed changelog output this contains the
(space-separated) name(s) of the distribution(s) where this version of
the package should be installed. Valid distributions are determined by
the archive maintainers.  [#]_ The Debian archive software only
supports listing a single distribution. Migration of packages to other
distributions is handled outside of the upload process.

.. _s-f-Date:

``Date``
~~~~~~~~

This field includes the date the package was built or last edited. It
must be in the same format as the date in a ``debian/changelog`` entry.

The value of this field is usually extracted from the
``debian/changelog`` file - see :ref:`s-dpkgchangelog`).

.. _s-f-Format:

``Format``
~~~~~~~~~~

In |changes link|_ files, this field declares the format version of
that file. The syntax of the field value is the same as that of a
:ref:`package version number <s-f-Version>` except that no epoch or
Debian revision is allowed. The format described in this document is
````.

In |dsc link|_ files, this field declares the format of the source
package. The field value is used by programs acting on a source
package to interpret the list of files in the source package and
determine how to unpack it. The syntax of the field value is a numeric
major revision, a period, a numeric minor revision, and then an
optional subtype after whitespace, which if specified is an
alphanumeric word in parentheses. The subtype is optional in the
syntax but may be mandatory for particular source format revisions.
[#]_

.. |changes link| replace:: ``.changes``
.. _changes link: #s-debianchangesfiles
.. |dsc link| replace:: ``.dsc`` Debian source control
.. _dsc link: #s-debiansourcecontrolfiles

.. _s-f-Urgency:

``Urgency``
~~~~~~~~~~~

This is a description of how important it is to upgrade to this version
from previous ones. It consists of a single keyword taking one of the
values ``low``, ``medium``, ``high``, ``emergency``, or ``critical``
[#]_ (not case-sensitive) followed by an optional commentary
(separated by a space) which is usually in parentheses. For example:

::

    Urgency: low (HIGH for users of diversions)

The value of this field is usually extracted from the
``debian/changelog`` file - see :ref:`s-dpkgchangelog`.

.. _s-f-Changes:

``Changes``
~~~~~~~~~~~

This multiline field contains the human-readable changes data,
describing the differences between the last version and the current one.

The first line of the field value (the part on the same line as
``Changes:``) is always empty. The content of the field is expressed as
continuation lines, with each line indented by at least one space. Blank
lines must be represented by a line consisting only of a space and a
full stop (``.``).

The value of this field is usually extracted from the
``debian/changelog`` file - see :ref:`s-dpkgchangelog`.

Each version's change information should be preceded by a "title" line
giving at least the version, distribution(s) and urgency, in a
human-readable way.

If data from several versions is being returned the entry for the most
recent version should be returned first, and entries should be separated
by the representation of a blank line (the "title" line may also be
followed by the representation of a blank line).

.. _s-f-Binary:

``Binary``
~~~~~~~~~~

This folded field is a list of binary packages. Its syntax and meaning
varies depending on the control file in which it appears.

When it appears in the ``.dsc`` file, it lists binary packages which a
source package can produce, separated by commas [#]_. The source
package does not necessarily produce all of these binary packages for
every architecture. The source control file doesn't contain details of
which architectures are appropriate for which of the binary packages.

When it appears in a ``.changes`` file, it lists the names of the binary
packages being uploaded, separated by whitespace (not commas).

.. _s-f-Installed-Size:

``Installed-Size``
~~~~~~~~~~~~~~~~~~

This field appears in the control files of binary packages, and in the
``Packages`` files. It gives an estimate of the total amount of disk
space required to install the named package. Actual installed size may
vary based on block size, file system properties, or actions taken by
package maintainer scripts.

The disk space is given as the integer value of the estimated installed
size in bytes, divided by 1024 and rounded up.

.. _s-f-Files:

``Files``
~~~~~~~~~

This field contains a list of files with information about each one. The
exact information and syntax varies with the context.

In all cases, Files is a multiline field. The first line of the field
value (the part on the same line as ``Files:``) is always empty. The
content of the field is expressed as continuation lines, one line per
file. Each line must be indented by one space and contain a number of
sub-fields, separated by spaces, as described below.

In the ``.dsc`` file, each line contains the MD5 checksum, size and
filename of the tar file and (if applicable) diff file which make up the
remainder of the source package.  [#]_ For example:

::

    Files:
     c6f698f19f2a2aa07dbb9bbda90a2754 571925 example_1.2.orig.tar.gz
     938512f08422f3509ff36f125f5873ba 6220 example_1.2-1.diff.gz

The exact forms of the filenames are described in
:ref:`s-pkg-sourcearchives`.

In the ``.changes`` file this contains one line per file being uploaded.
Each line contains the MD5 checksum, size, section and priority and the
filename. For example:

::

    Files:
     4c31ab7bfc40d3cf49d7811987390357 1428 text extra example_1.2-1.dsc
     c6f698f19f2a2aa07dbb9bbda90a2754 571925 text extra example_1.2.orig.tar.gz
     938512f08422f3509ff36f125f5873ba 6220 text extra example_1.2-1.diff.gz
     7c98fe853b3bbb47a00e5cd129b6cb56 703542 text extra example_1.2-1_i386.deb

The :ref:`section <s-f-Section>` and :ref:`priority <s-f-Priority>` are the
values of the corresponding fields in the main source control file. If
no section or priority is specified then ``-`` should be used, though
section and priority values must be specified for new packages to be
installed properly.

The special value ``byhand`` for the section in a ``.changes`` file
indicates that the file in question is not an ordinary package file and
must be installed by hand by the distribution maintainers. If the
section is ``byhand`` the priority should be ``-``.

If a new Debian revision of a package is being shipped and no new
original source archive is being distributed the ``.dsc`` must still
contain the ``Files`` field entry for the original source archive
``package_upstream-version.orig.tar.gz``, but the ``.changes`` file
should leave it out. In this case the original source archive on the
distribution site must match exactly, byte-for-byte, the original source
archive which was used to generate the ``.dsc`` file and diff which are
being uploaded.

.. _s-f-Closes:

``Closes``
~~~~~~~~~~

A space-separated list of bug report numbers that the upload governed by
the .changes file closes.

.. _s-f-Homepage:

``Homepage``
~~~~~~~~~~~~

The URL of the web site for this package, preferably (when applicable)
the site from which the original source can be obtained and any
additional upstream documentation or information may be found. The
content of this field is a simple URL without any surrounding characters
such as ``<>``.

.. _s-f-Checksums:

``Checksums-Sha1`` and ``Checksums-Sha256``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

These multiline fields contain a list of files with a checksum and size
for each one. Both ``Checksums-Sha1`` and ``Checksums-Sha256`` have the
same syntax and differ only in the checksum algorithm used: SHA-1 for
``Checksums-Sha1`` and SHA-256 for ``Checksums-Sha256``.

``Checksums-Sha1`` and ``Checksums-Sha256`` are multiline fields. The
first line of the field value (the part on the same line as
``Checksums-Sha1:`` or ``Checksums-Sha256:``) is always empty. The
content of the field is expressed as continuation lines, one line per
file. Each line consists of the checksum, a space, the file size, a
space, and the file name. For example (from a ``.changes`` file):

::

    Checksums-Sha1:
     1f418afaa01464e63cc1ee8a66a05f0848bd155c 1276 example_1.0-1.dsc
     a0ed1456fad61116f868b1855530dbe948e20f06 171602 example_1.0.orig.tar.gz
     5e86ecf0671e113b63388dac81dd8d00e00ef298 6137 example_1.0-1.debian.tar.gz
     71a0ff7da0faaf608481195f9cf30974b142c183 548402 example_1.0-1_i386.deb
    Checksums-Sha256:
     ac9d57254f7e835bed299926fd51bf6f534597cc3fcc52db01c4bffedae81272 1276 example_1.0-1.dsc
     0d123be7f51e61c4bf15e5c492b484054be7e90f3081608a5517007bfb1fd128 171602 example_1.0.orig.tar.gz
     f54ae966a5f580571ae7d9ef5e1df0bd42d63e27cb505b27957351a495bc6288 6137 example_1.0-1.debian.tar.gz
     3bec05c03974fdecd11d020fc2e8250de8404867a8a2ce865160c250eb723664 548402 example_1.0-1_i386.deb

In the ``.dsc`` file, these fields list all files that make up the
source package. In the ``.changes`` file, these fields list all files
being uploaded. The list of files in these fields must match the list of
files in the ``Files`` field.

.. _s5.6.25:

``DM-Upload-Allowed``
~~~~~~~~~~~~~~~~~~~~~

Obsolete, see :ref:`below <s-f-DM-Upload-Allowed>`.

.. _s-f-VCS-fields:

Version Control System (VCS) fields
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Debian source packages are increasingly developed using VCSs. The
purpose of the following fields is to indicate a publicly accessible
repository where the Debian source package is developed.

``Vcs-Browser``
    URL of a web interface for browsing the repository.

``Vcs-Arch``, ``Vcs-Bzr`` (Bazaar), ``Vcs-Cvs``, ``Vcs-Darcs``,
``Vcs-Git``, ``Vcs-Hg`` (Mercurial), ``Vcs-Mtn`` (Monotone), ``Vcs-Svn``
(Subversion)
    The field name identifies the VCS. The field's value uses the
    version control system's conventional syntax for describing
    repository locations and should be sufficient to locate the
    repository used for packaging. Ideally, it also locates the branch
    used for development of new versions of the Debian package.

    In the case of Git, the value consists of a URL, optionally followed
    by the word ``-b`` and the name of a branch in the indicated
    repository, following the syntax of the ``git clone`` command. If no
    branch is specified, the packaging should be on the default branch.

    More than one different VCS may be specified for the same package.

.. _s-f-Package-List:

``Package-List``
~~~~~~~~~~~~~~~~

Multiline field listing all the packages that can be built from the
source package, considering every architecture. The first line of the
field value is empty. Each one of the next lines describes one binary
package, by listing its name, type, section and priority separated by
spaces. Fifth and subsequent space-separated items may be present and
parsers must allow them. See the :ref:`Package-Type <s-f-Package-Type>`
field for a list of package types.

.. _s-f-Package-Type:

``Package-Type``
~~~~~~~~~~~~~~~~

Simple field containing a word indicating the type of package: ``deb``
for binary packages and ``udeb`` for micro binary packages. Other types
not defined here may be indicated. In source package control files, the
``Package-Type`` field should be omitted instead of giving it a value of
``deb``, as this value is assumed for paragraphs lacking this field.

.. _s-f-Dgit:

``Dgit``
~~~~~~~~

Folded field containing a single git commit hash, presented in full,
followed optionally by whitespace and other data to be defined in future
extensions.

Declares that the source package corresponds exactly to a referenced
commit in a Git repository available at the canonical location called
*dgit-repos*, used by ``dgit``, a bidirectional gateway between the
Debian archive and Git. The commit is reachable from at least one
reference whose name matches ``refs/dgit/*``. See the manual page of
``dgit`` for further details.

.. _s-f-Testsuite:

``Testsuite``
~~~~~~~~~~~~~

Simple field containing a comma-separated list of values allowing test
execution environments to discover packages which provide tests.
Currently, the only defined value is ``autopkgtest``.

This field is automatically added to Debian source control files by
``dpkg`` when a ``debian/tests/control`` file is present in the source
package. This field may also be used in source package control files if
needed in other situations.

.. _s5.7:

User-defined fields
-------------------

Additional user-defined fields may be added to the source package
control file. Such fields will be ignored, and not copied to (for
example) binary or Debian source control files or upload control files.

If you wish to add additional unsupported fields to these output files
you should use the mechanism described here.

Fields in the main source control information file with names starting
``X``, followed by one or more of the letters ``BCS`` and a hyphen
``-``, will be copied to the output files. Only the part of the field
name after the hyphen will be used in the output file. Where the letter
``B`` is used the field will appear in binary package control files,
where the letter ``S`` is used in Debian source control files and where
``C`` is used in upload control (``.changes``) files.

For example, if the main source information control file contains the
field

::

    XBS-Comment: I stand between the candle and the star.

then the binary and Debian source control files will contain the field

::

    Comment: I stand between the candle and the star.

.. _s-obsolete-control-data-fields:

Obsolete fields
---------------

The following fields have been obsoleted and may be found in packages
conforming with previous versions of the Policy.

.. _s-f-DM-Upload-Allowed:

``DM-Upload-Allowed``
~~~~~~~~~~~~~~~~~~~~~

Indicates that Debian Maintainers may upload this package to the Debian
archive. The only valid value is ``yes``. This field was used to
regulate uploads by Debian Maintainers, See the General Resolution
`Endorse the concept of Debian
Maintainers <https://www.debian.org/vote/2007/vote_003>`_ for more
details.

