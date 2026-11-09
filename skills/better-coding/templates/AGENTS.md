<!-- FILL: remove this block after filling. Keep this file under 120 lines. -->
# <PROJECT> — notes for coding agents

<PROJECT> is <one sentence: what it is and who uses it>. Agents write, review,
merge and release changes here; the owner sets direction and guards the
decisions listed under "Human gates".

## Read in this order

1. This file — the router.
2. The owning reference in `docs/subsystems/` for the area you will change.
3. `LESSONS.md` — search it for the area and the symptom.
4. `docs/code-standards.md` — the rules a reviewer checks.
5. The source, the tests, and the last few commits that touched them.

If a file is missing, say so and use the nearest existing reference. Do not
invent a contract.

## Project facts

| Fact | Value |
| --- | --- |
| Stack | <languages, frameworks, package manager> |
| Build | `<command>` |
| Fast check | `<command>` |
| Full suite | `<command>` (local or CI — say which) |
| Real-use check | `<command or recipe>` |
| Agent context budget | `<file or none>` |
| Surface matrix | `docs/surface-matrix.md` (if present) |
| Platforms | <OS/arch/browser/runtime> |
| Release | `<command or workflow>` |
| Never touch without the owner | <paths: secrets, release scripts, migrations, ...> |

## Route by task

| Task | Read first |
| --- | --- |
| <area / symptom> | `docs/subsystems/<area>.md` |
| <area / symptom> | `docs/subsystems/<area>.md` |
| User-facing API, CLI, config | `docs/reference.md` (if present) |
| External PR | `docs/contributors.md` (if present) |

## When you change a subsystem

Update the owning reference in the same change when a responsibility,
interface, state transition, compatibility rule or failure behavior changes.
An internal refactor that preserves those contracts does not need a prose
change; say that in the commit.

A deliberate product decision lives in the owning reference (or beside the
code) as `Decision: <what> (<owner>, <date>)`. Do not reverse it without the
owner.

Write a doc only for a decision, a constraint that spans components, or a
failure mode the code cannot show. If reading the code answers the question,
leave it out. Do not enumerate fields, narrate control flow or maintain a file
catalog.

## Evidence

Before you call a change done, put this in the commit body and the PR:

```
Ran at <pushed sha>:
- Red check: <test> failed before with <output>; passes after.
- Break check: <mutations> each made <test> red.
- Full suite: <local command or CI run> at <sha> -> <summary>.
- Real use: <what, where>.
- Not run: <check> (<why>).
Docs: <owning reference updated>.
```

Match the evidence to the change: failing test for logic; before/after for
visual; short transcript for server-only; eval or context budget for
model-facing text. A check that was not run is listed as not run, never left
out. "Tests pass" is not evidence.

## Agent safety in a live environment

- Kill only a PID you captured at spawn, or the owner of your port after
  confirming its working directory. Never `pkill -f`, `pgrep | kill`, or kill a
  PID found by matching a name/path/worktree.
- Never open, start a server against, or clean the live state directory. Read
  and copy from it into your worktree sandbox, one way. Never symlink back.
- Read the real dev ports from the runner. Do not bake HTTP/WS origins into the
  bundle.
- Stop what you started, by the PID you tracked. Use a worktree, not `/tmp`.
- Do not consume the user's pairing link, print credentials, or put them in a
  screenshot or commit.

If a rule here fights the task in front of you, say so loudly and get the
owner's sign-off before breaking it.

## Human gates

Stop and ask before:

- reversing a deliberate product decision or a documented design rule;
- changing CI, release scripts, update feeds, permissions or secrets;
- touching real credentials or a live user config;
- a migration or deletion with no rollback;
- spending money, contacting users, or making a public claim;
- blocking a community author or closing a report as won't-fix.
