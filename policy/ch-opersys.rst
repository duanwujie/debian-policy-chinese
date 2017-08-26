The Operating System
====================

.. _s9.1:

File system hierarchy
---------------------

.. _s-fhs:

File System Structure
~~~~~~~~~~~~~~~~~~~~~

The location of all files and directories must comply with the
Filesystem Hierarchy Standard (FHS), version 2.3, with the exceptions
noted below, and except where doing so would violate other terms of
Debian Policy. The following exceptions to the FHS apply:

1.  The FHS requirement that architecture-independent
    application-specific static files be located in ``/usr/share`` is
    relaxed to a suggestion. In particular, a subdirectory of
    ``/usr/lib`` may be used by a package (or a collection of packages)
    to hold a mixture of architecture-independent and
    architecture-dependent files. However, when a directory is entirely
    composed of architecture-independent files, it should be located in
    ``/usr/share``.

2.  The optional rules related to user specific configuration files for
    applications are stored in the user's home directory are relaxed. It
    is recommended that such files start with the '``.``' character (a
    "dot file"), and if an application needs to create more than one dot
    file then the preferred placement is in a subdirectory with a name
    starting with a '.' character, (a "dot directory"). In this case it
    is recommended the configuration files not start with the '.'
    character.

3.  The requirement for amd64 to use ``/lib64`` for 64 bit binaries is
    removed.  Only the dynamic linker is allowed to use this directory.

4.  The requirement for object files, internal binaries, and libraries,
    including ``libc.so.*``, to be located directly under ``/lib{,32}``
    and ``/usr/lib{,32}`` is amended, permitting files to instead be
    installed to ``/lib/triplet`` and ``/usr/lib/triplet``, where
    ``triplet`` is the value returned by ``dpkg-architecture -qDEB_HOST_MULTIARCH`` for the architecture of the
    package. Packages may *not* install files to any triplet path other
    than the one matching the architecture of that package; for
    instance, an ``Architecture:  amd64`` package containing 32-bit x86
    libraries may not install these libraries to
    ``/usr/lib/i386-linux-gnu``.  [#]_

    No package for a 64 bit architecture may install files in
    ``/usr/lib64/`` or in a subdirectory of it.

    The requirement for C and C++ headers files to be accessible through
    the search path ``/usr/include/`` is amended, permitting files to be
    accessible through the search path ``/usr/include/triplet`` where
    ``triplet`` is as above.  [#]_

    Applications may also use a single subdirectory under
    ``/usr/lib/triplet``.

    The execution time linker/loader, ld\*, must still be made available
    in the existing location under /lib or /lib64 since this is part of
    the ELF ABI for the architecture.

5.  The requirement that ``/usr/local/share/man`` be "synonymous" with
    ``/usr/local/man`` is relaxed to a recommendation

6.  The requirement that windowmanagers with a single configuration file
    call it ``system.*wmrc`` is removed, as is the restriction that the
    window manager subdirectory be named identically to the window
    manager name itself.

7.  The requirement that boot manager configuration files live in
    ``/etc``, or at least are symlinked there, is relaxed to a
    recommendation.

8.  The additional directory ``/run`` in the root file system is
    allowed. ``/run`` replaces ``/var/run``, and the subdirectory
    ``/run/lock`` replaces ``/var/lock``, with the ``/var`` directories
    replaced by symlinks for backwards compatibility. ``/run`` and
    ``/run/lock`` must follow all of the requirements in the FHS for
    ``/var/run`` and ``/var/lock``, respectively, such as file naming
    conventions, file format requirements, or the requirement that files
    be cleared during the boot process. Files and directories residing
    in ``/run`` should be stored on a temporary file system.

9.  The ``/sys`` directory in the root filesystem is additionally
    allowed.  [#]_

10. The ``/var/www`` directory is additionally allowed.

11. The requirement for ``/usr/local/libqual`` to exist if ``/libqual``
    or ``/usr/libqual`` exists (where ``libqual`` is a variant of
    ``lib`` such as ``lib32`` or ``lib64``) is removed.

12. On GNU/Hurd systems, the following additional directories are
    allowed in the root filesystem: ``/hurd`` and ``/servers``.  [#]_

The version of this document referred here can be found in the
``debian-policy`` package or on `FHS (Debian
copy) <https://www.debian.org/doc/packaging-manuals/fhs/>`_ alongside
this manual (or, if you have the debian-policy installed, you can try
`FHS (local copy) <file:///usr/share/doc/debian-policy/fhs/>`_). The
latest version, which may be a more recent version, may be found on `FHS
(upstream) <http://www.pathname.com/fhs/>`_. Specific questions about
following the standard may be asked on the ``debian-devel`` mailing
list, or referred to the FHS mailing list (see the `FHS web
site <http://www.pathname.com/fhs/>`_ for more information).

.. _s9.1.2:

Site-specific programs
~~~~~~~~~~~~~~~~~~~~~~

As mandated by the FHS, packages must not place any files in
``/usr/local``, either by putting them in the file system archive to be
unpacked by ``dpkg`` or by manipulating them in their maintainer
scripts.

However, the package may create empty directories below ``/usr/local``
so that the system administrator knows where to place site-specific
files. These are not directories *in* ``/usr/local``, but are children
of directories in ``/usr/local``. These directories
(``/usr/local/*/dir/``) should be removed on package removal if they are
empty.

Note that this applies only to directories *below* ``/usr/local``, not
*in* ``/usr/local``. Packages must not create sub-directories in the
directory ``/usr/local`` itself, except those listed in FHS, section
4.5. However, you may create directories below them as you wish. You
must not remove any of the directories listed in 4.5, even if you
created them.

Since ``/usr/local`` can be mounted read-only from a remote server,
these directories must be created and removed by the ``postinst`` and
``prerm`` maintainer scripts and not be included in the ``.deb``
archive. These scripts must not fail if either of these operations fail.

For example, the ``emacsen-common`` package could contain something like

::

    if [ ! -e /usr/local/share/ema.. [#]; then
        if mkdir /usr/local/share/emacs 2>/dev/null; then
            if chown root:staff /usr/local/share/emacs; then
                chmod 2775 /usr/local/share/emacs || true
            fi
        fi
    fi

in its ``postinst`` script, and

::

    rmdir /usr/local/share/emacs/site-lisp 2>/dev/null || true
    rmdir /usr/local/share/emacs 2>/dev/null || true

in the ``prerm`` script. (Note that this form is used to ensure that if
the script is interrupted, the directory ``/usr/local/share/emacs`` will
still be removed.)

If you do create a directory in ``/usr/local`` for local additions to a
package, you should ensure that settings in ``/usr/local`` take
precedence over the equivalents in ``/usr``.

However, because ``/usr/local`` and its contents are for exclusive use
of the local administrator, a package must not rely on the presence or
absence of files or directories in ``/usr/local`` for normal operation.

The ``/usr/local`` directory itself and all the subdirectories created
by the package should (by default) have permissions 2775 (group-writable
and set-group-id) and be owned by ``root:staff``.

.. _s9.1.3:

The system-wide mail directory
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The system-wide mail directory is ``/var/mail``. This directory is part
of the base system and should not be owned by any particular mail
agents. The use of the old location ``/var/spool/mail`` is deprecated,
even though the spool may still be physically located there.

.. _s-fhs-run:

``/run`` and ``/run/lock``
~~~~~~~~~~~~~~~~~~~~~~~~~~

The directory ``/run`` is cleared at boot, normally by being a mount
point for a temporary file system. Packages therefore must not assume
that any files or directories under ``/run`` other than ``/run/lock``
exist unless the package has arranged to create those files or
directories since the last reboot. Normally, this is done by the package
via an init script. See :ref:`s-writing-init` for more
information.

Packages must not include files or directories under ``/run``, or under
the older ``/var/run`` and ``/var/lock`` paths. The latter paths will
normally be symlinks or other redirections to ``/run`` for backwards
compatibility.

.. _s9.2:

Users and groups
----------------

.. _s9.2.1:

Introduction
~~~~~~~~~~~~

The Debian system can be configured to use either plain or shadow
passwords.

Some user ids (UIDs) and group ids (GIDs) are reserved globally for use
by certain packages. Because some packages need to include files which
are owned by these users or groups, or need the ids compiled into
binaries, these ids must be used on any Debian system only for the
purpose for which they are allocated. This is a serious restriction, and
we should avoid getting in the way of local administration policies. In
particular, many sites allocate users and/or local system groups
starting at 100.

Apart from this we should have dynamically allocated ids, which should
by default be arranged in some sensible order, but the behavior should
be configurable.

Packages other than ``base-passwd`` must not modify ``/etc/passwd``,
``/etc/shadow``, ``/etc/group`` or ``/etc/gshadow``.

.. _s9.2.2:

UID and GID classes
~~~~~~~~~~~~~~~~~~~

The UID and GID numbers are divided into classes as follows:

0-99:
    Globally allocated by the Debian project, the same on every Debian
    system. These ids will appear in the ``passwd`` and ``group`` files
    of all Debian systems, new ids in this range being added
    automatically as the ``base-passwd`` package is updated.

    Packages which need a single statically allocated uid or gid should
    use one of these; their maintainers should ask the ``base-passwd``
    maintainer for ids.

100-999:
    Dynamically allocated system users and groups. Packages which need a
    user or group, but can have this user or group allocated dynamically
    and differently on each system, should use ``adduser --system`` to
    create the group and/or user. ``adduser`` will check for the
    existence of the user or group, and if necessary choose an unused id
    based on the ranges specified in ``adduser.conf``.

1000-59999:
    Dynamically allocated user accounts. By default ``adduser`` will
    choose UIDs and GIDs for user accounts in this range, though
    ``adduser.conf`` may be used to modify this behavior.

60000-64999:
    Globally allocated by the Debian project, but only created on
    demand. The ids are allocated centrally and statically, but the
    actual accounts are only created on users' systems on demand.

    These ids are for packages which are obscure or which require many
    statically-allocated ids. These packages should check for and create
    the accounts in ``/etc/passwd`` or ``/etc/group`` (using ``adduser``
    if it has this facility) if necessary. Packages which are likely to
    require further allocations should have a "hole" left after them in
    the allocation, to give them room to grow.

65000-65533:
    Reserved.

65534:
    User ``nobody``. The corresponding gid refers to the group
    ``nogroup``.

65535:
    This value *must not* be used, because it was the error return
    sentinel value when ``uid_t`` was 16 bits.

65536-4294967293:
    Dynamically allocated user accounts. By default ``adduser`` will not
    allocate UIDs and GIDs in this range, to ease compatibility with
    legacy systems where ``uid_t`` is still 16 bits.

4294967294:
    ``(uid_t)(-2) == (gid_t)(-2)`` *must not* be used, because it is
    used as the anonymous, unauthenticated user by some NFS
    implementations.

4294967295:
    ``(uid_t)(-1) == (gid_t)(-1)`` *must not* be used, because it is the
    error return sentinel value.

.. _s-nonexistent:

Non-existent home directories
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The canonical non-existent home directory is ``/nonexistent``.  Users
who should not have a home directory should have their home directory
set to this value.

The Debian autobuilders set HOME to ``/nonexistent`` so that packages
which try to write to a home directory will fail to build.

.. _s-sysvinit:

System run levels and ``init.d`` scripts
----------------------------------------

.. _s-etc-init.d:

Introduction
~~~~~~~~~~~~

The ``/etc/init.d`` directory contains the scripts executed by ``init``
at boot time and when the init state (or "runlevel") is changed (see
``init(8)``).

There are at least two different, yet functionally equivalent, ways of
handling these scripts. For the sake of simplicity, this document
describes only the symbolic link method. However, it must not be assumed
by maintainer scripts that this method is being used, and any automated
manipulation of the various runlevel behaviors by maintainer scripts
must be performed using ``update-rc.d`` as described below and not by
manually installing or removing symlinks. For information on the
implementation details of the other method, implemented in the
``file-rc`` package, please refer to the documentation of that package.

These scripts are referenced by symbolic links in the ``/etc/rcn.d``
directories. When changing runlevels, ``init`` looks in the directory
``/etc/rcn.d`` for the scripts it should execute, where ``n`` is the
runlevel that is being changed to, or ``S`` for the boot-up scripts.

The names of the links all have the form ``Smmscript`` or ``Kmmscript``
where mm is a two-digit number and script is the name of the script
(this should be the same as the name of the actual script in
``/etc/init.d``).

When ``init`` changes runlevel first the targets of the links whose
names start with a ``K`` are executed, each with the single argument
``stop``, followed by the scripts prefixed with an ``S``, each with the
single argument ``start``. (The links are those in the ``/etc/rcn.d``
directory corresponding to the new runlevel.) The ``K`` links are
responsible for killing services and the ``S`` link for starting
services upon entering the runlevel.

For example, if we are changing from runlevel 2 to runlevel 3, init will
first execute all of the ``K`` prefixed scripts it finds in
``/etc/rc3.d``, and then all of the ``S`` prefixed scripts in that
directory. The links starting with ``K`` will cause the referred-to file
to be executed with an argument of ``stop``, and the ``S`` links with an
argument of ``start``.

The two-digit number mm is used to determine the order in which to run
the scripts: low-numbered links have their scripts run first. For
example, the ``K20`` scripts will be executed before the ``K30``
scripts. This is used when a certain service must be started before
another. For example, the name server ``bind`` might need to be started
before the news server ``inn`` so that ``inn`` can set up its access
lists. In this case, the script that starts ``bind`` would have a lower
number than the script that starts ``inn`` so that it runs first:

::

    /etc/rc2.d/S17bind
    /etc/rc2.d/S70inn

The two runlevels 0 (halt) and 6 (reboot) are slightly different. In
these runlevels, the links with an ``S`` prefix are still called after
those with a ``K`` prefix, but they too are called with the single
argument ``stop``.

.. _s-writing-init:

Writing the scripts
~~~~~~~~~~~~~~~~~~~

Packages that include daemons for system services should place scripts
in ``/etc/init.d`` to start or stop services at boot time or during a
change of runlevel. These scripts should be named
``/etc/init.d/package``, and they should accept one argument, saying
what to do:

``start``
    start the service,

``stop``
    stop the service,

``restart``
    stop and restart the service if it's already running, otherwise
    start the service

``try-restart``
    restart the service if it's already running, otherwise just report
    success.

``reload``
    cause the configuration of the service to be reloaded without
    actually stopping and restarting the service,

``force-reload``
    cause the configuration to be reloaded if the service supports this,
    otherwise restart the service.

``status``
    report the current status of the service

The ``start``, ``stop``, ``restart``, and ``force-reload`` options
should be supported by all scripts in ``/etc/init.d``. Supporting
``status`` is recommended but not required. The ``reload`` and
``try-restart`` options are optional.

The ``init.d`` scripts must ensure that they will behave sensibly (i.e.,
returning success and not starting multiple copies of a service) if
invoked with ``start`` when the service is already running, or with
``stop`` when it isn't, and that they don't kill unfortunately-named
user processes. The best way to achieve this is usually to use
``start-stop-daemon`` with the ``--oknodo`` option.

Be careful of using ``set -e`` in ``init.d`` scripts. Writing correct
``init.d`` scripts requires accepting various error exit statuses when
daemons are already running or already stopped without aborting the
``init.d`` script, and common ``init.d`` function libraries are not safe
to call with ``set -e`` in effect.  [#]_ For ``init.d`` scripts, it's
often easier to not use ``set -e`` and instead check the result of each
command separately.

If a service reloads its configuration automatically (as in the case of
``cron``, for example), the ``reload`` option of the ``init.d`` script
should behave as if the configuration has been reloaded successfully.

The ``/etc/init.d`` scripts must be treated as configuration files,
either (if they are present in the package, that is, in the .deb file)
by marking them as ``conffile``\ s, or, (if they do not exist in the
.deb) by managing them correctly in the maintainer scripts (see
:ref:`s-config-files`). This is important since we want
to give the local system administrator the chance to adapt the scripts
to the local system, e.g., to disable a service without de-installing
the package, or to specify some special command line options when
starting a service, while making sure their changes aren't lost during
the next package upgrade.

These scripts should not fail obscurely when the configuration files
remain but the package has been removed, as configuration files remain
on the system after the package has been removed. Only when ``dpkg`` is
executed with the ``--purge`` option will configuration files be
removed. In particular, as the ``/etc/init.d/package`` script itself is
usually a ``conffile``, it will remain on the system if the package is
removed but not purged. Therefore, you should include a ``test``
statement at the top of the script, like this:

::

    test -f program-executed-later-in-script || exit 0

Often there are some variables in the ``init.d`` scripts whose values
control the behavior of the scripts, and which a system administrator is
likely to want to change. As the scripts themselves are frequently
``conffile``\ s, modifying them requires that the administrator merge in
their changes each time the package is upgraded and the ``conffile``
changes. To ease the burden on the system administrator, such
configurable values should not be placed directly in the script.
Instead, they should be placed in a file in ``/etc/default``, which
typically will have the same base name as the ``init.d`` script. This
extra file should be sourced by the script when the script runs. It must
contain only variable settings and comments in SUSv3 ``sh`` format. It
may either be a ``conffile`` or a configuration file maintained by the
package maintainer scripts. See :ref:`s-config-files` for
more details.

To ensure that vital configurable values are always available, the
``init.d`` script should set default values for each of the shell
variables it uses, either before sourcing the ``/etc/default/`` file or
afterwards using something like the ``: ${VAR:=default}`` syntax. Also,
the ``init.d`` script must behave sensibly and not fail if the
``/etc/default`` file is deleted.

Files and directories under ``/run``, including ones referred to via the
compatibility paths ``/var/run`` and ``/var/lock``, are normally stored
on a temporary filesystem and are normally not persistent across a
reboot. The ``init.d`` scripts must handle this correctly. This will
typically mean creating any required subdirectories dynamically when the
``init.d`` script is run. See :ref:`s-fhs-run` for more
information.

.. _s9.3.3:

Interfacing with init systems
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Maintainers should use the abstraction layer provided by the
``update-rc.d`` and ``invoke-rc.d`` programs to deal with initscripts in
their packages' scripts such as ``postinst``, ``prerm`` and ``postrm``.

Directly managing the /etc/rc?.d links and directly invoking the
``/etc/init.d/`` initscripts should be done only by packages providing
the initscript subsystem (such as ``sysv-rc`` and ``file-rc``).

.. _s9.3.3.1:

Managing the links
^^^^^^^^^^^^^^^^^^

The program ``update-rc.d`` is provided for package maintainers to
arrange for the proper creation and removal of ``/etc/rcn.d`` symbolic
links, or their functional equivalent if another method is being used.
This may be used by maintainers in their packages' ``postinst`` and
``postrm`` scripts.

You must not include any ``/etc/rcn.d`` symbolic links in the actual
archive or manually create or remove the symbolic links in maintainer
scripts; you must use the ``update-rc.d`` program instead. (The former
will fail if an alternative method of maintaining runlevel information
is being used.) You must not include the ``/etc/rcn.d`` directories
themselves in the archive either. (Only the ``sysvinit`` package may do
so.)

To get the default behavior for your package, put in your ``postinst``
script

::

    update-rc.d package defaults

and in your ``postrm``

::

    if [ "$1" = pur.. [#]; then
        update-rc.d package remove
    fi

Note that if your package changes runlevels or priority, you may have to
remove and recreate the links, since otherwise the old links may
persist. Refer to the documentation of ``update-rc.d``.

For more information about using ``update-rc.d``, please consult its man
page, update-rc.d(8).

It is easiest for packages not to call ``update-rc.d`` directly, but
instead use debhelper programs that add the required ``update-rc.d``
calls automatically. See ``dh_installinit``, ``dh_systemd_enable``, etc.

.. _s9.3.3.2:

Running initscripts
^^^^^^^^^^^^^^^^^^^

The program ``invoke-rc.d`` is provided to make it easier for package
maintainers to properly invoke an initscript, obeying runlevel and other
locally-defined constraints that might limit a package's right to start,
stop and otherwise manage services. This program may be used by
maintainers in their packages' scripts.

The package maintainer scripts must use ``invoke-rc.d`` to invoke the
``/etc/init.d/*`` initscripts or equivalent, instead of calling them
directly.

By default, ``invoke-rc.d`` will pass any action requests (start, stop,
reload, restart...) to the ``/etc/init.d`` script, filtering out
requests to start or restart a service out of its intended runlevels.

Most packages will simply use:

::

    invoke-rc.d package action

in their ``postinst`` and ``prerm`` scripts.

A package should register its initscript services using ``update-rc.d``
before it tries to invoke them using ``invoke-rc.d``. Invocation of
unregistered services may fail.

For more information about using ``invoke-rc.d``, please consult its man
page, invoke-rc.d(8).

It is easiest for packages not to call ``invoke-rc.d`` directly, but
instead use debhelper programs that add the required ``invoke-rc.d``
calls automatically. See ``dh_installinit``, ``dh_systemd_start``, etc.

.. _s9.3.4:

Boot-time initialization
~~~~~~~~~~~~~~~~~~~~~~~~

This section has been deleted.

.. _s9.3.5:

Example
~~~~~~~

Examples on which you can base your systemd integration on is available in
the man page systemd.unit(8). An example on which you can base your
``/etc/init.d`` scripts is found in ``/etc/init.d/skeleton``.

.. _s9.4:

Console messages from ``init.d`` scripts
----------------------------------------

This section has been deleted.

.. _s-cron-jobs:

Cron jobs
---------

Packages must not modify the configuration file ``/etc/crontab``, and
they must not modify the files in ``/var/spool/cron/crontabs``.

If a package wants to install a job that has to be executed via cron, it
should place a file named as specified in
:ref:`s-cron-files` into one or more of the following
directories:

-  ``/etc/cron.hourly``

-  ``/etc/cron.daily``

-  ``/etc/cron.weekly``

-  ``/etc/cron.monthly``

As these directory names imply, the files within them are executed on an
hourly, daily, weekly, or monthly basis, respectively. The exact times
are listed in ``/etc/crontab``.

All files installed in any of these directories must be scripts (e.g.,
shell scripts or Perl scripts) so that they can easily be modified by
the local system administrator. In addition, they must be treated as
configuration files.

If a certain job has to be executed at some other frequency or at a
specific time, the package should install a file in ``/etc/cron.d`` with
a name as specified in :ref:`s-cron-files`. This file
uses the same syntax as ``/etc/crontab`` and is processed by ``cron``
automatically. The file must also be treated as a configuration file.
(Note that entries in the ``/etc/cron.d`` directory are not handled by
``anacron``. Thus, you should only use this directory for jobs which may
be skipped if the system is not running.)

Unlike ``crontab`` files described in the IEEE Std 1003.1-2008 (POSIX.1)
available from `The Open
Group <https://www.opengroup.org/onlinepubs/9699919799/>`_, the files
in ``/etc/cron.d`` and the file ``/etc/crontab`` have seven fields;
namely:

1. Minute [0,59]

2. Hour [0,23]

3. Day of the month [1,31]

4. Month of the year [1,12]

5. Day of the week ([0,6] with 0=Sunday)

6. Username

7. Command to be run

Ranges of numbers are allowed. Ranges are two numbers separated with a
hyphen. The specified range is inclusive. Lists are allowed. A list is a
set of numbers (or ranges) separated by commas. Step values can be used
in conjunction with ranges.

The scripts or ``crontab`` entries in these directories should check if
all necessary programs are installed before they try to execute them.
Otherwise, problems will arise when a package was removed but not purged
since configuration files are kept on the system in this situation.

Any ``cron`` daemon must provide ``/usr/bin/crontab`` and support normal
``crontab`` entries as specified in POSIX. The daemon must also support
names for days and months, ranges, and step values. It has to support
``/etc/crontab``, and correctly execute the scripts in ``/etc/cron.d``.
The daemon must also correctly execute scripts in
``/etc/cron.{hourly,daily,weekly,monthly}``.

.. _s-cron-files:

Cron job file names
~~~~~~~~~~~~~~~~~~~

The file name of a cron job file should normally match the name of the
package from which it comes.

If a package supplies multiple cron job files files in the same
directory, the file names should all start with the name of the package
(possibly modified as described below) followed by a hyphen (``-``) and
a suitable suffix.

A cron job file name must not include any period or plus characters
(``.`` or ``+``) characters as this will cause cron to ignore the file.
Underscores (``_``) should be used instead of ``.`` and ``+``
characters.

.. _s-menus:

Menus
-----

Packages shipping applications that comply with minimal requirements
described below for integration with desktop environments should
register these applications in the desktop menu, following the
*FreeDesktop* standard, using text files called *desktop entries*. Their
format is described in the *Desktop Entry Specification* at
https://standards.freedesktop.org/desktop-entry-spec/latest/ and
complementary information can be found in the *Desktop Menu
Specification* at https://standards.freedesktop.org/menu-spec/latest/.

The desktop entry files are installed by the packages in the directory
``/usr/share/applications`` and the FreeDesktop menus are refreshed
using *dpkg triggers*. It is therefore not necessary to depend on
packages providing FreeDesktop menu systems.

Entries displayed in the FreeDesktop menu should conform to the
following minima for relevance and visual integration.

-  Unless hidden by default, the desktop entry must point to a PNG or
   SVG icon with a transparent background, providing at least the 22×22
   size, and preferably up to 64×64. The icon should be neutral enough
   to integrate well with the default icon themes. It is encouraged to
   ship the icon in the default *hicolor* icon theme directories, or to
   use an existing icon from the *hicolor* theme.

-  If the menu entry is not useful in the general case as a standalone
   application, the desktop entry should set the ``NoDisplay`` key to
   true, so that it can be configured to be displayed only by those who
   need it.

-  In doubt, the package maintainer should coordinate with the
   maintainers of menu implementations through the *debian-desktop*
   mailing list in order to avoid problems with categories or bad
   interactions with other icons. Especially for packages which are part
   of installation tasks, the contents of the
   ``NotShowIn``/``OnlyShowIn`` keys should be validated by the
   maintainers of the relevant environments.

Since the FreeDesktop menu is a cross-distribution standard, the desktop
entries written for Debian should be forwarded upstream, where they will
benefit to other users and are more likely to receive extra
contributions such as translations.

If a package installs a FreeDesktop desktop entry, it must not also
install a Debian menu entry.

.. _s-mime:

Multimedia handlers
-------------------

Media types (formerly known as MIME types, Multipurpose Internet Mail
Extensions, RFCs 2045-2049) is a mechanism for encoding files and data
streams and providing meta-information about them, in particular their
type and format (e.g. ``image/png``, ``text/html``, ``audio/ogg``).

Registration of media type handlers allows programs like mail user
agents and web browsers to invoke these handlers to view, edit or
display media types they don't support directly.

There are two overlapping systems to associate media types to programs
which can handle them. The *mailcap* system is found on a large number
of Unix systems. The *FreeDesktop* system is aimed at Desktop
environments. In Debian, FreeDesktop entries are automatically
translated in mailcap entries, therefore packages already using desktop
entries should not use the mailcap system directly.

.. _s-media-types-freedesktop:

Registration of media type handlers with desktop entries
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Packages shipping an application able to view, edit or point to files of
a given media type, or open links with a given URI scheme, should list
it in the ``MimeType`` key of the application's `desktop
entry <#s-menus>`_. For URI schemes, the relevant MIME types are
``x-scheme-handler/*`` (e.g. ``x-scheme-handler/https``).

.. _s-mailcap:

Registration of media type handlers with mailcap entries
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Packages that are not using desktop entries for registration should
install a file in mailcap(5) format (RFC 1524) in the directory
``/usr/lib/mime/packages/``. The file name should be the binary
package's name.

The mime-support package provides the ``update-mime`` program, which
integrates these registrations in the ``/etc/mailcap`` file, using dpkg
triggers.  [#]_

Packages installing desktop entries should not install mailcap entries
for the same program, because the mime-support package already reads
desktop entries.

Packages using these facilities *should not* depend on, recommend, or
suggest ``mime-support``.

.. _s-file-media-type:

Providing media types to files
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The media type of a file is discovered by inspecting the file's
extension or its magic(5) pattern, and interrogating a database
associating them with media types.

To support new associations between media types and files, their
characteristic file extensions and magic patterns should be registered
to the IANA (Internet Assigned Numbers Authority). See
https://www.iana.org/assignments/media-types and RFC 6838 for details.
This information will then propagate to the systems discovering file
media types in Debian, provided by the shared-mime-info, mime-support
and file packages. If registration and propagation can not be waited
for, support can be asked to the maintainers of the packages mentioned
above.

For files that are produced and read by a single application, it is also
possible to declare this association to the *Shared MIME Info* system by
installing in the directory ``/usr/share/mime/packages`` a file in the
XML format specified at
https://standards.freedesktop.org/shared-mime-info-spec/latest/.

.. _s9.8:

Keyboard configuration
----------------------

To achieve a consistent keyboard configuration so that all applications
interpret a keyboard event the same way, all programs in the Debian
distribution must be configured to comply with the following guidelines.

The following keys must have the specified interpretations:

``<--``
    delete the character to the left of the cursor

``Delete``
    delete the character to the right of the cursor

``Control+H``
    emacs: the help prefix

The interpretation of any keyboard events should be independent of the
terminal that is used, be it a virtual console, an X terminal emulator,
an rlogin/telnet session, etc.

The following list explains how the different programs should be set up
to achieve this:

-  ``<--`` generates ``KB_BackSpace`` in X.

-  ``Delete`` generates ``KB_Delete`` in X.

-  X translations are set up to make ``KB_Backspace`` generate ASCII
   DEL, and to make ``KB_Delete`` generate ``ESC [ 3 ~`` (this is the vt220 escape code for the "delete
   character" key). This must be done by loading the X resources using
   ``xrdb`` on all local X displays, not using the application defaults,
   so that the translation resources used correspond to the ``xmodmap``
   settings.

-  The Linux console is configured to make ``<--`` generate DEL, and
   ``Delete`` generate ``ESC [ 3 ~``.

-  X applications are configured so that ``<`` deletes left, and
   ``Delete`` deletes right. Motif applications already work like this.

-  Terminals should have ``stty erase ^?`` .

-  The ``xterm`` terminfo entry should have ``ESC [ 3 ~`` for ``kdch1``,
   just as for ``TERM=linux`` and ``TERM=vt220``.

-  Emacs is programmed to map ``KB_Backspace`` or the ``stty erase``
   character to ``delete-backward-char``, and ``KB_Delete`` or ``kdch1``
   to ``delete-forward-char``, and ``^H`` to ``help`` as always.

-  Other applications use the ``stty erase`` character and ``kdch1`` for
   the two delete keys, with ASCII DEL being "delete previous character"
   and ``kdch1`` being "delete character under cursor".

This will solve the problem except for the following cases:

-  Some terminals have a ``<--`` key that cannot be made to produce
   anything except ``^H``. On these terminals Emacs help will be
   unavailable on ``^H`` (assuming that the ``stty erase`` character
   takes precedence in Emacs, and has been set correctly). ``M-x help`` or ``F1`` (if available) can be used instead.

-  Some operating systems use ``^H`` for ``stty erase``. However, modern
   telnet versions and all rlogin versions propagate ``stty`` settings,
   and almost all UNIX versions honour ``stty erase``. Where the
   ``stty`` settings are not propagated correctly, things can be made to
   work by using ``stty`` manually.

-  Some systems (including previous Debian versions) use ``xmodmap`` to
   arrange for both ``<--`` and ``Delete`` to generate ``KB_Delete``. We
   can change the behavior of their X clients using the same X resources
   that we use to do it for our own clients, or configure our clients
   using their resources when things are the other way around. On
   displays configured like this ``Delete`` will not work, but ``<--``
   will.

-  Some operating systems have different ``kdch1`` settings in their
   ``terminfo`` database for ``xterm`` and others. On these systems the
   ``Delete`` key will not work correctly when you log in from a system
   conforming to our policy, but ``<--`` will.

.. _s9.9:

Environment variables
---------------------

Programs installed on the system PATH (``/bin``, ``/usr/bin``,
``/sbin``, ``/usr/sbin``, or similar directories) must not depend on
custom environment variable settings to get reasonable defaults. This is
because such environment variables would have to be set in a system-wide
configuration file such as a file in ``/etc/profile.d``, which is not
supported by all shells.

If a program usually depends on environment variables for its
configuration, the program should be changed to fall back to a
reasonable default configuration if these environment variables are not
present. If this cannot be done easily (e.g., if the source code of a
non-free program is not available), the program must be replaced by a
small "wrapper" shell script that sets the environment variables if they
are not already defined, and calls the original program.

Here is an example of a wrapper script for this purpose:

::

    #!/bin/sh
    BAR=${BAR:-/var/lib/fubar}
    export BAR
    exec /usr/lib/foo/foo "$@"

.. _s-doc-base:

Registering Documents using doc-base
------------------------------------

The doc-base package implements a flexible mechanism for handling and
presenting documentation. The recommended practice is for every Debian
package that provides online documentation (other than just manual
pages) to register these documents with doc-base by installing a
doc-base control file in ``/usr/share/doc-base/``.

Please refer to the documentation that comes with the doc-base package
for information and details.

.. _s-alternateinit:

Alternate init systems
----------------------

A number of other init systems are available now in Debian that can be
used in place of sysvinit. Alternative init implementations must support
running SysV init scripts as described at
:ref:`s-sysvinit` for compatibility.

Packages may integrate with these replacement init systems by providing
implementation-specific configuration information about how and when to
start a service or in what order to run certain tasks at boot time.
However, any package integrating with other init systems must also be
backwards-compatible with sysvinit by providing a SysV-style init script
with the same name as and equivalent functionality to any init-specific
job, as this is the only start-up configuration method guaranteed to be
supported by all init implementations. An exception to this rule is
scripts or jobs provided by the init implementation itself; such jobs
may be required for an implementation-specific equivalent of the
``/etc/rcS.d/`` scripts and may not have a one-to-one correspondence
with the init scripts.

.. _s-upstart:

Event-based boot with upstart
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ``upstart`` event-based boot system is no longer maintained in
Debian, so this section has been removed.

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
   Creating, modifying or removing a file in
   ``/usr/lib/mime/packages/`` using maintainer scripts will not
   activate the trigger. In that case, it can be done by calling
   ``dpkg-trigger --no-await /usr/lib/mime/packages`` from the
   maintainer script after creating, modifying, or removing the file.
