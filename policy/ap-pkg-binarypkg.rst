Binary packages (from old Packaging Manual)
===========================================

See deb5 and :ref:`s-pkg-controlarea`.

.. _s-pkg-bincreating:

Creating package files - ``dpkg-deb``
-------------------------------------

All manipulation of binary package files is done by ``dpkg-deb``; it's
the only program that has knowledge of the format. (``dpkg-deb`` may be
invoked by calling ``dpkg``, as ``dpkg`` will spot that the options
requested are appropriate to ``dpkg-deb`` and invoke that instead with
the same arguments.)

In order to create a binary package, you must make a directory tree
which contains all the files and directories you want to have in the
file system data part of the package. In Debian-format source packages,
this directory is usually either ``debian/tmp`` or ``debian/pkg``,
relative to the top of the package's source tree.

They should have the locations (relative to the root of the directory
tree you're constructing) ownerships and permissions which you want them
to have on the system when they are installed.

With current versions of ``dpkg`` the uid/username and gid/groupname
mappings for the users and groups being used should be the same on the
system where the package is built and the one where it is installed.

You need to add one special directory to the root of the miniature file
system tree you're creating: ``DEBIAN``. It should contain the control
information files, notably the binary package control file (see
:ref:`s-pkg-controlfile`).

The ``DEBIAN`` directory will not appear in the file system archive of
the package, and so won't be installed by ``dpkg`` when the package is
unpacked.

When you've prepared the package, you should invoke:

::

    dpkg --build directory

This will build the package in ``directory.deb``. (``dpkg`` knows that
``--build`` is a ``dpkg-deb`` option, so it invokes ``dpkg-deb`` with
the same arguments to build the package.)

See the man page dpkg-deb8 for details of how to examine the contents of
this newly-created file. You may find the output of following commands
enlightening:

::

    dpkg-deb --info filename.deb
    dpkg-deb --contents filename.deb
    dpkg --contents filename.deb

To view the copyright file for a package you could use this command:

::

    dpkg --fsys-tarfile filename.deb | tar xOf - --wildcards \*/copyright | pager

.. _s-pkg-controlarea:

Package control information files
---------------------------------

The control information portion of a binary package is a collection of
files with names known to ``dpkg``. It will treat the contents of these
files specially - some of them contain information used by ``dpkg`` when
installing or removing the package; others are scripts which the package
maintainer wants ``dpkg`` to run.

It is possible to put other files in the package control information
file area, but this is not generally a good idea (though they will
largely be ignored).

Here is a brief list of the control information files supported by
``dpkg`` and a summary of what they're used for.

``control``
    This is the key description file used by ``dpkg``. It specifies the
    package's name and version, gives its description for the user,
    states its relationships with other packages, and so forth. See
    :ref:`s-sourcecontrolfiles` and
    :ref:`s-binarycontrolfiles`.

    It is usually generated automatically from information in the source
    package by the ``dpkg-gencontrol`` program, and with assistance from
    ``dpkg-shlibdeps``. See `section\_title <#s-pkg-sourcetools>`__.

``postinst``, ``preinst``, ``postrm``, ``prerm``
    These are executable files (usually scripts) which ``dpkg`` runs
    during installation, upgrade and removal of packages. They allow the
    package to deal with matters which are particular to that package or
    require more complicated processing than that provided by ``dpkg``.
    Details of when and how they are called are in
    :doc:`Package maintainer scripts and installation procedure <ch-maintainerscripts>`.

    It is very important to make these scripts idempotent. See
    :ref:`s-idempotency`.

    The maintainer scripts are not guaranteed to run with a controlling
    terminal and may not be able to interact with the user. See
    :ref:`s-controllingterminal`.

``conffiles``
    This file contains a list of configuration files which are to be
    handled automatically by ``dpkg`` (see
    `appendix\_title <#ap-pkg-conffiles>`__). Note that not necessarily
    every configuration file should be listed here.

``shlibs``
    This file contains a list of the shared libraries supplied by the
    package, with dependency details for each. This is used by
    ``dpkg-shlibdeps`` when it determines what dependencies are required
    in a package control file. The ``shlibs`` file format is described
    on :ref:`s-shlibs`.

.. _s-pkg-controlfile:

The main control information file: ``control``
----------------------------------------------

The most important control information file used by ``dpkg`` when it
installs a package is ``control``. It contains all the package's "vital
statistics".

The binary package control files of packages built from Debian sources
are made by a special tool, ``dpkg-gencontrol``, which reads
``debian/control`` and ``debian/changelog`` to find the information it
needs. See :doc:`ap-pkg-sourcepkg` for more details.

The fields in binary package control files are listed in
:ref:`s-binarycontrolfiles`.

A description of the syntax of control files and the purpose of the
fields is available in
:doc:`Control files and their fields <ch-controlfields>`.

.. _s-sB.4:

Time Stamps
-----------

See :ref:`s-timestamps`.

