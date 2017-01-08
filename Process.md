Format: complete
Title: Debian Policy changes process
Author: Margarita Manterola, Clint Adams, Russ Allbery, and Manoj Srivastava
Email: debian-policy@packages.debian.org
Link Home: http://wiki.debian.org/Teams/Policy
Link Up: http://www.debian.org/
XHTML Header: <style type="text/css">h1 { text-align: center; }</style>

# Debian Policy changes process

To introduce a change in the current DebianPolicy, the change proposal
has to go through a certain process.

## Change Goals

+ The change should be technically correct, and consistent with the
  rest of the policy document. This means no legislating the value of
  π. This also means that the proposed solution be known to work;
  iterative design processes do not belong in policy.
+ The change should not be too disruptive; if very many packages
  become instantly buggy, then instead there should be a transition
  plan. Exceptions should be rare (only if the current state is really
  untenable), and probably blessed by the TC.
+ The change has to be reviewed in depth, in the open, where any one
  may contribute; a publicly accessible, archived, open mailing list.
+ Proposal should be addressed in a timely fashion.
+ Any domain experts should be consulted, since not every policy
  mailing list subscriber is an expert on everything, including policy
  maintainers.
+ The goal is rough consensus on the change, which should not be hard
  if the matter is technical. Technical issues where there is no
  agreement should be referred to the TC; non-technical issues should
  be referred to the whole developer body, and perhaps general
  resolutions lie down that path.
+ Package maintainers whose packages may be impacted should have
  access to policy change proposals, even if they do not subscribe to
  policy mailing lists (policy gazette?).

## Current Process

Each suggested change goes through different states. These states are
denoted through either usertags of the
[debian-policy@packages.debian.org](mailto:debian-policy@packages.debian.org)
user or, for patch, pending, and wontfix, regular tags.

[Current list of bugs](http://bugs.debian.org/cgi-bin/pkgreport.cgi?src=debian-policy&pend-exc=done)

The Policy delegates are responsible for managing the tags on bugs and
will update tags as new bugs are submitted or as activity happens on
bugs. All Debian Developers should feel free to add the seconded tag
as described below. Other tags should be changed with the coordination
of the Policy Team.

### State A: Issue raised

Detect need, like gaps/flaws in current policy, or a new rule should
be added. Any user or developer may start this step. There is a
decision point here, not all issues are in scope of policy.
[TAG: issue](http://bugs.debian.org/cgi-bin/pkgreport.cgi?src=debian-policy&tag=issue)

What needs to happen next: If this is in scope for Policy, discuss the
issue and possible solutions, moving to the discussion tag, or if the
matter is sufficiently clear, go directly to a proposal for how to
address it, moving to the proposal tag. If this is not in scope for
Policy, close the bug.

### State B: Discussion

Discuss remedy. Alternate proposals. Discussion guided by
delegates. There should be a clear time limit to this stage, but as
yet we have not set one.
[TAG: discussion](http://bugs.debian.org/cgi-bin/pkgreport.cgi?src=debian-policy&pend-exc=done&tag=discussion)

What needs to happen next: Reach a conclusion and consensus in the
discussion and make a final proposal for what should be changed (if
anything), moving to the proposal tag.

### State C: Proposal

A final proposal has emerged from the discussion, and there is a rough
consensus on how to proceed to resolve the issue.
[TAG: proposal](http://bugs.debian.org/cgi-bin/pkgreport.cgi?src=debian-policy&pend-exc=done&tag=proposal)

What needs to happen next: Provided that the rough consensus persists,
develop a patch against the current Policy document with specific
wording of the change. Often this is done in conjunction with the
proposal, in which case one may skip this step and move directly to
patch tag.

### State D: Wording proposed

A patch against the Policy document reflecting the consensus has been
created and is waiting for formal seconds. The standard patch tag is
used for this state, since it's essentially equivalent to the standard
meaning of that tag.
[TAG: patch](http://bugs.debian.org/cgi-bin/pkgreport.cgi?src=debian-policy&pend-exc=done&tag=patch)

What needs to happen next: The proposal needs to be reviewed and
seconded. Any Debian developer who agrees with the change and the
conclusion of rough consensus from the discussion should say so in the
bug log by seconding the proposal.

### State E: Seconded

The proposal is signed off on by N Debian Developers. To start with,
we're going with N=3, meaning that if three Debian Developers agree,
not just with the proposal but with the conclusion that it reflects
consensus and addresses the original issue -- it is considered
eligible for inclusion in the next version of Policy. Since Policy is
partly a technical project governance method, one must be a Debian
Developer to formally second, although review and discussion is
welcome from anyone. Once this tag has been applied, the bug is
waiting for a Policy team member to apply the patch to the package
repository.
[TAG: seconded](http://bugs.debian.org/cgi-bin/pkgreport.cgi?src=debian-policy&pend-exc=done&tag=seconded)

What needs to happen next: A Policy maintainer does the final review
and confirmation, and then applies the patch for the next Policy
release.

This tag is not used very much because normally a Policy maintainer
applies the patch and moves the proposal to the next state once enough
seconds are reached.

### State F: Accepted

Change accepted, will be in next upload. The standard pending tag is
used for this state since it matches the regular meaning of
pending.
[TAG: pending](http://bugs.debian.org/cgi-bin/pkgreport.cgi?src=debian-policy&pend-exc=done&tag=pending)

What needs to happen next: The bug is now in the waiting queue for the
next Policy release, and there's nothing left to do except for upload
a new version of Policy.

### State G: Reject

Rejected proposals. The standard wontfix is used for this
state. Normally, bugs in this state will not remain open; instead, a
Policy team member will close them with an explanation. The submitter
may then appeal to the tech-ctte if they so desire. Alternately,
issues appealed to the tech-ctte may remain open with this tag while
that appeal proceeds.
[TAG: wontfix](http://bugs.debian.org/cgi-bin/pkgreport.cgi?src=debian-policy&pend-exc=done&tag=rejected)

We may use one of the following tags here, but to date we have only
used dubious and ctte. It's not clear whether we need more tags for
this tage.

**dubious**
:   Not a policy matter

**ctte**
:   Referred to the Technical Committee (tech-ctte)

**devel**
:   Referred to the developer body

**delegate**
:   Rejected by a Policy delegate

**obsolete**
:   The proposal timed out without a conclusion

What needs to happen next: The bug should be closed once a final
resolution is reached, or retagged to an appropriate state if that
final resolution reverses the decision to reject the proposal.

## Other Tags

All Policy bugs are additionally categorized by class of bug.

The normative tag is used for bugs that make normative changes to
Policy, meaning that the dictates of Policy will change in some
fashion as part of the resolution of the bug if the proposal is
accepted. The full process is followed for such bugs.
[TAG: normative](http://bugs.debian.org/cgi-bin/pkgreport.cgi?src=debian-policy&pend-exc=done&tag=normative)

The informative tag is used for bugs about wording issues, typos,
informative footnotes, or other changes that do not affect the formal
dictates of Policy, just the presentation. The same tags are used for
these bugs for convenience, but the Policy maintainers may make
informative changes without following the full process. Informative
bugs fall under their discretion.
[TAG: informative](http://bugs.debian.org/cgi-bin/pkgreport.cgi?src=debian-policy&pend-exc=done&tag=informative)

The packaging tag is used for bugs about the packaging and build
process of the debian-policy Debian package. These bugs do not follow
the normal process and will not have the other tags except for pending
and wontfix (used with their normal meanings).
[TAG: packaging](http://bugs.debian.org/cgi-bin/pkgreport.cgi?src=debian-policy&pend-exc=done&tag=packaging)
