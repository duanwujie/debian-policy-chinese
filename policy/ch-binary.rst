Binary packages
===============

The Debian distribution is based on the Debian package management
system, called ``dpkg``. Thus, all packages in the Debian distribution
must be provided in the ``.deb`` file format.

A ``.deb`` package contains two sets of files: a set of files to
install on the system when the package is installed, and a set of
files that provide additional metadata about the package or which are
executed when the package is installed or removed. This second set of
files is called *control information files*. Among those files are the
package maintainer scripts and ``control``, the `binary package
control file <#s-binarycontrolfiles>`_ that contains the control
fields for the package. Other control information files include the
|symbols link|_ or |shlibs link|_ used to store shared library
dependency information and the ``conffiles`` file that lists the
package's configuration files (described in :ref:`s-config-files`).

.. |symbols link| replace:: ``symbols``
.. _symbols link: #s-sharedlibs-symbols
.. |shlibs link| replace:: ``shlibs``
.. _shlibs link: #s-sharedlibs-shlisb

There is unfortunately a collision of terminology here between control
information files and files in the Debian control file format.
Throughout this document, a *control file* refers to a file in the
Debian control file format. These files are documented in
:doc:`Control files and their fields <ch-controlfields>`. Only files
referred to specifically as *control information files* are the files
included in the control information file member of the ``.deb`` file
format used by binary packages. Most control information files are not
in the Debian control file format.

.. _s3.1:

The package name
----------------

Every package must have a name that's unique within the Debian archive.

The package name is included in the control field ``Package``, the
format of which is described in :ref:`s-f-Package`. The
package name is also included as a part of the file name of the ``.deb``
file.

.. _s-versions:

The version of a package
------------------------

Every package has a version number recorded in its ``Version`` control
file field, described in :ref:`s-f-Version`.

The package management system imposes an ordering on version numbers, so
that it can tell whether packages are being up- or downgraded and so
that package system front end applications can tell whether a package it
finds available is newer than the one installed on the system. The
version number format has the most significant parts (as far as
comparison is concerned) at the beginning.

If an upstream package has problematic version numbers they should be
converted to a sane form for use in the ``Version`` field.

.. _s3.2.1:

Version numbers based on dates
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In general, Debian packages should use the same version numbers as the
upstream sources. However, upstream version numbers based on some date
formats (sometimes used for development or "snapshot" releases) will not
be ordered correctly by the package management software. For example,
``dpkg`` will consider "96May01" to be greater than "96Dec24".

To prevent having to use epochs for every new upstream version, the
date-based portion of any upstream version number should be given in a
way that sorts correctly: four-digit year first, followed by a two-digit
numeric month, followed by a two-digit numeric date, possibly with
punctuation between the components.

Native Debian packages (i.e., packages which have been written
especially for Debian) whose version numbers include dates should also
follow these rules. If punctuation is desired between the date
components, remember that hyphen (``-``) cannot be used in native
package versions. Period (``.``) is normally a good choice.

.. _s-maintainer:

The maintainer of a package
---------------------------

Every package must have a maintainer, except for orphaned packages as
described below. The maintainer may be one person or a group of people
reachable from a common email address, such as a mailing list. The
maintainer is responsible for maintaining the Debian packaging files,
evaluating and responding appropriately to reported bugs, uploading new
versions of the package (either directly or through a sponsor), ensuring
that the package is placed in the appropriate archive area and included
in Debian releases as appropriate for the stability and utility of the
package, and requesting removal of the package from the Debian
distribution if it is no longer useful or maintainable.

The maintainer must be specified in the ``Maintainer`` control field
with their correct name and a working email address. The email address
given in the ``Maintainer`` control field must accept mail from those
role accounts in Debian used to send automated mails regarding the
package. This includes non-spam mail from the bug-tracking system, all
mail from the Debian archive maintenance software, and other role
accounts or automated processes that are commonly agreed on by the
project.  [#]_ If one person or team maintains several packages, they
should use the same form of their name and email address in the
``Maintainer`` fields of those packages.

The format of the ``Maintainer`` control field is described in
:ref:`s-f-Maintainer`.

If the maintainer of the package is a team of people with a shared email
address, the ``Uploaders`` control field must be present and must
contain at least one human with their personal email address. See
:ref:`s-f-Uploaders` for the syntax of that field.

An orphaned package is one with no current maintainer. Orphaned packages
should have their ``Maintainer`` control field set to ``Debian QA Group <packages@qa.debian.org>``. These packages are considered
maintained by the Debian project as a whole until someone else
volunteers to take over maintenance.  [#]_

.. _s-descriptions:

The description of a package
----------------------------

Every Debian package must have a ``Description`` control field which
contains a synopsis and extended description of the package. Technical
information about the format of the ``Description`` field is in
:ref:`s-f-Description`.

The description should describe the package (the program) to a user
(system administrator) who has never met it before so that they have
enough information to decide whether they want to install it. This
description should not just be copied verbatim from the program's
documentation.

Put important information first, both in the synopsis and extended
description. Sometimes only the first part of the synopsis or of the
description will be displayed. You can assume that there will usually be
a way to see the whole extended description.

The description should also give information about the significant
dependencies and conflicts between this package and others, so that the
user knows why these dependencies and conflicts have been declared.

Instructions for configuring or using the package should not be included
(that is what installation scripts, manual pages, info files, etc., are
for). Copyright statements and other administrivia should not be
included either (that is what the copyright file is for).

.. _s-synopsis:

The single line synopsis
~~~~~~~~~~~~~~~~~~~~~~~~

The single line synopsis should be kept brief - certainly under 80
characters.

Do not include the package name in the synopsis line. The display
software knows how to display this already, and you do not need to state
it. Remember that in many situations the user may only see the synopsis
line - make it as informative as you can.

.. _s-extendeddesc:

The extended description
~~~~~~~~~~~~~~~~~~~~~~~~

Do not try to continue the single line synopsis into the extended
description. This will not work correctly when the full description is
displayed, and makes no sense where only the summary (the single line
synopsis) is available.

The extended description should describe what the package does and how
it relates to the rest of the system (in terms of, for example, which
subsystem it is which part of).

The description field needs to make sense to anyone, even people who
have no idea about any of the things the package deals with.  [#]_

.. _s-dependencies:

Dependencies
------------

Every package must specify the dependency information about other
packages that are required for the first to work correctly.

For example, a dependency entry must be provided for any shared
libraries required by a dynamically-linked executable binary in a
package.

Packages are not required to declare any dependencies they have on other
packages which are marked ``Essential`` (see below), and should not do
so unless they depend on a particular version of that package.  [#]_

Sometimes, unpacking one package requires that another package be first
unpacked *and* configured. In this case, the depending package must
specify this dependency in the ``Pre-Depends`` control field.

You should not specify a ``Pre-Depends`` entry for a package before this
has been discussed on the ``debian-devel`` mailing list and a consensus
about doing that has been reached.

The format of the package interrelationship control fields is described
in :doc:`Declaring relationships between packages <ch-relationships>`.

.. _s-virtual-pkg:

Virtual packages
----------------

Sometimes, there are several packages which offer more-or-less the same
functionality. In this case, it's useful to define a *virtual package*
whose name describes that common functionality. (The virtual packages
only exist logically, not physically; that's why they are called
*virtual*.) The packages with this particular function will then
*provide* the virtual package. Thus, any other package requiring that
function can simply depend on the virtual package without having to
specify all possible packages individually.

All packages should use virtual package names where appropriate, and
arrange to create new ones if necessary. They should not use virtual
package names (except privately, amongst a cooperating group of
packages) unless they have been agreed upon and appear in the list of
virtual package names. (See also :ref:`s-virtual`)

The latest version of the authoritative list of virtual package names
can be found in the ``debian-policy`` package. It is also available from
the Debian web mirrors at
https://www.debian.org/doc/packaging-manuals/virtual-package-names-list.txt.

The procedure for updating the list is described in the preface to the
list.

.. _s3.7:

Base system
-----------

The ``base system`` is a minimum subset of the Debian system that is
installed before everything else on a new system. Only very few packages
are allowed to form part of the base system, in order to keep the
required disk usage very small.

The base system consists of all those packages with priority
``required`` or ``important``. Many of them will be tagged ``essential``
(see below).

.. _s3.8:

Essential packages
------------------

Essential is defined as the minimal set of functionality that must be
available and usable on the system at all times, even when packages are
in the "Unpacked" state. Packages are tagged ``essential`` for a system
using the ``Essential`` control field. The format of the ``Essential``
control field is described in :ref:`s-f-Essential`.

Since these packages cannot be easily removed (one has to specify an
extra *force option* to ``dpkg`` to do so), this flag must not be used
unless absolutely necessary. A shared library package must not be tagged
``essential``; dependencies will prevent its premature removal, and we
need to be able to remove it when it has been superseded.

Since dpkg will not prevent upgrading of other packages while an
``essential`` package is in an unconfigured state, all ``essential``
packages must supply all of their core functionality even when
unconfigured. If the package cannot satisfy this requirement it must not
be tagged as essential, and any packages depending on this package must
instead have explicit dependency fields as appropriate.

Maintainers should take great care in adding any programs, interfaces,
or functionality to ``essential`` packages. Packages may assume that
functionality provided by ``essential`` packages is always available
without declaring explicit dependencies, which means that removing
functionality from the Essential set is very difficult and is almost
never done. Any capability added to an ``essential`` package therefore
creates an obligation to support that capability as part of the
Essential set in perpetuity.

You must not tag any packages ``essential`` before this has been
discussed on the ``debian-devel`` mailing list and a consensus about
doing that has been reached.

.. _s-maintscripts:

Maintainer Scripts
------------------

The package installation scripts should avoid producing output which is
unnecessary for the user to see and should rely on ``dpkg`` to stave off
boredom on the part of a user installing many packages. This means,
amongst other things, not passing the ``--verbose`` option to
``update-alternatives``.

Errors which occur during the execution of an installation script must
be checked and the installation must not continue after an error.

Note that in general :ref:`s-scripts` applies to package
maintainer scripts, too.

You should not use ``dpkg-divert`` on a file belonging to another
package without consulting the maintainer of that package first. When
adding or removing diversions, package maintainer scripts must provide
the ``--package`` flag to ``dpkg-divert`` and must not use ``--local``.

All packages which supply an instance of a common command name (or, in
general, filename) should generally use ``update-alternatives``, so that
they may be installed together. If ``update-alternatives`` is not used,
then each package must use ``Conflicts`` to ensure that other packages
are removed. (In this case, it may be appropriate to specify a conflict
against earlier versions of something that previously did not use
``update-alternatives``; this is an exception to the usual rule that
versioned conflicts should be avoided.)

.. _s-maintscriptprompt:

Prompting in maintainer scripts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Package maintainer scripts may prompt the user if necessary. Prompting
must be done by communicating through a program, such as ``debconf``,
which conforms to the Debian Configuration Management Specification,
version 2 or higher.

Packages which are essential, or which are dependencies of essential
packages, may fall back on another prompting method if no such interface
is available when they are executed.

The Debian Configuration Management Specification is included in the
``debconf_specification`` files in the debian-policy package. It is also
available from the Debian web mirrors at
https://www.debian.org/doc/packaging-manuals/debconf_specification.html.

Packages which use the Debian Configuration Management Specification may
contain the additional control information files ``config`` and
``templates``. ``config`` is an additional maintainer script used for
package configuration, and ``templates`` contains templates used for
user prompting. The ``config`` script might be run before the
``preinst`` script and before the package is unpacked or any of its
dependencies or pre-dependencies are satisfied. Therefore it must work
using only the tools present in *essential* packages.  [#]_

Packages which use the Debian Configuration Management Specification
must allow for translation of their user-visible messages by using a
gettext-based system such as the one provided by the po-debconf package.

Packages should try to minimize the amount of prompting they need to do,
and they should ensure that the user will only ever be asked each
question once. This means that packages should try to use appropriate
shared configuration files (such as ``/etc/papersize`` and
``/etc/news/server``), and shared debconf variables rather than each
prompting for their own list of required pieces of information.

It also means that an upgrade should not ask the same questions again,
unless the user has used ``dpkg --purge`` to remove the package's
configuration. The answers to configuration questions should be stored
in an appropriate place in ``/etc`` so that the user can modify them,
and how this has been done should be documented.

If a package has a vitally important piece of information to pass to the
user (such as "don't run me as I am, you must edit the following
configuration files first or you risk your system emitting
badly-formatted messages"), it should display this in the ``config`` or
``postinst`` script and prompt the user to hit return to acknowledge the
message. Copyright messages do not count as vitally important (they
belong in ``/usr/share/doc/package/copyright``); neither do instructions
on how to use a program (these should be in on-line documentation, where
all the users can see them).

Any necessary prompting should almost always be confined to the
``config`` or ``postinst`` script. If it is done in the ``postinst``, it
should be protected with a conditional so that unnecessary prompting
doesn't happen if a package's installation fails and the ``postinst`` is
called with ``abort-upgrade``, ``abort-remove`` or
``abort-deconfigure``.

