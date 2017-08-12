Shared libraries
================

Packages containing shared libraries must be constructed with a little
care to make sure that the shared library is always available. This is
especially important for packages whose shared libraries are vitally
important, such as the C library (currently ``libc6``).

This section deals only with public shared libraries: shared libraries
that are placed in directories searched by the dynamic linker by default
or which are intended to be linked against normally and possibly used by
other, independent packages. Shared libraries that are internal to a
particular package or that are only loaded as dynamic modules are not
covered by this section and are not subject to its requirements.

A shared library is identified by the ``SONAME`` attribute stored in its
dynamic section. When a binary is linked against a shared library, the
``SONAME`` of the shared library is recorded in the binary's ``NEEDED``
section so that the dynamic linker knows that library must be loaded at
runtime. The shared library file's full name (which usually contains
additional version information not needed in the ``SONAME``) is
therefore normally not referenced directly. Instead, the shared library
is loaded by its ``SONAME``, which exists on the file system as a
symlink pointing to the full name of the shared library. This symlink
must be provided by the package.
:ref:`s-sharedlibs-runtime` describes how to do this.  [#]_

When linking a binary or another shared library against a shared
library, the ``SONAME`` for that shared library is not yet known.
Instead, the shared library is found by looking for a file matching the
library name with ``.so`` appended. This file exists on the file system
as a symlink pointing to the shared library.

Shared libraries are normally split into several binary packages. The
``SONAME`` symlink is installed by the runtime shared library package,
and the bare ``.so`` symlink is installed in the development package
since it's only used when linking binaries or shared libraries. However,
there are some exceptions for unusual shared libraries or for shared
libraries that are also loaded as dynamic modules by other programs.

This section is primarily concerned with how the separation of shared
libraries into multiple packages should be done and how dependencies on
and between shared library binary packages are managed in Debian.
:ref:`s-libraries` should be read in conjunction with
this section and contains additional rules for the files contained in
the shared library packages.

.. _s-sharedlibs-runtime:

Run-time shared libraries
-------------------------

The run-time shared library must be placed in a package whose name
changes whenever the ``SONAME`` of the shared library changes. This
allows several versions of the shared library to be installed at the
same time, allowing installation of the new version of the shared
library without immediately breaking binaries that depend on the old
version. Normally, the run-time shared library and its ``SONAME``
symlink should be placed in a package named librarynamesoversion, where
soversion is the version number in the ``SONAME`` of the shared library.
Alternatively, if it would be confusing to directly append soversion to
libraryname (if, for example, libraryname itself ends in a number), you
should use libraryname-soversion instead.

To determine the soversion, look at the ``SONAME`` of the library,
stored in the ELF ``SONAME`` attribute. It is usually of the form
``name.so.major-version`` (for example, ``libz.so.1``). The version part
is the part which comes after ``.so.``, so in that example it is ``1``.
The soname may instead be of the form ``name-major-version.so``, such as
``libdb-5.1.so``, in which case the name would be ``libdb`` and the
version would be ``5.1``.

If you have several shared libraries built from the same source tree,
you may lump them all together into a single shared library package
provided that all of their ``SONAME``\ s will always change together. Be
aware that this is not normally the case, and if the ``SONAME``\ s do
not change together, upgrading such a merged shared library package will
be unnecessarily difficult because of file conflicts with the old
version of the package. When in doubt, always split shared library
packages so that each binary package installs a single shared library.

Every time the shared library ABI changes in a way that may break
binaries linked against older versions of the shared library, the
``SONAME`` of the library and the corresponding name for the binary
package containing the runtime shared library should change. Normally,
this means the ``SONAME`` should change any time an interface is removed
from the shared library or the signature of an interface (the number of
parameters or the types of parameters that it takes, for example) is
changed. This practice is vital to allowing clean upgrades from older
versions of the package and clean transitions between the old ABI and
new ABI without having to upgrade every affected package simultaneously.

The ``SONAME`` and binary package name need not, and indeed normally
should not, change if new interfaces are added but none are removed or
changed, since this will not break binaries linked against the old
shared library. Correct versioning of dependencies on the newer shared
library by binaries that use the new interfaces is handled via the
|symbols link|_.

.. |symbols link| replace:: ``symbols`` or ``shlibs`` system
.. _symbols link: #s-sharedlibs-depends

The package should install the shared libraries under their normal
names. For example, the libgdbm3 package should install
``libgdbm.so.3.0.0`` as ``/usr/lib/libgdbm.so.3.0.0``. The files should
not be renamed or re-linked by any ``prerm`` or ``postrm`` scripts;
``dpkg`` will take care of renaming things safely without affecting
running programs, and attempts to interfere with this are likely to lead
to problems.

Shared libraries should not be installed executable, since the dynamic
linker does not require this and trying to execute a shared library
usually results in a core dump.

The run-time library package should include the symbolic link for the
``SONAME`` that ``ldconfig`` would create for the shared libraries. For
example, the libgdbm3 package should include a symbolic link from
``/usr/lib/libgdbm.so.3`` to ``libgdbm.so.3.0.0``. This is needed so
that the dynamic linker (for example ``ld.so`` or ``ld-linux.so.*``) can
find the library between the time that ``dpkg`` installs it and the time
that ``ldconfig`` is run in the ``postinst`` script.  [61]_

.. _s-ldconfig:

``ldconfig``
~~~~~~~~~~~~

Any package installing shared libraries in one of the default library
directories of the dynamic linker (which are currently ``/usr/lib`` and
``/lib``) or a directory that is listed in ``/etc/ld.so.conf``  [#]_
must use ``ldconfig`` to update the shared library system.

Any such package must have the line ``activate-noawait ldconfig`` in its
``triggers`` control file (i.e. ``DEBIAN/triggers``

.. _s-sharedlibs-support-files:

Shared library support files
----------------------------

If your package contains files whose names do not change with each
change in the library shared object version, you must not put them in
the shared library package. Otherwise, several versions of the shared
library cannot be installed at the same time without filename clashes,
making upgrades and transitions unnecessarily difficult.

It is recommended that supporting files and run-time support programs
that do not need to be invoked manually by users, but are nevertheless
required for the package to function, be placed (if they are binary) in
a subdirectory of ``/usr/lib``, preferably under
``/usr/lib/``\ package-name. If the program or file is architecture
independent, the recommendation is for it to be placed in a subdirectory
of ``/usr/share`` instead, preferably under
``/usr/share/``\ package-name. Following the package-name naming
convention ensures that the file names change when the shared object
version changes.

Run-time support programs that use the shared library but are not
required for the library to function or files used by the shared library
that can be used by any version of the shared library package should
instead be put in a separate package. This package might typically be
named libraryname-tools; note the absence of the soversion in the
package name.

Files and support programs only useful when compiling software against
the library should be included in the development package for the
library.  [#]_

.. _s-sharedlibs-static:

Static libraries
----------------

The static library (``libraryname.a``) is usually provided in addition
to the shared version. It is placed into the development package (see
below).

In some cases, it is acceptable for a library to be available in static
form only; these cases include:

-  libraries for languages whose shared library support is immature or
   unstable

-  libraries whose interfaces are in flux or under development (commonly
   the case when the library's major version number is zero, or where
   the ABI breaks across patchlevels)

-  libraries which are explicitly intended to be available only in
   static form by their upstream author(s)

.. _s-sharedlibs-dev:

Development files
-----------------

If there are development files associated with a shared library, the
source package needs to generate a binary development package named
libraryname-dev, or if you need to support multiple development versions
at a time, librarynameapiversion-dev. Installing the development package
must result in installation of all the development files necessary for
compiling programs against that shared library.  [#]_

In case several development versions of a library exist, you may need to
use ``dpkg``'s Conflicts mechanism (see
`section\_title <#s-conflicts>`__) to ensure that the user only installs
one development version at a time (as different development versions are
likely to have the same header files in them, which would cause a
filename clash if both were unpacked).

The development package should contain a symlink for the associated
shared library without a version number. For example, the libgdbm-dev
package should include a symlink from ``/usr/lib/libgdbm.so`` to
``libgdbm.so.3.0.0``. This symlink is needed by the linker (``ld``) when
compiling packages, as it will only look for ``libgdbm.so`` when
compiling dynamically.

If the package provides Ada Library Information (``*.ali``) files for
use with GNAT, these files must be installed read-only (mode 0444) so
that GNAT will not attempt to recompile them. This overrides the normal
file mode requirements given in
:ref:`s-permissions-owners`.

.. _s-sharedlibs-intradeps:

Dependencies between the packages of the same library
-----------------------------------------------------

Typically the development version should have an exact version
dependency on the runtime library, to make sure that compilation and
linking happens correctly. The ``${binary:Version}`` substitution
variable can be useful for this purpose.  [#]_

.. _s-sharedlibs-depends:

Dependencies between the library and other packages
---------------------------------------------------

If a package contains a binary or library which links to a shared
library, we must ensure that, when the package is installed on the
system, all of the libraries needed are also installed. These
dependencies must be added to the binary package when it is built, since
they may change based on which version of a shared library the binary or
library was linked with even if there are no changes to the source of
the binary (for example, symbol versions change, macros become functions
or vice versa, or the binary package may determine at compile-time
whether new library interfaces are available and can be called). To
allow these dependencies to be constructed, shared libraries must
provide either a ``symbols`` file or a ``shlibs`` file. These provide
information on the package dependencies required to ensure the presence
of interfaces provided by this library. Any package with binaries or
libraries linking to a shared library must use these files to determine
the required dependencies when it is built. Other packages which use a
shared library (for example using ``dlopen()``) should compute
appropriate dependencies using these files at build time as well.

The two mechanisms differ in the degree of detail that they provide. A
``symbols`` file documents, for each symbol exported by a library, the
minimal version of the package any binary using this symbol will need.
This is typically the version of the package in which the symbol was
introduced. This information permits detailed analysis of the symbols
used by a particular package and construction of an accurate dependency,
but it requires the package maintainer to track more information about
the shared library.

A ``shlibs`` file, in contrast, only documents the last time the library
ABI changed in any way. It only provides information about the library
as a whole, not individual symbols. When a package is built using a
shared library with only a ``shlibs`` file, the generated dependency
will require a version of the shared library equal to or newer than the
version of the last ABI change. This generates unnecessarily restrictive
dependencies compared to ``symbols`` files if none of the symbols used
by the package have changed. This, in turn, may make upgrades needlessly
complex and unnecessarily restrict use of the package on systems with
older versions of the shared libraries.

``shlibs`` files also only support a limited range of library SONAMEs,
making it difficult to use ``shlibs`` files in some unusual corner
cases.  [#]_

``symbols`` files are therefore recommended for most shared library
packages since they provide more accurate dependencies. For most C
libraries, the additional detail required by ``symbols`` files is not
too difficult to maintain. However, maintaining exhaustive symbols
information for a C++ library can be quite onerous, so ``shlibs`` files
may be more appropriate for most C++ libraries. Libraries with a
corresponding udeb must also provide a ``shlibs`` file, since the udeb
infrastructure does not use ``symbols`` files.

.. _s-dpkg-shlibdeps:

Generating dependencies on shared libraries
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When a package that contains any shared libraries or compiled binaries
is built, it must run ``dpkg-shlibdeps`` on each shared library and
compiled binary to determine the libraries used and hence the
dependencies needed by the package. [#]_ To do this, put a call to
``dpkg-shlibdeps`` into your ``debian/rules`` file in the source
package. List all of the compiled binaries, libraries, or loadable
modules in your package.  [68]_ ``dpkg-shlibdeps`` will use the
``symbols`` or ``shlibs`` files installed by the shared libraries to
generate dependency information. The package must then provide a
substitution variable into which the discovered dependency information
can be placed.

If you are creating a udeb for use in the Debian Installer, you will
need to specify that ``dpkg-shlibdeps`` should use the dependency line
of type ``udeb`` by adding the ``-tudeb`` option.  [69]_ If there is no
dependency line of type ``udeb`` in the ``shlibs`` file,
``dpkg-shlibdeps`` will fall back to the regular dependency line.

``dpkg-shlibdeps`` puts the dependency information into the
``debian/substvars`` file by default, which is then used by
``dpkg-gencontrol``. You will need to place a ``${shlibs:Depends}``
variable in the ``Depends`` field in the control file of every binary
package built by this source package that contains compiled binaries,
libraries, or loadable modules. If you have multiple binary packages,
you will need to call ``dpkg-shlibdeps`` on each one which contains
compiled libraries or binaries. For example, you could use the ``-T``
option to the ``dpkg`` utilities to specify a different ``substvars``
file for each binary package.  [70]_

For more details on ``dpkg-shlibdeps``, see its manual page.

We say that a binary ``foo`` *directly* uses a library ``libbar`` if it
is explicitly linked with that library (that is, the library is listed
in the ELF ``NEEDED`` attribute, caused by adding ``-lbar`` to the link
line when the binary is created). Other libraries that are needed by
``libbar`` are linked *indirectly* to ``foo``, and the dynamic linker
will load them automatically when it loads ``libbar``. A package should
depend on the libraries it directly uses, but not the libraries it only
uses indirectly. The dependencies for the libraries used directly will
automatically pull in the indirectly-used libraries. ``dpkg-shlibdeps``
will handle this logic automatically, but package maintainers need to be
aware of this distinction between directly and indirectly using a
library if they have to override its results for some reason.  [#]_

.. _s-sharedlibs-updates:

Shared library ABI changes
~~~~~~~~~~~~~~~~~~~~~~~~~~

Maintaining a shared library package using either ``symbols`` or
``shlibs`` files requires being aware of the exposed ABI of the shared
library and any changes to it. Both ``symbols`` and ``shlibs`` files
record every change to the ABI of the shared library; ``symbols`` files
do so per public symbol, whereas ``shlibs`` files record only the last
change for the entire library.

There are two types of ABI changes: ones that are backward-compatible
and ones that are not. An ABI change is backward-compatible if any
reasonable program or library that was linked with the previous version
of the shared library will still work correctly with the new version of
the shared library.  [#]_ Adding new symbols to the shared library is a
backward-compatible change. Removing symbols from the shared library is
not. Changing the behavior of a symbol may or may not be
backward-compatible depending on the change; for example, changing a
function to accept a new enum constant not previously used by the
library is generally backward-compatible, but changing the members of a
struct that is passed into library functions is generally not unless the
library takes special precautions to accept old versions of the data
structure.

ABI changes that are not backward-compatible normally require changing
the ``SONAME`` of the library and therefore the shared library package
name, which forces rebuilding all packages using that shared library to
update their dependencies and allow them to use the new version of the
shared library. For more information, see
:ref:`s-sharedlibs-runtime`. The remainder of this
section will deal with backward-compatible changes.

Backward-compatible changes require either updating or recording the
minimal-version for that symbol in ``symbols`` files or updating the
version in the dependencies in ``shlibs`` files. For more information on
how to do this in the two formats, see :ref:`s-symbols`
and :ref:`s-shlibs`. Below are general rules that apply
to both files.

The easy case is when a public symbol is added. Simply add the version
at which the symbol was introduced (for ``symbols`` files) or update the
dependency version (for ``shlibs``) files. But special care should be
taken to update dependency versions when the behavior of a public symbol
changes. This is easy to neglect, since there is no automated method of
determining such changes, but failing to update versions in this case
may result in binary packages with too-weak dependencies that will fail
at runtime, possibly in ways that can cause security vulnerabilities. If
the package maintainer believes that a symbol behavior change may have
occurred but isn't sure, it's safer to update the version rather than
leave it unmodified. This may result in unnecessarily strict
dependencies, but it ensures that packages whose dependencies are
satisfied will work properly.

A common example of when a change to the dependency version is required
is a function that takes an enum or struct argument that controls what
the function does. For example:

::

    enum library_op { OP_FOO, OP_BAR };
    int library_do_operation(enum library_op);

If a new operation, ``OP_BAZ``, is added, the minimal-version of
``library_do_operation`` (for ``symbols`` files) or the version in the
dependency for the shared library (for ``shlibs`` files) must be
increased to the version at which ``OP_BAZ`` was introduced. Otherwise,
a binary built against the new version of the library (having detected
at compile-time that the library supports ``OP_BAZ``) may be installed
with a shared library that doesn't support ``OP_BAZ`` and will fail at
runtime when it tries to pass ``OP_BAZ`` into this function.

Dependency versions in either ``symbols`` or ``shlibs`` files normally
should not contain the Debian revision of the package, since the library
behavior is normally fixed for a particular upstream version and any
Debian packaging of that upstream version will have the same behavior.
In the rare case that the library behavior was changed in a particular
Debian revision, appending ``~`` to the end of the version that includes
the Debian revision is recommended, since this allows backports of the
shared library package using the normal backport versioning convention
to satisfy the dependency.

.. _s-sharedlibs-symbols:

The ``symbols`` system
~~~~~~~~~~~~~~~~~~~~~~

In the following sections, we will first describe where the various
``symbols`` files are to be found, then the ``symbols`` file format, and
finally how to create ``symbols`` files if your package contains a
shared library.

.. _s-symbols-paths:

The ``symbols`` files present on the system
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``symbols`` files for a shared library are normally provided by the
shared library package as a control file, but there are several override
paths that are checked first in case that information is wrong or
missing. The following list gives them in the order in which they are
read by ``dpkg-shlibdeps`` The first one that contains the required
information is used.

``debian/*/DEBIAN/symbols``
    During the package build, if the package itself contains shared
    libraries with ``symbols`` files, they will be generated in these
    staging directories by ``dpkg-gensymbols`` (see
    `section\_title <#s-providing-symbols>`__). ``symbols`` files found
    in the build tree take precedence over ``symbols`` files from other
    binary packages.

    These files must exist before ``dpkg-shlibdeps`` is run or the
    dependencies of binaries and libraries from a source package on
    other libraries from that same source package will not be correct.
    In practice, this means that ``dpkg-gensymbols`` must be run before
    ``dpkg-shlibdeps`` during the package build.  [#]_

``/etc/dpkg/symbols/package.symbols.arch`` and ``/etc/dpkg/symbols/package.symbols``
    Per-system overrides of shared library dependencies. These files
    normally do not exist. They are maintained by the local system
    administrator and must not be created by any Debian package.

``symbols`` control files for packages installed on the system
    The ``symbols`` control files for all the packages currently
    installed on the system are searched last. This will be the most
    common source of shared library dependency information. These files
    can be read with ``dpkg-query --control-show package symbols``.

Be aware that if a ``debian/shlibs.local`` exists in the source package,
it will override any ``symbols`` files. This is the only case where a
``shlibs`` is used despite ``symbols`` files being present. See
:ref:`s-shlibs-paths` and
:ref:`s-sharedlibs-shlibdeps` for more information.

.. \_s-symbols:

The ``symbols`` File Format
^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following documents the format of the ``symbols`` control file as
included in binary packages. These files are built from template
``symbols`` files in the source package by ``dpkg-gensymbols``. The
template files support a richer syntax that allows ``dpkg-gensymbols``
to do some of the tedious work involved in maintaining ``symbols``
files, such as handling C++ symbols or optional symbols that may not
exist on particular architectures. When writing ``symbols`` files for a
shared library package, refer to dpkg-gensymbols1 for the richer syntax.

A ``symbols`` may contain one or more entries, one for each shared
library contained in the package corresponding to that ``symbols``. Each
entry has the following format:

::

    library-soname main-dependency-template
     [| alternative-dependency-template]
     [...]
     [* field-name: field-value]
     [...]
     symbol minimal-version[ id-of-dependency-templa.. [#]

To explain this format, we'll use the ``zlib1g`` package as an example,
which (at the time of writing) installs the shared library
``/usr/lib/libz.so.1.2.3.4``. Mandatory lines will be described first,
followed by optional lines.

library-soname must contain exactly the value of the ELF ``SONAME``
attribute of the shared library. In our example, this is ``libz.so.1``.
[#]_

main-dependency-template has the same syntax as a dependency field in a
binary package control file, except that the string ``#MINVER#`` is
replaced by a version restriction like ``(>= version)`` or by nothing if an unversioned dependency is
deemed sufficient. The version restriction will be based on which
symbols from the shared library are referenced and the version at which
they were introduced (see below). In nearly all cases,
main-dependency-template will be ``package #MINVER#``, where package is the name of the binary package
containing the shared library. This adds a simple, possibly-versioned
dependency on the shared library package. In some rare cases, such as
when multiple packages provide the same shared library ABI, the
dependency template may need to be more complex.

In our example, the first line of the ``zlib1g`` ``symbols`` file would
be:

::

    libz.so.1 zlib1g #MINVER#

Each public symbol exported by the shared library must have a
corresponding symbol line, indented by one space. symbol is the exported
symbol (which, for C++, means the mangled symbol) followed by ``@`` and
the symbol version, or the string ``Base`` if there is no symbol
version. minimal-version is the most recent version of the shared
library that changed the behavior of that symbol, whether by adding it,
changing its function signature (the parameters, their types, or the
return type), or changing its behavior in a way that is visible to a
caller. id-of-dependency-template is an optional field that references
an alternative-dependency-template; see below for a full description.

For example, ``libz.so.1`` contains the symbols ``compress`` and
``compressBound``. ``compress`` has no symbol version and last changed
its behavior in upstream version ``1:1.1.4``. ``compressBound`` has the
symbol version ``ZLIB_1.2.0``, was introduced in upstream version
``1:1.2.0``, and has not changed its behavior. Its ``symbols`` file
therefore contains the lines:

::

    compress@Base 1:1.1.4
    compressBound@ZLIB_1.2.0 1:1.2.0

Packages using only ``compress`` would then get a dependency on
``zlib1g (>= 1:1.1.4)``, but packages using ``compressBound`` would get
a dependency on ``zlib1g (>= 1:1.2.0)``.

One or more alternative-dependency-template lines may be provided. These
are used in cases where some symbols in the shared library should use
one dependency template while others should use a different template.
The alternative dependency templates are used only if a symbol line
contains the id-of-dependency-template field. The first alternative
dependency template is numbered 1, the second 2, and so forth.  [#]_

Finally, the entry for the library may contain one or more metadata
fields. Currently, the only supported field-name is
``Build-Depends-Package``, whose value lists the `library development
package <#s-sharedlibs-dev>`_ on which packages using this shared
library declare a build dependency. If this field is present,
``dpkg-shlibdeps`` uses it to ensure that the resulting binary package
dependency on the shared library is at least as strict as the source
package dependency on the shared library development package.  [#]_ For
our example, the ``zlib1g`` ``symbols`` file would contain:

::

    * Build-Depends-Package: zlib1g-dev

Also see ``deb-symbols(5)``.

.. _s-providing-symbols:

Providing a ``symbols`` file
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If your package provides a shared library, you should arrange to include
a ``symbols`` control file following the format described above in that
package. You must include either a ``symbols`` control file or a
``shlibs`` control file.

Normally, this is done by creating a ``symbols`` in the source package
named ``debian/package.symbols`` or ``debian/symbols``, possibly with
``.arch`` appended if the symbols information varies by architecture.
This file may use the extended syntax documented in dpkg-gensymbols1.
Then, call ``dpkg-gensymbols`` as part of the package build process. It
will create ``symbols`` files in the package staging area based on the
binaries and libraries in the package staging area and the ``symbols``
files in the source package. [#]_

Packages that provide ``symbols`` files must keep them up-to-date to
ensure correct dependencies in packages that use the shared libraries.
This means updating the ``symbols`` file whenever a new public symbol is
added, changing the minimal-version field whenever a symbol changes
behavior or signature in a backward-compatible way (see
:ref:`s-sharedlibs-updates`), and changing the
library-soname and main-dependency-template, and probably all of the
minimal-version fields, when the library changes ``SONAME``. Removing a
public symbol from the ``symbols`` file because it's no longer provided
by the library normally requires changing the ``SONAME`` of the library.
See :ref:`s-sharedlibs-runtime` for more information on
``SONAME``\ s.

.. _s-sharedlibs-shlibdeps:

The ``shlibs`` system
~~~~~~~~~~~~~~~~~~~~~

The ``shlibs`` system is a simpler alternative to the ``symbols`` system
for declaring dependencies for shared libraries. It may be more
appropriate for C++ libraries and other cases where tracking individual
symbols is too difficult. It predated the ``symbols`` system and is
therefore frequently seen in older packages. It is also required for
udebs, which do not support ``symbols``.

In the following sections, we will first describe where the various
``shlibs`` files are to be found, then how to use ``dpkg-shlibdeps``,
and finally the ``shlibs`` file format and how to create them.

.. _s-shlibs-paths:

The ``shlibs`` files present on the system
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There are several places where ``shlibs`` files are found. The following
list gives them in the order in which they are read by
``dpkg-shlibdeps``. (The first one which gives the required information
is used.)

``debian/shlibs.local``
    This lists overrides for this package. This file should normally not
    be used, but may be needed temporarily in unusual situations to work
    around bugs in other packages, or in unusual cases where the
    normally declared dependency information in the installed ``shlibs``
    file for a library cannot be used. This file overrides information
    obtained from any other source.

``/etc/dpkg/shlibs.override``
    This lists global overrides. This list is normally empty. It is
    maintained by the local system administrator.

``DEBIAN/shlibs`` files in the "build directory"
    These files are generated as part of the package build process and
    staged for inclusion as control files in the binary packages being
    built. They provide details of any shared libraries included in the
    same package.

``shlibs`` control files for packages installed on the system
    The ``shlibs`` control files for all the packages currently
    installed on the system. These files can be read using ``dpkg-query --control-show package shlibs``.

``/etc/dpkg/shlibs.default``
    This file lists any shared libraries whose packages have failed to
    provide correct ``shlibs`` files. It was used when the ``shlibs``
    setup was first introduced, but it is now normally empty. It is
    maintained by the ``dpkg`` maintainer.

If a ``symbols`` file for a shared library package is available,
``dpkg-shlibdeps`` will always use it in preference to a ``shlibs``,
with the exception of ``debian/shlibs.local``. The latter overrides any
other ``shlibs`` or ``symbols`` files.

.. _s-shlibs:

The ``shlibs`` File Format
^^^^^^^^^^^^^^^^^^^^^^^^^^

Each ``shlibs`` file has the same format. Lines beginning with ``#`` are
considered to be comments and are ignored. Each line is of the form:

::

    [typ.. [#]library-name soname-version dependencies ...

We will explain this by reference to the example of the ``zlib1g``
package, which (at the time of writing) installs the shared library
``/usr/lib/libz.so.1.2.3.4``.

type is an optional element that indicates the type of package for which
the line is valid. The only type currently in use is ``udeb``. The colon
and space after the type are required.

library-name is the name of the shared library, in this case ``libz``.
(This must match the name part of the soname, see below.)

soname-version is the version part of the ELF ``SONAME`` attribute of
the library, determined the same way that the soversion component of the
recommended shared library package name is determined. See
:ref:`s-sharedlibs-runtime` for the details.

dependencies has the same syntax as a dependency field in a binary
package control file. It should give details of which packages are
required to satisfy a binary built against the version of the library
contained in the package. See :ref:`s-depsyntax` for
details on the syntax, and :ref:`s-sharedlibs-updates`
for details on how to maintain the dependency version constraint.

In our example, if the last change to the ``zlib1g`` package that could
change behavior for a client of that library was in version
``1:1.2.3.3.dfsg-1``, then the ``shlibs`` entry for this library could
say:

::

    libz 1 zlib1g (>= 1:1.2.3.3.dfsg)

This version restriction must be new enough that any binary built
against the current version of the library will work with any version of
the shared library that satisfies that dependency.

As zlib1g also provides a udeb containing the shared library, there
would also be a second line:

::

    udeb: libz 1 zlib1g-udeb (>= 1:1.2.3.3.dfsg)

.. _s8.6.4.3:

Providing a ``shlibs`` file
^^^^^^^^^^^^^^^^^^^^^^^^^^^

To provide a ``shlibs`` file for a shared library binary package, create
a ``shlibs`` file following the format described above and place it in
the ``DEBIAN`` directory for that package during the build. It will then
be included as a control file for that package.  [#]_

Since ``dpkg-shlibdeps`` reads the ``DEBIAN/shlibs`` files in all of the
binary packages being built from this source package, all of the
``DEBIAN/shlibs`` files should be installed before ``dpkg-shlibdeps`` is
called on any of the binary packages.

