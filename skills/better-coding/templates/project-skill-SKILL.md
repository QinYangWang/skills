<!-- FILL: remove this block after filling. Keep this file under 100 lines. -->
---
name: <project>-coding
description: >-
  Work on <PROJECT> with the repository's evidence-driven coding loop. Use when
  changing <PROJECT>, fixing a bug, reviewing a PR, cutting a release, or when
  you need the project's exact verification commands, subsystem map, invariants
  and boundaries. Points to AGENTS.md, LESSONS.md and docs/code-standards.md;
  does not replace them.
---

# <PROJECT> coding

<PROJECT> is <one sentence>. The repository is written, reviewed, merged and
released by agents; the owner sets direction and guards the decisions below.

## Read in this order

1. `AGENTS.md` — the router and the project facts.
2. The owning `docs/subsystems/<area>.md` — behavior, contracts, failure modes,
   verification.
3. `LESSONS.md` — search for the area and the symptom.
4. `docs/code-standards.md` — what a reviewer checks.
5. The source, tests and the last commits that touched them.

## Commands

| Purpose | Command |
| --- | --- |
| Fast changed-scope check | `<command>` |
| Full suite (local or CI) | `<command>` |
| Real use | `<command or recipe>` |
| Format/lint | `<command>` |
| Build | `<command>` |
| Release | `<command or workflow>` |
| Agent context budget | `<test or none>` |
| Surface matrix | `docs/surface-matrix.md` (if present) |

Run the fast check while iterating. The full suite is the merge gate; it may
run in CI. Record where it ran and at which SHA. If a command changes, update
`AGENTS.md` and `scripts/verify.sh` in the same change.

## The loop

1. Reproduce the exact case on the surface the reporter used.
2. Map the whole path: callers, siblings, state, saved copies, tests, docs.
3. Make the smallest complete change; one goal.
4. Prove it: red check, break check, full suite, real use, not-run list. Match
   the evidence to the change: test, capture, transcript or eval.
5. Record the evidence in the commit body at the pushed head, including where
   the full suite ran.
6. Merge only the reviewed head; a tag waits for a completed green run.
7. If it came back or was verified thinly, write a lesson.

The full protocol is in `docs/code-standards.md` and the `better-coding` skill.

## Invariants

- <The one or two things that must never break.>
- <A user-set value the project must never override.>
- <A data format or compatibility guarantee.>

## Boundaries

Never touch without the owner:

- <secrets / CI / release scripts / migrations / live config>;

Stop and ask before reversing a deliberate product decision, changing a
public contract, or making a claim users will rely on.

## Verification record

Use this block in the commit and the PR:

```
Ran at <pushed sha>:
- Red check: ...
- Break check: ...
- Full suite: ...
- Real use: ...
- Not run: ...
Docs: ...
```
