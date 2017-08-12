Alternative versions of an interface - ``update-alternatives`` (from old Packaging Manual)
==========================================================================================

When several packages all provide different versions of the same program
or file it is useful to have the system select a default, but to allow
the system administrator to change it and have their decisions
respected.

For example, there are several versions of the ``vi`` editor, and there
is no reason to prevent all of them from being installed at once, each
under their own name (``nvi``, ``vim`` or whatever). Nevertheless it is
desirable to have the name ``vi`` refer to something, at least by
default.

If all the packages involved cooperate, this can be done with
``update-alternatives``.

Each package provides its own version under its own name, and calls
``update-alternatives`` in its postinst to register its version (and
again in its prerm to deregister it).

See the man page update-alternatives8 for details.

If ``update-alternatives`` does not seem appropriate you may wish to
consider using diversions instead.

