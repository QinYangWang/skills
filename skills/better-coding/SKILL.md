---
name: better-coding
description: >-
  One command that gives a repository the coding-agent harness it needs: run it
  once and it detects the state — no harness, a partial one, a foreign AGENTS.md,
  an older harness version — and converges the repository on the current harness:
  AGENTS.md as the only entry file, the docs read on demand (LESSONS.md, code
  standards, subsystem references), the verify command and the PR and nightly
  templates. Run the same command again later to upgrade an adopted repository
  when the conventions move. After a run the repository's own AGENTS.md runs the
  work, and this skill is not loaded again until the next run.
---

# Better coding

Agent-maintained repositories fail in predictable places: the fix covers the
screenshot but not the class, the new test passes on the old code, the full suite
was never run, the commit says "tests pass" without saying what ran, and the same
regression returns three releases later.

The premise: **quality is not a property of the model. It is a property of the
repository's feedback loop.** Write the loop down, make it cheap to follow, and
let every repeated mistake harden into a rule and then into a check.

This skill writes that loop into a repository. It is a scaffold, not a way of
working: one run, and then the repository runs itself. An agent that follows
`AGENTS.md` is already working the right way; nothing here needs to be loaded to
do that.

## One run

`/better-coding` does one thing: it brings the repository's harness to the
current version. It reads the state first, then builds, upgrades, repairs, or
reports that nothing is needed. There is no mode to choose and no second command.

| State it finds | What the run does |
| --- | --- |
| no harness, or a partial one | writes what is missing: the entry first, then the docs it routes to |
| an older harness stamp | applies the version delta, keeping every project fact and all evidence |
| the current stamp | verifies the shape; changes nothing and says "already current" |
| a foreign `AGENTS.md` | merges its facts into a new entry, keeps every rule, and says what moved |
| a drift after setup | repairs only the named drift — a second entry, a missing doc, an entry that lost the first read |

It does not stop because a file already exists. A repository with an old
`AGENTS.md` gets the upgrade steps applied inside the same run, not a refusal,
and the report says what happened to each file.

Run it once per repository. From then on the repository's own `AGENTS.md` is the
entry; this skill is not read again until the conventions move.

## What it writes

- **Entry:** `AGENTS.md` (≤150 lines) — harness stamp, project facts, exact
  commands, the rules in one screen, a route table, the evidence block, agent
  safety, human gates.
- **On demand:** `LESSONS.md`, `docs/code-standards.md`, `docs/subsystems/`,
  `docs/contributing.md`.
- **Runnable:** `scripts/verify.sh`.
- **Record:** `.github/pull_request_template.md`, `docs/nightly-review.md`.
- **Shim:** `CLAUDE.md`, two lines pointing at the entry.

The read budget it installs is the point of the entry file: **one mandatory
read** — `AGENTS.md`, start to end, once — and then only the one document the
task names. `LESSONS.md` is searched, `docs/code-standards.md` is grepped,
`scripts/verify.sh` is run. Reading the whole docs tree is the failure mode this
skill exists to prevent.

Full procedure, state table, deliverable list and validation:
`references/converge.md`. File responsibilities and budgets:
`references/file-contract.md`.

## Upgrading, inside the same run

The entry file carries a harness stamp on the line under its title
(`<!-- better-coding harness: v2 -->`). It is read only by a run, never at work
time. When it is older than this skill, the run prints a plan first, patches only
the sections the version table names, keeps every project fact and every piece of
evidence verbatim, stamps the new version, and validates that running it again
changes nothing.

Version table, the v1 → v2 steps, the plan format and the upgrade rules are in
`references/converge.md`.

## The protocol the harness encodes

The generated files are the digest an agent works from. These references are the
full text, for writing the harness, auditing it, or changing it:

- `references/change-protocol.md` — before/during/after a change, the sixteen
  rules in detail, commit and PR formats.
- `references/contribution-and-branches.md` — the branch model, target-branch
  table, what is accepted and refused, the design note for new surface, the
  commit convention that feeds the changelog, owner-edit re-verification.
- `references/quality-gates.md` — reproduction, red/break checks, full suite,
  real use, cross-platform, merge and release gates.
- `references/lesson-loop.md` — the nightly review, lesson format, 3-day
  promotion, deduplication and pruning.
- `references/worked-example.md` — a filled example from symptom to hard rule.
- `references/file-contract.md` — every file, why it exists, size budgets, and
  which are read on demand.
- `templates/` — the fill-in shapes a run writes.

A larger repository adds guardrails the core files do not carry — a measured
agent-facing context budget, a fast/full split, test failures turned into lint,
an evidence type per change, a surface matrix, scoped review agents, a release
candidate. They are conditional: `references/converge.md` lists the failure mode
each one catches. Do not install all of them on a small repo.

## Human gates

A run and the work that follows happen only inside boundaries the owner sets.
Stop and ask before:

- reversing a deliberate product decision or a documented design rule;
- changing security, credentials, permissions, release scripts or update feeds;
- changing the branch model, branch protection or the commit lint that guards
  the changelog;
- approving a new API surface, or landing one without its design note;
- touching the live state directory, a running dev server, or a user's pairing
  link;
- a migration or deletion with no way back;
- spending money, contacting users, or making a public claim;
- blocking a community author or closing a report as won't-fix.

The owner sets direction and guards the gates. An agent that only reads the
repository's `AGENTS.md` inherits the same gates from it. A deliberate decision
is recorded in the owning subsystem reference (or beside the code) with the owner
and date, not only in a chat. If a rule fights the task in front of you, say so
and get the owner's sign-off before breaking it.

## Origin

The method is distilled from the magpie repository's agent workflow
([AGENTS.md](https://github.com/yetone/magpie/blob/main/AGENTS.md),
[LESSONS.md](https://github.com/yetone/magpie/blob/main/LESSONS.md),
[code standards](https://github.com/yetone/magpie/blob/main/docs/code-standards.md),
[subsystem references](https://github.com/yetone/magpie/blob/main/docs/subsystems/README.md))
and WquGuru's analysis of its nightly loop,
[“yetone 的魔法：magpie 是怎么让 AI 自己维护项目的”](https://x.com/wquguru/status/2109650264601117141).
The branch and contribution rules are adapted from Vue's contributor guide and
commit convention. Magpie's own statement of the loop is the opening line of
`LESSONS.md`: the code is written, reviewed, merged and released by agents.
Magpie does not publish its nightly trigger or prompt; the loop here is a
portable reconstruction, not a claim about magpie's private automation.
