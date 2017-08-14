Source packages
===============

.. _s-standardsversion:

Standards conformance
---------------------

Source packages should specify the most recent version number of this
policy document with which your package complied when it was last
updated.

This information may be used to file bug reports automatically if your
package becomes too much out of date.

The version is specified in the ``Standards-Version`` control field. The
format of the ``Standards-Version`` field is described in
:ref:`s-f-Standards-Version`.

You should regularly, and especially if your package has become out of
date, check for the newest Policy Manual available and update your
package, if necessary. When your package complies with the new standards
you should update the ``Standards-Version`` source package field and
release it.  [#]_

.. _s-pkg-relations:

Package relationships
---------------------

Source packages should specify which binary packages they require to be
installed or not to be installed in order to build correctly. For
example, if building a package requires a certain compiler, then the
compiler should be specified as a build-time dependency.

It is not necessary to explicitly specify build-time relationships on a
minimal set of packages that are always needed to compile, link and put
in a Debian package a standard "Hello World!" program written in C or
C++. The required packages are called *build-essential*, and an
informational list can be found in
``/usr/share/doc/build-essential/list`` (which is contained in the
``build-essential`` package).  [#]_

When specifying the set of build-time dependencies, one should list only
those packages explicitly required by the build. It is not necessary to
list packages which are required merely because some other package in
the list of build-time dependencies depends on them.  [#]_

If build-time dependencies are specified, it must be possible to build
the package and produce working binaries on a system with only essential
and build-essential packages installed and also those required to
satisfy the build-time relationships (including any implied
relationships). In particular, this means that version clauses should be
used rigorously in build-time relationships so that one cannot produce
bad or inconsistently configured packages when the relationships are
properly satisfied.

:doc:`Declaring relationships between packages <ch-relationships>`
explains the technical details.

.. _s4.3:

Changes to the upstream sources
-------------------------------

If changes to the source code are made that are not specific to the
needs of the Debian system, they should be sent to the upstream authors
in whatever form they prefer so as to be included in the upstream
version of the package.

If you need to configure the package differently for Debian or for
Linux, and the upstream source doesn't provide a way to do so, you
should add such configuration facilities (for example, a new
``autoconf`` test or ``#define``) and send the patch to the upstream
authors, with the default set to the way they originally had it. You can
then easily override the default in your ``debian/rules`` or wherever is
appropriate.

You should make sure that the ``configure`` utility detects the correct
architecture specification string (refer to
:ref:`s-arch-spec` for details).

If your package includes the scripts ``config.sub`` and
``config.guess``, you should arrange for the versions provided by the
package autotools-dev be used instead (see autotools-dev documentation
for details how to achieve that). This ensures that these files can be
updated distribution-wide at build time when introducing new
architectures.

If you need to edit a ``Makefile`` where GNU-style ``configure`` scripts
are used, you should edit the ``.in`` files rather than editing the
``Makefile`` directly. This allows the user to reconfigure the package
if necessary. You should *not* configure the package and edit the
generated ``Makefile``! This makes it impossible for someone else to
later reconfigure the package without losing the changes you made.

.. _s-dpkgchangelog:

Debian changelog: ``debian/changelog``
--------------------------------------

Changes in the Debian version of the package should be briefly explained
in the Debian changelog file ``debian/changelog``.  [#]_ This includes
modifications made in the Debian package compared to the upstream one as
well as other changes and updates to the package.  [#]_

The format of the ``debian/changelog`` allows the package building tools
to discover which version of the package is being built and find out
other release-specific information.

That format is a series of entries like this:

::

    package (version) distribution(s); urgency=urgency
      [optional blank line(s), stripped]
      * change details
      more change details
      [blank line(s), included in output of dpkg-parsechangelog]
      * even more change details
      [optional blank line(s), stripped]
    -- maintainer name <email address>[two spaces]  date

``package`` and ``version`` are the source package name and version
number.

``distribution(s)`` lists the distributions where this version should
be installed when it is uploaded - it is copied to the
``Distribution`` field in the ``.changes`` file. See
:ref:`s-f-Distribution`.

``urgency`` is the value for the ``Urgency`` field in the ``.changes``
file for the upload (see :ref:`s-f-Urgency`). It is not possible to
specify an urgency containing commas; commas are used to separate
``keyword=value`` settings in the ``dpkg`` changelog format (though
there is currently only one useful keyword, ``urgency``).

The change details may in fact be any series of lines starting with at
least two spaces, but conventionally each change starts with an asterisk
and a separating space and continuation lines are indented so as to
bring them in line with the start of the text above. Blank lines may be
used here to separate groups of changes, if desired.

If this upload resolves bugs recorded in the Bug Tracking System (BTS),
they may be automatically closed on the inclusion of this package into
the Debian archive by including the string: ``closes:  Bug#nnnnn`` in
the change details.  [#]_ This information is conveyed via the
``Closes`` field in the ``.changes`` file (see
:ref:`s-f-Closes`).

The maintainer name and email address used in the changelog should be
the details of the person who prepared this release of the package. They
are *not* necessarily those of the uploader or usual package maintainer.
[#]_ The information here will be copied to the ``Changed-By`` field
in the ``.changes`` file (see :ref:`s-f-Changed-By`), and
then later used to send an acknowledgement when the upload has been
installed.

The date has the following format  [#]_ (compatible and with the same
semantics of RFC 2822 and RFC 5322):

::

    day-of-week, dd month yyyy hh:mm:ss +zzzz

where:

-  ``day-of week`` is one of: Mon, Tue, Wed, Thu, Fri, Sat, Sun

-  ``dd`` is a one- or two-digit day of the month (01-31)

-  ``month`` is one of: Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct,
   Nov, Dec

-  ``yyyy`` is the four-digit year (e.g. 2010)

-  ``hh`` is the two-digit hour (00-23)

-  ``mm`` is the two-digit minutes (00-59)

-  ``ss`` is the two-digit seconds (00-60)

- ``+zzzz`` or ``-zzzz`` is the time zone offset from Coordinated
   Universal Time (UTC). "+" indicates that the time is ahead of
   (i.e., east of) UTC and "-" indicates that the time is behind
   (i.e., west of) UTC.  The first two digits indicate the hour
   difference from UTC and the last two digits indicate the number of
   additional minutes difference from UTC. The last two digits must be
   in the range 00-59.

The first "title" line with the package name must start at the left hand
margin. The "trailer" line with the maintainer and date details must be
preceded by exactly one space. The maintainer details and the date must
be separated by exactly two spaces.

The entire changelog must be encoded in UTF-8.

For more information on placement of the changelog files within binary
packages, please see :ref:`s-changelogs`.

.. _s-dpkgcopyright:

Copyright: ``debian/copyright``
-------------------------------

Every package must be accompanied by a verbatim copy of its copyright
information and distribution license in the file
``/usr/share/doc/package/copyright`` (see
:ref:`s-copyrightfile` for further details). Also see
:ref:`s-pkgcopyright` for further considerations related
to copyrights for packages.

.. _s4.6:

Error trapping in makefiles
---------------------------

When ``make`` invokes a command in a makefile (including your package's
upstream makefiles and ``debian/rules``), it does so using ``sh``. This
means that ``sh``'s usual bad error handling properties apply: if you
include a miniature script as one of the commands in your makefile
you'll find that if you don't do anything about it then errors are not
detected and ``make`` will blithely continue after problems.

Every time you put more than one shell command (this includes using a
loop) in a makefile command you must make sure that errors are trapped.
For simple compound commands, such as changing directory and then
running a program, using ``&&`` rather than semicolon as a command
separator is sufficient. For more complex commands including most loops
and conditionals you should include a separate ``set -e`` command at the start of every makefile command that's
actually one of these miniature shell scripts.

.. _s-timestamps:

Time Stamps
-----------

Maintainers should preserve the modification times of the upstream
source files in a package, as far as is reasonably possible.  [#]_

.. _s-restrictions:

Restrictions on objects in source packages
------------------------------------------

The source package may not contain any hard links,  [#]_ device special
files, sockets or setuid or setgid files.. [#]_

.. _s-debianrules:

Main building script: ``debian/rules``
--------------------------------------

This file must be an executable makefile, and contains the
package-specific recipes for compiling the package and building binary
package(s) from the source.

It must start with the line ``#!/usr/bin/make -f``, so that it can be
invoked by saying its name rather than invoking ``make`` explicitly.
That is, invoking either of ``make -f debian/rules args...`` or ``./debian/rules args...`` must result in identical behavior.

The following targets are required and must be implemented by
``debian/rules``: ``clean``, ``binary``, ``binary-arch``,
``binary-indep``, ``build``, ``build-arch`` and ``build-indep``. These
are the targets called by ``dpkg-buildpackage``.

Since an interactive ``debian/rules`` script makes it impossible to
auto-compile that package and also makes it hard for other people to
reproduce the same binary package, all required targets must be
non-interactive. It also follows that any target that these targets
depend on must also be non-interactive.

For packages in the main archive, no required targets may attempt
network access.

The targets are as follows:

``build`` (required)
    The ``build`` target should perform all the configuration and
    compilation of the package. If a package has an interactive
    pre-build configuration routine, the Debian source package must
    either be built after this has taken place (so that the binary
    package can be built without rerunning the configuration) or the
    configuration routine modified to become non-interactive. (The
    latter is preferable if there are architecture-specific features
    detected by the configuration routine.)

    For some packages, notably ones where the same source tree is
    compiled in different ways to produce two binary packages, the
    ``build`` target does not make much sense. For these packages it is
    good enough to provide two (or more) targets (``build-a`` and
    ``build-b`` or whatever) for each of the ways of building the
    package, and a ``build`` target that does nothing. The ``binary``
    target will have to build the package in each of the possible ways
    and make the binary package out of each.

    The ``build`` target must not do anything that might require root
    privilege.

    The ``build`` target may need to run the ``clean`` target first -
    see below.

    When a package has a configuration and build routine which takes a
    long time, or when the makefiles are poorly designed, or when
    ``build`` needs to run ``clean`` first, it is a good idea to
    ``touch build`` when the build process is complete. This will ensure
    that if ``debian/rules build`` is run again it will not rebuild the whole
    program. [#]_

``build-arch`` (required), ``build-indep`` (required)
    The ``build-arch`` target must perform all the configuration and
    compilation required for producing all architecture-dependent binary
    packages (those packages for which the body of the ``Architecture``
    field in ``debian/control`` is not ``all``). Similarly, the
    ``build-indep`` target must perform all the configuration and
    compilation required for producing all architecture-independent
    binary packages (those packages for which the body of the
    ``Architecture`` field in ``debian/control`` is ``all``). The
    ``build`` target should either depend on those targets or take the
    same actions as invoking those targets would perform.  [#]_

    The ``build-arch`` and ``build-indep`` targets must not do anything
    that might require root privilege.

``binary`` (required), ``binary-arch`` (required), ``binary-indep`` (required)
    The ``binary`` target must be all that is necessary for the user to
    build the binary package(s) produced from this source package. It is
    split into two parts: ``binary-arch`` builds the binary packages
    which are specific to a particular architecture, and
    ``binary-indep`` builds those which are not.

    ``binary`` may be (and commonly is) a target with no commands which
    simply depends on ``binary-arch`` and ``binary-indep``.

    Both ``binary-*`` targets should depend on the ``build`` target, or
    on the appropriate ``build-arch`` or ``build-indep`` target, so that
    the package is built if it has not been already. It should then
    create the relevant binary package(s), using ``dpkg-gencontrol`` to
    make their control files and ``dpkg-deb`` to build them and place
    them in the parent of the top level directory.

    Both the ``binary-arch`` and ``binary-indep`` targets *must* exist.
    If one of them has nothing to do (which will always be the case if
    the source generates only a single binary package, whether
    architecture-dependent or not), it must still exist and must always
    succeed.

    The ``binary`` targets must be invoked as root.  [#]_

``clean`` (required)     This must undo any effects that the ``build`` and ``binary`` targets
    may have had, except that it should leave alone any output files
    created in the parent directory by a run of a ``binary`` target.

    If a ``build`` file is touched at the end of the ``build`` target,
    as suggested above, it should be removed as the first action that
    ``clean`` performs, so that running ``build`` again after an
    interrupted ``clean`` doesn't think that everything is already done.

    The ``clean`` target may need to be invoked as root if ``binary``
    has been invoked since the last ``clean``, or if ``build`` has been
    invoked as root (since ``build`` may create directories, for
    example).

    The ``clean`` target cannot be used to remove files in the source
    tree that are not compatible with the DFSG. This is because the
    files would remain in the upstream tarball, and thus in the source
    package, so the source package would continue to violate DFSG.
    Instead, the upstream source should be repacked to remove those
    files.

``get-orig-source`` (optional)
    This target fetches the most recent version of the original source
    package from a canonical archive site (via FTP or WWW, for example),
    does any necessary rearrangement to turn it into the original source
    tar file format described below, and leaves it in the current
    directory.

    This target may be invoked in any directory, and should take care to
    clean up any temporary files it may have left.

    This target is optional, but providing it if possible is a good
    idea.

``patch`` (optional)
    This target performs whatever additional actions are required to
    make the source ready for editing (unpacking additional upstream
    archives, applying patches, etc.). It is recommended to be
    implemented for any package where ``dpkg-source -x`` does not result
    in source ready for additional modification. See
    :ref:`s-readmesource`.

The ``build``, ``binary`` and ``clean`` targets must be invoked with the
current directory being the package's top-level directory.

Additional targets may exist in ``debian/rules``, either as published or
undocumented interfaces or for the package's internal use.

The architectures we build on and build for are determined by ``make``
variables using the utility ``dpkg-architecture``. You can determine the
Debian architecture and the GNU style architecture specification string
for the build architecture as well as for the host architecture. The
build architecture is the architecture on which ``debian/rules`` is run
and the package build is performed. The host architecture is the
architecture on which the resulting package will be installed and run.
The target architecture is the architecture of the packages that the
compiler currently being built will generate. These are normally the
same, but may be different in the case of cross-compilation (building
packages for one architecture on machines of a different architecture),
building a cross-compiler (a compiler package that will generate objects
for one architecture, built on a machine of a different architecture) or
a Canadian cross-compiler (a compiler that will generate objects for one
architecture, built on a machine of a different architecture, that will
run on yet a different architecture).

Here is a list of supported ``make`` variables:

-  ``DEB_*_ARCH`` (the Debian architecture)

-  ``DEB_*_ARCH_CPU`` (the Debian CPU name)

-  ``DEB_*_ARCH_BITS`` (the Debian CPU pointer size in bits)

-  ``DEB_*_ARCH_ENDIAN`` (the Debian CPU endianness)

-  ``DEB_*_ARCH_OS`` (the Debian System name)

-  ``DEB_*_GNU_TYPE`` (the GNU style architecture specification string)

-  ``DEB_*_GNU_CPU`` (the CPU part of ``DEB_*_GNU_TYPE``)

-  ``DEB_*_GNU_SYSTEM`` (the System part of ``DEB_*_GNU_TYPE``)

where ``*`` is either ``BUILD`` for specification of the build
architecture, ``HOST`` for specification of the host architecture or
``TARGET`` for specification of the target architecture.

Backward compatibility can be provided in the rules file by setting the
needed variables to suitable default values; please refer to the
documentation of ``dpkg-architecture`` for details.

It is important to understand that the ``DEB_*_ARCH`` string only
determines which Debian architecture we are building on or for. It
should not be used to get the CPU or system information; the
``DEB_*_ARCH_CPU`` and ``DEB_*_ARCH_OS`` variables should be used for
that. GNU style variables should generally only be used with upstream
build systems.

.. _s-debianrules-options:

``debian/rules`` and ``DEB_BUILD_OPTIONS``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Supporting the standardized environment variable ``DEB_BUILD_OPTIONS``
is recommended. This variable can contain several flags to change how a
package is compiled and built. Each flag must be in the form flag or
flag=options. If multiple flags are given, they must be separated by
whitespace.  [#]_ flag must start with a lowercase letter (``a-z``) and
consist only of lowercase letters, numbers (``0-9``), and the characters
``-`` and ``_`` (hyphen and underscore). options must not contain
whitespace. The same tag should not be given multiple times with
conflicting values. Package maintainers may assume that
``DEB_BUILD_OPTIONS`` will not contain conflicting tags.

The meaning of the following tags has been standardized:

``nocheck``
    This tag says to not run any build-time test suite provided by the
    package.

``nodoc``
    This tag says to skip any build steps that only generate package
    documentation. Files required by other sections of Debian Policy,
    such as copyright and changelog files, must still be generated and
    put in the package, but other generated documentation such as
    help2man-generated pages, Doxygen-generated API documentation, or
    info pages generated from Texinfo sources should be skipped if
    possible. This option does not change the set of binary packages
    generated by the source package, but documentation-only binary
    packages may be nearly empty when built with this option.

``noopt``
    The presence of this tag means that the package should be compiled
    with a minimum of optimization. For C programs, it is best to add
    ``-O0`` to ``CFLAGS`` (although this is usually the default). Some
    programs might fail to build or run at this level of optimization;
    it may be necessary to use ``-O1``, for example.

``nostrip``
    This tag means that the debugging symbols should not be stripped
    from the binary during installation, so that debugging information
    may be included in the package.

``parallel=n``
    This tag means that the package should be built using up to ``n``
    parallel processes if the package build system supports this.  [#]_
    If the package build system does not support parallel builds, this
    string must be ignored. If the package build system only supports a
    lower level of concurrency than n, the package should be built using
    as many parallel processes as the package build system supports. It
    is up to the package maintainer to decide whether the package build
    times are long enough and the package build system is robust enough
    to make supporting parallel builds worthwhile.

Unknown flags must be ignored by ``debian/rules``.

The following makefile snippet is an example of how one may implement
the build options; you will probably have to massage this example in
order to make it work for your package.

::

    CFLAGS = -Wall -g
    INSTALL = install
    INSTALL_FILE    = $(INSTALL) -p    -o root -g root  -m  644
    INSTALL_PROGRAM = $(INSTALL) -p    -o root -g root  -m  755
    INSTALL_SCRIPT  = $(INSTALL) -p    -o root -g root  -m  755
    INSTALL_DIR     = $(INSTALL) -p -d -o root -g root  -m  755

    ifneq (,$(filter noopt,$(DEB_BUILD_OPTIONS)))
        CFLAGS += -O0
    else
        CFLAGS += -O2
    endif
    ifeq (,$(filter nostrip,$(DEB_BUILD_OPTIONS)))
        INSTALL_PROGRAM += -s
    endif
    ifneq (,$(filter parallel=%,$(DEB_BUILD_OPTIONS)))
        NUMJOBS = $(patsubst parallel=%,%,$(filter parallel=%,$(DEB_BUILD_OPTIONS)))
        MAKEFLAGS += -j$(NUMJOBS)
    endif

    build:
            # ...
    ifeq (,$(filter nocheck,$(DEB_BUILD_OPTIONS)))
            # Code to run the package test suite.
    endif

.. _s-substvars:

Variable substitutions: ``debian/substvars``
--------------------------------------------

When ``dpkg-gencontrol`` generates :ref:`binary package control files
<s-binarycontrolfiles>` (``DEBIAN/control``), it performs variable
substitutions on its output just before writing it. Variable
substitutions have the form ``${variable}``. The optional file
``debian/substvars`` contains variable substitutions to be used;
variables can also be set directly from ``debian/rules`` using the
``-V`` option to the source packaging commands, and certain predefined
variables are also available.

The ``debian/substvars`` file is usually generated and modified
dynamically by ``debian/rules`` targets, in which case it must be
removed by the ``clean`` target.

See deb-substvars5 for full details about source variable substitutions,
including the format of ``debian/substvars``.

.. _s-debianwatch:

Optional upstream source location: ``debian/watch``
---------------------------------------------------

This is an optional, recommended configuration file for the ``uscan``
utility which defines how to automatically scan ftp or http sites for
newly available updates of the package. This is also used by some Debian
QA tools to help with quality control and maintenance of the
distribution as a whole.

If the upstream maintainer of the software provides OpenPGP signatures
for new releases, including the information required for ``uscan`` to
verify signatures for new upstream releases is also recommended. To do
this, use the ``pgpsigurlmangle`` option in ``debian/watch`` to specify
the location of the upstream signature, and include the key or keys used
to sign upstream releases in the Debian source package as
``debian/upstream/signing-key.asc``.

For more information about ``uscan`` and these options, including how to
generate the file containing upstream signing keys, see uscan1.

.. _s-debianfiles:

Generated files list: ``debian/files``
--------------------------------------

This file is not a permanent part of the source tree; it is used while
building packages to record which files are being generated.
``dpkg-genchanges`` uses it when it generates a ``.changes`` file.

It should not exist in a shipped source package, and so it (and any
backup files or temporary files such as ``files.new``)  [#]_ should be
removed by the ``clean`` target. It may also be wise to ensure a fresh
start by emptying or removing it at the start of the ``binary`` target.

When ``dpkg-gencontrol`` is run for a binary package, it adds an entry
to ``debian/files`` for the ``.deb`` file that will be created when
``dpkg-deb --build`` is run for that binary package. So for most
packages all that needs to be done with this file is to delete it in the
``clean`` target.

If a package upload includes files besides the source package and any
binary packages whose control files were made with ``dpkg-gencontrol``
then they should be placed in the parent of the package's top-level
directory and ``dpkg-distaddfile`` should be called to add the file to
the list in ``debian/files``.

.. _s-embeddedfiles:

Convenience copies of code
--------------------------

Some software packages include in their distribution convenience copies
of code from other software packages, generally so that users compiling
from source don't have to download multiple packages. Debian packages
should not make use of these convenience copies unless the included
package is explicitly intended to be used in this way.  [#]_ If the
included code is already in the Debian archive in the form of a library,
the Debian packaging should ensure that binary packages reference the
libraries already in Debian and the convenience copy is not used. If the
included code is not already in Debian, it should be packaged separately
as a prerequisite if possible.  [#]_

.. _s-readmesource:

Source package handling: ``debian/README.source``
-------------------------------------------------

If running ``dpkg-source -x`` on a source package doesn't produce the
source of the package, ready for editing, and allow one to make changes
and run ``dpkg-buildpackage`` to produce a modified package without
taking any additional steps, creating a ``debian/README.source``
documentation file is recommended. This file should explain how to do
all of the following:

1. Generate the fully patched source, in a form ready for editing, that
   would be built to create Debian packages. Doing this with a ``patch``
   target in ``debian/rules`` is recommended; see
   `Main building script: debian/rules <#s-debianrules>`__.

2. Modify the source and save those modifications so that they will be
   applied when building the package.

3. Remove source modifications that are currently being applied when
   building the package.

4. Optionally, document what steps are necessary to upgrade the Debian
   source package to a new upstream version, if applicable.

This explanation should include specific commands and mention any
additional required Debian packages. It should not assume familiarity
with any specific Debian packaging system or patch management tools.

This explanation may refer to a documentation file installed by one of
the package's build dependencies provided that the referenced
documentation clearly explains these tasks and is not a general
reference manual.

``debian/README.source`` may also include any other information that
would be helpful to someone modifying the source package. Even if the
package doesn't fit the above description, maintainers are encouraged to
document in a ``debian/README.source`` file any source package with a
particularly complex or unintuitive source layout or build system (for
example, a package that builds the same source multiple times to
generate different binary packages).

Reproducibility
---------------

Packages should build reproducibly, which for the purposes of this
document [#]_ means that given

- a version of a source package unpacked at a given path;
- a set of versions of installed build dependencies;
- a set of environment variable values;
- a build architecture; and
- a host architecture,

repeatedly building the source package for the build architecture on
any machine of the host architecture with those versions of the build
dependencies installed and exactly those environment variable values
set will produce bit-for-bit identical binary packages.

It is recommended that packages produce bit-for-bit identical binaries
even if most environment variables and build paths are varied.  It is
intended for this stricter standard to replace the above when it is
easier for packages to meet it.

.. [#]
   See the file ``upgrading-checklist`` for information about policy
   which has changed between different versions of this document.

.. [#]
   Rationale:

   -  This allows maintaining the list separately from the policy
      documents (the list does not need the kind of control that the
      policy documents do).

   -  Having a separate package allows one to install the
      build-essential packages on a machine, as well as allowing other
      packages such as tasks to require installation of the
      build-essential packages using the depends relation.

   -  The separate package allows bug reports against the list to be
      categorized separately from the policy management process in the
      BTS.

.. [#]
   The reason for this is that dependencies change, and you should list
   all those packages, and *only* those packages that *you* need
   directly. What others need is their business. For example, if you
   only link against ``libimlib``, you will need to build-depend on
   libimlib2-dev but not against any ``libjpeg*`` packages, even though
   ``libimlib2-dev`` currently depends on them: installation of
   libimlib2-dev will automatically ensure that all of its run-time
   dependencies are satisfied.

.. [#]
   Mistakes in changelogs are usually best rectified by making a new
   changelog entry rather than "rewriting history" by editing old
   changelog entries.

.. [#]
   Although there is nothing stopping an author who is also the Debian
   maintainer from using this changelog for all their changes, it will
   have to be renamed if the Debian and upstream maintainers become
   different people. In such a case, however, it might be better to
   maintain the package as a non-native package.

.. [#]
   To be precise, the string should match the following Perl regular
   expression:

   ::

       /closes:\s*(?:bug)?\#?\s?\d+(?:,\s*(?:bug)?\#?\s?\d+)*/i

   Then all of the bug numbers listed will be closed by the archive
   maintenance software (``dak``) using the version of the changelog
   entry.

.. [#]
   In the case of a sponsored upload, the uploader signs the files, but
   the changelog maintainer name and address are those of the person who
   prepared this release. If the preparer of the release is not one of
   the usual maintainers of the package (as listed in the
   :ref:```Maintainer`` <#s-f-Maintainer` or
   ```Uploaders`` <s-f-Uploaders>` control fields of the package),
   the first line of the changelog is conventionally used to explain why
   a non-maintainer is uploading the package. The Debian Developer's
   Reference (see :ref:`s-related`) documents the
   conventions used.

.. [#]   This is the same as the format generated by ``date
 -R``.

.. [#]
   The rationale is that there is some information conveyed by knowing
   the age of the file, for example, you could recognize that some
   documentation is very old by looking at the modification time, so it
   would be nice if the modification time of the upstream source would
   be preserved.

.. [#]
   This is not currently detected when building source packages, but
   only when extracting them.

   Hard links may be permitted at some point in the future, but would
   require a fair amount of work.

.. [#]
   Setgid directories are allowed.

.. [#]
   Another common way to do this is for ``build`` to depend on
   ``build-stamp`` and to do nothing else, and for the ``build-stamp``
   target to do the building and to ``touch build-stamp`` on completion.
   This is especially useful if the build routine creates a file or
   directory called ``build``; in such a case, ``build`` will need to be
   listed as a phony target (i.e., as a dependency of the ``.PHONY``
   target). See the documentation of ``make`` for more information on
   phony targets.

.. [#]
   This split allows binary-only builds to not install the dependencies
   required for the ``build-indep`` target and skip any
   resource-intensive build tasks that are only required when building
   architecture-independent binary packages.

.. [#]
   The ``fakeroot`` package often allows one to build a package
   correctly even without being root.

.. [#]
   Some packages support any delimiter, but whitespace is the easiest to
   parse inside a makefile and avoids ambiguity with flag values that
   contain commas.

.. [#]
   Packages built with ``make`` can often implement this by passing the
   ``-j``\ n option to ``make``.

.. [#]
   ``files.new`` is used as a temporary file by ``dpkg-gencontrol`` and
   ``dpkg-distaddfile`` - they write a new version of ``files`` here
   before renaming it, to avoid leaving a corrupted copy if an error
   occurs.

.. [#]
   For example, parts of the GNU build system work like this.

.. [#]
   Having multiple copies of the same code in Debian is inefficient,
   often creates either static linking or shared library conflicts, and,
   most importantly, increases the difficulty of handling security
   vulnerabilities in the duplicated code.

.. [#]
   This is Debian's precisification of the `reproducible-builds.org
   definition <https://reproducible-builds.org/docs/definition/>`_.
