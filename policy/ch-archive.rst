The Debian Archive
==================

The Debian system is maintained and distributed as a collection of
*packages*. Since there are so many of them (currently well over 15000),
they are split into *sections* and given *priorities* to simplify the
handling of them.

The effort of the Debian project is to build a free operating system,
but not every package we want to make accessible is *free* in our sense
(see the Debian Free Software Guidelines, below), or may be
imported/exported without restrictions. Thus, the archive is split into
areas  [#]_ based on their licenses and other restrictions.

The aims of this are:

-  to allow us to make as much software available as we can

-  to allow us to encourage everyone to write free software, and

-  to allow us to make it easy for people to produce CD-ROMs of our
   system without violating any licenses, import/export restrictions, or
   any other laws.

The *main* archive area forms the *Debian distribution*.

Packages in the other archive areas (``contrib``, ``non-free``) are not
considered to be part of the Debian distribution, although we support
their use and provide infrastructure for them (such as our bug-tracking
system and mailing lists). This Debian Policy Manual applies to these
packages as well.

.. _s-dfsg:

The Debian Free Software Guidelines
-----------------------------------

The Debian Free Software Guidelines (DFSG) form our definition of "free
software". These are:

1. Free Redistribution
    The license of a Debian component may not restrict any party from
    selling or giving away the software as a component of an aggregate
    software distribution containing programs from several different
    sources. The license may not require a royalty or other fee for such
    sale.

2. Source Code
    The program must include source code, and must allow distribution in
    source code as well as compiled form.

3. Derived Works
    The license must allow modifications and derived works, and must
    allow them to be distributed under the same terms as the license of
    the original software.

4. Integrity of The Author's Source Code
    The license may restrict source-code from being distributed in
    modified form *only* if the license allows the distribution of
    "patch files" with the source code for the purpose of modifying the
    program at build time. The license must explicitly permit
    distribution of software built from modified source code. The
    license may require derived works to carry a different name or
    version number from the original software. (This is a compromise.
    The Debian Project encourages all authors to not restrict any files,
    source or binary, from being modified.)

5. No Discrimination Against Persons or Groups
    The license must not discriminate against any person or group of
    persons.

6. No Discrimination Against Fields of Endeavor
    The license must not restrict anyone from making use of the program
    in a specific field of endeavor. For example, it may not restrict
    the program from being used in a business, or from being used for
    genetic research.

7. Distribution of License
    The rights attached to the program must apply to all to whom the
    program is redistributed without the need for execution of an
    additional license by those parties.

8. License Must Not Be Specific to Debian
    The rights attached to the program must not depend on the program's
    being part of a Debian system. If the program is extracted from
    Debian and used or distributed without Debian but otherwise within
    the terms of the program's license, all parties to whom the program
    is redistributed must have the same rights as those that are granted
    in conjunction with the Debian system.

9. License Must Not Contaminate Other Software
    The license must not place restrictions on other software that is
    distributed along with the licensed software. For example, the
    license must not insist that all other programs distributed on the
    same medium must be free software.

10. Example Licenses
    The "GPL," "BSD," and "Artistic" licenses are examples of licenses
    that we consider *free*.

.. _s-sections:

Archive areas
-------------

.. _s-main:

The main archive area
~~~~~~~~~~~~~~~~~~~~~

The *main* archive area comprises the Debian distribution. Only the
packages in this area are considered part of the distribution. None of
the packages in the *main* archive area require software outside of that
area to function. Anyone may use, share, modify and redistribute the
packages in this archive area freely [#]_.

Every package in *main* must comply with the DFSG (Debian Free Software
Guidelines).  [#]_

In addition, the packages in *main*

- must not require or recommend a package outside of *main* for
  compilation or execution (thus, the package must not declare a
  ``Pre-Depends``, ``Depends``, ``Recommends``, ``Build-Depends``,
  ``Build-Depends-Indep``, or ``Build-Depends-Arch`` relationship on a
  non-*main* package unless that package is only listed as a non-default
  alternative for a package in *main*),

- must not be so buggy that we refuse to support them, and

- must meet all policy requirements presented in this manual.

.. _s-contrib:

The contrib archive area
~~~~~~~~~~~~~~~~~~~~~~~~

The *contrib* archive area contains supplemental packages intended to
work with the Debian distribution, but which require software outside of
the distribution to either build or function.

Every package in *contrib* must comply with the DFSG.

In addition, the packages in *contrib*

-  must not be so buggy that we refuse to support them, and

-  must meet all policy requirements presented in this manual.

Examples of packages which would be included in *contrib* are:

-  free packages which require *contrib*, *non-free* packages or
   packages which are not in our archive at all for compilation or
   execution, and

-  wrapper packages or other sorts of free accessories for non-free
   programs.

.. _s-non-free:

The non-free archive area
~~~~~~~~~~~~~~~~~~~~~~~~~

The *non-free* archive area contains supplemental packages intended to
work with the Debian distribution that do not comply with the DFSG or
have other problems that make their distribution problematic. They may
not comply with all of the policy requirements in this manual due to
restrictions on modifications or other limitations.

Packages must be placed in *non-free* if they are not compliant with the
DFSG or are encumbered by patents or other legal issues that make their
distribution problematic.

In addition, the packages in *non-free*

-  must not be so buggy that we refuse to support them, and

-  must meet all policy requirements presented in this manual that it is
   possible for them to meet.  [#]_

.. _s-pkgcopyright:

Copyright considerations
------------------------

Every package must be accompanied by a verbatim copy of its copyright
information and distribution license in the file
``/usr/share/doc/package/copyright`` (see
:ref:`s-copyrightfile` for further details).

We reserve the right to restrict files from being included anywhere in
our archives if

-  their use or distribution would break a law,

-  there is an ethical conflict in their distribution or use,

-  we would have to sign a license for them, or

-  their distribution would conflict with other project policies.

Programs whose authors encourage the user to make donations are fine for
the main distribution, provided that the authors do not claim that not
donating is immoral, unethical, illegal or something similar; in such a
case they must go in *non-free*.

Packages whose copyright permission notices (or patent problems) do not
even allow redistribution of binaries only, and where no special
permission has been obtained, must not be placed on the Debian FTP site
and its mirrors at all.

Note that under international copyright law (this applies in the United
States, too), *no* distribution or modification of a work is allowed
without an explicit notice saying so. Therefore a program without a
copyright notice *is* copyrighted and you may not do anything to it
without risking being sued! Likewise if a program has a copyright notice
but no statement saying what is permitted then nothing is permitted.

Many authors are unaware of the problems that restrictive copyrights (or
lack of copyright notices) can cause for the users of their
supposedly-free software. It is often worthwhile contacting such authors
diplomatically to ask them to modify their license terms. However, this
can be a politically difficult thing to do and you should ask for advice
on the ``debian-legal`` mailing list first, as explained below.

When in doubt about a copyright, send mail to
debian-legal@lists.debian.org. Be prepared to provide us with the
copyright statement. Software covered by the GPL, public domain software
and BSD-like copyrights are safe; be wary of the phrases "commercial use
prohibited" and "distribution restricted".

.. _s-subsections:

Sections
--------

The packages in the archive areas *main*, *contrib* and *non-free* are
grouped further into *sections* to simplify handling.

The archive area and section for each package should be specified in the
package's ``Section`` control record (see
:ref:`s-f-Section`). However, the maintainer of the
Debian archive may override this selection to ensure the consistency of
the Debian distribution. The ``Section`` field should be of the form:

-  *section* if the package is in the *main* archive area,

-  *area/section* if the package is in the *contrib* or *non-free*
   archive areas.

The Debian archive maintainers provide the authoritative list of
sections. At present, they are: admin, cli-mono, comm, database, debug,
devel, doc, editors, education, electronics, embedded, fonts, games,
gnome, gnu-r, gnustep, graphics, hamradio, haskell, httpd, interpreters,
introspection, java, javascript, kde, kernel, libdevel, libs, lisp,
localization, mail, math, metapackages, misc, net, news, ocaml, oldlibs,
otherosfs, perl, php, python, ruby, rust, science, shells, sound, tasks,
tex, text, utils, vcs, video, web, x11, xfce, zope. The additional
section *debian-installer* contains special packages used by the
installer and is not used for normal Debian packages.

For more information about the sections and their definitions, see the
`list of sections in
unstable <https://packages.debian.org/unstable/>`_.

.. _s-priorities:

Priorities
----------

Each package must have a *priority* value, which is set in the metadata
for the Debian archive and is also included in the package's control
files (see :ref:`s-f-Priority`). This information is used
to control which packages are included in standard or minimal Debian
installations.

Most Debian packages will have a priority of ``optional``. Priority
levels other than ``optional`` are only used for packages that should be
included by default in a standard installation of Debian.

The priority of a package is determined solely by the functionality it
provides directly to the user. The priority of a package should not be
increased merely because another higher-priority package depends on it;
instead, the tools used to construct Debian installations will correctly
handle package dependencies. In particular, this means that C-like
libraries will almost never have a priority above ``optional``, since
they do not provide functionality directly to users. However, as an
exception, the maintainers of Debian installers may request an increase
of the priority of a package to resolve installation issues and ensure
that the correct set of packages is included in a standard or minimal
install.

The following *priority levels* are recognized by the Debian package
management tools.

``required``
    Packages which are necessary for the proper functioning of the
    system (usually, this means that dpkg functionality depends on these
    packages). Removing a ``required`` package may cause your system to
    become totally broken and you may not even be able to use ``dpkg``
    to put things back, so only do so if you know what you are doing.

    Systems with only the ``required`` packages installed have at least
    enough functionality for the sysadmin to boot the system and install
    more software.

``important``
    Important programs, including those which one would expect to find
    on any Unix-like system. If the expectation is that an experienced
    Unix person who found it missing would say "What on earth is going
    on, where is ``foo``?", it must be an ``important`` package.  [#]_
    Other packages without which the system will not run well or be
    usable must also have priority ``important``. This does *not*
    include Emacs, the X Window System, TeX or any other large
    applications. The ``important`` packages are just a bare minimum of
    commonly-expected and necessary tools.

``standard``
    These packages provide a reasonably small but not too limited
    character-mode system. This is what will be installed by default if
    the user doesn't select anything else. It doesn't include many large
    applications.

    No two packages that both have a priority of ``standard`` or higher
    may conflict with each other.

``optional``
    This is the default priority for the majority of the archive. Unless
    a package should be installed by default on standard Debian systems,
    it should have a priority of ``optional``. Packages with a priority
    of ``optional`` may conflict with each other.

``extra``
    *This priority is deprecated.* Use the ``optional`` priority
    instead. This priority should be treated as equivalent to
    ``optional``.

    The ``extra`` priority was previously used for packages that
    conflicted with other packages and packages that were only likely to
    be useful to people with specialized requirements. However, this
    distinction was somewhat arbitrary, not consistently followed, and
    not useful enough to warrant the maintenance effort.

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
