Control files and their fields (from old Packaging Manual)
==========================================================

Many of the tools in the ``dpkg`` suite manipulate data in a common
format, known as control files. Binary and source packages have control
data as do the ``.changes`` files which control the installation of
uploaded files, and ``dpkg``'s internal databases are in a similar
format.

.. _s-sD.1:

Syntax of control files
-----------------------

See :ref:`s-controlsyntax`.

It is important to note that there are several fields which are optional
as far as ``dpkg`` and the related tools are concerned, but which must
appear in every Debian package, or whose omission may cause problems.

.. _s-sD.2:

List of fields
--------------

See :ref:`s-controlfieldslist`.

This section now contains only the fields that didn't belong to the
Policy manual.

.. _s-pkg-f-Filename:

``Filename`` and ``MSDOS-Filename``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

These fields in ``Packages`` files give the filename(s) of (the parts
of) a package in the distribution directories, relative to the root of
the Debian hierarchy. If the package has been split into several parts
the parts are all listed in order, separated by spaces.

.. _s-pkg-f-Size:

``Size`` and ``MD5sum``
~~~~~~~~~~~~~~~~~~~~~~~

These fields in ``Packages`` files give the size (in bytes, expressed in
decimal) and MD5 checksum of the file(s) which make(s) up a binary
package in the distribution. If the package is split into several parts
the values for the parts are listed in order, separated by spaces.

.. _s-pkg-f-Status:

``Status``
~~~~~~~~~~

This field in ``dpkg``'s status file records whether the user wants a
package installed, removed or left alone, whether it is broken
(requiring re-installation) or not and what its current state on the
system is. Each of these pieces of information is a single word.

.. _s-pkg-f-Config-Version:

``Config-Version``
~~~~~~~~~~~~~~~~~~

If a package is not installed or not configured, this field in
``dpkg``'s status file records the last version of the package which was
successfully configured.

.. _s-pkg-f-Conffiles:

``Conffiles``
~~~~~~~~~~~~~

This field in ``dpkg``'s status file contains information about the
automatically-managed configuration files held by a package. This field
should *not* appear anywhere in a package!

.. _s-sD.2.6:

Obsolete fields
~~~~~~~~~~~~~~~

These are still recognized by ``dpkg`` but should not appear anywhere
any more.

``Revision``; \ ``Package-Revision``; \ ``Package_Revision``
    The Debian revision part of the package version was at one point in
    a separate control field. This field went through several names.

``Recommended``
    Old name for ``Recommends``.

``Optional``
    Old name for ``Suggests``.

``Class``
    Old name for ``Priority``.

CHAPTER###ap-pkg-controlfields

Control files and their fields (from old Packaging Manual)
==========================================================

Many of the tools in the ``dpkg`` suite manipulate data in a common
format, known as control files. Binary and source packages have control
data as do the ``.changes`` files which control the installation of
uploaded files, and ``dpkg``'s internal databases are in a similar
format.

.. _s-sD.1:

Syntax of control files
-----------------------

See :ref:`s-controlsyntax`.

It is important to note that there are several fields which are optional
as far as ``dpkg`` and the related tools are concerned, but which must
appear in every Debian package, or whose omission may cause problems.

.. _s-sD.2:

List of fields
--------------

See :ref:`s-controlfieldslist`.

This section now contains only the fields that didn't belong to the
Policy manual.

.. _s-pkg-f-Filename:

``Filename`` and ``MSDOS-Filename``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

These fields in ``Packages`` files give the filename(s) of (the parts
of) a package in the distribution directories, relative to the root of
the Debian hierarchy. If the package has been split into several parts
the parts are all listed in order, separated by spaces.

.. _s-pkg-f-Size:

``Size`` and ``MD5sum``
~~~~~~~~~~~~~~~~~~~~~~~

These fields in ``Packages`` files give the size (in bytes, expressed in
decimal) and MD5 checksum of the file(s) which make(s) up a binary
package in the distribution. If the package is split into several parts
the values for the parts are listed in order, separated by spaces.

.. _s-pkg-f-Status:

``Status``
~~~~~~~~~~

This field in ``dpkg``'s status file records whether the user wants a
package installed, removed or left alone, whether it is broken
(requiring re-installation) or not and what its current state on the
system is. Each of these pieces of information is a single word.

.. _s-pkg-f-Config-Version:

``Config-Version``
~~~~~~~~~~~~~~~~~~

If a package is not installed or not configured, this field in
``dpkg``'s status file records the last version of the package which was
successfully configured.

.. _s-pkg-f-Conffiles:

``Conffiles``
~~~~~~~~~~~~~

This field in ``dpkg``'s status file contains information about the
automatically-managed configuration files held by a package. This field
should *not* appear anywhere in a package!

.. _s-sD.2.6:

Obsolete fields
~~~~~~~~~~~~~~~

These are still recognized by ``dpkg`` but should not appear anywhere
any more.

``Revision``; \ ``Package-Revision``; \ ``Package_Revision``
    The Debian revision part of the package version was at one point in
    a separate control field. This field went through several names.

``Recommended``
    Old name for ``Recommends``.

``Optional``
    Old name for ``Suggests``.

``Class``
    Old name for ``Priority``.

