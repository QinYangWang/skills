<!-- FILL: remove this block after filling. Keep this file under 150 lines: it is
the only file an agent must read before starting. Everything else is on demand.
Keep the harness stamp line below; it is how a later run knows what is due. -->
# <PROJECT> — notes for coding agents
<!-- repo-governance harness: v2 -->

<PROJECT> is <one sentence: what it is and who uses it>. Agents write, review,
merge and release changes here; the owner sets direction and guards the
decisions under "Human gates".

Read this file once, start to end. The route table below names at most one more
document per task. Do not read the docs tree before your first edit.

## Project facts

| Fact | Value |
| --- | --- |
| Stack | <languages, frameworks, package manager> |
| Fast check | `<command>` |
| Full suite | `<command>` (local or CI — say which) |
| Commit-header lint | `<command>` |
| Real-use check | `<command or recipe>` |
| Branches | `<stable>`: fixes, chores, docs · `<next minor>`: new surface · `<major>`: breaks, owner only |
| Release | `<command or workflow>` |
| Agent context budget | `<file or none>` |
| Platforms | <OS/arch/browser/runtime> |
| Never touch without the owner | <paths: secrets, release scripts, migrations, ...> |

## The loop

1. **Pick the branch.** Fix → `<stable>`. New user-visible surface → `<next
   minor>`, with an approved design note in `docs/plans/`. Break → the owner.
   Never a fix and a feature on one branch; never a commit on a long-lived
   branch.
2. **Reproduce** the reporter's exact case on the surface they use, or write the
   failing test first.
3. **Map the whole path**: callers, siblings, state, saved copies, tests, docs.
4. **Make the smallest complete change.** One goal; no reformat, rename or
   drive-by refactor.
5. **Prove it**: red check, break check, full suite, real use, not-run list.
6. **Record and merge**: the evidence block below goes in the commit body; merge
   only the reviewed head. A fix that ships next is cherry-picked forward with
   `-x`.

## Rules that always apply

- Reproduce the reporter's case on their surface; a fix that reaches one sibling
  is unfinished.
- Re-derive everything built on what you change: callers, caches, saved copies,
  tests, docs.
- A failed read, parse or hash means "unknown", never "empty".
- The project's default never overrides a value the user set.
- Nothing that can block runs under a lock its reader needs.
- A test must fail without the change, and be broken on purpose.
- A red on `<stable>` is a bug to fix now, not a baseline.
- One commit, one goal; the body records what ran at the pushed head.
- Real use before claiming it works; list what you did not run as not run.
- A fix carries no new API surface and no stylistic refactor.

## Route by task

Read the row that matches, then stop. Grep tags like `LESSONS: <area>` rather
than opening a file end to end.

| Task | Read |
| --- | --- |
| Change or debug <area> | `docs/subsystems/<area>.md` |
| Change or debug <area> | `docs/subsystems/<area>.md` |
| User-facing API, CLI, config | `docs/reference.md` |
| "This went wrong before" | `LESSONS.md` — search the area and symptom |
| A rule you are unsure of | `docs/code-standards.md` — grep the rule |
| Branch, commit, PR rules | `docs/contributing.md` |
| Verification | `scripts/verify.sh` — run it, do not read it |
| External PR | `docs/contributors.md` |

## When you change a subsystem

Update the owning reference in the same change when a responsibility, interface,
state transition, compatibility rule or failure behavior changes. An internal
refactor that preserves those contracts does not need a prose change; say that in
the commit.

A deliberate product decision lives in the owning reference (or beside the code)
as `Decision: <what> (<owner>, <date>)`. Do not reverse it without the owner.

Write a doc only for a decision, a constraint that spans components, or a failure
mode the code cannot show. If reading the code answers the question, leave it
out. Do not enumerate fields, narrate control flow or maintain a file catalog.

## Branches and commits

- Header: `<type>(<scope>): <subject>`, imperative, at most 50 characters, types
  `feat|fix|perf|docs|refactor|test|build|ci|chore|revert`.
- `close #123` and `BREAKING CHANGE: <what users must do>` go in the footer.
- Only `feat`, `fix`, `perf` and a break reach the changelog, which is generated
  from the headers. Never edit it by hand, and never hide a behavior change under
  `chore`.
- Merge only the reviewed head; an owner push starts a new review.

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
visual; short transcript for server-only; eval or context budget for model-facing
text. "Tests pass" is not evidence.

## Agent safety in a live environment

- Kill only a PID you captured at spawn, or the owner of your port after
  confirming its working directory. Never `pkill -f`, `pgrep | kill`, or kill a
  PID found by matching a name/path/worktree.
- Never open, start a server against, or clean the live state directory. Read and
  copy from it into your worktree sandbox, one way. Never symlink back.
- Read the real dev ports from the runner. Do not bake HTTP/WS origins into the
  bundle.
- Stop what you started, by the PID you tracked. Use a worktree, not `/tmp`.
- Do not consume the user's pairing link, print credentials, or put them in a
  screenshot or commit.

If a rule here fights the task in front of you, say so loudly and get the owner's
sign-off before breaking it.

## Human gates

Stop and ask before:

- reversing a deliberate product decision or a documented design rule;
- changing CI, release scripts, update feeds, permissions or secrets;
- changing the branch model, branch protection or the commit lint;
- approving a new API surface, or landing one without its design note;
- touching real credentials or a live user config;
- a migration or deletion with no rollback;
- spending money, contacting users, or making a public claim;
- blocking a community author or closing a report as won't-fix.
