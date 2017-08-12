Introduction and scope of these appendices
==========================================

These appendices, except the final three, are taken essentially verbatim
from the now-deprecated Packaging Manual, version 3.2.1.0. They are the
chapters which are likely to be of use to package maintainers and which
have not already been included in the policy document itself. Most of
these sections are very likely not relevant to policy; they should be
treated as documentation for the packaging system. Please note that
these appendices are included for convenience, and for historical
reasons: they used to be part of policy package, and they have not yet
been incorporated into dpkg documentation. However, they still have
value, and hence they are presented here.

They have not yet been checked to ensure that they are compatible with
the contents of policy, and if there are any contradictions, the version
in the main policy document takes precedence. The remaining chapters of
the old Packaging Manual have also not been read in detail to ensure
that there are not parts which have been left out. Both of these will be
done in due course.

Certain parts of the Packaging manual were integrated into the Policy
Manual proper, and removed from the appendices. Links have been placed
from the old locations to the new ones.

``dpkg`` is a suite of programs for creating binary package files and
installing and removing them on Unix systems.  [119]_

The binary packages are designed for the management of installed
executable programs (usually compiled binaries) and their associated
data, though source code examples and documentation are provided as part
of some packages.

This manual describes the technical aspects of creating Debian binary
packages (``.deb`` files). It documents the behavior of the package
management programs ``dpkg``, ``dselect`` et al. and the way they
interact with packages.

This manual does not go into detail about the options and usage of the
package building and installation tools. It should therefore be read in
conjunction with those programs' man pages.

The utility programs which are provided with ``dpkg`` not described in
detail here, are documented in their man pages.

It is assumed that the reader is reasonably familiar with the ``dpkg``
System Administrators' manual. Unfortunately this manual does not yet
exist.

The Debian version of the FSF's GNU hello program is provided as an
example for people wishing to create Debian packages. However, while the
examples are helpful, they do not replace the need to read and follow
the Policy and Programmer's Manual.

