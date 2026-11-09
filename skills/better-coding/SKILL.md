---
name: better-coding
description: >-
  Evidence-driven coding loop for repositories maintained or heavily changed by
  AI agents. Use when working in a repo that has AGENTS.md, LESSONS.md or
  docs/code-standards.md; when setting up autonomous or high-quality agent
  workflows; when reviewing, merging or releasing agent-written changes; when a
  fix needs reproduction, sibling-scope, red/green tests, real-use checks,
  commit evidence, nightly lesson review, promotion of repeated mistakes into
  hard rules, or adopting this loop in a project.
---

# Better coding

Agent-maintained repositories fail in predictable places: the fix covers the
screenshot but not the class, the new test passes on the old code, the full
suite was never run, the commit says "tests pass" without saying what ran, and
the same regression returns three releases later.

The premise: **quality is not a property of the model. It is a property of the
repository's feedback loop.** Write the loop down, make it cheap to follow, and
let every repeated mistake harden into a rule and then into a check.

Use the full loop where a mistake reaches users, data, money or a release. For a
throwaway prototype, keep the red test, the one-goal commit and the not-run
list; skip the subsystem docs and the nightly review until the code has users.

This skill is the loop. `better-coding-init` installs it into a specific
project.

## Read order

Before touching code, read these in order. If a file does not exist, use the
fallback in `references/file-contract.md`.

1. `AGENTS.md` — the router. Which doc owns this area, and which commands run.
2. The owning `docs/subsystems/<area>.md` — behavior, source of truth,
   invariants, failure modes, verification.
3. `LESSONS.md` — what recent work got wrong. Search it for the area and for
   the symptom before you start.
4. `docs/code-standards.md` — the rules a reviewer will check.
5. The source, tests, and the last few commits that touched them.

Do not start from the issue text alone. The reporter's words tell you what
they saw; the subsystem doc and the source tell you what the system does.

## The loop

### 1. Route and reproduce

Name the affected subsystem and the real runtime path. Reproduce the exact
case on the surface the reporter used: their platform, provider, config,
input bytes and UI. If there is no reporter, write the failing test first.
"Looks right" is not a reproduction.

### 2. Scope the whole path

List every place the change must reach before editing:

- callers, siblings, other routes, other platforms, other providers;
- state that is written and read under different names;
- defaults, migrations, saved copies and tests that assumed the old meaning;
- docs that describe the contract you are changing;
- the person who owns a deliberate product decision.

A fix that reaches one sibling is unfinished. Grep for the pattern, not just
the reported line.

### 3. Make the smallest complete change

One goal per commit. No unrelated refactors, no "while I'm here" features, no
new abstraction for one caller. Preserve existing error handling and
validation. If the change alters a formula, list, layout, timing or saved
format, re-derive everything built on it.

### 4. Prove it

Run the gates in `references/quality-gates.md`. The non-negotiables:

- the new test **fails without the change**, with a real `FAIL` that names the
  behavior — not a compile error and not a skip;
- break the code on purpose in two or three ways and watch the test catch
  each break;
- run the full suite (locally or in CI), not the packages you think you
  touched, and record where it ran;
- try the real thing where the change meets a vendor, account, config format,
  binary or user surface;
- list every check you did not run and why.

### 5. Record the evidence

The commit body is the durable record, not a chat message or a push note:

```
<area>: <what the user now sees, as behavior>

Fixes #<n> (<reporter>).
Root cause: <one or two sentences>.
Ran at <pushed sha>:
- Red check: <test> failed before with <real output>; passes after.
- Break check: <mutations> each made <test> red.
- Full suite: <local command or CI run> at <sha> -> <summary>.
- Real use: <what, where>.
- Not run: <check> (<why>).
Docs: <owning reference updated>.
```

A large change with no body cannot be reviewed afterwards. A body that points
to "the push" or to a chat is not a record.

### 6. Merge only what was reviewed

Merge the reviewed head, not a later push. In GitHub:
`gh pr merge --match-head-commit <reviewed sha>`. A tag waits for a completed
green run on that commit; a cancelled run is not a pass. A tag is not a
release: verify the artifacts and the "latest" marker exist before telling
anyone the version is out.

### 7. Close the loop nightly

Once a day, review the day's merged work for three things:
what had to be fixed again, what should not have merged, and what was verified
too thinly. Write each finding into `LESSONS.md` with a rule, the evidence and
`Seen N× (dates)`. When the same lesson is seen on **three separate days**, move
it into `docs/code-standards.md` as a checkable rule and, where possible, a
guard test. See `references/lesson-loop.md`.

## Twelve rules that transfer

These are distilled from real incidents, not style preferences. The full
reasoning and review checks are in `references/change-protocol.md`.

| Rule | What it prevents |
| --- | --- |
| Reproduce the reporter's exact case on the surface they use. | Fixing only the visible instance; the report comes back. |
| Fix the class, not the sample. | The same bug surviving in the next agent, route, provider or platform. |
| Re-derive everything built on what you change. | Tests, saved copies and callers still assuming the old meaning. |
| A failed read, parse or hash means "unknown", never "empty". | Overwriting good data because a corrupt file looked like "no data". |
| The project's default never overrides a value the user set. | Migrations and presets silently replacing a deliberate choice. |
| Another app's values come from that app. | Writing the wrong type, unit or URL into someone else's config. |
| Nothing that can block runs under a lock its reader needs. | Deadlocks, races and CI that hangs under load. |
| A test must fail without the change, and be broken on purpose. | Tests that pass on the old code and guard nothing. |
| A red on main is a bug to fix now. | "Fails the same on main" shipped past a real defect. |
| One commit, one goal; the body records what was run at the pushed head. | Unreviewable commits and evidence that describes a different tree. |
| Merge only the reviewed head; a tag waits for a completed green run. | Code nobody ran reaching users under a reviewed subject. |
| Real use before claiming it works; list what was not run. | A platform claim never actually tested. |

## Guardrails for larger repos

The core loop works for a small repository. A larger, multi-surface, frequently
released or model-facing repo adds guardrails that catch failure modes the loop
does not:

- **Measure the agent-facing context.** Count the bytes of the router, skill
descriptions and tool schemas the model loads; test that the committed budget
matches; fail CI on growth unless the owner approves it.
- **Split the fast check from the full gate.** Let the agent run a
changed-scope check while iterating; CI owns the full suite at the pushed head.
The PR records where the full suite ran, not a claim that the agent ran it.
- **Turn recurring test failures into lint.** Sleeps, wall-clock waits, frame
waits, retries and unreasoned skips become rules that fail a PR, not prose in a
doc.
- **Match evidence to the change type.** Logic gets a failing test; visual
changes get before/after captures; server-only changes get a test and a
runtime transcript; model-facing text gets an eval or a context budget.
- **Use a surface matrix** (`templates/surface-matrix.md`). Entry points,
clients, providers, agents, contracts, reverse states, connection modes and
docs each get a decision.
- **Scope review agents** (`templates/review-agent.md`). One concern, explicit
include/exclude, changed lines only, a budget, and an exact "All clear" when
there is nothing to say.
- **Promote a verified release candidate.** A disposable preview runs the real
pipeline; a candidate is verified; stable promotes that commit; the packaged
artifact is smoked against old data.

See the conditional deliverables in `better-coding-init/SKILL.md` and the
matching templates. Do not install all of them on a small repo.

## What "done" means

A change is done when a reviewer can answer all of these from the commit and
the PR:

- What was the goal, and what was deliberately not done?
- Which subsystem and runtime path changed?
- Which test failed before, and with what output?
- Which breaks were injected, and which tests caught them?
- Which full suite ran, where, at which head, with what result?
- Which evidence type matches the change, and did you provide that type?
- What was tried against the real thing, and what was not?
- Which docs changed because a contract changed?
- What is the rollback if it goes wrong?

If any answer is missing, the change is not done. Say "not run", never leave
it out.

## Files and adoption

The complete required-file list, responsibilities, size budgets and example
trees are in `references/file-contract.md`. Start from the templates in
`templates/` and fill them with facts from the project.

To adopt this in a repository, use the `better-coding-init` skill. It detects
the stack, mines recent history for real lessons, writes the files, wires the
nightly review and validates that a deliberate bad change is caught.

## Human gates

The agent writes, reviews, merges and releases only inside boundaries the owner
sets. Stop and ask before:

- reversing a deliberate product decision or a documented design rule;
- changing security, credentials, permissions, release scripts or update
  feeds;
- touching the live state directory, a running dev server, or a user's pairing
  link;
- a migration or deletion with no way back;
- spending money, contacting users, or making a public claim;
- blocking a community author or closing a report as won't-fix.

The owner sets direction and guards the gates. The agent does the work and
leaves evidence. A deliberate decision is recorded in the owning subsystem
reference (or beside the code) with the owner and date, not only in a chat. If a
rule fights the task in front of you, say so and get the owner's sign-off before
breaking it.

## References

- `references/file-contract.md` — every file, why it exists, and example trees.
- `references/change-protocol.md` — before/during/after a change, the twelve
  rules in detail, commit and PR formats.
- `references/quality-gates.md` — reproduction, red/break checks, full suite,
  real use, cross-platform, merge and release gates.
- `references/lesson-loop.md` — the nightly review, lesson format, 3-day
  promotion, deduplication and pruning.
- `references/worked-example.md` — a filled example from symptom to hard rule.
- `templates/` — fill-in files for a target repository.

## Origin

The method is distilled from the magpie repository's agent workflow
([AGENTS.md](https://github.com/yetone/magpie/blob/main/AGENTS.md),
[LESSONS.md](https://github.com/yetone/magpie/blob/main/LESSONS.md),
[code standards](https://github.com/yetone/magpie/blob/main/docs/code-standards.md),
[subsystem references](https://github.com/yetone/magpie/blob/main/docs/subsystems/README.md))
and WquGuru's analysis of its nightly loop,
[“yetone 的魔法：magpie 是怎么让 AI 自己维护项目的”](https://x.com/wquguru/status/2109650264601117141).
Magpie's own statement of the loop is the opening line of `LESSONS.md`: the
code is written, reviewed, merged and released by agents. Magpie does not
publish its nightly trigger or prompt; the loop here is a portable
reconstruction, not a claim about magpie's private automation.
