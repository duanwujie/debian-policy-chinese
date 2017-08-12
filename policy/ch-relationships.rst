Declaring relationships between packages
========================================

.. _s-depsyntax:

Syntax of relationship fields
-----------------------------

These fields all have a uniform syntax. They are a list of package names
separated by commas.

In the ``Depends``, ``Recommends``, ``Suggests``, ``Pre-Depends``,
``Build-Depends``, ``Build-Depends-Indep`` and ``Build-Depends-Arch``
control fields of the package, which declare dependencies on other
packages, the package names listed may also include lists of alternative
package names, separated by vertical bar (pipe) symbols ``|``. In such a
case, that part of the dependency can be satisfied by any one of the
alternative packages.

All of the fields except for ``Provides`` may restrict their
applicability to particular versions of each named package. This is done
in parentheses after each individual package name; the parentheses
should contain a relation from the list below followed by a version
number, in the format described in :ref:`s-f-Version`.

The relations allowed are ``<<``, ``<=``, ``=``, ``>=`` and ``>>`` for
strictly earlier, earlier or equal, exactly equal, later or equal and
strictly later, respectively.  [#]_

Whitespace may appear at any point in the version specification subject
to the rules in :ref:`s-controlsyntax`, and must appear where it's
necessary to disambiguate; it is not otherwise significant. All of the
relationship fields can only be folded in source package control files.
For consistency and in case of future changes to ``dpkg`` it is
recommended that a single space be used after a version relationship and
before a version number; it is also conventional to put a single space
after each comma, on either side of each vertical bar, and before each
open parenthesis. When opening a continuation line in a relationship
field, it is conventional to do so after a comma and before the space
following that comma.

For example, a list of dependencies might appear as:

::

    Package: mutt
    Version: 1.3.17-1
    Depends: libc6 (>= 2.2.1), exim | mail-transport-agent

Relationships may be restricted to a certain set of architectures. This
is indicated in brackets after each individual package name and the
optional version specification. The brackets enclose a non-empty list of
Debian architecture names in the format described in
:ref:`s-arch-spec`, separated by whitespace. Exclamation marks may
be prepended to each of the names. (It is not permitted for some names
to be prepended with exclamation marks while others aren't.)

For build relationship fields (``Build-Depends``,
``Build-Depends-Indep``, ``Build-Depends-Arch``, ``Build-Conflicts``,
``Build-Conflicts-Indep`` and ``Build-Conflicts-Arch``), if the current
Debian host architecture is not in this list and there are no
exclamation marks in the list, or it is in the list with a prepended
exclamation mark, the package name and the associated version
specification are ignored completely for the purposes of defining the
relationships.

For example:

::

    Source: glibc
    Build-Depends-Indep: texinfo
    Build-Depends: kernel-headers-2.2.10 [!hurd-i386],
     hurd-dev [hurd-i386], gnumach-dev [hurd-i386]

requires ``kernel-headers-2.2.10`` on all architectures other than
hurd-i386 and requires ``hurd-dev`` and ``gnumach-dev`` only on
hurd-i386. Here is another example showing multiple architectures
separated by spaces:

::

    Build-Depends:
     libluajit5.1-dev [i386 amd64 kfreebsd-i386 armel armhf powerpc mips],
     liblua5.1-dev [hurd-i386 ia64 kfreebsd-amd64 s390x sparc],

For binary relationship fields and the ``Built-Using`` field, the
architecture restriction syntax is only supported in the source package
control file ``debian/control``. When the corresponding binary package
control file is generated, the relationship will either be omitted or
included without the architecture restriction based on the architecture
of the binary package. This means that architecture restrictions must
not be used in binary relationship fields for architecture-independent
packages (``Architecture: all``).

For example:

::

    Depends: foo [i386], bar [amd64]

becomes ``Depends: foo`` when the package is built on the ``i386``architecture, ``Depends:
        bar`` when the package is built on the ``amd64`` architecture,
and omitted entirely in binary packages built on all other
architectures.

If the architecture-restricted dependency is part of a set of
alternatives using ``|``, that alternative is ignored completely on
architectures that do not match the restriction. For example:

::

    Build-Depends: foo [!i386] | bar [!amd64]

is equivalent to ``bar`` on the i386 architecture, to ``foo`` on the
amd64 architecture, and to ``foo | bar`` on all other architectures.

Relationships may also be restricted to a certain set of architectures
using architecture wildcards in the format described in
:ref:`s-arch-wildcard-spec`. The syntax for declaring such
restrictions is the same as declaring restrictions using a certain set
of architectures without architecture wildcards. For example:

::

    Build-Depends: foo [linux-any], bar [any-i386], baz [!linux-any]

is equivalent to ``foo`` on architectures using the Linux kernel and any
cpu, ``bar`` on architectures using any kernel and an i386 cpu, and
``baz`` on any architecture using a kernel other than Linux.

Note that the binary package relationship fields such as ``Depends``
appear in one of the binary package sections of the control file,
whereas the build-time relationships such as ``Build-Depends`` appear in
the source package section of the control file (which is the first
section).

.. _s-binarydeps:

Binary Dependencies - ``Depends``, ``Recommends``, ``Suggests``, ``Enhances``, ``Pre-Depends``
----------------------------------------------------------------------------------------------

Packages can declare in their control file that they have certain
relationships to other packages - for example, that they may not be
installed at the same time as certain other packages, and/or that they
depend on the presence of others.

This is done using the ``Depends``, ``Pre-Depends``, ``Recommends``,
``Suggests``, ``Enhances``, ``Breaks`` and ``Conflicts`` control fields.
``Breaks`` is described in :ref:`s-breaks`, and ``Conflicts`` is
described in `??? <#s-conflicts`. The rest are described below.

These seven fields are used to declare a dependency relationship by one
package on another. Except for ``Enhances`` and ``Breaks``, they appear
in the depending (binary) package's control file. (``Enhances`` appears
in the recommending package's control file, and ``Breaks`` appears in
the version of depended-on package which causes the named package to
break).

A ``Depends`` field takes effect *only* when a package is to be
configured. It does not prevent a package being on the system in an
unconfigured state while its dependencies are unsatisfied, and it is
possible to replace a package whose dependencies are satisfied and which
is properly installed with a different version whose dependencies are
not and cannot be satisfied; when this is done the depending package
will be left unconfigured (since attempts to configure it will give
errors) and will not function properly. If it is necessary, a
``Pre-Depends`` field can be used, which has a partial effect even when
a package is being unpacked, as explained in detail below. (The other
three dependency fields, ``Recommends``, ``Suggests`` and ``Enhances``,
are only used by the various front-ends to ``dpkg`` such as ``apt-get``,
``aptitude``, and ``dselect``.)

Since ``Depends`` only places requirements on the order in which
packages are configured, packages in an installation run are usually all
unpacked first and all configured later.  [#]_

If there is a circular dependency among packages being installed or
removed, installation or removal order honoring the dependency order is
impossible, requiring the dependency loop be broken at some point and
the dependency requirements violated for at least one package. Packages
involved in circular dependencies may not be able to rely on their
dependencies being configured before they themselves are configured,
depending on which side of the break of the circular dependency loop
they happen to be on. If one of the packages in the loop has no
``postinst`` script, then the cycle will be broken at that package; this
ensures that all ``postinst`` scripts are run with their dependencies
properly configured if this is possible. Otherwise the breaking point is
arbitrary. Packages should therefore avoid circular dependencies where
possible, particularly if they have ``postinst`` scripts.

The meaning of the five dependency fields is as follows:

``Depends``
    This declares an absolute dependency. A package will not be
    configured unless all of the packages listed in its ``Depends``
    field have been correctly configured (unless there is a circular
    dependency as described above).

    The ``Depends`` field should be used if the depended-on package is
    required for the depending package to provide a significant amount
    of functionality.

    The ``Depends`` field should also be used if the ``postinst`` or
    ``prerm`` scripts require the depended-on package to be unpacked or
    configured in order to run. In the case of ``postinst configure``,
    the depended-on packages will be unpacked and configured first. (If
    both packages are involved in a dependency loop, this might not work
    as expected; see the explanation a few paragraphs back.) In the case
    of ``prerm`` or other ``postinst`` actions, the package dependencies
    will normally be at least unpacked, but they may be only
    "Half-Installed" if a previous upgrade of the dependency failed.

    Finally, the ``Depends`` field should be used if the depended-on
    package is needed by the ``postrm`` script to fully clean up after
    the package removal. There is no guarantee that package dependencies
    will be available when ``postrm`` is run, but the depended-on
    package is more likely to be available if the package declares a
    dependency (particularly in the case of ``postrm remove``). The
    ``postrm`` script must gracefully skip actions that require a
    dependency if that dependency isn't available.

``Recommends``
    This declares a strong, but not absolute, dependency.

    The ``Recommends`` field should list packages that would be found
    together with this one in all but unusual installations.

``Suggests``
    This is used to declare that one package may be more useful with one
    or more others. Using this field tells the packaging system and the
    user that the listed packages are related to this one and can
    perhaps enhance its usefulness, but that installing this one without
    them is perfectly reasonable.

``Enhances``
    This field is similar to Suggests but works in the opposite
    direction. It is used to declare that a package can enhance the
    functionality of another package.

``Pre-Depends``
    This field is like ``Depends``, except that it also forces ``dpkg``
    to complete installation of the packages named before even starting
    the installation of the package which declares the pre-dependency,
    as follows:

    When a package declaring a pre-dependency is about to be *unpacked*
    the pre-dependency can be satisfied if the depended-on package is
    either fully configured, *or even if* the depended-on package(s) are
    only in the "Unpacked" or the "Half-Configured" state, provided that
    they have been configured correctly at some point in the past (and
    not removed or partially removed since). In this case, both the
    previously-configured and currently "Unpacked" or "Half-Configured"
    versions must satisfy any version clause in the ``Pre-Depends``
    field.

    When the package declaring a pre-dependency is about to be
    *configured*, the pre-dependency will be treated as a normal
    ``Depends``. It will be considered satisfied only if the depended-on
    package has been correctly configured. However, unlike with
    ``Depends``, ``Pre-Depends`` does not permit circular dependencies
    to be broken. If a circular dependency is encountered while
    attempting to honor ``Pre-Depends``, the installation will be
    aborted.

    ``Pre-Depends`` are also required if the ``preinst`` script depends
    on the named package. It is best to avoid this situation if
    possible.

    ``Pre-Depends`` should be used sparingly, preferably only by
    packages whose premature upgrade or installation would hamper the
    ability of the system to continue with any upgrade that might be in
    progress.

    You should not specify a ``Pre-Depends`` entry for a package before
    this has been discussed on the ``debian-devel`` mailing list and a
    consensus about doing that has been reached. See
    :ref:`s-dependencies`.

When selecting which level of dependency to use you should consider how
important the depended-on package is to the functionality of the one
declaring the dependency. Some packages are composed of components of
varying degrees of importance. Such a package should list using
``Depends`` the package(s) which are required by the more important
components. The other components' requirements may be mentioned as
Suggestions or Recommendations, as appropriate to the components'
relative importance.

.. _s-breaks:

Packages which break other packages - ``Breaks``
------------------------------------------------

When one binary package declares that it breaks another, ``dpkg`` will
refuse to allow the package which declares ``Breaks`` to be unpacked
unless the broken package is deconfigured first, and it will refuse to
allow the broken package to be reconfigured.

A package will not be regarded as causing breakage merely because its
configuration files are still installed; it must be at least
"Half-Installed".

A special exception is made for packages which declare that they break
their own package name or a virtual package which they provide (see
below): this does not count as a real breakage.

Normally a ``Breaks`` entry will have an "earlier than" version clause;
such a ``Breaks`` is introduced in the version of an (implicit or
explicit) dependency which violates an assumption or reveals a bug in
earlier versions of the broken package, or which takes over a file from
earlier versions of the package named in ``Breaks``. This use of
``Breaks`` will inform higher-level package management tools that the
broken package must be upgraded before the new one.

If the breaking package also overwrites some files from the older
package, it should use ``Replaces`` to ensure this goes smoothly. See
:ref:`s-replaces` for a full discussion of taking over files from
other packages, including how to use ``Breaks`` in those cases.

Many of the cases where ``Breaks`` should be used were previously
handled with ``Conflicts`` because ``Breaks`` did not yet exist. Many
``Conflicts`` fields should now be ``Breaks``. See
:ref:`s-conflicts` for more information about the differences.

.. _s-conflicts:

Conflicting binary packages - ``Conflicts``
-------------------------------------------

When one binary package declares a conflict with another using a
``Conflicts`` field, ``dpkg`` will refuse to allow them to be unpacked
on the system at the same time. This is a stronger restriction than
``Breaks``, which prevents the broken package from being configured
while the breaking package is in the "Unpacked" state but allows both
packages to be unpacked at the same time.

If one package is to be unpacked, the other must be removed first. If
the package being unpacked is marked as replacing (see
:ref:`s-replaces`, but note that ``Breaks`` should normally be used
in this case) the one on the system, or the one on the system is marked
as deselected, or both packages are marked ``Essential``, then ``dpkg``
will automatically remove the package which is causing the conflict.
Otherwise, it will halt the installation of the new package with an
error. This mechanism is specifically designed to produce an error when
the installed package is ``Essential``, but the new package is not.

A package will not cause a conflict merely because its configuration
files are still installed; it must be at least "Half-Installed".

A special exception is made for packages which declare a conflict with
their own package name, or with a virtual package which they provide
(see below): this does not prevent their installation, and allows a
package to conflict with others providing a replacement for it. You use
this feature when you want the package in question to be the only
package providing some feature.

Normally, ``Breaks`` should be used instead of ``Conflicts`` since
``Conflicts`` imposes a stronger restriction on the ordering of package
installation or upgrade and can make it more difficult for the package
manager to find a correct solution to an upgrade or installation
problem. ``Breaks`` should be used

-  when moving a file from one package to another (see
   :ref:`s-replaces`),

-  when splitting a package (a special case of the previous one), or

-  when the breaking package exposes a bug in or interacts badly with
   particular versions of the broken package.

``Conflicts`` should be used

-  when two packages provide the same file and will continue to do so,

-  in conjunction with ``Provides`` when only one package providing a
   given virtual facility may be unpacked at a time (see
   :ref:`s-virtual`),

-  in other cases where one must prevent simultaneous installation of
   two packages for reasons that are ongoing (not fixed in a later
   version of one of the packages) or that must prevent both packages
   from being unpacked at the same time, not just configured.

Be aware that adding ``Conflicts`` is normally not the best solution
when two packages provide the same files. Depending on the reason for
that conflict, using alternatives or renaming the files is often a
better approach. See, for example, :ref:`s-binaries`.

Neither ``Breaks`` nor ``Conflicts`` should be used unless two packages
cannot be installed at the same time or installing them both causes one
of them to be broken or unusable. Having similar functionality or
performing the same tasks as another package is not sufficient reason to
declare ``Breaks`` or ``Conflicts`` with that package.

A ``Conflicts`` entry may have an "earlier than" version clause if the
reason for the conflict is corrected in a later version of one of the
packages. However, normally the presence of an "earlier than" version
clause is a sign that ``Breaks`` should have been used instead. An
"earlier than" version clause in ``Conflicts`` prevents ``dpkg`` from
upgrading or installing the package which declares such a conflict until
the upgrade or removal of the conflicted-with package has been
completed, which is a strong restriction.

.. _s-virtual:

Virtual packages - ``Provides``
-------------------------------

As well as the names of actual ("concrete") packages, the package
relationship fields ``Depends``, ``Recommends``, ``Suggests``,
``Enhances``, ``Pre-Depends``, ``Breaks``, ``Conflicts``,
``Build-Depends``, ``Build-Depends-Indep``, ``Build-Depends-Arch``,
``Build-Conflicts``, ``Build-Conflicts-Indep`` and
``Build-Conflicts-Arch`` may mention "virtual packages".

A *virtual package* is one which appears in the ``Provides`` control
field of another package. The effect is as if the package(s) which
provide a particular virtual package name had been listed by name
everywhere the virtual package name appears. (See also
:ref:`s-virtual-pkg`)

If there are both concrete and virtual packages of the same name, then
the dependency may be satisfied (or the conflict caused) by either the
concrete package with the name in question or any other concrete package
which provides the virtual package with the name in question. This is so
that, for example, supposing we have

::

    Package: foo
    Depends: bar

and someone else releases an enhanced version of the ``bar`` package
they can say:

::

    Package: bar-plus
    Provides: bar

and the ``bar-plus`` package will now also satisfy the dependency for
the ``foo`` package.

If a relationship field has a version number attached, only real
packages will be considered to see whether the relationship is satisfied
(or the prohibition violated, for a conflict or breakage). In other
words, if a version number is specified, this is a request to ignore all
``Provides`` for that package name and consider only real packages. The
package manager will assume that a package providing that virtual
package is not of the "right" version. A ``Provides`` field may not
contain version numbers, and the version number of the concrete package
which provides a particular virtual package will not be considered when
considering a dependency on or conflict with the virtual package name.
[#]_

To specify which of a set of real packages should be the default to
satisfy a particular dependency on a virtual package, list the real
package as an alternative before the virtual one.

If the virtual package represents a facility that can only be provided
by one real package at a time, such as the mail-transport-agent virtual
package that requires installation of a binary that would conflict with
all other providers of that virtual package (see
:ref:`s-mail-transport-agents`), all packages providing that virtual
package should also declare a conflict with it using ``Conflicts``. This
will ensure that at most one provider of that virtual package is
unpacked or installed at a time.

.. _s-replaces:

Overwriting files and replacing packages - ``Replaces``
-------------------------------------------------------

Packages can declare in their control file that they should overwrite
files in certain other packages, or completely replace other packages.
The ``Replaces`` control field has these two distinct purposes.

.. _s7.6.1:

Overwriting files in other packages
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

It is usually an error for a package to contain files which are on the
system in another package. However, if the overwriting package declares
that it ``Replaces`` the one containing the file being overwritten, then
``dpkg`` will replace the file from the old package with that from the
new. The file will no longer be listed as "owned" by the old package and
will be taken over by the new package. Normally, ``Breaks`` should be
used in conjunction with ``Replaces``.  [#]_

For example, if a package foo is split into foo and foo-data starting at
version 1.2-3, foo-data would have the fields

::

    Replaces: foo (<< 1.2-3)
    Breaks: foo (<< 1.2-3)

in its control file. The new version of the package foo would normally
have the field

::

    Depends: foo-data (>= 1.2-3)

(or possibly ``Recommends`` or even ``Suggests`` if the files moved into
foo-data are not required for normal operation).

If a package is completely replaced in this way, so that ``dpkg`` does
not know of any files it still contains, it is considered to have
"disappeared". It will be marked as not wanted on the system (selected
for removal) and "Not-Installed". Any ``conffile``\ s details noted for
the package will be ignored, as they will have been taken over by the
overwriting package. The package's ``postrm`` script will be run with a
special argument to allow the package to do any final cleanup required.
See :ref:`s-mscriptsinstact`.  [#]_

For this usage of ``Replaces``, virtual packages (see
:ref:`s-virtual`) are not considered when looking at a ``Replaces``
field. The packages declared as being replaced must be mentioned by
their real names.

This usage of ``Replaces`` only takes effect when both packages are at
least partially on the system at once. It is not relevant if the
packages conflict unless the conflict has been overridden.

.. _s7.6.2:

Replacing whole packages, forcing their removal
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Second, ``Replaces`` allows the packaging system to resolve which
package should be removed when there is a conflict (see
:ref:`s-conflicts`). This usage only takes effect when the two
packages *do* conflict, so that the two usages of this field do not
interfere with each other.

In this situation, the package declared as being replaced can be a
virtual package, so for example, all mail transport agents (MTAs) would
have the following fields in their control files:

::

    Provides: mail-transport-agent
    Conflicts: mail-transport-agent
    Replaces: mail-transport-agent

ensuring that only one MTA can be unpacked at any one time. See
:ref:`s-virtual` for more information about this example.

.. _s-sourcebinarydeps:

Relationships between source and binary packages - ``Build-Depends``, ``Build-Depends-Indep``, ``Build-Depends-Arch``, ``Build-Conflicts``, ``Build-Conflicts-Indep``, ``Build-Conflicts-Arch``
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Source packages that require certain binary packages to be installed or
absent at the time of building the package can declare relationships to
those binary packages.

This is done using the ``Build-Depends``, ``Build-Depends-Indep``,
``Build-Depends-Arch``, ``Build-Conflicts``, ``Build-Conflicts-Indep``
and ``Build-Conflicts-Arch`` control fields.

Build-dependencies on "build-essential" binary packages can be omitted.
Please see :ref:`s-pkg-relations` for more information.

The dependencies and conflicts they define must be satisfied (as defined
earlier for binary packages) in order to invoke the targets in
``debian/rules``, as follows:

``clean``
    Only the ``Build-Depends`` and ``Build-Conflicts`` fields must be
    satisfied when this target is invoked.

``build-arch``, and ``binary-arch``
    The ``Build-Depends``, ``Build-Conflicts``, ``Build-Depends-Arch``,
    and ``Build-Conflicts-Arch`` fields must be satisfied when these
    targets are invoked.

``build-indep``, and ``binary-indep``
    The ``Build-Depends``, ``Build-Conflicts``, ``Build-Depends-Indep``,
    and ``Build-Conflicts-Indep`` fields must be satisfied when these
    targets are invoked.

``build`` and ``binary``
    The ``Build-Depends``, ``Build-Conflicts``, ``Build-Depends-Indep``,
    ``Build-Conflicts-Indep``, ``Build-Depends-Arch``, and
    ``Build-Conflicts-Arch`` fields must be satisfied when these targets
    are invoked.

.. _s-built-using:

Additional source packages used to build the binary - ``Built-Using``
---------------------------------------------------------------------

Some binary packages incorporate parts of other packages when built but
do not have to depend on those packages. Examples include linking with
static libraries or incorporating source code from another package
during the build. In this case, the source packages of those other
packages are a required part of the complete source (the binary package
is not reproducible without them).

A ``Built-Using`` field must list the corresponding source package for
any such binary package incorporated during the build,  [#]_ including
an "exactly equal" ("=") version relation on the version that was used
to build that binary package.  [#]_

A package using the source code from the gcc-4.6-source binary package
built from the gcc-4.6 source package would have this field in its
control file:

::

    Built-Using: gcc-4.6 (= 4.6.0-11)

A package including binaries from grub2 and loadlin would have this
field in its control file:

::

    Built-Using: grub2 (= 1.99-9), loadlin (= 1.6e-1)

CHAPTER###ch-relationships

Declaring relationships between packages
========================================

.. _s-depsyntax:

Syntax of relationship fields
-----------------------------

These fields all have a uniform syntax. They are a list of package names
separated by commas.

In the ``Depends``, ``Recommends``, ``Suggests``, ``Pre-Depends``,
``Build-Depends``, ``Build-Depends-Indep`` and ``Build-Depends-Arch``
control fields of the package, which declare dependencies on other
packages, the package names listed may also include lists of alternative
package names, separated by vertical bar (pipe) symbols ``|``. In such a
case, that part of the dependency can be satisfied by any one of the
alternative packages.

All of the fields except for ``Provides`` may restrict their
applicability to particular versions of each named package. This is done
in parentheses after each individual package name; the parentheses
should contain a relation from the list below followed by a version
number, in the format described in :ref:`s-f-Version`.

The relations allowed are ``<<``, ``<=``, ``=``, ``>=`` and ``>>`` for
strictly earlier, earlier or equal, exactly equal, later or equal and
strictly later, respectively.  [#]_

Whitespace may appear at any point in the version specification subject
to the rules in :ref:`s-controlsyntax`, and must appear
where it's necessary to disambiguate; it is not otherwise significant.
All of the relationship fields can only be folded in source package
control files. For consistency and in case of future changes to ``dpkg``
it is recommended that a single space be used after a version
relationship and before a version number; it is also conventional to put
a single space after each comma, on either side of each vertical bar,
and before each open parenthesis. When opening a continuation line in a
relationship field, it is conventional to do so after a comma and before
the space following that comma.

For example, a list of dependencies might appear as:

::

    Package: mutt
    Version: 1.3.17-1
    Depends: libc6 (>= 2.2.1), exim | mail-transport-agent

Relationships may be restricted to a certain set of architectures. This
is indicated in brackets after each individual package name and the
optional version specification. The brackets enclose a non-empty list of
Debian architecture names in the format described in
:ref:`s-arch-spec`, separated by whitespace. Exclamation
marks may be prepended to each of the names. (It is not permitted for
some names to be prepended with exclamation marks while others aren't.)

For build relationship fields (``Build-Depends``,
``Build-Depends-Indep``, ``Build-Depends-Arch``, ``Build-Conflicts``,
``Build-Conflicts-Indep`` and ``Build-Conflicts-Arch``), if the current
Debian host architecture is not in this list and there are no
exclamation marks in the list, or it is in the list with a prepended
exclamation mark, the package name and the associated version
specification are ignored completely for the purposes of defining the
relationships.

For example:

::

    Source: glibc
    Build-Depends-Indep: texinfo
    Build-Depends: kernel-headers-2.2.10 [!hurd-i386],
     hurd-dev [hurd-i386], gnumach-dev [hurd-i386]

requires ``kernel-headers-2.2.10`` on all architectures other than
hurd-i386 and requires ``hurd-dev`` and ``gnumach-dev`` only on
hurd-i386. Here is another example showing multiple architectures
separated by spaces:

::

    Build-Depends:
     libluajit5.1-dev [i386 amd64 kfreebsd-i386 armel armhf powerpc mips],
     liblua5.1-dev [hurd-i386 ia64 kfreebsd-amd64 s390x sparc],

For binary relationship fields and the ``Built-Using`` field, the
architecture restriction syntax is only supported in the source package
control file ``debian/control``. When the corresponding binary package
control file is generated, the relationship will either be omitted or
included without the architecture restriction based on the architecture
of the binary package. This means that architecture restrictions must
not be used in binary relationship fields for architecture-independent
packages (``Architecture: all``).

For example:

::

    Depends: foo [i386], bar [amd64]

becomes ``Depends: foo`` when the package is built on the ``i386``architecture, ``Depends:
        bar`` when the package is built on the ``amd64`` architecture,
and omitted entirely in binary packages built on all other
architectures.

If the architecture-restricted dependency is part of a set of
alternatives using ``|``, that alternative is ignored completely on
architectures that do not match the restriction. For example:

::

    Build-Depends: foo [!i386] | bar [!amd64]

is equivalent to ``bar`` on the i386 architecture, to ``foo`` on the
amd64 architecture, and to ``foo | bar`` on all other architectures.

Relationships may also be restricted to a certain set of architectures
using architecture wildcards in the format described in
:ref:`s-arch-wildcard-spec`. The syntax for declaring
such restrictions is the same as declaring restrictions using a certain
set of architectures without architecture wildcards. For example:

::

    Build-Depends: foo [linux-any], bar [any-i386], baz [!linux-any]

is equivalent to ``foo`` on architectures using the Linux kernel and any
cpu, ``bar`` on architectures using any kernel and an i386 cpu, and
``baz`` on any architecture using a kernel other than Linux.

Note that the binary package relationship fields such as ``Depends``
appear in one of the binary package sections of the control file,
whereas the build-time relationships such as ``Build-Depends`` appear in
the source package section of the control file (which is the first
section).

.. _s-binarydeps:

Binary Dependencies - ``Depends``, ``Recommends``, ``Suggests``, ``Enhances``, ``Pre-Depends``
----------------------------------------------------------------------------------------------

Packages can declare in their control file that they have certain
relationships to other packages - for example, that they may not be
installed at the same time as certain other packages, and/or that they
depend on the presence of others.

This is done using the ``Depends``, ``Pre-Depends``, ``Recommends``,
``Suggests``, ``Enhances``, ``Breaks`` and ``Conflicts`` control fields.
``Breaks`` is described in :ref:`s-breaks`, and
``Conflicts`` is described in :ref:`s-conflicts`. The
rest are described below.

These seven fields are used to declare a dependency relationship by one
package on another. Except for ``Enhances`` and ``Breaks``, they appear
in the depending (binary) package's control file. (``Enhances`` appears
in the recommending package's control file, and ``Breaks`` appears in
the version of depended-on package which causes the named package to
break).

A ``Depends`` field takes effect *only* when a package is to be
configured. It does not prevent a package being on the system in an
unconfigured state while its dependencies are unsatisfied, and it is
possible to replace a package whose dependencies are satisfied and which
is properly installed with a different version whose dependencies are
not and cannot be satisfied; when this is done the depending package
will be left unconfigured (since attempts to configure it will give
errors) and will not function properly. If it is necessary, a
``Pre-Depends`` field can be used, which has a partial effect even when
a package is being unpacked, as explained in detail below. (The other
three dependency fields, ``Recommends``, ``Suggests`` and ``Enhances``,
are only used by the various front-ends to ``dpkg`` such as ``apt-get``,
``aptitude``, and ``dselect``.)

Since ``Depends`` only places requirements on the order in which
packages are configured, packages in an installation run are usually all
unpacked first and all configured later.  [#]_

If there is a circular dependency among packages being installed or
removed, installation or removal order honoring the dependency order is
impossible, requiring the dependency loop be broken at some point and
the dependency requirements violated for at least one package. Packages
involved in circular dependencies may not be able to rely on their
dependencies being configured before they themselves are configured,
depending on which side of the break of the circular dependency loop
they happen to be on. If one of the packages in the loop has no
``postinst`` script, then the cycle will be broken at that package; this
ensures that all ``postinst`` scripts are run with their dependencies
properly configured if this is possible. Otherwise the breaking point is
arbitrary. Packages should therefore avoid circular dependencies where
possible, particularly if they have ``postinst`` scripts.

The meaning of the five dependency fields is as follows:

``Depends``
    This declares an absolute dependency. A package will not be
    configured unless all of the packages listed in its ``Depends``
    field have been correctly configured (unless there is a circular
    dependency as described above).

    The ``Depends`` field should be used if the depended-on package is
    required for the depending package to provide a significant amount
    of functionality.

    The ``Depends`` field should also be used if the ``postinst`` or
    ``prerm`` scripts require the depended-on package to be unpacked or
    configured in order to run. In the case of ``postinst configure``,
    the depended-on packages will be unpacked and configured first. (If
    both packages are involved in a dependency loop, this might not work
    as expected; see the explanation a few paragraphs back.) In the case
    of ``prerm`` or other ``postinst`` actions, the package dependencies
    will normally be at least unpacked, but they may be only
    "Half-Installed" if a previous upgrade of the dependency failed.

    Finally, the ``Depends`` field should be used if the depended-on
    package is needed by the ``postrm`` script to fully clean up after
    the package removal. There is no guarantee that package dependencies
    will be available when ``postrm`` is run, but the depended-on
    package is more likely to be available if the package declares a
    dependency (particularly in the case of ``postrm remove``). The
    ``postrm`` script must gracefully skip actions that require a
    dependency if that dependency isn't available.

``Recommends``
    This declares a strong, but not absolute, dependency.

    The ``Recommends`` field should list packages that would be found
    together with this one in all but unusual installations.

``Suggests``
    This is used to declare that one package may be more useful with one
    or more others. Using this field tells the packaging system and the
    user that the listed packages are related to this one and can
    perhaps enhance its usefulness, but that installing this one without
    them is perfectly reasonable.

``Enhances``
    This field is similar to Suggests but works in the opposite
    direction. It is used to declare that a package can enhance the
    functionality of another package.

``Pre-Depends``
    This field is like ``Depends``, except that it also forces ``dpkg``
    to complete installation of the packages named before even starting
    the installation of the package which declares the pre-dependency,
    as follows:

    When a package declaring a pre-dependency is about to be *unpacked*
    the pre-dependency can be satisfied if the depended-on package is
    either fully configured, *or even if* the depended-on package(s) are
    only in the "Unpacked" or the "Half-Configured" state, provided that
    they have been configured correctly at some point in the past (and
    not removed or partially removed since). In this case, both the
    previously-configured and currently "Unpacked" or "Half-Configured"
    versions must satisfy any version clause in the ``Pre-Depends``
    field.

    When the package declaring a pre-dependency is about to be
    *configured*, the pre-dependency will be treated as a normal
    ``Depends``. It will be considered satisfied only if the depended-on
    package has been correctly configured. However, unlike with
    ``Depends``, ``Pre-Depends`` does not permit circular dependencies
    to be broken. If a circular dependency is encountered while
    attempting to honor ``Pre-Depends``, the installation will be
    aborted.

    ``Pre-Depends`` are also required if the ``preinst`` script depends
    on the named package. It is best to avoid this situation if
    possible.

    ``Pre-Depends`` should be used sparingly, preferably only by
    packages whose premature upgrade or installation would hamper the
    ability of the system to continue with any upgrade that might be in
    progress.

    You should not specify a ``Pre-Depends`` entry for a package before
    this has been discussed on the ``debian-devel`` mailing list and a
    consensus about doing that has been reached. See
    :ref:`s-dependencies`.

When selecting which level of dependency to use you should consider how
important the depended-on package is to the functionality of the one
declaring the dependency. Some packages are composed of components of
varying degrees of importance. Such a package should list using
``Depends`` the package(s) which are required by the more important
components. The other components' requirements may be mentioned as
Suggestions or Recommendations, as appropriate to the components'
relative importance.

.. _s-breaks:

Packages which break other packages - ``Breaks``
------------------------------------------------

When one binary package declares that it breaks another, ``dpkg`` will
refuse to allow the package which declares ``Breaks`` to be unpacked
unless the broken package is deconfigured first, and it will refuse to
allow the broken package to be reconfigured.

A package will not be regarded as causing breakage merely because its
configuration files are still installed; it must be at least
"Half-Installed".

A special exception is made for packages which declare that they break
their own package name or a virtual package which they provide (see
below): this does not count as a real breakage.

Normally a ``Breaks`` entry will have an "earlier than" version clause;
such a ``Breaks`` is introduced in the version of an (implicit or
explicit) dependency which violates an assumption or reveals a bug in
earlier versions of the broken package, or which takes over a file from
earlier versions of the package named in ``Breaks``. This use of
``Breaks`` will inform higher-level package management tools that the
broken package must be upgraded before the new one.

If the breaking package also overwrites some files from the older
package, it should use ``Replaces`` to ensure this goes smoothly. See
:ref:`s-replaces` for a full discussion of taking over
files from other packages, including how to use ``Breaks`` in those
cases.

Many of the cases where ``Breaks`` should be used were previously
handled with ``Conflicts`` because ``Breaks`` did not yet exist. Many
``Conflicts`` fields should now be ``Breaks``. See
:ref:`s-conflicts` for more information about the
differences.

.. _s-conflicts:

Conflicting binary packages - ``Conflicts``
-------------------------------------------

When one binary package declares a conflict with another using a
``Conflicts`` field, ``dpkg`` will refuse to allow them to be unpacked
on the system at the same time. This is a stronger restriction than
``Breaks``, which prevents the broken package from being configured
while the breaking package is in the "Unpacked" state but allows both
packages to be unpacked at the same time.

If one package is to be unpacked, the other must be removed first. If
the package being unpacked is marked as replacing (see
:ref:`s-replaces`, but note that ``Breaks`` should
normally be used in this case) the one on the system, or the one on the
system is marked as deselected, or both packages are marked
``Essential``, then ``dpkg`` will automatically remove the package which
is causing the conflict. Otherwise, it will halt the installation of the
new package with an error. This mechanism is specifically designed to
produce an error when the installed package is ``Essential``, but the
new package is not.

A package will not cause a conflict merely because its configuration
files are still installed; it must be at least "Half-Installed".

A special exception is made for packages which declare a conflict with
their own package name, or with a virtual package which they provide
(see below): this does not prevent their installation, and allows a
package to conflict with others providing a replacement for it. You use
this feature when you want the package in question to be the only
package providing some feature.

Normally, ``Breaks`` should be used instead of ``Conflicts`` since
``Conflicts`` imposes a stronger restriction on the ordering of package
installation or upgrade and can make it more difficult for the package
manager to find a correct solution to an upgrade or installation
problem. ``Breaks`` should be used

-  when moving a file from one package to another (see
   :ref:`s-replaces`),

-  when splitting a package (a special case of the previous one), or

-  when the breaking package exposes a bug in or interacts badly with
   particular versions of the broken package.

``Conflicts`` should be used

-  when two packages provide the same file and will continue to do so,

-  in conjunction with ``Provides`` when only one package providing a
   given virtual facility may be unpacked at a time (see
   :ref:`s-virtual`),

-  in other cases where one must prevent simultaneous installation of
   two packages for reasons that are ongoing (not fixed in a later
   version of one of the packages) or that must prevent both packages
   from being unpacked at the same time, not just configured.

Be aware that adding ``Conflicts`` is normally not the best solution
when two packages provide the same files. Depending on the reason for
that conflict, using alternatives or renaming the files is often a
better approach. See, for example, :ref:`s-binaries`.

Neither ``Breaks`` nor ``Conflicts`` should be used unless two packages
cannot be installed at the same time or installing them both causes one
of them to be broken or unusable. Having similar functionality or
performing the same tasks as another package is not sufficient reason to
declare ``Breaks`` or ``Conflicts`` with that package.

A ``Conflicts`` entry may have an "earlier than" version clause if the
reason for the conflict is corrected in a later version of one of the
packages. However, normally the presence of an "earlier than" version
clause is a sign that ``Breaks`` should have been used instead. An
"earlier than" version clause in ``Conflicts`` prevents ``dpkg`` from
upgrading or installing the package which declares such a conflict until
the upgrade or removal of the conflicted-with package has been
completed, which is a strong restriction.

.. _s-virtual:

Virtual packages - ``Provides``
-------------------------------

As well as the names of actual ("concrete") packages, the package
relationship fields ``Depends``, ``Recommends``, ``Suggests``,
``Enhances``, ``Pre-Depends``, ``Breaks``, ``Conflicts``,
``Build-Depends``, ``Build-Depends-Indep``, ``Build-Depends-Arch``,
``Build-Conflicts``, ``Build-Conflicts-Indep`` and
``Build-Conflicts-Arch`` may mention "virtual packages".

A *virtual package* is one which appears in the ``Provides`` control
field of another package. The effect is as if the package(s) which
provide a particular virtual package name had been listed by name
everywhere the virtual package name appears. (See also
:ref:`s-virtual-pkg`)

If there are both concrete and virtual packages of the same name, then
the dependency may be satisfied (or the conflict caused) by either the
concrete package with the name in question or any other concrete package
which provides the virtual package with the name in question. This is so
that, for example, supposing we have

::

    Package: foo
    Depends: bar

and someone else releases an enhanced version of the ``bar`` package
they can say:

::

    Package: bar-plus
    Provides: bar

and the ``bar-plus`` package will now also satisfy the dependency for
the ``foo`` package.

If a relationship field has a version number attached, only real
packages will be considered to see whether the relationship is satisfied
(or the prohibition violated, for a conflict or breakage). In other
words, if a version number is specified, this is a request to ignore all
``Provides`` for that package name and consider only real packages. The
package manager will assume that a package providing that virtual
package is not of the "right" version. A ``Provides`` field may not
contain version numbers, and the version number of the concrete package
which provides a particular virtual package will not be considered when
considering a dependency on or conflict with the virtual package name.
[#]_

To specify which of a set of real packages should be the default to
satisfy a particular dependency on a virtual package, list the real
package as an alternative before the virtual one.

If the virtual package represents a facility that can only be provided
by one real package at a time, such as the mail-transport-agent virtual
package that requires installation of a binary that would conflict with
all other providers of that virtual package (see
:ref:`s-mail-transport-agents`), all packages providing
that virtual package should also declare a conflict with it using
``Conflicts``. This will ensure that at most one provider of that
virtual package is unpacked or installed at a time.

.. _s-replaces:

Overwriting files and replacing packages - ``Replaces``
-------------------------------------------------------

Packages can declare in their control file that they should overwrite
files in certain other packages, or completely replace other packages.
The ``Replaces`` control field has these two distinct purposes.

.. _s7.6.1:

Overwriting files in other packages
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

It is usually an error for a package to contain files which are on the
system in another package. However, if the overwriting package declares
that it ``Replaces`` the one containing the file being overwritten, then
``dpkg`` will replace the file from the old package with that from the
new. The file will no longer be listed as "owned" by the old package and
will be taken over by the new package. Normally, ``Breaks`` should be
used in conjunction with ``Replaces``.  [#]_

For example, if a package foo is split into foo and foo-data starting at
version 1.2-3, foo-data would have the fields

::

    Replaces: foo (<< 1.2-3)
    Breaks: foo (<< 1.2-3)

in its control file. The new version of the package foo would normally
have the field

::

    Depends: foo-data (>= 1.2-3)

(or possibly ``Recommends`` or even ``Suggests`` if the files moved into
foo-data are not required for normal operation).

If a package is completely replaced in this way, so that ``dpkg`` does
not know of any files it still contains, it is considered to have
"disappeared". It will be marked as not wanted on the system (selected
for removal) and "Not-Installed". Any ``conffile``\ s details noted for
the package will be ignored, as they will have been taken over by the
overwriting package. The package's ``postrm`` script will be run with a
special argument to allow the package to do any final cleanup required.
See :ref:`s-mscriptsinstact`.  [#]_

For this usage of ``Replaces``, virtual packages (see
:ref:`s-virtual`) are not considered when looking at a
``Replaces`` field. The packages declared as being replaced must be
mentioned by their real names.

This usage of ``Replaces`` only takes effect when both packages are at
least partially on the system at once. It is not relevant if the
packages conflict unless the conflict has been overridden.

.. _s7.6.2:

Replacing whole packages, forcing their removal
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Second, ``Replaces`` allows the packaging system to resolve which
package should be removed when there is a conflict (see
:ref:`s-conflicts`). This usage only takes effect when
the two packages *do* conflict, so that the two usages of this field do
not interfere with each other.

In this situation, the package declared as being replaced can be a
virtual package, so for example, all mail transport agents (MTAs) would
have the following fields in their control files:

::

    Provides: mail-transport-agent
    Conflicts: mail-transport-agent
    Replaces: mail-transport-agent

ensuring that only one MTA can be unpacked at any one time. See
:ref:`s-virtual` for more information about this example.

.. _s-sourcebinarydeps:

Relationships between source and binary packages - ``Build-Depends``, ``Build-Depends-Indep``, ``Build-Depends-Arch``, ``Build-Conflicts``, ``Build-Conflicts-Indep``, ``Build-Conflicts-Arch``
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Source packages that require certain binary packages to be installed or
absent at the time of building the package can declare relationships to
those binary packages.

This is done using the ``Build-Depends``, ``Build-Depends-Indep``,
``Build-Depends-Arch``, ``Build-Conflicts``, ``Build-Conflicts-Indep``
and ``Build-Conflicts-Arch`` control fields.

Build-dependencies on "build-essential" binary packages can be omitted.
Please see :ref:`s-pkg-relations` for more information.

The dependencies and conflicts they define must be satisfied (as defined
earlier for binary packages) in order to invoke the targets in
``debian/rules``, as follows:

``clean``
    Only the ``Build-Depends`` and ``Build-Conflicts`` fields must be
    satisfied when this target is invoked.

``build-arch``, and ``binary-arch``
    The ``Build-Depends``, ``Build-Conflicts``, ``Build-Depends-Arch``,
    and ``Build-Conflicts-Arch`` fields must be satisfied when these
    targets are invoked.

``build-indep``, and ``binary-indep``
    The ``Build-Depends``, ``Build-Conflicts``, ``Build-Depends-Indep``,
    and ``Build-Conflicts-Indep`` fields must be satisfied when these
    targets are invoked.

``build`` and ``binary``
    The ``Build-Depends``, ``Build-Conflicts``, ``Build-Depends-Indep``,
    ``Build-Conflicts-Indep``, ``Build-Depends-Arch``, and
    ``Build-Conflicts-Arch`` fields must be satisfied when these targets
    are invoked.

.. _s-built-using:

Additional source packages used to build the binary - ``Built-Using``
---------------------------------------------------------------------

Some binary packages incorporate parts of other packages when built but
do not have to depend on those packages. Examples include linking with
static libraries or incorporating source code from another package
during the build. In this case, the source packages of those other
packages are a required part of the complete source (the binary package
is not reproducible without them).

A ``Built-Using`` field must list the corresponding source package for
any such binary package incorporated during the build,  [#]_ including
an "exactly equal" ("=") version relation on the version that was used
to build that binary package.  [#]_

A package using the source code from the gcc-4.6-source binary package
built from the gcc-4.6 source package would have this field in its
control file:

::

    Built-Using: gcc-4.6 (= 4.6.0-11)

A package including binaries from grub2 and loadlin would have this
field in its control file:

::

    Built-Using: grub2 (= 1.99-9), loadlin (= 1.6e-1)

