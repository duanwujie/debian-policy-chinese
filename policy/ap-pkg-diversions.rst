Diversions - overriding a package's version of a file (from old Packaging Manual)
=================================================================================

It is possible to have ``dpkg`` not overwrite a file when it reinstalls
the package it belongs to, and to have it put the file from the package
somewhere else instead.

This can be used locally to override a package's version of a file, or
by one package to override another's version (or provide a wrapper for
it).

Before deciding to use a diversion, read
:doc:`ap-pkg-alternatives` to see if you really want a
diversion rather than several alternative versions of a program.

There is a diversion list, which is read by ``dpkg``, and updated by a
special program ``dpkg-divert``. Please see dpkg-divert8 for full
details of its operation.

When a package wishes to divert a file from another, it should call
``dpkg-divert`` in its preinst to add the diversion and rename the
existing file. For example, supposing that a ``smailwrapper`` package
wishes to install a wrapper around ``/usr/sbin/smail``:

::

    dpkg-divert --package smailwrapper --add --rename \
        --divert /usr/sbin/smail.real /usr/sbin/smail

The ``--package smailwrapper`` ensures that ``smailwrapper``'s copy of
``/usr/sbin/smail`` can bypass the diversion and get installed as the
true version. It's safe to add the diversion unconditionally on upgrades
since it will be left unchanged if it already exists, but
``dpkg-divert`` will display a message. To suppress that message, make
the command conditional on the version from which the package is being
upgraded:

::

    if [ upgrade != "$1 || dpkg --compare-versions "$2" lt 1.0-2; then
        dpkg-divert --package smailwrapper --add --rename \
            --divert /usr/sbin/smail.real /usr/sbin/smail
    fi

where ``1.0-2`` is the version at which the diversion was first added to
the package. Running the command during abort-upgrade is pointless but
harmless.

The postrm has to do the reverse:

::

    if [ remove = "$1" -o abort-install = "$1" -o disappear = "$1; then
        dpkg-divert --package smailwrapper --remove --rename \
            --divert /usr/sbin/smail.real /usr/sbin/smail
    fi

If the diversion was added at a particular version, the postrm should
also handle the failure case of upgrading from an older version (unless
the older version is so old that direct upgrades are no longer
supported):

::

    if [ abort-upgrade = "$1 && dpkg --compare-versions "$2" lt 1.0-2; then
        dpkg-divert --package smailwrapper --remove --rename \
            --divert /usr/sbin/smail.real /usr/sbin/smail
    fi

where ``1.0-2`` is the version at which the diversion was first added to
the package. The postrm should not remove the diversion on upgrades both
because there's no reason to remove the diversion only to immediately
re-add it and since the postrm of the old package is run after unpacking
so the removal of the diversion will fail.

Do not attempt to divert a file which is vitally important for the
system's operation - when using ``dpkg-divert`` there is a time, after
it has been diverted but before ``dpkg`` has installed the new version,
when the file does not exist.

Do not attempt to divert a conffile, as ``dpkg`` does not handle it
well.

