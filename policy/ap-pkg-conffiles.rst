Configuration file handling (from old Packaging Manual)
=======================================================

``dpkg`` can do a certain amount of automatic handling of package
configuration files.

Whether this mechanism is appropriate depends on a number of factors,
but basically there are two approaches to any particular configuration
file.

The easy method is to ship a best-effort configuration in the package,
and use ``dpkg``'s conffile mechanism to handle updates. If the user is
unlikely to want to edit the file, but you need them to be able to
without losing their changes, and a new package with a changed version
of the file is only released infrequently, this is a good approach.

The hard method is to build the configuration file from scratch in the
``postinst`` script, and to take the responsibility for fixing any
mistakes made in earlier versions of the package automatically. This
will be appropriate if the file is likely to need to be different on
each system.

.. _s-sE.1:

Automatic handling of configuration files by ``dpkg``
-----------------------------------------------------

A package may contain a control information file called ``conffiles``.
This file should be a list of filenames of configuration files needing
automatic handling, separated by newlines. The filenames should be
absolute pathnames, and the files referred to should actually exist in
the package.

When a package is upgraded ``dpkg`` will process the configuration files
during the configuration stage, shortly before it runs the package's
``postinst`` script,

For each file it checks to see whether the version of the file included
in the package is the same as the one that was included in the last
version of the package (the one that is being upgraded from); it also
compares the version currently installed on the system with the one
shipped with the last version.

If neither the user nor the package maintainer has changed the file, it
is left alone. If one or the other has changed their version, then the
changed version is preferred - i.e., if the user edits their file, but
the package maintainer doesn't ship a different version, the user's
changes will stay, silently, but if the maintainer ships a new version
and the user hasn't edited it the new version will be installed (with an
informative message). If both have changed their version the user is
prompted about the problem and must resolve the differences themselves.

The comparisons are done by calculating the MD5 message digests of the
files, and storing the MD5 of the file as it was included in the most
recent version of the package.

When a package is installed for the first time ``dpkg`` will install the
file that comes with it, unless that would mean overwriting a file
already on the file system.

However, note that ``dpkg`` will *not* replace a conffile that was
removed by the user (or by a script). This is necessary because with
some programs a missing file produces an effect hard or impossible to
achieve in another way, so that a missing file needs to be kept that way
if the user did it.

Note that a package should *not* modify a ``dpkg``-handled conffile in
its maintainer scripts. Doing this will lead to ``dpkg`` giving the user
confusing and possibly dangerous options for conffile update when the
package is upgraded.

.. _s-sE.2:

Fully-featured maintainer script configuration handling
-------------------------------------------------------

For files which contain site-specific information such as the hostname
and networking details and so forth, it is better to create the file in
the package's ``postinst`` script.

This will typically involve examining the state of the rest of the
system to determine values and other information, and may involve
prompting the user for some information which can't be obtained some
other way.

When using this method there are a couple of important issues which
should be considered:

If you discover a bug in the program which generates the configuration
file, or if the format of the file changes from one version to the next,
you will have to arrange for the postinst script to do something
sensible - usually this will mean editing the installed configuration
file to remove the problem or change the syntax. You will have to do
this very carefully, since the user may have changed the file, perhaps
to fix the very problem that your script is trying to deal with - you
will have to detect these situations and deal with them correctly.

If you do go down this route it's probably a good idea to make the
program that generates the configuration file(s) a separate program in
``/usr/sbin``, by convention called ``packageconfig`` and then run that
if appropriate from the post-installation script. The ``packageconfig``
program should not unquestioningly overwrite an existing configuration -
if its mode of operation is geared towards setting up a package for the
first time (rather than any arbitrary reconfiguration later) you should
have it check whether the configuration already exists, and require a
``--force`` flag to overwrite it.

