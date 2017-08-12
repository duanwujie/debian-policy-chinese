.. [#]
   Informally, the criteria used for inclusion is that the material meet
   one of the following requirements:

   Standard interfaces
       The material presented represents an interface to the packaging
       system that is mandated for use, and is used by, a significant
       number of packages, and therefore should not be changed without
       peer review. Package maintainers can then rely on this interface
       not changing, and the package management software authors need to
       ensure compatibility with this interface definition. (Control
       file and changelog file formats are examples.)

   Chosen Convention
       If there are a number of technically viable choices that can be
       made, but one needs to select one of these options for
       inter-operability. The version number format is one example.

   Please note that these are not mutually exclusive; selected
   conventions often become parts of standard interfaces.

.. [#]
   Compare RFC 2119. Note, however, that these words are used in a
   different way in this document.

.. [#]
   The Debian archive software uses the term "component" internally and
   in the Release file format to refer to the division of an archive.
   The Debian Social Contract simply refers to "areas." This document
   uses terminology similar to the Social Contract.

.. [#]
   See `What Does Free Mean? <https://www.debian.org/intro/free>`_ for
   more about what we mean by free software.

.. [#]
   Debian's FTP Masters publish a
   `REJECT-FAQ <https://ftp-master.debian.org/REJECT-FAQ.html>`_ which
   details the project's current working interpretation of the DFSG.

.. [#]
   It is possible that there are policy requirements which the package
   is unable to meet, for example, if the source is unavailable. These
   situations will need to be handled on a case-by-case basis.

.. [#]
   This is an important criterion because we are trying to produce,
   amongst other things, a free Unix.

.. [#]
   A sample implementation of such a whitelist written for the Mailman
   mailing list management software is used for mailing lists hosted by
   alioth.debian.org.

.. [#]
   The detailed procedure for gracefully orphaning a package can be
   found in the Debian Developer's Reference (see
   :ref:`s-related`).

.. [#]
   The blurb that comes with a program in its announcements and/or
   ``README`` files is rarely suitable for use in a description. It is
   usually aimed at people who are already in the community where the
   package is used.

.. [#]
   Essential is needed in part to avoid unresolvable dependency loops on
   upgrade. If packages add unnecessary dependencies on packages in this
   set, the chances that there **will** be an unresolvable dependency
   loop caused by forcing these Essential packages to be configured
   first before they need to be is greatly increased. It also increases
   the chances that frontends will be unable to **calculate** an upgrade
   path, even if one exists.

   Also, functionality is rarely ever removed from the Essential set,
   but *packages* have been removed from the Essential set when the
   functionality moved to a different package. So depending on these
   packages *just in case* they stop being essential does way more harm
   than good.

.. [#]
   Debconf or another tool that implements the Debian Configuration
   Management Specification will also be installed, and any versioned
   dependencies on it will be satisfied before preconfiguration begins.

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
   ``dpkg``'s internal databases are in a similar format.

.. [#]
   The paragraphs are also sometimes referred to as stanzas.

.. [#]
   This folding method is similar to RFC 5322, allowing control files
   that contain only one paragraph and no multiline fields to be read by
   parsers written for RFC 5322.

.. [#]
   It is customary to leave a space after the package name if a version
   number is specified.

.. [#]
   In the past, people specified the full version number in the
   Standards-Version field, for example "2.3.0.0". Since minor
   patch-level changes don't introduce new policy, it was thought it
   would be better to relax policy and only require the first 3
   components to be specified, in this example "2.3.0". All four
   components may still be used if someone wishes to do so.

.. [#]
   Alphanumerics are ``A-Za-z0-9`` only.

.. [#]
   One common use of ``~`` is for upstream pre-releases. For example,
   ``1.0~beta1~svn1245`` sorts earlier than ``1.0~beta1``, which sorts
   earlier than ``1.0``.

.. [#]
   The author of this manual has heard of a package whose versions went
   ``1.1``, ``1.2``, ``1.3``, ``1``, ``2.1``, ``2.2``, ``2`` and so
   forth.

.. [#]
   Completely empty lines will not be rendered as blank lines. Instead,
   they will cause the parser to think you're starting a whole new
   record in the control file, and will therefore likely abort with an
   error.

.. [#]
   Example distribution names in the Debian archive used in ``.changes``
   files are:

   *unstable*
       This distribution value refers to the *developmental* part of the
       Debian distribution tree. Most new packages, new upstream
       versions of packages and bug fixes go into the *unstable*
       directory tree.

   *experimental*
       The packages with this distribution value are deemed by their
       maintainers to be high risk. Oftentimes they represent early beta
       or developmental packages from various sources that the
       maintainers want people to try, but are not ready to be a part of
       the other parts of the Debian distribution tree.

   Others are used for updating stable releases or for security uploads.
   More information is available in the Debian Developer's Reference,
   section "The Debian archive".

.. [#]
   The source formats currently supported by the Debian archive software
   are ``1.0``, ``3.0 (native)``, and ``3.0 (quilt)``.

.. [#]
   Other urgency values are supported with configuration changes in the
   archive software but are not used in Debian. The urgency affects how
   quickly a package will be considered for inclusion into the
   ``testing`` distribution and gives an indication of the importance of
   any fixes included in the upload. ``Emergency`` and ``critical`` are
   treated as synonymous.

.. [#]
   A space after each comma is conventional.

.. [#]
   That is, the parts which are not the ``.dsc``.

.. [#]
   The relations ``<`` and ``>`` were previously allowed, but they were
   confusingly defined to mean earlier/later or equal rather than
   strictly earlier/later. ``dpkg`` still supports them with a warning,
   but they are no longer allowed by Debian Policy.

.. [#]
   This approach makes dependency resolution easier. If two packages A
   and B are being upgraded, the installed package A depends on exactly
   the installed package B, and the new package A depends on exactly the
   new package B (a common situation when upgrading shared libraries and
   their corresponding development packages), satisfying the
   dependencies at every stage of the upgrade would be impossible. This
   relaxed restriction means that both new packages can be unpacked
   together and then configured in their dependency order.

.. [#]
   It is possible that a future release of ``dpkg`` may add the ability
   to specify a version number for each virtual package it provides.
   This feature is not yet present, however, and is expected to be used
   only infrequently.

.. [#]
   To see why ``Breaks`` is normally needed in addition to ``Replaces``,
   consider the case of a file in the package foo being taken over by
   the package foo-data. ``Replaces`` will allow foo-data to be
   installed and take over that file. However, without ``Breaks``,
   nothing requires foo to be upgraded to a newer version that knows it
   does not include that file and instead depends on foo-data. Nothing
   would prevent the new foo-data package from being installed and then
   removed, removing the file that it took over from foo. After that
   operation, the package manager would think the system was in a
   consistent state, but the foo package would be missing one of its
   files.

.. [#]
   Replaces is a one way relationship. You have to install the replacing
   package after the replaced package.

.. [#]
   ``Build-Depends`` in the source package is not adequate since it
   (rightfully) does not document the exact version used in the build.

.. [#]
   The archive software might reject packages that refer to non-existent
   sources.

.. [#]
   This is a convention of shared library versioning, but not a
   requirement. Some libraries use the ``SONAME`` as the full library
   file name instead and therefore do not need a symlink. Most, however,
   encode additional information about backwards-compatible revisions as
   a minor version number in the file name. The ``SONAME`` itself only
   changes when binaries linked with the earlier version of the shared
   library may no longer work, but the filename may change with each
   release of the library. See
   :ref:`s-sharedlibs-runtime` for more information.

.. [#]
   The package management system requires the library to be placed
   before the symbolic link pointing to it in the ``.deb`` file. This is
   so that when ``dpkg`` comes to install the symlink (overwriting the
   previous symlink pointing at an older version of the library), the
   new shared library is already in place. In the past, this was
   achieved by creating the library in the temporary packaging directory
   before creating the symlink. Unfortunately, this was not always
   effective, since the building of the tar file in the ``.deb``
   depended on the behavior of the underlying file system. Some file
   systems (such as reiserfs) reorder the files so that the order of
   creation is forgotten. Since version 1.7.0, ``dpkg`` reorders the
   files itself as necessary when building a package. Thus it is no
   longer important to concern oneself with the order of file creation.

.. [#]
   These are currently ``/usr/local/lib`` plus directories under
   ``/lib`` and ``/usr/lib`` matching the multiarch triplet for the
   system architecture.

.. [#]
   For example, a ``package-name-config`` script or pkg-config
   configuration files.

.. [#]
   This wording allows the development files to be split into several
   packages, such as a separate architecture-independent
   libraryname-headers, provided that the development package depends on
   all the required additional packages.

.. [#]
   Previously, ``${Source-Version}`` was used, but its name was
   confusing and it has been deprecated since dpkg 1.13.19.

.. [#]
   A ``shlibs`` file represents an SONAME as a library name and version
   number, such as ``libfoo VERSION``, instead of recording the actual SONAME. If the
   SONAME doesn't match one of the two expected formats
   (``libfoo-VERSION.so`` or ``libfoo.so.VERSION``), it cannot be
   represented.

.. [#]
   ``dpkg-shlibdeps`` will use a program like ``objdump`` or ``readelf``
   to find the libraries and the symbols in those libraries directly
   needed by the binaries or shared libraries in the package.

.. [#]
   The easiest way to call ``dpkg-shlibdeps`` correctly is to use a
   package helper framework such as debhelper. If you are using
   debhelper, the ``dh_shlibdeps`` program will do this work for you. It
   will also correctly handle multi-binary packages.

.. [#]
   ``dh_shlibdeps`` from the ``debhelper`` suite will automatically add
   this option if it knows it is processing a udeb.

.. [#]
   Again, ``dh_shlibdeps`` and ``dh_gencontrol`` will handle everything
   except the addition of the variable to the control file for you if
   you're using debhelper, including generating separate ``substvars``
   files for each binary package and calling ``dpkg-gencontrol`` with
   the appropriate flags.

.. [#]
   A good example of where this helps is the following. We could update
   ``libimlib`` with a new version that supports a new revision of a
   graphics format called dgf (but retaining the same major version
   number) and depends on a new library package libdgf4 instead of the
   older libdgf3. If we used ``ldd`` to add dependencies for every
   library directly or indirectly linked with a binary, every package
   that uses ``libimlib`` would need to be recompiled so it would also
   depend on libdgf4 in order to retire the older libdgf3 package. Since
   dependencies are only added based on ELF ``NEEDED`` attribute,
   packages using ``libimlib`` can rely on ``libimlib`` itself having
   the dependency on an appropriate version of ``libdgf`` and do not
   need rebuilding.

.. [#]
   An example of an "unreasonable" program is one that uses library
   interfaces that are documented as internal and unsupported. If the
   only programs or libraries affected by a change are "unreasonable"
   ones, other techniques, such as declaring ``Breaks`` relationships
   with affected packages or treating their usage of the library as bugs
   in those packages, may be appropriate instead of changing the SONAME.
   However, the default approach is to change the SONAME for any change
   to the ABI that could break a program.

.. [#]
   An example may clarify. Suppose the source package ``foo`` generates
   two binary packages, ``libfoo2`` and ``foo-runtime``. When building
   the binary packages, the contents of the packages are staged in the
   directories ``debian/libfoo2`` and ``debian/foo-runtime``
   respectively. (``debian/tmp`` could be used instead of one of these.)
   Since ``libfoo2`` provides the ``libfoo`` shared library, it will
   contain a ``symbols`` file, which will be installed in
   ``debian/libfoo2/DEBIAN/symbols``, eventually to be included as a
   control file in that package. When ``dpkg-shlibdeps`` is run on the
   executable ``debian/foo-runtime/usr/bin/foo-prog``, it will examine
   the ``debian/libfoo2/DEBIAN/symbols`` file to determine whether
   ``foo-prog``'s library dependencies are satisfied by any of the
   libraries provided by ``libfoo2``. Since those binaries were linked
   against the just-built shared library as part of the build process,
   the ``symbols`` file for the newly-built ``libfoo2`` must take
   precedence over a ``symbols`` file for any other ``libfoo2`` package
   already installed on the system.

.. [#]
   This can be determined by using the command

   ::

       readelf -d /usr/lib/libz.so.1.2.3.4 | grep SONAME

.. [#]
   An example of where this may be needed is with a library that
   implements the libGL interface. All GL implementations provide the
   same set of base interfaces, and then may provide some additional
   interfaces only used by programs that require that specific GL
   implementation. So, for example, libgl1-mesa-glx may use the
   following ``symbols`` file:

   ::

       libGL.so.1 libgl1 | libgl1-mesa-glx #MINVER#
        publicGlSymbol@Base 6.3-1 [...] implementationSpecificSymbol@Base 6.5.2-7 1
        [...]

   Binaries or shared libraries using only ``publicGlSymbol`` would
   depend only on ``libgl1`` (which may be provided by multiple
   packages), but ones using ``implementationSpecificSymbol`` would get
   a dependency on ``libgl1-mesa-glx (>= 6.5.2-7)``

.. [#]
   This field should normally not be necessary, since if the behavior of
   any symbol has changed, the corresponding symbol minimal-version
   should have been increased. But including it makes the ``symbols``
   system more robust by tightening the dependency in cases where the
   package using the shared library specifically requires at least a
   particular version of the shared library development package for some
   reason.

.. [#]
   If you are using ``debhelper``, ``dh_makeshlibs`` will take care of
   calling either ``dpkg-gensymbols`` or generating a ``shlibs`` file as
   appropriate.

.. [#]
   This is what ``dh_makeshlibs`` in the debhelper suite does. If your
   package also has a udeb that provides a shared library,
   ``dh_makeshlibs`` can automatically generate the ``udeb:`` lines if
   you specify the name of the udeb with the ``--add-udeb`` option.

.. [#]
   This is necessary in order to reserve the directories for use in
   cross-installation of library packages from other architectures, as
   part of ``multiarch``.

.. [#]
   This is necessary for architecture-dependent headers file to coexist
   in a ``multiarch`` setup.

.. [#]
   This directory is used as mount point to mount virtual filesystems to
   get access to kernel information.

.. [#]
   These directories are used to store translators and as a set of
   standard names for mount points, respectively.

.. [#]
   ``/lib/lsb/init-functions``, which assists in writing LSB-compliant
   init scripts, may fail if ``set          -e`` is in effect and echoing status messages to the
   console fails, for example.

.. [#]
   Creating, modifying or removing a file in ``/usr/lib/mime/packages/``
   using maintainer scripts will not activate the trigger. In that case,
   it can be done by calling ``dpkg-trigger --no-await /usr/lib/mime/packages`` from the maintainer
   script after creating, modifying, or removing the file.

.. [#]
   If you are using GCC, ``-fPIC`` produces code with relocatable
   position independent code, which is required for most architectures
   to create a shared library, with i386 and perhaps some others where
   non position independent code is permitted in a shared library.

   Position independent code may have a performance penalty, especially
   on ``i386``. However, in most cases the speed penalty must be
   measured against the memory wasted on the few architectures where non
   position independent code is even possible.

.. [#]
   Some of the reasons why this might be required is if the library
   contains hand crafted assembly code that is not relocatable, the
   speed penalty is excessive for compute intensive libs, and similar
   reasons.

.. [#]
   Some of the reasons for linking static libraries with the ``-fPIC``
   flag are if, for example, one needs a Perl API for a library that is
   under rapid development, and has an unstable API, so shared libraries
   are pointless at this phase of the library's development. In that
   case, since Perl needs a library with relocatable code, it may make
   sense to create a static library with relocatable code. Another
   reason cited is if you are distilling various libraries into a common
   shared library, like ``mklibs`` does in the Debian installer project.

.. [#]
   You might also want to use the options ``--remove-section=.comment``
   and ``--remove-section=.note`` on both shared libraries and
   executables, and ``--strip-debug`` on static libraries.

.. [#]
   A common example are the so-called "plug-ins", internal shared
   objects that are dynamically loaded by programs using dlopen3.

.. [#]
   These files store, among other things, all libraries on which that
   shared library depends. Unfortunately, if the ``.la`` file is present
   and contains that dependency information, using ``libtool`` when
   linking against that library will cause the resulting program or
   library to be linked against those dependencies as well, even if this
   is unnecessary. This can create unneeded dependencies on shared
   library packages that would otherwise be hidden behind the library
   ABI, and can make library transitions to new SONAMEs unnecessarily
   complicated and difficult to manage.

.. [#]
   Single UNIX Specification, version 3, which is also IEEE 1003.1-2004
   (POSIX), and is available on the World Wide Web from `The Open
   Group <http://www.unix.org/version3/online.html>`_ after free
   registration.

.. [#]
   These features are in widespread use in the Linux community and are
   implemented in all of bash, dash, and ksh, the most common shells
   users may wish to use as ``/bin/sh``.

.. [#]
   This is necessary to allow top-level directories to be symlinks. If
   linking ``/var/run`` to ``/run`` were done with the relative symbolic
   link ``../run``, but ``/var`` were a symbolic link to ``/srv/disk1``,
   the symbolic link would point to ``/srv/run`` rather than the
   intended target.

.. [#]
   It's better to use ``mkfifo`` rather than ``mknod`` to create named
   pipes to avoid false positives from automated checks for packages
   incorrectly creating device files.

.. [#]
   The ``dpkg-maintscript-helper`` tool, available from the dpkg
   package, can help for this task.

.. [#]
   Rationale: There are two problems with hard links. The first is that
   some editors break the link while editing one of the files, so that
   the two files may unwittingly become unlinked and different. The
   second is that ``dpkg`` might break the hard link while upgrading
   ``conffile``\ s.

.. [#]
   The traditional approach to log files has been to set up *ad hoc* log
   rotation schemes using simple shell scripts and cron. While this
   approach is highly customizable, it requires quite a lot of sysadmin
   work. Even though the original Debian system helped a little by
   automatically installing a system which can be used as a template,
   this was deemed not enough.

   The use of ``logrotate``, a program developed by Red Hat, is better,
   as it centralizes log management. It has both a configuration file
   (``/etc/logrotate.conf``) and a directory where packages can drop
   their individual log rotation configurations (``/etc/logrotate.d``).

.. [#]
   When a package is upgraded, and the owner or permissions of a file
   included in the package has changed, dpkg arranges for the ownership
   and permissions to be correctly set upon installation. However, this
   does not extend to directories; the permissions and ownership of
   directories already on the system does not change on install or
   upgrade of packages. This makes sense, since otherwise common
   directories like ``/usr`` would always be in flux. To correctly
   change permissions of a directory the package owns, explicit action
   is required, usually in the ``postinst`` script. Care must be taken
   to handle downgrades as well, in that case.

.. [#]
   Ordinary files installed by ``dpkg`` (as opposed to ``conffile``\ s
   and other similar objects) normally have their permissions reset to
   the distributed permissions when the package is reinstalled. However,
   the use of ``dpkg-statoverride`` overrides this default behavior.

.. [#]
   Internally, the package system normalizes the GNU triplets and the
   Debian arches into Debian arch triplets (which are kind of inverted
   GNU triplets), with the first component of the triplet representing
   the libc and ABI in use, and then does matching against those
   triplets. However, such triplets are an internal implementation
   detail that should not be used by packages directly. The libc and ABI
   portion is handled internally by the package system based on the os
   and cpu.

.. [#]
   The Debian base system already provides an editor and a pager
   program.

.. [#]
   If it is not possible to establish both locks, the system shouldn't
   wait for the second lock to be established, but remove the first
   lock, wait a (random) time, and start over locking again.

.. [#]
   There are two traditional permission schemes for mail spools: mode
   600 with all mail delivery done by processes running as the
   destination user, or mode 660 and owned by group mail with mail
   delivery done by a process running as a system user in group mail.
   Historically, Debian required mode 660 mail spools to enable the
   latter model, but that model has become increasingly uncommon and the
   principle of least privilege indicates that mail systems that use the
   first model should use permissions of 600. If delivery to programs is
   permitted, it's easier to keep the mail system secure if the delivery
   agent runs as the destination user. Debian Policy therefore permits
   either scheme.

.. [#]
   This implements current practice, and provides an actual policy for
   usage of the ``xserver`` virtual package which appears in the virtual
   packages list. In a nutshell, X servers that interface directly with
   the display and input hardware or via another subsystem (e.g., GGI)
   should provide ``xserver``. Things like ``Xvfb``, ``Xnest``, and
   ``Xprt`` should not.

.. [#]
   "New terminal window" does not necessarily mean a new top-level X
   window directly parented by the window manager; it could, if the
   terminal emulator application were so coded, be a new "view" in a
   multiple-document interface (MDI).

.. [#]
   For the purposes of Debian Policy, a "font for the X Window System"
   is one which is accessed via X protocol requests. Fonts for the Linux
   console, for PostScript renderer, or any other purpose, do not fit
   this definition. Any tool which makes such fonts available to the X
   Window System, however, must abide by this font policy.

.. [#]
   This is because the X server may retrieve fonts from the local file
   system or over the network from an X font server; the Debian package
   system is empowered to deal only with the local file system.

.. [#]
   Note that this mechanism is not the same as using app-defaults;
   app-defaults are tied to the client binary on the local file system,
   whereas X resources are stored in the X server and affect all
   connecting clients.

.. [#]
   It is not very hard to write a man page. See the
   `Man-Page-HOWTO <http://www.schweikhardt.net/man_page_howto.html>`_,
   man7, the examples created by ``dh_make``, the helper program
   ``help2man``, or the directory ``/usr/share/doc/man-db/examples``.

.. [#]
   Supporting this in ``man`` often requires unreasonable processing
   time to find a manual page or to report that none exists, and moves
   knowledge into man's database that would be better left in the file
   system. This support is therefore deprecated and will cease to be
   present in the future.

.. [#]
   ``man`` will automatically detect whether UTF-8 is in use. In future,
   all manual pages will be required to use UTF-8.

.. [#]
   At the time of writing, Chinese and Portuguese are the main languages
   with such differences, so ``pt_BR``, ``zh_CN``, and ``zh_TW`` are all
   allowed.

.. [#]
   Normally, info documents are generated from Texinfo source. To
   include this information in the generated info document, if it is
   absent, add commands like:

   ::

       @dircategory Individual utilities
       @direntry
       * example: (example).  An example info directory entry.
       @end direntry

   to the Texinfo source of the document and ensure that the info
   documents are rebuilt from source during the package build.

.. [#]
   The system administrator should be able to delete files in
   ``/usr/share/doc/`` without causing any programs to break.

.. [#]
   Please note that this does not override the section on changelog
   files below, so the file
   ``/usr/share/doc/package/changelog.Debian.gz`` must refer to the
   changelog for the current version of package in question. In
   practice, this means that the sources of the target and the
   destination of the symlink must be the same (same source package and
   version).

.. [#]
   Rationale: The important thing here is that HTML documentation should
   be available from *some* binary package.

.. [#]
   In particular, ``/usr/share/common-licenses/Apache-2.0``,
   ``/usr/share/common-licenses/Artistic``,
   ``/usr/share/common-licenses/GPL-1``,
   ``/usr/share/common-licenses/GPL-2``,
   ``/usr/share/common-licenses/GPL-3``,
   ``/usr/share/common-licenses/LGPL-2``,
   ``/usr/share/common-licenses/LGPL-2.1``,
   ``/usr/share/common-licenses/LGPL-3``,
   ``/usr/share/common-licenses/GFDL-1.2``,
   ``/usr/share/common-licenses/GFDL-1.3``,
   ``/usr/share/common-licenses/MPL-1.1``, and
   ``/usr/share/common-licenses/MPL-2.0`` respectively. The University
   of California BSD license is also included in base-files as
   ``/usr/share/common-licenses/BSD``, but given the brevity of this
   license, its specificity to code whose copyright is held by the
   Regents of the University of California, and the frequency of minor
   wording changes, its text should be included in the copyright file
   rather than referencing this file.

.. [#]
   Rationale: People should not have to look in places for upstream
   changelogs merely because they are given different names or are
   distributed in HTML format.

.. [#]
   ``dpkg`` is targeted primarily at Debian, but may work on or be
   ported to other systems.

.. [#]
   This is so that the control file which is produced has the right
   permissions

.. [#]
   This is not currently detected when building source packages, but
   only when extracting them.

.. [#]
   Hard links may be permitted at some point in the future, but would
   require a fair amount of work.

.. [#]
   Setgid directories are allowed.

.. [#]
   Renaming a file is not treated specially - it is seen as the removal
   of the old file (which generates a warning, but is otherwise
   ignored), and the creation of the new one.

.. [#]
   This process was originally developed by Margarita Manterola, Clint
   Adams, Russ Allbery and Manoj Srivastava.
