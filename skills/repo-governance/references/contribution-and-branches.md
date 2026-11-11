# Branches and contribution gates

A change needs a home before it needs a diff. Two long-lived branches fail in a
predictable way: a feature is opened against the stable line, a fix is opened
against the next line, and the review then verifies a tree nobody ships. The
gates below make the branch, the change kind and the record decide each other.

Adapted from Vue's contribution guide
(`vuejs/core/.github/contributing.md`) and commit convention
(`vuejs/core/.github/commit-convention.md`). Vue's rules are written for outside
contributors; here they apply to an agent as the contributor. The
cherry-pick-forward rule and the owner-edit re-verification rule are this
skill's policy for a two-branch agent repository, not Vue's.

## The branch model

| Branch | Holds | Receives |
| --- | --- | --- |
| `main` | the stable line: what installs and ships | fixes, chores, docs, tests, refactors with a measured reason |
| `minor` | the next minor: new surface not yet released | features, new options, new API surface, behavior a user will see |
| `major` | the next breaking line, only while breaking work is staged | breaking changes, owner-gated, usually a long-lived branch |

- Patch releases are tagged from `main`. A minor release merges `minor` into
  `main` once, then tags `main`. Nobody tags `minor` directly.
- A fix that lands on `main` and must ship in the minor line is
  **cherry-picked forward**: `git cherry-pick -x <sha>`. Never merge `main`
  into `minor`; that drags unrelated patches and makes the minor line's history
  unreadable.
- A branch that has a fix and a feature on it answers to neither line. Split it.
- Work branches are short-lived and named for the change:
  `fix/<issue>-<slug>`, `feat/<issue>-<slug>`, `docs/<slug>`, `chore/<slug>`.
  Never commit to `main`, `minor` or `major` directly.
- The owner owns the protection on `main`, `minor` and `major`. An agent that
  needs a rule changed asks; it does not edit branch protection or CI.

## Target the branch before you edit

| Change | Branch | If unsure |
| --- | --- | --- |
| Fix for a report, a regression or a red test | `main` | `main`; a fix never waits for a feature release |
| New user-visible behavior, option, flag, API surface | `minor` | ask the owner; a new surface on `main` is a decision, not a default |
| Breaking change, format or contract removal | `major` | stop and ask |
| Docs, tests, build, CI, dependencies, format | `main` | `main` |
| Refactor with a measured reason | `main` | `main`, in its own change |
| Security or credential handling | the line the owner names | stop and ask |

A change that adds surface and fixes a bug is two changes on two branches. If
the fix is what unblocks the feature, land the fix on `main` first and
cherry-pick it forward.

## What is accepted

Vue accepts four kinds of contribution. The same four, with the same refusals:

1. **A bug fix with a clear reproduction.** The reproduction is in a linked
   report or in the change itself. "It looks wrong" is not a report; a fix
   without a reproduction is not a fix.
2. **A widely applicable feature.** It improves most users, not a niche case
   that userland can already solve. The change must be worth its complexity: a
   small feature that spreads across the codebase is not worth it.
3. **A chore.** Typos, comments, build and CI config. Combine several small ones
   into one change rather than opening a stream of them.
4. **A refactor with a measurable reason.** Faster, smaller, or it unblocks a
   named feature.

Refused:

- **Stylistic refactors.** Readability is subjective; the project already chose
  its style. A repo-wide rename or reformat buries the behavior change and makes
  `git log` archaeology impossible. If a formatting rule matters, it belongs in
  the formatter, not in a diff.
- **An unnamed bug.** A change that "fixes something" without a reproduction.
- **Surface with no design note.** Non-trivial new API surface goes through a
  design note first. In this skill that file is
  `docs/plans/<date>-<slug>.md` (or an owner-approved issue), and it names the
  problem, the shape of the API, what is rejected, and the migration story.
  Code first, design later is refused: an API shaped by its implementation is
  expensive to change once users depend on it.
- **A feature and a fix in one commit.** See the branch table.

## Design gate for new surface

Before the first line of code:

- write the note: problem, proposed surface, alternatives rejected, cost,
  compatibility, what happens to saved data;
- name who is affected and how they opt in;
- get the owner's approval recorded in the note;
- then open the branch against `minor`.

A change that touches an existing public contract without changing its shape
does not need a note; it needs the subsystem reference updated in the same
change. A breaking change needs the note **and** the migration section.

## Commit format, and why the changelog is generated

The header is machine-read; the body is for a human. Keep them separate.

```
<type>(<scope>): <subject>

<body: why, and the evidence block>

<footer: close #123 / BREAKING CHANGE: ...>
```

- Types: `feat`, `fix`, `perf`, `docs`, `refactor`, `test`, `build`, `ci`,
  `chore`, `revert`.
- Subject: imperative, present tense, lowercase first letter, no trailing dot,
  ≤ 50 characters. `change`, not `changed` or `changes`.
- Scope: the area (`compiler`, `auth`, `settings`), optional.
- Footer: `close #123` or `fix #123` for the report. `BREAKING CHANGE: <what
  users must do>` for a break; that line is what turns a `feat`/`fix` into a
  major.
- Revert: `revert: <subject of the reverted commit>` and `This reverts commit
  <sha>.` in the body.
- Validate the header with a hook or a lint step. A convention nobody checks is
  a suggestion.

Only `feat`, `fix`, `perf` and any breaking change reach the changelog. That is
the reason not to smuggle a behavior change into `chore`: it disappears from the
release notes, and users find it by accident.

Rules:

- The changelog is generated from the headers. Nobody edits it by hand, and a
  change that needs different wording gets a different subject, not a manual
  entry.
- The evidence block stays in the body. It is long; the header stays short.
- One subject, one behavior. If the subject needs "and", split the change.

## Owner edits and re-verification

Vue asks contributors to allow maintainer edits so a maintainer can make a
small fix instead of sending the patch back. Here the owner plays that role:
when the owner pushes to the branch under review, the agent re-runs the gates at
the **new** head and records that head. An edit invalidates the earlier record,
exactly as a push by the contributor does.

An agent never merges a head it did not itself verify, even with an approval on
a different commit.

## Checks a reviewer can perform

- **C1.** The PR's base is the branch the change kind belongs to, and it
  contains only that kind.
- **C2.** A bug fix names a reproduction; a new surface names an approved design
  note; a refactor names its measured reason.
- **C3.** No reformat, rename or drive-by refactor is mixed into the diff.
- **C4.** The header matches the convention and the subject is in the changelog
  scope it claims.
- **C5.** The evidence body names the newly pushed head, and an owner edit
  triggered a fresh run.
- **C6.** A fix that must reach the minor line is cherry-picked forward with
  `-x`, not merged.

Anything a check cannot answer is a question for the owner, not a judgement
call the reviewer makes alone.
