Format: complete
Css: README.css
Title: Debian Policy
Author: Manoj Srivastava and Russ Allbery
Email: debian-policy@packages.debian.org
Link Home: http://wiki.debian.org/Teams/Policy
Link Up: http://www.debian.org/

# Debian Policy

## Infrastructure

+ Website:: <http://www.debian.org/doc/devel-manuals#policy>
+ Mailing list:: <debian-policy@lists.debian.org> lists
+ Source Code::
  * git clone git://anonscm.debian.org/dbnpolicy/policy.git
  * Browser: <http://anonscm.debian.org/gitweb/?p=dbnpolicy/policy.git>
+ Unix group:: dbnpolicy
+ Alioth Project:: <http://alioth.debian.org/projects/dbnpolicy> (exists
  to manage the repository but not otherwise used)

### Interacting with the team

+ Email contact:: <debian-policy@lists.debian.org>
+ Request tracker:: <http://bugs.debian.org/src:debian-policy>

Debian Policy uses a formal procedure and a set of user tags to manage
the lifecycle of change proposals. For definitions of those tags and
proposal states and information about what the next step is for each
phase, see [Policy changes process](./Process.md).

Once the wording for a change has been finalized, please send a patch
against the current Git master branch to the bug report, if you're not
familiar with Git, the following commands are the basic process:


    git clone git://anonscm.debian.org/dbnpolicy/policy.git
    git checkout -b <local-branch-name>

    # edit files, but don't make changes to upgrading-checklist or debian/changelog
    git add <files>
    git commit
    # repeat as necessary

    # update your branch against the current master
    git checkout master
    git pull

    git checkout master
    git merge --no-commit <local-branch-name>
    git reset --hard HEAD;
    git checkout <local-branch-name>;

    # If there are changes in master that make the branch not apply cleanly,
    # there should have been en error during the merge step above. If there
    # was an error, merge the master branch into the local branch, fix the
    # conflicts, and commit the new version of the local branch.
     : git merge master
    # Edit files to remove conflict
     : git commit -s

    # Checkout the local branch, to create the patch to send to the policy
    git checkout <local-branch-name>
    dir=$(mktemp -d)
    git format-patch -o $dir -s master
    # check out the patches created in $dir
    git send-email --from "you <your@email>"             \
                   --to debian-policy@lists.debian.org   \
                   $dir/

&lt;local-branch-name&gt; is some convenient name designating your local
changes. You may want to use some common prefix like local-. You can
use git format-patch and git send-email if you want, but usually it's
overkill.

## Usual Roles

The Debian Policy team are official project delegates (see the DPL
delegation). All of the Policy team members do basically the same
work: shepherd proposals, propose wording, and merge changes when
consensus has been reached. The current delegates are:

+ Andreas Barth (aba)
+ Bill Allombert (ballombe)
+ Jonathan Nieder (jrnieder)
+ Russ Allbery (rra)

## Task description

The Debian Policy team is responsible for maintaining and coordinating
updates to the Debian Policy Manual and all the other policy documents
released as part of the "debian-policy" package.

The Debian Policy Editors:

+ Guide the work on the Debian Policy Manual and related documents as a
  collaborative process where developers review and second or object to
  proposals, usually on the debian-policy mailing list.
+ Count seconds and weight objections to proposals, to determine whether
  they have reached sufficient consensus to be included, and accept
  consensual proposals.
+ Reject or refer to the Technical Committee proposals that fail to
  reach consensus.
+ Commit changes to the version control system repository used to
  maintain the Debian Policy Manual and related documents.
+ Maintain the "debian-policy" package. As package maintainers, they
  have the last word on package content, releases, bug reports, etc.

Everything else can be done by anyone, or any DD (depending on the
outcome of the discussion about seconding). We explicitly want any
Debian DD to review and second or object to proposals. The more
participation, the better. Many other people are active on the Policy
mailing list without being project delegates.

In addition to the main technical manual, the team currently also maintains:

+ [Machine-readable debian/copyright format](http://www.debian.org/doc/packaging-manuals/copyright-format/1.0/)
+ [Debian Menu sub-policy](http://www.debian.org/doc/packaging-manuals/menu-policy/)
+ [Debian Perl Policy](http://www.debian.org/doc/packaging-manuals/perl-policy/)
+ [Debconf Specification](http://www.debian.org/doc/packaging-manuals/debconf_specification.html)
+ [Authoritative list of virtual package names ](http://www.debian.org/doc/packaging-manuals/virtual-package-names-list.txt)

These documents are maintained using the [Policy changes process](./Process.md), and
the current state of all change proposals is tracked using the
[debian-policy BTS](http://bugs.debian.org/src:debian-policy).

## Get involved

The best way to help is to review the [current open bugs](http://bugs.debian.org/src:debian-policy),
pick a bug that no one is currently shepherding (ask on
[debian-policy@lists.debian.org](mailto:debian-policy@lists.debian.org) if
you're not sure if a particular bug
is being shepherded), and help it through the change process. This
will involve guiding the discussion, seeking additional input
(particularly from experts in the area being discussed), possibly
raising the issue on other mailing lists, proposing or getting other
people to propose specific wording changes, and writing diffs against
the current Policy document. All of the steps of [Policy changes process](./Process.md)
can be done by people other than Policy team members except
the final acceptance steps and almost every change can be worked on
independently, so there's a lot of opportunity for people to help.

There are also some other, larger projects:

+ Policy is currently maintained in DebianDoc-SGML, which is no longer
  very actively maintained and isn't a widely used or understood
  format. The most logical replacement would be DocBook. However,
  DocBook is a huge language with many tags and options, making it
  rather overwhelming. We badly need someone with DocBook experience
  to write a style guide specifying exactly which tags should be used
  and what they should be used for so that we can limit ourselves to
  an easy-to-understand and documented subset of the language.
+ Policy contains several appendices which are really documentation of
  how parts of the dpkg system works rather than technical
  Policy. Those appendices should be removed from the Policy document
  and maintained elsewhere, probably as part of dpkg, and any Policy
  statements in them moved into the main document. This project will
  require reviewing the current contents of the appendices and feeding
  the useful bits that aren't currently documented back to the dpkg
  team as documentation patches.
+ Policy has grown organically over the years and suffers from
  organizational issues because of it. It also doesn't make use of the
  abilities that a current XML language might give us, such as being
  able to extract useful portions of the document (all **must**
  directives, for example). There has been quite a bit of discussion
  of a new format that would allow for this, probably as part of
  switching to DocBook, but as yet such a reorganization and reworking
  has not been started.

If you want to work on any of these projects, please mail
[debian-policy@lists.debian.org](mailto:debian-policy@lists.debian.org)
for more information. We'll be happy to help you get started.

## Maintenance procedures

### Repository layout

The Git repository used for Debian Policy has the following branches:

+ master:: the current accepted changes that will be in the next release
+ bug&lt;number&gt;-&lt;user&gt;:: changes addressing bug &lt;number&gt;,
  shepherded by &lt;user&gt;
+ rra:: old history of Russ's arch repository, now frozen
+ srivasta:: old history of Manoj's arch repository

### Managing a bug

The process used by Policy team members to manage a bug, once there is
proposed wording, is:

+ Create a bug&lt;number&gt;-&lt;user&gt; branch for the bug, where
  &lt;number&gt; is the bug number in the BTS and &lt;user&gt;is a
  designator of the Policy team member who is shepherding the bug.
+ Commit wording changes in that branch until consensus is
  achieved. Do not modify debian/changelog or upgrading-checklist.html
  during this phase. Use the BTS to track who proposed the wording and
  who seconded it.
+ git pull master to make sure you have the latest version.
+ Once the change has been approved by enough people, git merge the
  branch into master immediately after making the final commit adding
  the changelog entry to minimize conflicts.
+ add the debian/changelog and upgrading-checklist.html changes, and
  commit to master.
+ Push master out so other people may merge in their own bug branches
  without conflicts.
+ Tag the bug as pending and remove other process tags.
+ Delete the now-merged branch.

The Git commands used for this workflow are:

    git checkout -b bug12345-rra master
    # edit files
    # git add files
    git commit
    git push origin bug12345-rra
    # iterate until good
    # update your local master branch
    git checkout master
    git pull

    git checkout master
    git merge --no-commit bug12345-rra
    git reset --hard HEAD;

    # If there are changes in master that make the branch not apply cleanly,
    # there should have been en error during the merge step above. If there
    # was an error, merge the master branch into the local branch, fix the
    # conflicts, and commit the new version of the local branch.
     : git checkout bug12345-rra
     : git merge master
    # Edit files to remove conflict
     : git commit -s

    git checkout master
    git merge bug12345-rra
    # edit debian/changelog and upgrading-checklist.html
    git add debian/changelog upgrading-checklist.html
    git commit
    git push origin master
    git branch -d bug12345-rra
    git push origin :bug12345-rra

For the debian/changelog entry, use the following format:

    * <document>: <brief change description>
      Wording: <author of wording>
      Seconded: <seconder>
      Seconded: <seconder>
      Closes: <bug numbers>

For example:

    * Policy: better document version ranking and empty Debian revisions
      Wording: Russ Allbery <rra@debian.org>
      Seconded: Raphaël Hertzog <hertzog@debian.org>
      Seconded: Manoj Srivastava <srivasta@debian.org>
      Seconded: Guillem Jover <guillem@debian.org>
      Closes: #186700, #458910

### Updating branches

After commits to master have been pushed, either by you or by another
Policy team member, you will generally want to update your working bug
branches. The equivalent of the following commands should do that:

    for i in `git show-ref --heads | awk '{print $2}'`; do
        j=$(basename $i)
        if [ "$j" != "master" ]; then
            git checkout $j && git merge master
        fi
    done
    git push --all origin

assuming that you haven't packed the refs in your repository.

### Making a release

For a final Policy release, change UNRELEASED to unstable in
debian/changelog and update the timestamp to match the final release
time (dch -r may be helpful for this), update the release date in
upgrading-checklist.html, update Standards-Version in debian/control,
and commit that change. Then do the final release build and make sure
that it builds and installs.

Then, tag the repository and push the final changes to Alioth:

    git tag -s v3.8.0.0
    git push origin
    git push --tags origin

replacing the version number with the version of the release, of course.

Finally, announce the new Policy release on debian-devel-announce,
including in the announcement the upgrading-checklist section for the
new release.

### Setting release goals

Policy has a large bug backlog, and each bug against Policy tends to
take considerable time and discussion to resolve. I've found it
useful, when trying to find a place to start, to pick a manageable set
of bugs and set as a target resolving them completely before the next
Policy release. Resolving a bug means one of the following:

+ Proposing new language to address the bug that's seconded and approved by
  the readers of the Policy list following the [Policy changes process](./Progress.md)
  (or that's accepted by one of the Policy delegates if the change isn't
  normative; i.e., doesn't change the technical meaning of the document).
+ Determining that the bug is not relevant to Policy and closing it.
+ Determining that either there is no consensus that the bug indicates
  a problem, that the solutions that we can currently come up with are
  good solutions, or that Debian is ready for the change. These bugs
  are tagged wontfix and then closed after a while. A lot of Policy
  bugs fall into this category; just because it would be useful to
  have a policy in some area doesn't mean that we're ready to make
  one, and keeping the bugs open against Policy makes it difficult to
  tell what requires work. If the problem is worth writing a policy
  for, it will come up again later when hopefully the project
  consensus is more mature.

Anyone can pick bugs and work resolve them. The final determination to
accept a wording change or reject a bug will be made by a Policy
delegate, but if a patch is already written and seconded, or if a
summary of why a bug is not ready to be acted on is already written,
the work is much easier for the Policy delegate.

One of the best ways to help out is to pick one or two bugs (checking
on the Policy list first), say that you'll make resolving them a goal
for the next release, and guide the discussion until the bugs can
reach one of the resolution states above.
