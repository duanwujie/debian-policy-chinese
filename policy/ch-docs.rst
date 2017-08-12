Documentation
=============

.. _s12.1:

Manual pages
------------

You should install manual pages in ``nroff`` source form, in appropriate
places under ``/usr/share/man``. You should only use sections 1 to 9
(see the FHS for more details). You must not install a pre-formatted
"cat page".

Each program, utility, and function should have an associated manual
page included in the same package. It is suggested that all
configuration files also have a manual page included as well. Manual
pages for protocols and other auxiliary things are optional.

If no manual page is available, this is considered as a bug and should
be reported to the Debian Bug Tracking System (the maintainer of the
package is allowed to write this bug report themselves, if they so
desire). Do not close the bug report until a proper man page is
available.  [#]_

You may forward a complaint about a missing man page to the upstream
authors, and mark the bug as forwarded in the Debian bug tracking
system. Even though the GNU Project do not in general consider the lack
of a man page to be a bug, we do; if they tell you that they don't
consider it a bug you should leave the bug in our bug tracking system
open anyway.

Manual pages should be installed compressed using ``gzip -9``.

If one man page needs to be accessible via several names it is better to
use a symbolic link than the ``.so`` feature, but there is no need to
fiddle with the relevant parts of the upstream source to change from
``.so`` to symlinks: don't do it unless it's easy. You should not create
hard links in the manual page directories, nor put absolute filenames in
``.so`` directives. The filename in a ``.so`` in a man page should be
relative to the base of the man page tree (usually ``/usr/share/man``).
If you do not create any links (whether symlinks, hard links, or ``.so``
directives) in the file system to the alternate names of the man page,
then you should not rely on ``man`` finding your man page under those
names based solely on the information in the man page's header.  [#]_

Manual pages in locale-specific subdirectories of ``/usr/share/man``
should use either UTF-8 or the usual legacy encoding for that language
(normally the one corresponding to the shortest relevant locale name in
``/usr/share/i18n/SUPPORTED``). For example, pages under
``/usr/share/man/fr`` should use either UTF-8 or ISO-8859-1.  [#]_

A country name (the ``DE`` in ``de_DE``) should not be included in the
subdirectory name unless it indicates a significant difference in the
language, as this excludes speakers of the language in other countries.
[#]_

If a localized version of a manual page is provided, it should either be
up-to-date or it should be obvious to the reader that it is outdated and
the original manual page should be used instead. This can be done either
by a note at the beginning of the manual page or by showing the missing
or changed portions in the original language instead of the target
language.

.. _s12.2:

Info documents
--------------

Info documents should be installed in ``/usr/share/info``. They should
be compressed with ``gzip -9``.

The ``install-info`` program maintains a directory of installed info
documents in ``/usr/share/info/dir`` for the use of info readers. This
file must not be included in packages other than install-info.

``install-info`` is automatically invoked when appropriate using dpkg
triggers. Packages other than install-info *should not* invoke
``install-info`` directly and *should not* depend on, recommend, or
suggest install-info for this purpose.

Info readers requiring the ``/usr/share/info/dir`` file should depend on
install-info.

Info documents should contain section and directory entry information in
the document for the use of ``install-info``. The section should be
specified via a line starting with ``INFO-DIR-SECTION`` followed by a
space and the section of this info page. The directory entry or entries
should be included between a ``START-INFO-DIR-ENTRY`` line and an
``END-INFO-DIR-ENTRY`` line. For example:

::

    INFO-DIR-SECTION Individual utilities
    START-INFO-DIR-ENTRY
    * example: (example).               An example info directory entry.
    END-INFO-DIR-ENTRY

To determine which section to use, you should look at
``/usr/share/info/dir`` on your system and choose the most relevant (or
create a new section if none of the current sections are relevant).
[#]_

.. _s-docs-additional:

Additional documentation
------------------------

Any additional documentation that comes with the package may be
installed at the discretion of the package maintainer. It is often a
good idea to include text information files (``README``\ s, FAQs, and so
forth) that come with the source package in the binary package. However,
you don't need to install the instructions for building and installing
the package, of course!

Plain text documentation should be compressed with ``gzip -9`` unless it is small.

If a package comes with large amounts of documentation that many users
of the package will not require, you should create a separate binary
package to contain it so that it does not take up disk space on the
machines of users who do not need or want it installed. As a special
case of this rule, shared library documentation of any appreciable size
should always be packaged with the library development package
(:ref:`s-sharedlibs-dev`) or in a separate documentation
package, since shared libraries are frequently installed as dependencies
of other packages by users who have little interest in documentation of
the library itself. The documentation package for the package package is
conventionally named package-doc (or package-doc-language-code if there
are separate documentation packages for multiple languages).

If package is a build tool, development tool, command-line tool, or
library development package, package (or package-dev in the case of a
library development package) already provides documentation in man,
info, or plain text format, and package-doc provides HTML or other
formats, package should declare at most a ``Suggests`` on package-doc.
Otherwise, package should declare at most a ``Recommends`` on
package-doc.

Additional documentation included in the package should be installed
under ``/usr/share/doc/package``. If the documentation is packaged
separately, as package-doc for example, it may be installed under either
that path or into the documentation directory for the separate
documentation package (``/usr/share/doc/package-doc`` in this example).
However, installing the documentation into the documentation directory
of the main package is preferred since it is independent of the
packaging method and will be easier for users to find.

Any separate package providing documentation must still install standard
documentation files in its own ``/usr/share/doc`` directory as specified
in the rest of this policy. See, for example,
:ref:`s-copyrightfile` and
:ref:`s-changelogs`.

Packages must not require the existence of any files in
``/usr/share/doc/`` in order to function.  [#]_ Any files that are
used or read by programs but are also useful as stand alone
documentation should be installed elsewhere, such as under
``/usr/share/package/``, and then included via symbolic links in
``/usr/share/doc/package``.

``/usr/share/doc/package`` may be a symbolic link to another directory
in ``/usr/share/doc`` only if the two packages both come from the same
source and the first package Depends on the second.  [#]_

.. _s12.4:

Preferred documentation formats
-------------------------------

The unification of Debian documentation is being carried out via HTML.

If the package comes with extensive documentation in a markup format
that can be converted to various other formats you should if possible
ship HTML versions in a binary package.  [#]_ The documentation must
be installed as specified in :ref:`s-docs-additional`.

Other formats such as PostScript may be provided at the package
maintainer's discretion.

.. _s-copyrightfile:

Copyright information
---------------------

Every package must be accompanied by a verbatim copy of its copyright
information and distribution license in the file
``/usr/share/doc/package/copyright``. This file must neither be
compressed nor be a symbolic link.

In addition, the copyright file must say where the upstream sources (if
any) were obtained, and should include a name or contact address for the
upstream authors. This can be the name of an individual or an
organization, an email address, a web forum or bugtracker, or any other
means to unambiguously identify who to contact to participate in the
development of the upstream source code.

Packages in the *contrib* or *non-free* archive areas should state in
the copyright file that the package is not part of the Debian
distribution and briefly explain why.

A copy of the file which will be installed in
``/usr/share/doc/package/copyright`` should be in ``debian/copyright``
in the source package.

``/usr/share/doc/package`` may be a symbolic link to another directory
in ``/usr/share/doc`` only if the two packages both come from the same
source and the first package Depends on the second. These rules are
important because ``copyright`` files must be extractable by mechanical
means.

Packages distributed under the Apache license (version 2.0), the
Artistic license, the GNU GPL (versions 1, 2, or 3), the GNU LGPL
(versions 2, 2.1, or 3), the GNU FDL (versions 1.2 or 1.3), and the
Mozilla Public License (version 1.1 or 2.0) should refer to the
corresponding files under ``/usr/share/common-licenses``,  [#]_ rather
than quoting them in the copyright file.

You should not use the copyright file as a general ``README`` file. If
your package has such a file it should be installed in
``/usr/share/doc/package/README`` or ``README.Debian`` or some other
appropriate place.

All copyright files must be encoded in UTF-8.

.. _s-copyrightformat:

Machine-readable copyright information
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A specification for a standard, machine-readable format for
``debian/copyright`` files is maintained as part of the debian-policy
package. This document may be found in the ``copyright-format`` files in
the debian-policy package. It is also available from the Debian web
mirrors at
https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/.

Use of this format is optional.

.. _s12.6:

Examples
--------

Any examples (configurations, source files, whatever), should be
installed in a directory ``/usr/share/doc/package/examples``. These
files should not be referenced by any program: they're there for the
benefit of the system administrator and users as documentation only.
Architecture-specific example files should be installed in a directory
``/usr/lib/package/examples`` with symbolic links to them from
``/usr/share/doc/package/examples``, or the latter directory itself may
be a symbolic link to the former.

If the purpose of a package is to provide examples, then the example
files may be installed into ``/usr/share/doc/package``.

.. _s-changelogs:

Changelog files
---------------

Packages that are not Debian-native must contain a compressed copy of
the ``debian/changelog`` file from the Debian source tree in
``/usr/share/doc/package`` with the name ``changelog.Debian.gz``.

If an upstream changelog is available, it should be accessible as
``/usr/share/doc/package/changelog.gz`` in plain text. If the upstream
changelog is distributed in HTML, it should be made available in that
form as ``/usr/share/doc/package/changelog.html.gz`` and a plain text
``changelog.gz`` should be generated from it using, for example,
``lynx -dump -nolist``. If the upstream changelog files do not already
conform to this naming convention, then this may be achieved either by
renaming the files, or by adding a symbolic link, at the maintainer's
discretion.  [#]_

All of these files should be installed compressed using ``gzip -9``, as
they will become large with time even if they start out small.

If the package has only one changelog which is used both as the Debian
changelog and the upstream one because there is no separate upstream
maintainer then that changelog should usually be installed as
``/usr/share/doc/package/changelog.gz``; if there is a separate upstream
maintainer, but no upstream changelog, then the Debian changelog should
still be called ``changelog.Debian.gz``.

For details about the format and contents of the Debian changelog file,
please see :ref:`s-dpkgchangelog`.

