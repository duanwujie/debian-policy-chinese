Source packages (from old Packaging Manual)
===========================================

The Debian binary packages in the distribution are generated from Debian
sources, which are in a special format to assist the easy and automatic
building of binaries.

.. _s-pkg-sourcetools:

Tools for processing source packages
------------------------------------

Various tools are provided for manipulating source packages; they pack
and unpack sources and help build of binary packages and help manage the
distribution of new versions.

They are introduced and typical uses described here; see dpkg-source1
for full documentation about their arguments and operation.

For examples of how to construct a Debian source package, and how to use
those utilities that are used by Debian source packages, please see the
``hello`` example package.

.. _s-pkg-dpkg-source:

``dpkg-source`` - packs and unpacks Debian source packages
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This program is frequently used by hand, and is also called from
package-independent automated building scripts such as
``dpkg-buildpackage``.

To unpack a package it is typically invoked with

::

    dpkg-source -x .../path/to/filename.dsc

with the ``filename.tar.gz`` and ``filename.diff.gz`` (if applicable) in
the same directory. It unpacks into ``package-version``, and if
applicable ``package-version.orig``, in the current directory.

To create a packed source archive it is typically invoked:

::

    dpkg-source -b package-version

This will create the ``.dsc``, ``.tar.gz`` and ``.diff.gz`` (if
appropriate) in the current directory. ``dpkg-source`` does not clean
the source tree first - this must be done separately if it is required.

See also :ref:`s-pkg-sourcearchives`.

.. _s-pkg-dpkg-buildpackage:

``dpkg-buildpackage`` - overall package-building control script
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

See ``dpkg-buildpackage(1)``.

.. _s-pkg-dpkg-gencontrol:

``dpkg-gencontrol`` - generates binary package control files
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This program is usually called from ``debian/rules`` (see
`section\_title <#s-pkg-sourcetree>`__) in the top level of the source
tree.

This is usually done just before the files and directories in the
temporary directory tree where the package is being built have their
permissions and ownerships set and the package is constructed using
``dpkg-deb/``.  [#]_

``dpkg-gencontrol`` must be called after all the files which are to go
into the package have been placed in the temporary build directory, so
that its calculation of the installed size of a package is correct.

It is also necessary for ``dpkg-gencontrol`` to be run after
``dpkg-shlibdeps`` so that the variable substitutions created by
``dpkg-shlibdeps`` in ``debian/substvars`` are available.

For a package which generates only one binary package, and which builds
it in ``debian/tmp`` relative to the top of the source package, it is
usually sufficient to call ``dpkg-gencontrol``.

Sources which build several binaries will typically need something like:

::

    dpkg-gencontrol -Pdebian/pkg -ppackage

The ``-P`` tells ``dpkg-gencontrol`` that the package is being built in
a non-default directory, and the ``-p`` tells it which package's control
file should be generated.

``dpkg-gencontrol`` also adds information to the list of files in
``debian/files``, for the benefit of (for example) a future invocation
of ``dpkg-genchanges``.

.. _s-pkg-dpkg-shlibdeps:

``dpkg-shlibdeps`` - calculates shared library dependencies
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

See ``dpkg-shlibdeps(1)``.

.. _s-pkg-dpkg-distaddfile:

``dpkg-distaddfile`` - adds a file to ``debian/files``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Some packages' uploads need to include files other than the source and
binary package files.

``dpkg-distaddfile`` adds a file to the ``debian/files`` file so that it
will be included in the ``.changes`` file when ``dpkg-genchanges`` is
run.

It is usually invoked from the ``binary`` target of ``debian/rules``:

::

    dpkg-distaddfile filename section priority

The filename is relative to the directory where ``dpkg-genchanges`` will
expect to find it - this is usually the directory above the top level of
the source tree. The ``debian/rules`` target should put the file there
just before or just after calling ``dpkg-distaddfile``.

The section and priority are passed unchanged into the resulting
``.changes`` file.

.. _s-pkg-dpkg-genchanges:

``dpkg-genchanges`` - generates a ``.changes`` upload control file
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

See ``dpkg-genchanges(1)``.

.. _s-pkg-dpkg-parsechangelog:

``dpkg-parsechangelog`` - produces parsed representation of a changelog
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

See ``dpkg-parsechangelog(1)``.

.. _s-pkg-dpkg-architecture:

``dpkg-architecture`` - information about the build and host system
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

See ``dpkg-architecture(1)``.

.. _s-pkg-sourcetree:

The Debian package source tree
------------------------------

The source archive scheme described later is intended to allow a Debian
package source tree with some associated control information to be
reproduced and transported easily. The Debian package source tree is a
version of the original program with certain files added for the benefit
of the packaging process, and with any other changes required made to
the rest of the source code and installation scripts.

The extra files created for Debian are in the subdirectory ``debian`` of
the top level of the Debian package source tree. They are described
below.

.. _s-pkg-debianrules:

``debian/rules`` - the main building script
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

See :ref:`s-debianrules`.

.. _s-pkg-srcsubstvars:

``debian/substvars`` and variable substitutions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

See :ref:`s-substvars`.

.. _s-sC.2.3:

``debian/files``
~~~~~~~~~~~~~~~~

See :ref:`s-debianfiles`.

.. _s-sC.2.4:

``debian/tmp``
~~~~~~~~~~~~~~

This is the default temporary location for the construction of binary
packages by the ``binary`` target. The directory ``tmp`` serves as the
root of the file system tree as it is being constructed (for example, by
using the package's upstream makefiles install targets and redirecting
the output there), and it also contains the ``DEBIAN`` subdirectory. See
:ref:`s-pkg-bincreating`.

This is only a default and can be easily overridden. Most packaging
tools no longer use ``debian/tmp``, instead preferring ``debian/pkg``
for the common case of a source package building only one binary
package. Such tools usually only use ``debian/tmp`` as a temporary
staging area for built files and do not construct packages from it.

If several binary packages are generated from the same source tree, it
is usual to use a separate ``debian/pkg`` directory for each binary
package as the temporary construction locations.

Whatever temporary directories are created and used by the ``binary``
target must of course be removed by the ``clean`` target.

.. _s-pkg-sourcearchives:

Source packages as archives
---------------------------

As it exists on the FTP site, a Debian source package consists of three
related files. You must have the right versions of all three to be able
to use them.

Debian source control file - ``.dsc``
    This file is a control file used by ``dpkg-source`` to extract a
    source package. See
    :ref:`s-debiansourcecontrolfiles`.

Original source archive - ``package_upstream-version.orig.tar.gz``
    This is a compressed (with ``gzip -9``) ``tar`` file containing the
    source code from the upstream authors of the program.

Debian package diff - ``package_upstream_version-revision.diff.gz``
    This is a unified context diff (``diff -u``) giving the changes
    which are required to turn the original source into the Debian
    source. These changes may only include editing and creating plain
    files. The permissions of files, the targets of symbolic links and
    the characteristics of special files or pipes may not be changed and
    no files may be removed or renamed.

    All the directories in the diff must exist, except the ``debian``
    subdirectory of the top of the source tree, which will be created by
    ``dpkg-source`` if necessary when unpacking.

    The ``dpkg-source`` program will automatically make the
    ``debian/rules`` file executable (see below).

If there is no original source code - for example, if the package is
specially prepared for Debian or the Debian maintainer is the same as
the upstream maintainer - the format is slightly different: then there
is no diff, and the tarfile is named ``package_version.tar.gz``, and
preferably contains a directory named ``package-version``.

.. _s-sC.4:

Unpacking a Debian source package without ``dpkg-source``
---------------------------------------------------------

``dpkg-source -x`` is the recommended way to unpack a Debian source
package. However, if it is not available it is possible to unpack a
Debian source archive as follows:

1. Untar the tarfile, which will create a ``.orig`` directory.

2. Rename the ``.orig`` directory to ``package-version``.

3. Create the subdirectory ``debian`` at the top of the source tree.

4. Apply the diff using ``patch -p0``.

5. Untar the tarfile again if you want a copy of the original source
   code alongside the Debian version.

It is not possible to generate a valid Debian source archive without
using ``dpkg-source``. In particular, attempting to use ``diff``
directly to generate the ``.diff.gz`` file will not work.

.. _s-sC.4.1:

Restrictions on objects in source packages
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The source package may not contain any hard links, [#]_ [#]_ device
special files, sockets or setuid or setgid files.  [#]_

The source packaging tools manage the changes between the original and
Debian source using ``diff`` and ``patch``. Turning the original source
tree as included in the ``.orig.tar.gz`` into the Debian package source
must not involve any changes which cannot be handled by these tools.
Problematic changes which cause ``dpkg-source`` to halt with an error
when building the source package are:

-  Adding or removing symbolic links, sockets or pipes.

-  Changing the targets of symbolic links.

-  Creating directories, other than ``debian``.

-  Changes to the contents of binary files.

Changes which cause ``dpkg-source`` to print a warning but continue
anyway are:

-  Removing files, directories or symlinks.  [#]_

-  Changed text files which are missing the usual final newline (either
   in the original or the modified source tree).

Changes which are not represented, but which are not detected by
``dpkg-source``, are:

-  Changing the permissions of files (other than ``debian/rules``) and
   directories.

The ``debian`` directory and ``debian/rules`` are handled specially by
``dpkg-source`` - before applying the changes it will create the
``debian`` directory, and afterwards it will make ``debian/rules``
world-executable.

