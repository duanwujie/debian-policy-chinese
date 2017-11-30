Upgrading checklist
===================

About the checklist
-------------------

The checklist below has been created to simplify the upgrading process
of old packages. This list is not official or normative. It only
provides an indication of what has changed and whether you are likely to
need to make changes to your package in light of this. If you have
doubts about a certain topic, if you need more details, or if you think
some other package does not comply with policy, please refer to the
Policy Manual itself.

All of the changes from version 3.0.0 onwards indicate which section of
the Policy Manual discusses the issue. The section numbering should
still be accurate for changes back to the 2.5.0 release. Before that
point, the sections listed here probably no longer correspond to
sections in the modern Policy Manual.

Here is how the check list works: Check which policy version your
package was checked against last (indicated in the ``Standards-Version``
field of the source package). Then move upwards until the top and check
which of the items on the list might concern your package. Note which
sections of policy discuss this, and then check out the Policy Manual
for details. Once you've made all necessary changes to match the current
rules, update the value of ``Standards-Version`` to the current Policy
Manual version.

If an item in the list is followed by the name of a Lintian tag in
square brackets, it indicates that the policy requirement is covered
by that Lintian tag.  The lack of such an annotation does not mean
that no Lintian tag exists to cover the requirement.  Our coverage of
these annotations is quite incomplete, and patches to this checklist
are very welcome.

The sections in this checklist match the values for the
``Standards-Version`` control field in omitting the minor patch version,
except in the two anomalous historical cases where normative
requirements were changed in a minor patch release.

Version 4.1.2
-------------

Unreleased.

10.2
    Private shared object files should be installed in subdirectories
    of ``/usr/lib`` or ``/usr/lib/triplet``.  This change permits
    private shared object files to take advantage of multiarch, and
    also removes the implication that it is permissible to install
    private shared object files directly into ``/usr/lib/triplet``.

10.4
    The shebang at the top of Perl command scripts must be
    ``#!/usr/bin/perl``.  (Previously, this was a 'should' rather than
    a 'must'.)

Version 4.1.1
-------------

Released September, 2017.

4.4
    debian/changelog must exist in source packages.

9.2.3
    The canonical non-existent home directory is ``/nonexistent``.

Version 4.1.0
-------------

Released August, 2017.

2.2.1
    Non-default alternative dependencies on non-free packages are
    permitted for packages in main.

4.11
    If upstream provides OpenPGP signatures, including the upstream
    signing key as ``debian/upstream/signing-key.asc`` in the source
    package and using the ``pgpsigurlmangle`` option in
    ``debian/watch`` configuration to indicate how to find the upstream
    signature for new releases is recommended.

4.15
    Packages should build reproducibly when certain factors are held
    constant; see 4.15 for the list.

4.15
    Packages are recommended to build reproducibly even when build
    paths and most environment variables are allowed to vary.

9.1.1
    Only the dynamic linker may install files to ``/lib64/``.

    No package for a 64 bit architecture may install files to
    ``/usr/lib64/`` or any subdirectory.

11.8.3
    The required behaviour of ``x-terminal-emulator -e`` has been
    clarified, and updated to replace a false claim about the
    behaviour of ``xterm``.

    Programs must support ``-e command`` where ``command`` may include
    multiple arguments, which must be executed as if the arguments
    were passed to ``execvp`` directly, bypassing the shell.

    If this execution fails and ``-e`` has a single argument,
    ``xterm``'s fallback behaviour of passing ``command`` to the shell
    is permitted but not required.

Version 4.0.1
-------------

Released August, 2017.

2.5
    Priorities are now used only for controlling which packages are part
    of a minimal or standard Debian installation and should be selected
    based on functionality provided directly to users (so nearly all
    shared libraries should have a priority of ``optional``). Packages
    may now depend on packages with a lower priority.

    The ``extra`` priority has been deprecated and should be treated as
    equivalent to ``optional``. All ``extra`` priorities should be
    changed to ``optional``. Packages with a priority of ``optional``
    may conflict with each other (but packages that both have a priority
    of ``standard`` or higher still may not conflict).

5.6.30
    New section documenting the ``Testsuite`` field in Debian source
    control files.

8.1.1
    Shared libraries must now invoke ``ldconfig`` by means of triggers,
    instead of maintscripts.

9.3.3
    Packages are recommended to use debhelper tools instead of invoking
    ``update-rc.d`` and ``invoke-rc.d`` directly.

9.3.3
    Policy's description of how the local system administrator may
    modify the runlevels at which a daemon is started and stopped, and
    how init scripts may depend on other init scripts, have been
    removed. These are now handled by LSB headers.

9.4
    Policy's specification of the console messages that should be
    emitted by ``init.d`` scripts has been removed. This is now defined
    by LSB, for sysvinit, and is not expected to be followed by other
    init systems.

9.6
    Packages installing a Free Desktop entry must not also install a
    Debian menu system entry.

9.9
    The prohibition against depending on environment variables for
    reasonable defaults is only for programs on the system PATH and only
    for custom environment variable settings (not, say, a sane PATH).

Version 4.0.0
-------------

Released May, 2017.

4.3
    ``config.sub`` and ``config.guess`` should be updated at build time
    or replaced with the versions from autotools-dev.

4.9
    New ``TARGET`` set of ``dpkg-architecture`` variables and new
    ``DEB_*_ARCH_BITS`` and ``DEB_*_ARCH_ENDIAN`` variables.

4.9.1
    New ``DEB_BUILD_OPTIONS`` tag, ``nodoc``, which says to suppress
    documentation generation (but continue to build all binary packages,
    even documentation packages, just let them be mostly empty).

5.2
    Automatically-generated debug packages do not need to have a
    corresponding paragraph in ``debian/control``. (This is existing
    practice; this Policy update is just clearer about it.)

5.6.12
    Colons are not permitted in upstream version numbers.

7.7
    New ``Build-Depends-Arch`` and ``Build-Conflicts-Arch`` fields are
    now supported.

8.4
    The recommended package name for shared library development files is
    now libraryname-dev or librarynameapiversion-dev, not
    librarynamesoversion-dev.

9.1.1
    The stable release of Debian supports ``/run``, so packages may now
    assume that it exists and do not need any special dependency on a
    version of initscripts.

9.3.2
    New optional ``try-restart`` standard init script argument, which
    (if supported) should restart the service if it is already running
    and otherwise just report success.

9.3.2
    Support for the ``status`` init script argument is recommended.

9.3.3.2
    Packages must not call ``/etc/init.d`` scripts directly even as a
    fallback, and instead must always use ``invoke-rc.d`` (which is
    essential and shouldn't require any conditional).

9.11.1
    Instructions for ``upstart`` integration removed since ``upstart``
    is no longer maintained in Debian.

10.1
    Packages may not install files in both ``/path`` and ``/usr/path``,
    and must manage any backward-compatibility symlinks so that they
    don't break if ``/path`` and ``/usr/path`` are the same directory.

10.6
    Packages should assume device files in ``/dev`` are dynamically
    managed and don't have to be created by the package. Packages other
    than those whose purpose is to manage ``/dev`` must not create or
    remove files there when a dynamic management facility is in use.
    Named pipes and device files outside of ``/dev`` should normally be
    created on demand via init scripts, systemd units, or similar
    mechanisms, but may be created and removed in maintainer scripts if
    they must be created during package installation.

10.9
    Checking with the base-passwd maintainer is no longer required (or
    desirable) when creating a new dynamic user or group in a package.

12.3
    Dependencies on \*-doc packages should be at most Recommends
    (Suggests if they only include documentation in supplemental
    formats).

12.5
    The Mozilla Public License 1.1 and 2.0 (MPL-1.1 and MPL-2.0) are now
    included in ``/usr/share/common-licenses`` and do not need to be
    copied verbatim in the package ``copyright`` file.

copyright-format
    The ``https`` form of the copyright-format URL is now allowed and
    preferred in the ``Format`` field.

perl
    The Perl search path now includes multiarch directories. The vendor
    directory for architecture-specific modules is now versioned to
    support multiarch.

virtual
    New ``adventure`` virtual package for implementations of the classic
    Colossal Cave Adventure game.

virtual
    New ``httpd-wsgi3`` virtual package for Python 3 WSGI-capable HTTP
    servers. The existing ``httpd-wsgi`` virtual package is for Python 2
    WSGI-capable HTTP servers.

virtual
    New ``virtual-mysql-client``, ``virtual-mysql-client-core``,
    ``virtual-mysql-server``, ``virtual-mysql-server-core``, and
    ``virtual-mysql-testsuite`` virtual packages for MySQL-compatible
    software.

Version 3.9.8
-------------

Released April, 2016.

9.6
    The menu system is deprecated in favor of the FreeDesktop menu
    standard. New requirements set for FreeDesktop menu entries.

9.7
    New instructions for registering media type handlers with the
    FreeDesktop system, which automatically synchronizes with mailcap
    and therefore replaces mailcap registration for packages using
    desktop entries.

Version 3.9.7
-------------

Released February, 2016.

10.5
    Symbolic links must not traverse above the root directory.

9.2.2
    32bit UIDs in the range 65536-4294967293 are reserved for
    dynamically allocated user accounts.

5.1
    Empty field values in control files are only permitted in the
    ``debian/control`` file of a source package.

4.9
    ``debian/rules``: required targets must not attempt network access.

12.3
    recommend to ship additional documentation for package ``pkg`` in a
    separate package ``pkg-doc`` and install it into
    ``/usr/share/doc/pkg``.

Version 3.9.6
-------------

Released September, 2014.

9.1
    The FHS is relaxed to allow a subdirectory of ``/usr/lib`` to hold a
    mixture of architecture-independent and architecture-dependent
    files, though directories entirely composed of
    architecture-independent files should be located in ``/usr/share``.

9.1
    The FHS requirement for ``/usr/local/lib64`` to exist if ``/lib64``
    or ``/usr/lib64`` exists is removed.

9.1
    An FHS exception has been granted for multiarch include files,
    permitting header files to instead be installed to
    ``/usr/include/triplet``.

10.1
    Binaries must not be statically linked with the GNU C library, see
    policy for exceptions.

4.4
    It is clarified that signature appearing in debian/changelog should
    be the details of the person who prepared this release of the
    package.

11.5
    The default web document root is now ``/var/www/html``

virtual
    ``java1-runtime`` and ``java2-runtime`` are removed,
    ``javaN-runtime`` and ``javaN-runtime-headless`` are added for all N
    between 5 and 9.

virtual
    Added ``httpd-wsgi`` for WSGI capable HTTP servers.

perl
    Perl packages should use the ``%Config`` hash to locate module paths
    instead of hardcoding paths in ``@INC``.

perl
    Perl binary modules and any modules installed into
    ``$Config{vendorarch}`` must depend on the relevant perlapi-\*
    package.

Version 3.9.5
-------------

Released October, 2013.

5.1
    Control data fields must not start with the hyphen character
    (``-``), to avoid potential confusions when parsing clearsigned
    control data files that were not properly unescaped.

5.4, 5.6.24
    ``Checksums-Sha1`` and ``Checksums-Sha256`` are now mandatory in
    ``.dsc`` files.

5.6.25, 5.8.1
    The ``DM-Upload-Allowed`` field is obsolete. Permissions are now
    granted via *dak-commands* files.

5.6.27
    New section documenting the ``Package-List`` field in Debian source
    control files.

5.6.28
    New section documenting the ``Package-Type`` field in source package
    control files.

5.6.29
    New section documenting the ``Dgit`` field in Debian source control
    files.

9.1.1.8
    The exception to the FHS for the ``/selinux`` was removed.

10.7.3
    Packages should remove all obsolete configuration files without
    local changes during upgrades. The ``dpkg-maintscript-helper`` tool,
    available from the dpkg package since *Wheezy*, can help with this.

10.10
    The name of the files and directories installed by binary packages
    must be encoded in UTF-8 and should be restricted to ASCII when
    possible. In the system PATH, they must be restricted to ASCII.

11.5.2
    Stop recommending to serve HTML documents from
    ``/usr/share/doc/package``.

12.2
    Packages distributing Info documents should use install-info's
    trigger, and do not need anymore to depend on
    ``dpkg (>= 1.15.4) | install-info``.

debconf
    The ``escape`` capability is now documented.

virtual
    ``mp3-decoder`` and ``mp3-encoder`` are removed.

Version 3.9.4
-------------

Released August, 2012.

2.4
    New *tasks* archive section.

4.9
    ``build-arch`` and ``build-indep`` are now mandatory targets in
    ``debian/rules``.

5.6.26
    New section documenting the ``Vcs-*`` fields, which are already in
    widespread use. Note the mechanism for specifying the Git branch
    used for packaging in the Vcs-Git field.

7.1
    The deprecated relations < and > now must not be used.

7.8
    New ``Built-Using`` field, which must be used to document the source
    packages for any binaries that are incorporated into this package at
    build time. This is used to ensure that the archive meets license
    requirements for providing source for all binaries.

8.6
    Policy for dependencies between shared libraries and other packages
    has been largely rewritten to document the ``symbols`` system and
    more clearly document handling of shared library ABI changes.
    ``symbols`` files are now recommended over ``shlibs`` files in most
    situations. All maintainers of shared library packages should review
    the entirety of this section.

9.1.1
    Packages must not assume the ``/run`` directory exists or is usable
    without a dependency on ``initscripts (>= 2.88dsf-13.3)`` until the
    stable release of Debian supports ``/run``.

9.7
    Packages including MIME configuration can now rely on triggers and
    do not need to call update-mime.

9.11
    New section documenting general requirements for alternate init
    systems and specific requirements for integrating with upstart.

12.5
    All copyright files must be encoded in UTF-8.

Version 3.9.3
-------------

Released February, 2012.

2.4
    New archive sections *education*, *introspection*, and
    *metapackages* added.

5.6.8
    The ``Architecture`` field in ``*.dsc`` files may now contain the
    value ``any all`` for source packages building both
    architecture-independent and architecture-dependent packages.

7.1
    If a dependency is restricted to particular architectures, the list
    of architectures must be non-empty.

9.1.1
    ``/run`` is allowed as an exception to the FHS and replaces
    ``/var/run``. ``/run/lock`` replaces ``/var/lock``. The FHS
    requirements for the older directories apply to these directories as
    well. Backward compatibility links will be maintained and packages
    need not switch to referencing ``/run`` directly yet. Files in
    ``/run`` should be stored in a temporary file system.

9.1.4
    New section spelling out the requirements for packages that use
    files in ``/run``, ``/var/run``, or ``/var/lock``. This generalizes
    information previously only in 9.3.2.

9.5
    Cron job file names must not contain ``.`` or ``+`` or they will be
    ignored by cron. They should replace those characters with ``_``. If
    a package provides multiple cron job files in the same directory,
    they should each start with the package name (possibly modified as
    above), ``-``, and then some suitable suffix.

9.10
    Packages using doc-base do not need to call install-docs anymore.

10.7.4
    Packages that declare the same ``conffile`` may see left-over
    configuration files from each other even if they conflict.

11.8
    The Policy rules around Motif libraries were just a special case of
    normal rules for non-free dependencies and were largely obsolete, so
    they have been removed.

12.5
    ``debian/copyright`` is no longer required to list the Debian
    maintainers involved in the creation of the package (although note
    that the requirement to list copyright information is unchanged).

copyright-format
    Version 1.0 of the "Machine-readable ``debian/copyright`` file"
    specification is included.

mime
    This separate document has been retired and and its (short) contents
    merged into Policy section 9.7. There are no changes to the
    requirements.

perl
    Packages may declare an interest in the perl-major-upgrade trigger
    to be notified of major upgrades of perl.

virtual
    ``ttf-japanese-{mincho, gothic}`` is renamed to
    ``fonts-japanese-{mincho, gothic}``.

Version 3.9.2
-------------

Released April, 2011.

\*
    Multiple clarifications throughout Policy where "installed" was used
    and the more precise terms "unpacked" or "configured" were intended.

3.3
    The maintainer address must accept mail from Debian role accounts
    and the BTS. At least one human must be listed with their personal
    email address in ``Uploaders`` if the maintainer is a shared email
    address. The duties of a maintainer are also clearer.

5
    All control fields are now classified as simple, folded, or
    multiline, which governs whether their values must be a single line
    or may be continued across multiple lines and whether line breaks
    are significant.

5.1
    Parsers are allowed to accept paragraph separation lines containing
    whitespace, but control files should use completely empty lines.
    Ordering of paragraphs is significant. Field names must be composed
    of printable ASCII characters except colon and must not begin with
    #.

5.6.25
    The ``DM-Upload-Allowed`` field is now documented.

6.5
    The system state maintainer scripts can rely upon during each
    possible invocation is now documented. In several less-common cases,
    this is stricter than Policy had previously documented. Packages
    with complex maintainer scripts should be reviewed in light of this
    new documentation.

7.2
    The impact on system state when maintainer scripts that are part of
    a circular dependency are run is now documented. Circular
    dependencies are now a should not.

7.2
    The system state when ``postinst`` and ``prerm`` scripts are run is
    now documented, and the documentation of the special case of
    dependency state for ``postrm`` scripts has been improved.
    ``postrm`` scripts are required to gracefully skip actions if their
    dependencies are not available.

9.1.1
    GNU/Hurd systems are allowed ``/hurd`` and ``/servers`` directories
    in the root filesystem.

9.1.1
    Packages installing to architecture-specific subdirectories of
    ``/usr/lib`` must use the value returned by
    ``dpkg-architecture -qDEB_HOST_MULTIARCH``, not by
    ``dpkg-architecture -qDEB_HOST_GNU_TYPE``; this is a path change on
    i386 architectures and a no-op for other architectures.

virtual
    ``mailx`` is now a virtual package provided by packages that install
    ``/usr/bin/mailx`` and implement at least the POSIX-required
    interface.

Version 3.9.1
-------------

Released July, 2010.

3.2.1
    Date-based version components should be given as the four-digit
    year, two-digit month, and then two-digit day, but may have embedded
    punctuation.

3.9
    Maintainer scripts must pass ``--package`` to ``dpkg-divert`` when
    creating or removing diversions and must not use ``--local``.

4.10
    Only ``dpkg-gencontrol`` supports variable substitution.
    ``dpkg-genchanges`` (for ``*.changes``) and ``dpkg-source`` (for
    ``*.dsc``) do not.

7.1
    Architecture restrictions and wildcards are also allowed in binary
    package relationships provided that the binary package is not
    architecture-independent.

7.4
    ``Conflicts`` and ``Breaks`` should only be used when there are file
    conflicts or one package breaks the other, not just because two
    packages provide similar functionality but don't interfere.

8.1
    The SONAME of a library should change whenever the ABI of the
    library changes in a way that isn't backward-compatible. It should
    not change if the library ABI changes are backward-compatible.
    Discourage bundling shared libraries together in one package.

8.4
    Ada Library Information (``*.ali``) files must be installed
    read-only.

8.6.1, 8.6.2, 8.6.5
    Packages should normally not include a ``shlibs.local`` file since
    we now have complete ``shlibs`` coverage.

8.6.3
    The SONAME of a library may instead be of the form
    ``name-major-version.so``.

10.2
    Libtool ``.la`` files should not be installed for public libraries.
    If they're required (for ``libltdl``, for instance), the
    ``dependency_libs`` setting should be emptied. Library packages
    historically including ``.la`` files must continue to include them
    (with ``dependency_libs`` emptied) until all libraries that depend
    on that library have removed or emptied their ``.la`` files.

10.2
    Libraries no longer need to be built with ``-D_REENTRANT``, which
    was an obsolete LinuxThreads requirement. Instead, say explicitly
    that libraries should be built with threading support and to be
    thread-safe if the library supports this.

10.4
    ``/bin/sh`` scripts may assume that ``kill`` supports an argument of
    ``-signal``, that ``kill`` and ``trap`` support the numeric signals
    listed in the XSI extension, and that signal 13 (SIGPIPE) can be
    trapped with ``trap``.

10.8
    Use of ``/etc/logrotate.d/package`` for logrotate rules is now
    recommended.

10.9
    Control information files should be owned by ``root:root`` and
    either mode 644 or mode 755.

11.4, 11.8.3, 11.8.4
    Packages providing alternatives for ``editor``, ``pager``,
    ``x-terminal-emulator``, or ``x-window-manager`` should also provide
    a slave alternative for the corresponding manual page.

11.5
    Cgi-bin executable files may be installed in subdirectories of
    ``/usr/lib/cgi-bin`` and web servers should serve out executables in
    those subdirectories.

12.5
    The GPL version 1 is now included in common-licenses and should be
    referenced from there instead of included in the ``copyright`` file.

Version 3.9.0
-------------

Released June, 2010.

4.4, 5.6.15
    The required format for the date in a changelog entry and in the
    Date control field is now precisely specified.

5.1
    A control paragraph must not contain more than one instance of a
    particular field name.

5.4, 5.5, 5.6.24
    The ``Checksums-Sha1`` and ``Checksums-Sha256`` fields in ``*.dsc``
    and ``*.changes`` files are now documented and recommended.

5.5, 5.6.16
    The ``Format`` field of ``.changes`` files is now 1.8. The
    ``Format`` field syntax for source package ``.dsc`` files allows a
    subtype in parentheses, and it is used for a different purpose than
    the ``Format`` field for ``.changes`` files.

5.6.2
    The syntax of the ``Maintainer`` field is now must rather than
    should.

5.6.3
    The comma separating entries in ``Uploaders`` is now must rather
    than should.

5.6.8, 7.1, 11.1.1
    Architecture wildcards may be used in addition to specific
    architectures in ``debian/control`` and ``*.dsc`` Architecture
    fields, and in architecture restrictions in build relationships.

6.3
    Maintainer scripts are no longer guaranteed to run with a
    controlling terminal and must be able to fall back to noninteractive
    behavior (debconf handles this). Maintainer scripts may abort if
    there is no controlling terminal and no reasonable default for a
    high-priority question, but should avoid this if possible.

7.3, 7.6.1
    ``Breaks`` should be used with ``Replaces`` for moving files between
    packages.

7.4
    ``Breaks`` should normally be used instead of ``Conflicts`` for
    transient issues and moving files between packages. New
    documentation of when each should be used.

7.5
    Use ``Conflicts`` with ``Provides`` if only one provider of a
    virtual facility can be installed at a time.

8.4
    All shared library development files are no longer required to be in
    the ``-dev`` package, only be available when the ``-dev`` package is
    installed. This allows the ``-dev`` package to be split as long as
    it depends on the additional packages.

9.2.2
    The UID range of user accounts is extended to 1000-59999.

9.3.2, 10.4
    ``init.d`` scripts are a possible exception from the normal
    requirement to use ``set -e`` in each shell script.

12.5
    The UCB BSD license was removed from the list of licenses that
    should be referenced from ``/usr/share/common-licenses/BSD``. It
    should instead be included directly in ``debian/copyright``,
    although it will still be in common-licenses for the time being.

debconf
    ``SETTITLE`` is now documented (it has been supported for some
    time). ``SETTITLE`` is like ``TITLE`` but takes a template instead
    of a string to allow translation.

perl
    perl-base now provides perlapi-abiname instead of a package based
    solely on the Perl version. Perl packages must now depend on
    perlapi-$Config{debian\_abi}, falling back on ``$Config{version}``
    if ``$Config{debian_abi}`` is not set.

perl
    Packages using ``Makefile.PL`` should use ``DESTDIR`` rather than
    ``PREFIX`` to install into the package staging area. ``PREFIX`` only
    worked due to a Debian-local patch.

Version 3.8.4
-------------

Released January, 2010.

9.1.1
    An FHS exception has been granted for multiarch libraries.
    Permitting files to instead be installed to ``/lib/triplet`` and
    ``/usr/lib/triplet`` directories.

10.6
    Packages may not contain named pipes and should instead create them
    in postinst and remove them in prerm or postrm.

9.1.1
    ``/sys`` and ``/selinux`` directories are explicitly allowed as an
    exception to the FHS.

Version 3.8.3
-------------

Released August, 2009.

4.9
    DEB\_\*\_ARCH\_CPU and DEB\_\*\_ARCH\_OS variables are now
    documented and recommended over GNU-style variables for that
    information.

5.6.8
    Source package Architecture fields may contain *all* in combination
    with other architectures. Clarify when *all* and *any* may be used
    in different versions of the field.

5.6.14
    The Debian archive software does not support uploading to multiple
    distributions with one ``*.changes`` file.

5.6.19
    The Binary field may span multiple lines.

10.2
    Shared library packages are no longer allowed to install libraries
    in a non-standard location and modify ``ld.so.conf``. Packages
    should either be installed in a standard library directory or
    packages using them should be built with RPATH.

11.8.7
    Installation directories for X programs have been clarified.
    Packages are no longer required to pre-depend on x11-common before
    installing into ``/usr/include/X11`` and ``/usr/lib/X11``.

12.1
    Manual pages are no longer required to contain only characters
    representable in the legacy encoding for that language.

12.1
    Localized man pages should either be kept up-to-date with the
    original version or warn that they're not up-to-date, either with
    warning text or by showing missing or changed portions in the
    original language.

12.2
    install-info is now handled via triggers so packages no longer need
    to invoke it in maintainer scripts. Info documents should now have
    directory sections and entries in the document. Packages containing
    info documents should add a dependency to support partial upgrades.

perl
    The requirement for Perl modules to have a versioned Depend and
    Build-Depend on ``perl >= 5.6.0-16`` has been removed.

Version 3.8.2
-------------

Released June, 2009.

2.4
    The list of archive sections has been significantly expanded. See
    `this debian-devel-announce
    message <http://lists.debian.org/debian-devel-announce/2009/03/msg00010.html>`__
    for the list of new sections and rules for how to categorize
    packages.

3.9.1
    All packages must use debconf or equivalent for user prompting,
    though essential packages or their dependencies may also fall back
    on other methods.

5.6.1
    The requirements for source package names are now explicitly spelled
    out.

9.1
    Legacy XFree86 servers no longer get a special exception from the
    FHS permitting ``/etc/X11/XF86Config-4``.

9.1.3
    Removed obsolete dependency requirements for packages that use
    ``/var/mail``.

11.8.5
    Speedo fonts are now deprecated. The X backend was disabled starting
    in lenny.

12.5
    The GNU Free Documentation License version 1.3 is included in
    common-licenses and should be referenced from there.

Version 3.8.1
-------------

Released March, 2009.

3.8
    Care should be taken when adding functionality to essential and such
    additions create an obligation to support that functionality in
    essential forever unless significant work is done.

4.4
    Changelog files must be encoded in UTF-8.

4.4
    Some format requirements for changelog files are now "must" instead
    of "should."

4.4.1
    Alternative changelog formats have been removed. Debian only
    supports one changelog format for the Debian Archive.

4.9.1
    New nocheck option for DEB\_BUILD\_OPTIONS indicating any build-time
    test suite provided by the package should not be run.

5.1
    All control files must be encoded in UTF-8.

5.2
    ``debian/control`` allows comment lines starting with # with no
    preceding whitespace.

9.3
    Init scripts ending in .sh are not handled specially. They are not
    sourced and are not guaranteed to be run by ``/bin/sh`` regardless
    of the #! line. This brings Policy in line with the long-standing
    behavior of the init system in Debian.

9.3.2
    The start action of an init script must exit successfully and not
    start the daemon again if it's already running.

9.3.2
    ``/var/run`` and ``/var/lock`` may be mounted as temporary
    filesystems, and init scripts must therefore create any necessary
    subdirectories dynamically.

10.4
    ``/bin/sh`` scripts may assume that local can take multiple variable
    arguments and supports assignment.

11.6
    User mailboxes may be mode 600 and owned by the user rather than
    mode 660, owned by user, and group mail.

Version 3.8.0
-------------

Released June, 2008.

2.4, 3.7
    The base section has been removed. contrib and non-free have been
    removed from the section list; they are only categories. The base
    system is now defined by priority.

4.9
    If ``dpkg-source -x`` doesn't provide the source that will be
    compiled, a debian/rules patch target is recommended and should do
    whatever else is necessary.

4.9.1, 10.1
    Standardized the format of DEB\_BUILD\_OPTIONS. Specified permitted
    characters for tags, required that tags be whitespace-separated,
    allowed packages to assume non-conflicting tags, and required
    unknown flags be ignored.

4.9.1
    Added parallel=n to the standardized DEB\_BUILD\_OPTIONS tags,
    indicating that a package should be built using up to n parallel
    processes if the package supports it

4.13
    Debian packages should not use convenience copies of code from other
    packages unless the included package is explicitly intended to be
    used that way.

4.14
    If dpkg-source -x doesn't produce source ready for editing and
    building with dpkg-buildpackage, packages should include a
    ``debian/README.source`` file explaining how to generate the patched
    source, add a new modification, and remove an existing modification.
    This file may also be used to document packaging a new upstream
    release and any other complexity of the Debian build process.

5.6.3
    The Uploaders field in debian/control may be wrapped.

5.6.12
    An empty Debian revision is equivalent to a Debian revision of 0 in
    a version number.

5.6.23
    New Homepage field for upstream web sites.

6.5, 6.6, 7
    The Breaks field declares that this package breaks another and
    prevents installation of the breaking package unless the package
    named in Breaks is deconfigured first. This field should not be used
    until the dpkg in Debian stable supports it.

8.1, 8.2
    Clarify which files should go into a shared library package, into a
    separate package, or into the -dev package. Suggest -tools instead
    of -runtime for runtime support programs, since that naming is more
    common in Debian.

9.5
    Files in ``/etc/cron.{hourly,daily,weekly,monthly}`` must be
    configuration files (upgraded from should). Mention the hourly
    directory.

11.8.6
    Packages providing ``/etc/X11/Xresources`` files need not conflict
    with ``xbase (<< 3.3.2.3a-2)``, which is long-obsolete.

12.1
    Manual pages in locale-specific directories should use either the
    legacy encoding for that directory or UTF-8. Country names should
    not be included in locale-specific manual page directories unless
    indicating a significant difference in the language. All characters
    in the manual page source should be representable in the legacy
    encoding for a locale even if the man page is encoded in UTF-8.

12.5
    The Apache 2.0 license is now in common-licenses and should be
    referenced rather than quoted in ``debian/copyright``.

12.5
    Packages in contrib and non-free should state in the copyright file
    that the package is not part of Debian GNU/Linux and briefly explain
    why.

debconf
    Underscore (``_``) is allowed in debconf template names.

Version 3.7.3
-------------

Released December, 2007.

5.6.12
    Package version numbers may contain tildes, which sort before
    anything, even the end of a part.

10.4
    Scripts may assume that ``/bin/sh`` supports local (at a basic
    level) and that its test builtin (if any) supports -a and -o binary
    logical operators.

8.5
    The substitution variable ${binary:Version} should be used in place
    of ${Source-Version} for dependencies between packages of the same
    library.

menu policy
    Substantial reorganization and renaming of sections in the Debian
    menu structure. Packages with menu entries should be reviewed to see
    if the menu section has been renamed or if one of the new sections
    would be more appropriate.

5.6.1
    The Source field in a .changes file may contain a version number in
    parentheses.

5.6.17
    The acceptable values for the Urgency field are low, medium, high,
    critical, or emergency.

8.6
    The shlibs file now allows an optional type field, indicating the
    type of package for which the line is valid. The only currently
    supported type is udeb, used with packages for the Debian Installer.

3.9.1
    Packages following the Debian Configuration management specification
    must allow for translation of their messages by using a
    gettext-based system such as po-debconf.

12.5
    GFDL 1.2, GPL 3, and LGPL 3 are now in common-licenses and should be
    referenced rather than quoted in debian/copyright.

Version 3.7.2.2
---------------

Released October, 2006.

This release broke the normal rule against introducing normative changes
without changing the major patch level.

6.1
    Maintainer scripts must not be world writeable (up from a should to
    a must)

Version 3.7.2
-------------

Released April, 2006.

11.5
    Revert the cgi-lib change.

Version 3.7.1
-------------

Released April, 2006.

10.2
    It is now possible to create shared libraries without relocatable
    code (using -fPIC) in certain exceptional cases, provided some
    procedures are followed, and for creating static libraries with
    relocatable code (again, using -fPIC). Discussion on
    debian-devel@lists.debian.org, getting a rough consensus, and
    documenting it in README.Debian constitute most of the process.

11.8.7
    Packages should install any relevant files into the directories
    ``/usr/include/X11/`` and ``/usr/lib/X11/``, but if they do so, they
    must pre-depend on ``x11-common (>= 1:7.0.0)``

Version 3.7.0
-------------

Released April, 2006.

11.5
    Packages shipping web server CGI files are expected to install them
    in ``/usr/lib/cgi-lib/`` directories. This location change perhaps
    should be documented in NEWS

11.5
    Web server packages should include a standard scriptAlias of cgi-lib
    to ``/usr/lib/cgi-lib``.

9.1.1
    The version of FHS mandated by policy has been upped to 2.3. There
    should be no changes required for most packages, though new top
    level directories ``/media``, ``/srv``, etc. may be of interest.

5.1, 5.6.3
    All fields, apart from the Uploaders field, in the control file are
    supposed to be a single logical line, which may be spread over
    multiple physical lines (newline followed by space is elided).
    However, any parser for the control file must allow the Uploaders
    field to be spread over multiple physical lines as well, to prepare
    for future changes.

10.4
    When scripts are installed into a directory in the system PATH, the
    script name should not include an extension that denotes the
    scripting language currently used to implement it.

9.3.3.2
    packages that invoke initscripts now must use invoke-rc.d to do so
    since it also pays attention to run levels and other local
    constraints.

11.8.5.2, 11.8.7, etc
    We no longer use ``/usr/X11R6``, since we have migrated away to
    using Xorg paths. This means, for one thing, fonts live in
    ``/usr/share/fonts/X11/`` now, and ``/usr/X11R6`` is gone.

Version 3.6.2
-------------

Released June, 2005.

    Recommend doc-base, and not menu, for registering package
    documentation.

8.1
    Run time support programs should live in subdirectories of
    ``/usr/lib/`` or ``/usr/share``, and preferably the shared lib is
    named the same as the package name (to avoid name collisions).

11.5
    It is recommended that HTTP servers provide an alias /images to
    allow packages to share image files with the web server

Version 3.6.1
-------------

Released August, 2003.

3.10.1
    Prompting the user should be done using debconf. Non debconf user
    prompts are now deprecated.

Version 3.6.0
-------------

Released July, 2003.

Restructuring caused shifts in section numbers and bumping of the
minor version number.

Many packaging manual appendices that were integrated into policy
sections are now empty, and replaced with links to the Policy. In
particular, the appendices that included the list of control fields
were updated (new fields like Closes, Changed-By were added) and the
list of fields for each of control, .changes and .dsc files is now
in Policy, and they're marked mandatory, recommended or optional
based on the current practice and the behavior of the deb-building
tool-chain.

Elimination of needlessly deep section levels, primarily in the
chapter Debian Archive, from which two new chapters were split out,
Binary packages and Source packages. What remained was reordered
properly, that is, some sects became sects etc.

Several sections that were redundant, crufty or simply not designed
with any sort of vision, were rearranged according to the formula
that everything should be either in the same place or properly
interlinked. Some things remained split up between different
chapters when they talked about different aspects of files: their
content, their syntax, and their placement in the file system. In
particular, see the new sections about changelog files.

menu policy
    Added Games/Simulation and Apps/Education to menu sub-policy

C.2.2
    Debian changelogs should be UTF-8 encoded.

10.2
    shared libraries must be linked against all libraries that they use
    symbols from in the same way that binaries are.

7.6
    build-depends-indep need not be satisfied during clean target.

Version 3.5.10
--------------

Released May, 2003.

11.8.3
    packages providing the x-terminal-emulator virtual package ought to
    ensure that they interpret the command line exactly like xterm does.

11.8.4
    Window managers compliant with the Window Manager Specification
    Project may add 40 points for ranking in the alternatives

Version 3.5.9
-------------

Released March, 2003.

3.4.2
    The section describing the Description: package field once again has
    full details of the long description format.

4.2
    Clarified that if a package has non-build-essential
    build-dependencies, it should have them listed in the Build-Depends
    and related fields (i.e. it's not merely optional).

9.3.2
    When asked to restart a service that isn't already running, the init
    script should start the service.

12.6
    If the purpose of a package is to provide examples, then the example
    files can be installed into ``/usr/share/doc/package`` (rather than
    ``/usr/share/doc/package/examples``).

Version 3.5.8
-------------

Released November, 2002.

12.7
    It is no longer necessary to keep a log of changes to the upstream
    sources in the copyright file. Instead, all such changes should be
    documented in the changelog file.

7.6
    Build-Depends, Build-Conflicts, Build-Depends-Indep, and
    Build-Conflicts-Indep must also be satisfied when the clean target
    is called.

menu policy
    A new Apps/Science menu section is available

debconf policy
    debconf specification cleared up, various changes.

12.1
    It is no longer recommended to create symlinks from nonexistent
    manual pages to undocumented(7). Missing manual pages for programs
    are still a bug.

Version 3.5.7
-------------

Released August, 2002.

    Packages no longer have to ask permission to call MAKEDEV in
    postinst, merely notifying the user ought to be enough.

2.2.4
    cryptographic software may now be included in the main archive.

3.9
    task packages are no longer permitted; tasks are now created by a
    special Tasks: field in the control file.

11.8.4
    window managers that support netwm can now add 20 points when they
    add themselves as an alternative for ``/usr/bin/x-window-manager``

10.1
    The default compilation options have now changed, one should provide
    debugging symbols in all cases, and optionally step back
    optimization to -O0, depending on the DEB\_BUILD\_OPTIONS
    environment variable.

7.6, 4.8
    Added mention of build-arch, build-indep, etc, in describing the
    relationships with Build-Depends, Build-Conflicts,
    Build-Depends-Indep, and Build-Conflicts-Indep. May need to
    review the new rules.

8
    Changed rules on how, and when, to invoke ldconfig in maintainer
    scripts. Long rationale.

*Added the last note in 3.5.6 upgrading checklist item regarding build
rules, please see below*

Version 3.5.6
-------------

Released July, 2001.

2.5
    Emacs and TeX are no longer mandated by policy to be priority
    standard packages

11.5
    Programs that access docs need to do so via ``/usr/share/doc``, and
    not via ``/usr/doc/`` as was the policy previously

12.3
    Putting documentation in ``/usr/doc`` versus ``/usr/share/doc`` is
    now a "serious" policy violation.

11.5
    For web servers, one should not provide non-local access to the
    ``/usr/share/doc`` hierarchy. If one can't provide access controls
    for the http://localhost/doc/ directory, then it is preferred that
    one ask permission to expose that information during the install.

7
    There are new rules for build-indep/build-arch targets and there is
    a new Build-Depend-Indep semantic.

Version 3.5.5
-------------

Released May, 2001.

12.1
    Manpages should not rely on header information to have alternative
    manpage names available; it should only use symlinks or .so pages to
    do this

    *Clarified note in 3.5.3.0 upgrading checklist regarding examples
    and templates: this refers only to those examples used by scripts;
    see section 10.7.3 for the whole story*

    Included a new section 10.9.1 describing the use of
    dpkg-statoverride; this does not have the weight of policy

    Clarify Standards-Version: you don't need to rebuild your packages
    just to change the Standards-Version!

10.2
    Plugins are no longer bound by all the rules of shared libraries

X Windows related things:
    11.8.1
        Clarification of priority levels of X Window System related
        packages

    11.8.3
        Rules for defining x-terminal-emulator improved

    11.8.5
        X Font policy rewritten: you must read this if you provide fonts
        for the X Window System

    11.8.6
        Packages must not ship ``/usr/X11R6/lib/X11/app-defaults/``

    11.8.7
        X-related packages should usually use the regular FHS locations;
        imake-using packages are exempted from this

    11.8.8
        OpenMotif linked binaries have the same rules as
        OSF/Motif-linked ones

Version 3.5.4
-------------

Released April, 2001.

11.6
    The system-wide mail directory is now /var/mail, no longer
    /var/spool/mail. Any packages accessing the mail spool should access
    it via /var/mail and include a suitable Depends field;

11.9; perl-policy
    The perl policy is now part of Debian policy proper. Perl programs
    and modules should follow the current Perl policy

Version 3.5.3
-------------

Released April, 2001.

7.1
    Build-Depends arch syntax has been changed to be less ambiguous.
    This should not affect any current packages

10.7.3
    Examples and templates files for use by scripts should now live in
    ``/usr/share/<package>`` or ``/usr/lib/<package>``, with symbolic
    links from ``/usr/share/doc/<package>/examples`` as needed

Version 3.5.2
-------------

Released February, 2001.

11.8.6
    X app-defaults directory has moved from
    ``/usr/X11R6/lib/X11/app-defaults`` to ``/etc/X11/app-defaults``

Version 3.5.1
-------------

Released February, 2001.

8.1
    dpkg-shlibdeps now uses objdump, so shared libraries have to be run
    through dpkg-shlibdeps as well as executables

Version 3.5.0
-------------

Released January, 2001.

11.8.5
    Font packages for the X Window System must now declare a dependency
    on ``xutils (>= 4.0.2)``

Version 3.2.1.1
---------------

Released January, 2001.

This release broke the normal rule against introducing normative changes
without changing the major patch level.

9.3.2
    Daemon startup scripts in ``/etc/init.d/`` should not contain
    modifiable parameters; these should be moved to a file in
    ``/etc/default/``

12.3
    Files in ``/usr/share/doc`` must not be referenced by any program.
    If such files are needed, they must be placed in
    ``/usr/share/<package>/``, and symbolic links created as required in
    ``/usr/share/doc/<package>/``

    Much of the packaging manual has now been imported into the policy
    document

Version 3.2.1
-------------

Released August, 2000.

11.8.1
    A package of priority standard or higher may provide two binaries,
    one compiled with support for the X Window System, and the other
    without

Version 3.2.0
-------------

Released August, 2000.

10.1
    By default executables should not be built with the debugging option
    -g. Instead, it is recommended to support building the package with
    debugging information optionally.

12.8
    Policy for packages where the upstream uses HTML changelog files has
    been expanded. In short, a plain text changelog file should always
    be generated for the upstream changes

    Please note that the new release of the X window system (3.2) shall
    probably need sweeping changes in policy

    Policy for packages providing the following X-based features has
    been codified:

    11.8.2
        X server (virtual package xserver)

    11.8.3
        X terminal emulator (virtual package x-terminal-emulator)

    11.8.4
        X window manager (virtual package x-window-manager, and
        ``/usr/bin/x-window-manager`` alternative, with priority
        calculation guidelines)

    12.8.5
        X fonts (this section has been written from scratch)

    11.8.6
        X application defaults

11.8.7
    Policy for packages using the X Window System and FHS issues has
    been clarified;

11.7.3
    No package may contain or make hard links to conffiles

8
    Noted that newer dpkg versions do not require extreme care in always
    creating the shared lib before the symlink, so the unpack order be
    correct

Version 3.1.1
-------------

Released November, 1999.

7.1
    Correction to semantics of architecture lists in Build-Depends etc.
    Should not affect many packages

Version 3.1.0
-------------

Released October, 1999.

defunct
    ``/usr/doc/<package>`` has to be a symlink pointing to
    ``/usr/share/doc/<package>``, to be maintained by postinst and prerm
    scripts.

7.1, 7.6
    Introduced source dependencies (Build-Depends, etc.)

9.3.4
    ``/etc/rc.boot`` has been deprecated in favour of ``/etc/rcS.d``.
    (Packages should not be touching this directory, but should use
    update-rc.d instead)

9.3.3
    update-rc.d is now the *only* allowable way of accessing the
    ``/etc/rc?.d/[SK]??*`` links. Any scripts which manipulate them
    directly must be changed to use update-rc.d instead. (This is
    because the file-rc package handles this information in an
    incompatible way.)

12.7
    Architecture-specific examples go in ``/usr/lib/<package>/examples``
    with symlinks from ``/usr/share/doc/<package>/examples/*`` or from
    ``/usr/share/doc/<package>/examples`` itself

9.1.1
    Updated FHS to a 2.1 draft; this reverts ``/var/state`` to
    ``/var/lib``

9.7; mime-policy
    Added MIME sub-policy document

12.4
    VISUAL is allowed as a (higher priority) alternative to EDITOR

11.6
    Modified liblockfile description, which affects mailbox-accessing
    programs. Please see the policy document for details

12.7
    If a package provides a changelog in HTML format, a text-only
    version should also be included. (Such a version may be prepared
    using ``lynx -dump -nolist``.)

3.2.1
    Description of how to handle version numbers based on dates added

Version 3.0.1
-------------

Released July, 1999.

10.2
    Added the clarification that the .la files are essential for the
    packages using libtool's libltdl library, in which case the .la
    files must go in the run-time library package

Version 3.0.0
-------------

Released June, 1999.

9.1
    Debian formally moves from the FSSTND to the FHS. This is a major
    change, and the implications of this move are probably not all
    known.

4.1
    Only 3 digits of the Standards version need be included in control
    files, though all four digits are still permitted.

12.6
    The location of the GPL has changed to
    ``/usr/share/common-licenses``. This may require changing the
    copyright files to point to the correct location of the GPL and
    other major licenses

10.2
    Packages that use libtool to create shared libraries must include
    the .la files in the -dev packages

10.8
    Use logrotate to rotate log files

now 11.8
    section 5.8 has been rewritten (Programs for the X Window System)

9.6; menu-policy
    There is now an associated menu policy, in a separate document, that
    carries the full weight of Debian policy

11.3
    Programs which need to modify the files ``/var/run/utmp``,
    ``/var/log/wtmp`` and ``/var/log/lastlog`` must be installed setgid
    utmp

Version 2.5.0
-------------

Released October, 1998.

*Please note that section numbers below this point may not match the
current Policy Manual.*

-  Rearranged the manual to create a new Section 4, Files

   -  Section 3.3 ("Files") was moved to Section 4. The Sections that
      were Section 4 and Section 5 were moved down to become Section 5
      and Section 6.

   -  What was Section 5.5 ("Log files") is now a subsection of the new
      Section 4 ("Files"), becoming section 4.8, placed after
      "Configuration files", moving the Section 4.8 ("Permissions and
      owners") to Section 4.9. All subsections of the old Section 5
      after 5.5 were moved down to fill in the number gap.

-  Modified the section about changelog files to accommodate upstream
   changelogs which were formatted as HTML. These upstream changelog
   files should now be accessible as
   ``/usr/doc/package/changelog.html.gz``

-  Symlinks are permissible to link the real, or upstream, changelog
   name to the Debian mandated name.

-  Clarified that HTML documentation should be present in some package,
   though not necessarily the main binary package.

-  Corrected all references to the location of the copyright files. The
   correct location is ``/usr/doc/package/copyright``

-  Ratified the architecture specification strings to cater to the HURD.

Version 2.4.1
-------------

Released April, 1998.

Updated section 3.3.5 Symbolic links
    symbolic links within a toplevel directory should be relative,
    symbolic links between toplevel directories should be absolute (cf.,
    Policy Weekly Issue#6, topic 2)

Updated section 4.9 Games
    manpages for games should be installed in ``/usr/man/man6`` (cf.,
    Policy Weekly Issue#6, topic 3)

Updated Chapter 12 Shared Libraries
    ldconfig must be called in the postinst script if the package
    installs shared libraries (cf., Policy Weekly Issue #6,
    fixes:bug#20515)

Version 2.4.0
-------------

Released January, 1998

Updated section 3.3.4 Scripts
    -  /bin/sh may be any POSIX compatible shell

    -  scripts including bashisms have to specify ``/bin/bash`` as
       interpreter

    -  scripts which create files in world-writable directories (e.g.,
       in ``/tmp``) should use tempfile or mktemp for creating the
       directory

Updated section 3.3.5 Symbolic Links
    symbolic links referencing compressed files must have the same file
    extension as the referenced file

Updated section 3.3.6 Device files
    ``/dev/tty*`` serial devices should be used instead of ``/dev/cu*``

Updated section 3.4.2 Writing the scripts in ``/etc/init.d``
    -  all ``/etc/init.d`` scripts have to provide the following
       options: start, stop, restart, force-reload

    -  the reload option is optional and must never stop and restart the
       service

Updated section 3.5 Cron jobs
    cron jobs that need to be executed more often than daily should be
    installed into ``/etc/cron.d``

Updated section 3.7 Menus
    removed section about how to register HTML docs to \`menu' (the
    corresponding section in 4.4, Web servers and applications, has been
    removed in policy 2.2.0.0 already, so this one was obsolete)

New section 3.8 Keyboard configuration
    details about how the backspace and delete keys should be handled

New section 3.9 Environment variables
    no program must depend on environment variables to get a reasonable
    default configuration

New section 4.6 News system configuration
    ``/etc/news/organization`` and ``/etc/news/server`` should be
    supported by all news servers and clients

Updated section 4.7 Programs for the X Window System
    -  programs requiring a non-free Motif library should be provided as
       foo-smotif and foo-dmotif package

    -  if lesstif works reliably for such program, it should be linked
       against lesstif and not against a non-free Motif library

Updated section 4.9 Games
    games for X Windows have to be installed in ``/usr/games``, just as
    non-X games

Version 2.3.0
-------------

Released September, 1997.

-  new section \`4.2 Daemons' including rules for ``/etc/services``,
   ``/etc/protocols``, ``/etc/rpc``, and ``/etc/inetd.conf``

-  updated section about \`Configuration files': packages may not touch
   other packages' configuration files

-  MUAs and MTAs have to use liblockfile

Version 2.2.0
-------------

Released July, 1997.

-  added section 4.1 \`Architecture specification strings': use
   <arch>-linux where <arch> is one of the following: i386, alpha, arm,
   m68k, powerpc, sparc.

-  detailed rules for ``/usr/local``

-  user ID's

-  editor/pager policy

-  cron jobs

-  device files

-  don't install shared libraries as executable

-  app-defaults files may not be conffiles

Version 2.1.3
-------------

Released March, 1997.

-  two programs with different functionality must not have the same name

-  "Webstandard 3.0"

-  "Standard for Console Messages"

-  Libraries should be compiled with ``-D_REENTRANT``

-  Libraries should be stripped with ``strip --strip-unneeded``

Version 2.1.2
-------------

Released November, 1996.

-  Some changes WRT shared libraries

Version 2.1.1
-------------

Released September, 1996.

-  No hard links in source packages

-  Do not use ``dpkg-divert`` or ``update-alternatives`` without
   consultation

-  Shared libraries must be installed stripped

Version 2.1.0
-------------

Released August, 1996.

-  Upstream changelog must be installed too
