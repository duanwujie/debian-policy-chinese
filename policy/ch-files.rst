Files
=====

.. _s-binaries:

Binaries
--------

Two different packages must not install programs with different
functionality but with the same filenames. (The case of two programs
having the same functionality but different implementations is handled
via "alternatives" or the "Conflicts" mechanism. See
:ref:`s-maintscripts` and
:ref:`s-conflicts` respectively.) If this case happens,
one of the programs must be renamed. The maintainers should report this
to the ``debian-devel`` mailing list and try to find a consensus about
which program will have to be renamed. If a consensus cannot be reached,
*both* programs must be renamed.

To support merged-\ ``/usr`` systems, packages must not install files in
both ``/path`` and ``/usr/path``. For example, a package may not install
both ``/bin/example`` and ``/usr/bin/example``.

If a file is moved between ``/path`` and ``/usr/path`` in revisions of a
Debian package, and a compatibility symlink at the old path is needed,
the symlink must be managed in a way that will not break when ``/path``
and ``/usr/path`` are the same underlying directory due to symlinks or
other mechanisms.

Binary executables must not be statically linked with the GNU C library,
since this prevents the binary from benefiting from fixes and
improvements to the C library without being rebuilt and complicates
security updates. This requirement may be relaxed for binary executables
whose intended purpose is to diagnose and fix the system in situations
where the GNU C library may not be usable (such as system recovery
shells or utilities like ldconfig) or for binary executables where the
security benefits of static linking outweigh the drawbacks.

By default, when a package is being built, any binaries created should
include debugging information, as well as being compiled with
optimization. You should also turn on as many reasonable compilation
warnings as possible; this makes life easier for porters, who can then
look at build logs for possible problems. For the C programming
language, this means the following compilation parameters should be
used:

::

    CC = gcc
    CFLAGS = -O2 -g -Wall # sane warning options vary between programs
    LDFLAGS = # none
    INSTALL = install -s # (or use strip on the files in debian/tmp)

Note that by default all installed binaries should be stripped, either
by using the ``-s`` flag to ``install``, or by calling ``strip`` on the
binaries after they have been copied into ``debian/tmp`` but before the
tree is made into a package.

Although binaries in the build tree should be compiled with debugging
information by default, it can often be difficult to debug programs if
they are also subjected to compiler optimization. For this reason, it is
recommended to support the standardized environment variable
``DEB_BUILD_OPTIONS`` (see :ref:`s-debianrules-options`).
This variable can contain several flags to change how a package is
compiled and built.

It is up to the package maintainer to decide what compilation options
are best for the package. Certain binaries (such as
computationally-intensive programs) will function better with certain
flags (``-O3``, for example); feel free to use them. Please use good
judgment here. Don't use flags for the sake of it; only use them if
there is good reason to do so. Feel free to override the upstream
author's ideas about which compilation options are best: they are often
inappropriate for our environment.

.. _s-libraries:

Libraries
---------

If the package is **architecture: any**, then the shared library
compilation and linking flags must have ``-fPIC``, or the package shall
not build on some of the supported architectures.  [#]_ Any exception
to this rule must be discussed on the mailing list
*debian-devel@lists.debian.org*, and a rough consensus obtained. The
reasons for not compiling with ``-fPIC`` flag must be recorded in the
file ``README.Debian``, and care must be taken to either restrict the
architecture or arrange for ``-fPIC`` to be used on architectures where
it is required.  [#]_

As to the static libraries, the common case is not to have relocatable
code, since there is no benefit, unless in specific cases; therefore the
static version must not be compiled with the ``-fPIC`` flag. Any
exception to this rule should be discussed on the mailing list
*debian-devel@lists.debian.org*, and the reasons for compiling with the
``-fPIC`` flag must be recorded in the file ``README.Debian``.  [#]_

In other words, if both a shared and a static library is being built,
each source unit (``*.c``, for example, for C files) will need to be
compiled twice, for the normal case.

Libraries should be built with threading support and to be thread-safe
if the library supports this.

Although not enforced by the build tools, shared libraries must be
linked against all libraries that they use symbols from in the same way
that binaries are. This ensures the correct functioning of the
:ref:`symbols <s-sharedlibs-symbols>` and :ref:`shlibs <s-sharedlibs-shlibdeps>` systems and guarantees that all
libraries can be safely opened with ``dlopen()``. Packagers may wish to
use the gcc option ``-Wl,-z,defs`` when building a shared library. Since
this option enforces symbol resolution at build time, a missing library
reference will be caught early as a fatal build error.

All installed shared libraries should be stripped with

::

    strip --strip-unneeded your-lib

(The option ``--strip-unneeded`` makes ``strip`` remove only the symbols
which aren't needed for relocation processing.) Shared libraries can
function perfectly well when stripped, since the symbols for dynamic
linking are in a separate part of the ELF object file.  [#]_

Note that under some circumstances it may be useful to install a shared
library unstripped, for example when building a separate package to
support debugging.

Shared object files (often ``.so`` files) that are not public libraries,
that is, they are not meant to be linked to by third party executables
(binaries of other packages), should be installed in subdirectories of
the ``/usr/lib`` directory. Such files are exempt from the rules that
govern ordinary shared libraries, except that they must not be installed
executable and should be stripped. [#]_

Packages that use ``libtool`` to create and install their shared
libraries install a file containing additional metadata (ending in
``.la``) alongside the library. For public libraries intended for use by
other packages, these files normally should not be included in the
Debian package, since the information they include is not necessary to
link with the shared library on Debian and can add unnecessary
additional dependencies to other programs or libraries.  [#]_ If the
``.la`` file is required for that library (if, for instance, it's loaded
via ``libltdl`` in a way that requires that meta-information), the
``dependency_libs`` setting in the ``.la`` file should normally be set
to the empty string. If the shared library development package has
historically included the ``.la``, it must be retained in the
development package (with ``dependency_libs`` emptied) until all
libraries that depend on it have removed or emptied ``dependency_libs``
in their ``.la`` files to prevent linking with those other libraries
using ``libtool`` from failing.

If the ``.la`` must be included, it should be included in the
development (``-dev``) package, unless the library will be loaded by
``libtool``'s ``libltdl`` library. If it is intended for use with
``libltdl``, the ``.la`` files must go in the run-time library package.

These requirements for handling of ``.la`` files do not apply to
loadable modules or libraries not installed in directories searched by
default by the dynamic linker. Packages installing loadable modules will
frequently need to install the ``.la`` files alongside the modules so
that they can be loaded by ``libltdl``. ``dependency_libs`` does not
need to be modified for libraries or modules that are not installed in
directories searched by the dynamic linker by default and not intended
for use by other packages.

You must make sure that you use only released versions of shared
libraries to build your packages; otherwise other users will not be able
to run your binaries properly. Producing source packages that depend on
unreleased compilers is also usually a bad idea.

.. _s10.3:

Shared libraries
----------------

This section has moved to :doc:`Shared libraries <ch-sharedlibs>`.

.. _s-scripts:

Scripts
-------

All command scripts, including the package maintainer scripts inside the
package and used by ``dpkg``, should have a ``#!`` line naming the shell
to be used to interpret them.

In the case of Perl scripts this should be ``#!/usr/bin/perl``.

When scripts are installed into a directory in the system PATH, the
script name should not include an extension such as ``.sh`` or ``.pl``
that denotes the scripting language currently used to implement it.

Shell scripts (``sh`` and ``bash``) other than ``init.d`` scripts should
almost certainly start with ``set -e`` so that errors are detected.
``init.d`` scripts are something of a special case, due to how
frequently they need to call commands that are allowed to fail, and it
may instead be easier to check the exit status of commands directly. See
:ref:`s-writing-init` for more information about writing
``init.d`` scripts.

Every script should use ``set -e`` or check the exit status of *every*
command.

Scripts may assume that ``/bin/sh`` implements the SUSv3 Shell Command
Language  [#]_ plus the following additional features not mandated by
SUSv3.. [#]_

-  ``echo -n``, if implemented as a shell built-in, must not generate a
   newline.

-  ``test``, if implemented as a shell built-in, must support ``-a`` and
   ``-o`` as binary logical operators.

-  ``local`` to create a scoped variable must be supported, including
   listing multiple variables in a single local command and assigning a
   value to a variable at the same time as localizing it. ``local`` may
   or may not preserve the variable value from an outer scope if no
   assignment is present. Uses such as:

   ::

       fname () {
           local a b c=delta d
           # ... use a, b, c, d ...
       }

   must be supported and must set the value of ``c`` to ``delta``.

-  The XSI extension to ``kill`` allowing ``kill -signal``, where signal
   is either the name of a signal or one of the numeric signals listed
   in the XSI extension (0, 1, 2, 3, 6, 9, 14, and 15), must be
   supported if ``kill`` is implemented as a shell built-in.

-  The XSI extension to ``trap`` allowing numeric signals must be
   supported. In addition to the signal numbers listed in the extension,
   which are the same as for ``kill`` above, 13 (SIGPIPE) must be
   allowed.

If a shell script requires non-SUSv3 features from the shell interpreter
other than those listed above, the appropriate shell must be specified
in the first line of the script (e.g., ``#!/bin/bash``) and the package
must depend on the package providing the shell (unless the shell package
is marked "Essential", as in the case of ``bash``).

You may wish to restrict your script to SUSv3 features plus the above
set when possible so that it may use ``/bin/sh`` as its interpreter.
Checking your script with ``checkbashisms`` from the devscripts package
or running your script with an alternate shell such as ``posh`` may help
uncover violations of the above requirements. If in doubt whether a
script complies with these requirements, use ``/bin/bash``.

Perl scripts should check for errors when making any system calls,
including ``open``, ``print``, ``close``, ``rename`` and ``system``.

``csh`` and ``tcsh`` should be avoided as scripting languages. See *Csh
Programming Considered Harmful*, one of the ``comp.unix.*`` FAQs, which
can be found at http://www.faqs.org/faqs/unix-faq/shell/csh-whynot/. If
an upstream package comes with ``csh`` scripts then you must make sure
that they start with ``#!/bin/csh`` and make your package depend on the
``c-shell`` virtual package.

Any scripts which create files in world-writeable directories (e.g., in
``/tmp``) must use a mechanism which will fail atomically if a file with
the same name already exists.

The Debian base system provides the ``tempfile`` and ``mktemp``
utilities for use by scripts for this purpose.

.. _s10.5:

Symbolic links
--------------

In general, symbolic links within a top-level directory should be
relative, and symbolic links pointing from one top-level directory to or
into another should be absolute. (A top-level directory is a
sub-directory of the root directory ``/``.) For example, a symbolic link
from ``/usr/lib/foo`` to ``/usr/share/bar`` should be relative
(``../share/bar``), but a symbolic link from ``/var/run`` to ``/run``
should be absolute.  [#]_ Symbolic links must not traverse above the
root directory.

In addition, symbolic links should be specified as short as possible,
i.e., link targets like ``foo/../bar`` are deprecated.

Note that when creating a relative link using ``ln`` it is not necessary
for the target of the link to exist relative to the working directory
you're running ``ln`` from, nor is it necessary to change directory to
the directory where the link is to be made. Simply include the string
that should appear as the target of the link (this will be a pathname
relative to the directory in which the link resides) as the first
argument to ``ln``.

For example, in your ``Makefile`` or ``debian/rules``, you can do things
like:

::

    ln -fs gcc $(prefix)/bin/cc
    ln -fs gcc debian/tmp/usr/bin/cc
    ln -fs ../sbin/sendmail $(prefix)/bin/runq
    ln -fs ../sbin/sendmail debian/tmp/usr/bin/runq

A symbolic link pointing to a compressed file (in the sense that it is
meant to be uncompressed with ``unzip`` or ``zless`` etc.) should always
have the same file extension as the referenced file. (For example, if a
file ``foo.gz`` is referenced by a symbolic link, the filename of the
link has to end with "``.gz``" too, as in ``bar.gz``.)

.. _s10.6:

Device files
------------

Packages must not include device files or named pipes in the package
file tree.

Debian packages should assume that device files in ``/dev`` are
dynamically managed by the kernel or some other system facility and do
not have to be explicitly created or managed by the package. Debian
packages other than those whose purpose is to manage the ``/dev`` device
file tree must not attempt to create or remove device files in ``/dev``
when a dynamic device management facility is in use.

If named pipes or device files outside of ``/dev`` are required by a
package, they should normally be created when necessary by the programs
in the package, by init scripts or systemd unit files, or by similar
on-demand mechanisms. If such files need to be created during package
installation, they must be created in the ``postinst`` maintainer script
[#]_ and removed in either the ``prerm`` or the ``postrm`` maintainer
script.

.. _s-config-files:

Configuration files
-------------------

.. _s10.7.1:

Definitions
~~~~~~~~~~~

configuration file
    A file that affects the operation of a program, or provides site- or
    host-specific information, or otherwise customizes the behavior of a
    program. Typically, configuration files are intended to be modified
    by the system administrator (if needed or desired) to conform to
    local policy or to provide more useful site-specific behavior.

``conffile``
    A file listed in a package's ``conffiles`` file, and is treated
    specially by ``dpkg`` (see :ref:`s-configdetails`).

The distinction between these two is important; they are not
interchangeable concepts. Almost all ``conffile``\ s are configuration
files, but many configuration files are not ``conffiles``.

As noted elsewhere, ``/etc/init.d`` scripts, ``/etc/default`` files,
scripts installed in ``/etc/cron.{hourly,daily,weekly,monthly}``, and
cron configuration installed in ``/etc/cron.d`` must be treated as
configuration files. In general, any script that embeds configuration
information is de-facto a configuration file and should be treated as
such.

.. _s10.7.2:

Location
~~~~~~~~

Any configuration files created or used by your package must reside in
``/etc``. If there are several, consider creating a subdirectory of
``/etc`` named after your package.

If your package creates or uses configuration files outside of ``/etc``,
and it is not feasible to modify the package to use ``/etc`` directly,
put the files in ``/etc`` and create symbolic links to those files from
the location that the package requires.

.. _s10.7.3:

Behavior
~~~~~~~~

Configuration file handling must conform to the following behavior:

-  local changes must be preserved during a package upgrade, and

-  configuration files must be preserved when the package is removed,
   and only deleted when the package is purged.

Obsolete configuration files without local changes should be removed by
the package during upgrade.  [#]_

The easy way to achieve this behavior is to make the configuration file
a ``conffile``. This is appropriate only if it is possible to distribute
a default version that will work for most installations, although some
system administrators may choose to modify it. This implies that the
default version will be part of the package distribution, and must not
be modified by the maintainer scripts during installation (or at any
other time).

In order to ensure that local changes are preserved correctly, no
package may contain or make hard links to conffiles. [#]_

The other way to do it is via the maintainer scripts. In this case, the
configuration file must not be listed as a ``conffile`` and must not be
part of the package distribution. If the existence of a file is required
for the package to be sensibly configured it is the responsibility of
the package maintainer to provide maintainer scripts which correctly
create, update and maintain the file and remove it on purge. (See
:doc:`Package maintainer scripts and installation procedure <ch-maintainerscripts>`
for more information.) These scripts must be idempotent (i.e., must work
correctly if ``dpkg`` needs to re-run them due to errors during
installation or removal), must cope with all the variety of ways
``dpkg`` can call maintainer scripts, must not overwrite or otherwise
mangle the user's configuration without asking, must not ask unnecessary
questions (particularly during upgrades), and must otherwise be good
citizens.

The scripts are not required to configure every possible option for the
package, but only those necessary to get the package running on a given
system. Ideally the sysadmin should not have to do any configuration
other than that done (semi-)automatically by the ``postinst`` script.

A common practice is to create a script called ``package-configure`` and
have the package's ``postinst`` call it if and only if the configuration
file does not already exist. In certain cases it is useful for there to
be an example or template file which the maintainer scripts use. Such
files should be in ``/usr/share/package`` or ``/usr/lib/package``
(depending on whether they are architecture-independent or not). There
should be symbolic links to them from
``/usr/share/doc/package/examples`` if they are examples, and should be
perfectly ordinary ``dpkg``-handled files (*not* configuration files).

These two styles of configuration file handling must not be mixed, for
that way lies madness: ``dpkg`` will ask about overwriting the file
every time the package is upgraded.

.. _s10.7.4:

Sharing configuration files
~~~~~~~~~~~~~~~~~~~~~~~~~~~

If two or more packages use the same configuration file and it is
reasonable for both to be installed at the same time, one of these
packages must be defined as *owner* of the configuration file, i.e., it
will be the package which handles that file as a configuration file.
Other packages that use the configuration file must depend on the owning
package if they require the configuration file to operate. If the other
package will use the configuration file if present, but is capable of
operating without it, no dependency need be declared.

If it is desirable for two or more related packages to share a
configuration file *and* for all of the related packages to be able to
modify that configuration file, then the following should be done:

1. One of the related packages (the "owning" package) will manage the
   configuration file with maintainer scripts as described in the
   previous section.

2. The owning package should also provide a program that the other
   packages may use to modify the configuration file.

3. The related packages must use the provided program to make any
   desired modifications to the configuration file. They should either
   depend on the core package to guarantee that the configuration
   modifier program is available or accept gracefully that they cannot
   modify the configuration file if it is not. (This is in addition to
   the fact that the configuration file may not even be present in the
   latter scenario.)

Sometimes it's appropriate to create a new package which provides the
basic infrastructure for the other packages and which manages the shared
configuration files. (The ``sgml-base`` package is a good example.)

If the configuration file cannot be shared as described above, the
packages must be marked as conflicting with each other. Two packages
that specify the same file as a ``conffile`` must conflict. This is an
instance of the general rule about not sharing files. Neither
alternatives nor diversions are likely to be appropriate in this case;
in particular, ``dpkg`` does not handle diverted ``conffile``\ s well.

When two packages both declare the same ``conffile``, they may see
left-over configuration files from each other even though they conflict
with each other. If a user removes (without purging) one of the packages
and installs the other, the new package will take over the ``conffile``
from the old package. If the file was modified by the user, it will be
treated the same as any other locally modified ``conffile`` during an
upgrade.

The maintainer scripts must not alter a ``conffile`` of *any* package,
including the one the scripts belong to.

.. _s10.7.5:

User configuration files ("dotfiles")
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The files in ``/etc/skel`` will automatically be copied into new user
accounts by ``adduser``. No other program should reference the files in
``/etc/skel``.

Therefore, if a program needs a dotfile to exist in advance in ``$HOME``
to work sensibly, that dotfile should be installed in ``/etc/skel`` and
treated as a configuration file.

However, programs that require dotfiles in order to operate sensibly are
a bad thing, unless they do create the dotfiles themselves
automatically.

Furthermore, programs should be configured by the Debian default
installation to behave as closely to the upstream default behavior as
possible.

Therefore, if a program in a Debian package needs to be configured in
some way in order to operate sensibly, that should be done using a
site-wide configuration file placed in ``/etc``. Only if the program
doesn't support a site-wide default configuration and the package
maintainer doesn't have time to add it may a default per-user file be
placed in ``/etc/skel``.

``/etc/skel`` should be as empty as we can make it. This is particularly
true because there is no easy (or necessarily desirable) mechanism for
ensuring that the appropriate dotfiles are copied into the accounts of
existing users when a package is installed.

.. _s10.8:

Log files
---------

Log files should usually be named ``/var/log/package.log``. If you have
many log files, or need a separate directory for permission reasons
(``/var/log`` is writable only by ``root``), you should usually create a
directory named ``/var/log/package`` and place your log files there.

Log files must be rotated occasionally so that they don't grow
indefinitely. The best way to do this is to install a log rotation
configuration file in the directory ``/etc/logrotate.d``, normally named
``/etc/logrotate.d/package``, and use the facilities provided by
``logrotate``.  [#]_ Here is a good example for a logrotate config file
(for more information see logrotate(8)):

::

    /var/log/foo/*.log {
        rotate 12
        weekly
        compress
        missingok
        postrotate
            start-stop-daemon -K -p /var/run/foo.pid -s HUP -x /usr/sbin/foo -q
        endscript
    }

This rotates all files under ``/var/log/foo``, saves 12 compressed
generations, and tells the daemon to reopen its log files after the log
rotation. It skips this log rotation (via ``missingok``) if no such log
file is present, which avoids errors if the package is removed but not
purged.

Log files should be removed when the package is purged (but not when it
is only removed). This should be done by the ``postrm`` script when it
is called with the argument ``purge`` (see
:ref:`s-removedetails`).

.. _s-permissions-owners:

Permissions and owners
----------------------

The rules in this section are guidelines for general use. If necessary
you may deviate from the details below. However, if you do so you must
make sure that what is done is secure and you should try to be as
consistent as possible with the rest of the system. You should probably
also discuss it on ``debian-devel`` first.

Files should be owned by ``root:root``, and made writable only by the
owner and universally readable (and executable, if appropriate), that is
mode 644 or 755.

Directories should be mode 755 or (for group-writability) mode 2775. The
ownership of the directory should be consistent with its mode: if a
directory is mode 2775, it should be owned by the group that needs write
access to it.  [#]_

Control information files should be owned by ``root:root`` and either
mode 644 (for most files) or mode 755 (for executables such as
:ref:`maintainer scripts <s-maintscripts>`).

Setuid and setgid executables should be mode 4755 or 2755 respectively,
and owned by the appropriate user or group. They should not be made
unreadable (modes like 4711 or 2711 or even 4111); doing so achieves no
extra security, because anyone can find the binary in the freely
available Debian package; it is merely inconvenient. For the same reason
you should not restrict read or execute permissions on non-set-id
executables.

Some setuid programs need to be restricted to particular sets of users,
using file permissions. In this case they should be owned by the uid to
which they are set-id, and by the group which should be allowed to
execute them. They should have mode 4754; again there is no point in
making them unreadable to those users who must not be allowed to execute
them.

It is possible to arrange that the system administrator can reconfigure
the package to correspond to their local security policy by changing the
permissions on a binary: they can do this by using
``dpkg-statoverride``, as described below.  [#]_ Another method you
should consider is to create a group for people allowed to use the
program(s) and make any setuid executables executable only by that
group.

If you need to create a new user or group for your package there are two
possibilities. Firstly, you may need to make some files in the binary
package be owned by this user or group, or you may need to compile the
user or group id (rather than just the name) into the binary (though
this latter should be avoided if possible, as in this case you need a
statically allocated id).

If you need a statically allocated id, you must ask for a user or group
id from the ``base-passwd`` maintainer, and must not release the package
until you have been allocated one. Once you have been allocated one you
must either make the package depend on a version of the ``base-passwd``
package with the id present in ``/etc/passwd`` or ``/etc/group``, or
arrange for your package to create the user or group itself with the
correct id (using ``adduser``) in its ``preinst`` or ``postinst``.
(Doing it in the ``postinst`` is to be preferred if it is possible,
otherwise a pre-dependency will be needed on the ``adduser`` package.)

On the other hand, the program might be able to determine the uid or gid
from the user or group name at runtime, so that a dynamically allocated
id can be used. In this case you should choose an appropriate user or
group name, discussing this on ``debian-devel`` and checking that it is
unique. When this has been checked you must arrange for your package to
create the user or group if necessary using ``adduser`` in the
``preinst`` or ``postinst`` script (again, the latter is to be preferred
if it is possible).

Note that changing the numeric value of an id associated with a name is
very difficult, and involves searching the file system for all
appropriate files. You need to think carefully whether a static or
dynamic id is required, since changing your mind later will cause
problems.

.. _s10.9.1:

The use of ``dpkg-statoverride``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This section is not intended as policy, but as a description of the use
of ``dpkg-statoverride``.

If a system administrator wishes to have a file (or directory or other
such thing) installed with owner and permissions different from those in
the distributed Debian package, they can use the ``dpkg-statoverride``
program to instruct ``dpkg`` to use the different settings every time
the file is installed. Thus the package maintainer should distribute the
files with their normal permissions, and leave it for the system
administrator to make any desired changes. For example, a daemon which
is normally required to be setuid root, but in certain situations could
be used without being setuid, should be installed setuid in the
``.deb``. Then the local system administrator can change this if they
wish. If there are two standard ways of doing it, the package maintainer
can use ``debconf`` to find out the preference, and call
``dpkg-statoverride`` in the maintainer script if necessary to
accommodate the system administrator's choice. Care must be taken during
upgrades to not override an existing setting.

Given the above, ``dpkg-statoverride`` is essentially a tool for system
administrators and would not normally be needed in the maintainer
scripts. There is one type of situation, though, where calls to
``dpkg-statoverride`` would be needed in the maintainer scripts, and
that involves packages which use dynamically allocated user or group
ids. In such a situation, something like the following idiom can be very
helpful in the package's ``postinst``, where ``sysuser`` is a
dynamically allocated id:

::

    for i in /usr/bin/foo /usr/sbin/bar; do
        # only do something when no setting exists
        if ! dpkg-statoverride --list $i >/dev/null 2>&1; then
            #include: debconf processing, question about foo and bar
            if [ "$RET" = "tru.. [#] ; then
                dpkg-statoverride --update --add sysuser root 4755 $i
            fi
        fi
    done

The corresponding code to remove the override when the package is purged
would be:

::

    for i in /usr/bin/foo /usr/sbin/bar; do
        if dpkg-statoverride --list $i >/dev/null 2>&1; then
            dpkg-statoverride --remove $i
        fi
    done

.. _s-filenames:

File names
----------

The name of the files installed by binary packages in the system PATH
(namely ``/bin``, ``/sbin``, ``/usr/bin``, ``/usr/sbin`` and
``/usr/games``) must be encoded in ASCII.

The name of the files and directories installed by binary packages
outside the system PATH must be encoded in UTF-8 and should be
restricted to ASCII when it is possible to do so.

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
   objects that are dynamically loaded by programs using dlopen(3).

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
