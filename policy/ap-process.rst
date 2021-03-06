Debian Policy changes process
=============================

.. _process-introduction:

Introduction
------------

To introduce a change in the current Debian Policy, the change proposal
has to go through a certain process.  [#]_

.. _process-change-goals:

Change Goals
------------

-  The change should be technically correct, and consistent with the
   rest of the policy document. This means no legislating the value of
   π. This also means that the proposed solution be known to work;
   iterative design processes do not belong in policy.

-  The change should not be too disruptive; if very many packages become
   instantly buggy, then instead there should be a transition plan.
   Exceptions should be rare (only if the current state is really
   untenable), and probably blessed by the TC.

-  The change has to be reviewed in depth, in the open, where any one
   may contribute; a publicly accessible, archived, open mailing list.

-  Proposal should be addressed in a timely fashion.

-  Any domain experts should be consulted, since not every policy
   mailing list subscriber is an expert on everything, including policy
   maintainers.

-  The goal is rough consensus on the change, which should not be hard
   if the matter is technical. Technical issues where there is no
   agreement should be referred to the TC; non-technical issues should
   be referred to the whole developer body, and perhaps general
   resolutions lie down that path.

-  Package maintainers whose packages may be impacted should have access
   to policy change proposals, even if they do not subscribe to policy
   mailing lists (policy gazette?).

.. _process-current:

Current Process
---------------

Each suggested change goes through different states. These states are
denoted through either usertags of the
debian-policy@packages.debian.org user or, for ``moreinfo``,
``patch``, ``pending``, and ``wontfix``, regular tags.

`Current list of
bugs <https://bugs.debian.org/cgi-bin/pkgreport.cgi?src=debian-policy&pend-exc=done>`_

The Policy delegates are responsible for managing the tags on bugs and
will update tags as new bugs are submitted or as activity happens on
bugs. All Debian Developers should feel free to add the seconded tag as
described below. Other tags should be changed with the coordination of
the Policy Team.

.. _state-a-moreinfo:

State A: More information required
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The Policy delegates are unable to determine whether the bug is really
a Policy matter, or judge that there are missing details that would
prevent a fruitful discussion (and may result in a confused and
unhelpful discussion).

Policy delegates ask the original submitter to provide the missing
details.  Others are asked to refrain from discussing whatever they
take the issue to be, limiting their postings to attempts to supply
the missing details.

`TAG: moreinfo <https://bugs.debian.org/cgi-bin/pkgreport.cgi?src=debian-policy&pend-exc=done&tag=moreinfo>`_

What needs to happen next: Submitter (or someone else) provides the
requested information within 30 days, or the bug is closed.

The majority of bugs will skip this stage.

.. _state-b-discussion:

State B: Discussion
~~~~~~~~~~~~~~~~~~~

Discuss remedy. Alternate proposals. Discussion guided by delegates.
There should be a clear time limit to this stage, but as yet we have not
set one.

`TAG: discussion
<https://bugs.debian.org/cgi-bin/pkgreport.cgi?src=debian-policy&pend-exc=done&tag=discussion>`_

What needs to happen next: Reach a conclusion and consensus in the
discussion and make a final proposal for what should be changed (if
anything), moving to the proposal tag.

.. _state-c-proposal:

State C: Proposal
~~~~~~~~~~~~~~~~~

A final proposal has emerged from the discussion, and there is a rough
consensus on how to proceed to resolve the issue.

`TAG: proposal
<https://bugs.debian.org/cgi-bin/pkgreport.cgi?src=debian-policy&pend-exc=done&tag=proposal>`_

What needs to happen next: Provided that the rough consensus persists,
develop a patch against the current Policy document with specific
wording of the change. Often this is done in conjunction with the
proposal, in which case one may skip this step and move directly to
patch tag.

.. _state-d-wording-proposed:

State D: Wording proposed
~~~~~~~~~~~~~~~~~~~~~~~~~

A patch against the Policy document reflecting the consensus has been
created and is waiting for formal seconds. The standard patch tag is
used for this state, since it's essentially equivalent to the standard
meaning of that tag.

`TAG: patch
<https://bugs.debian.org/cgi-bin/pkgreport.cgi?src=debian-policy&pend-exc=done&tag=patch>`_

What needs to happen next: The proposal needs to be reviewed and
seconded. Any Debian developer who agrees with the change and the
conclusion of rough consensus from the discussion should say so in the
bug log by seconding the proposal.

.. _state-e-seconded:

State E: Seconded
~~~~~~~~~~~~~~~~~

The proposal is signed off on by N Debian Developers. To start with,
we're going with N=3, meaning that if three Debian Developers agree, not
just with the proposal but with the conclusion that it reflects
consensus and addresses the original issue -- it is considered eligible
for inclusion in the next version of Policy. Since Policy is partly a
technical project governance method, one must be a Debian Developer to
formally second, although review and discussion is welcome from anyone.
Once this tag has been applied, the bug is waiting for a Policy team
member to apply the patch to the package repository.

`TAG: seconded
<https://bugs.debian.org/cgi-bin/pkgreport.cgi?src=debian-policy&pend-exc=done&tag=seconded>`_

What needs to happen next: A Policy maintainer does the final review and
confirmation, and then applies the patch for the next Policy release.

This tag is not used very much because normally a Policy maintainer
applies the patch and moves the proposal to the next state once enough
seconds are reached.

.. _state-f-accepted:

State F: Accepted
~~~~~~~~~~~~~~~~~

Change accepted, will be in next upload. The standard pending tag is
used for this state since it matches the regular meaning of pending.

`TAG: pending
<https://bugs.debian.org/cgi-bin/pkgreport.cgi?src=debian-policy&pend-exc=done&tag=pending>`_

What needs to happen next: The bug is now in the waiting queue for the
next Policy release, and there's nothing left to do except for upload a
new version of Policy.

.. _state-g-reject:

State G: Reject
~~~~~~~~~~~~~~~

Rejected proposals. The standard wontfix is used for this state.
Normally, bugs in this state will not remain open; instead, a Policy
team member will close them with an explanation. The submitter may then
appeal to the tech-ctte if they so desire. Alternately, issues appealed
to the tech-ctte may remain open with this tag while that appeal
proceeds.

`TAG: wontfix
<https://bugs.debian.org/cgi-bin/pkgreport.cgi?src=debian-policy&pend-exc=done&tag=rejected>`_

We may use one of the following tags here, but to date we have only used
dubious and ctte. It's not clear whether we need more tags for this
stage.

**dubious**
    Not a policy matter

**ctte**
    Referred to the Technical Committee (tech-ctte)

**devel**
    Referred to the developer body

**delegate**
    Rejected by a Policy delegate

**obsolete**
    The proposal timed out without a conclusion

What needs to happen next: The bug should be closed once a final
resolution is reached, or retagged to an appropriate state if that final
resolution reverses the decision to reject the proposal.

.. _process-other-tags:

Other Tags
----------

All Policy bugs are additionally categorized by class of bug.

The normative tag is used for bugs that make normative changes to
Policy, meaning that the dictates of Policy will change in some fashion
as part of the resolution of the bug if the proposal is accepted. The
full process is followed for such bugs.

`TAG: normative
<https://bugs.debian.org/cgi-bin/pkgreport.cgi?src=debian-policy&pend-exc=done&tag=normative>`_

The informative tag is used for bugs about wording issues, typos,
informative footnotes, or other changes that do not affect the formal
dictates of Policy, just the presentation. The same tags are used for
these bugs for convenience, but the Policy maintainers may make
informative changes without following the full process. Informative bugs
fall under their discretion.

`TAG: informative
<https://bugs.debian.org/cgi-bin/pkgreport.cgi?src=debian-policy&pend-exc=done&tag=informative>`_

The packaging tag is used for bugs about the packaging and build process
of the debian-policy Debian package. These bugs do not follow the normal
process and will not have the other tags except for pending and wontfix
(used with their normal meanings).

`TAG: packaging
<https://bugs.debian.org/cgi-bin/pkgreport.cgi?src=debian-policy&pend-exc=done&tag=packaging>`_

.. [#]
   This process was originally developed by Margarita Manterola, Clint
   Adams, Russ Allbery and Manoj Srivastava.  In 2017, Sean Whitton
   deprecated the 'issue' usertag and added use of the 'moreinfo' tag,
   after discussions at DebConf17.
