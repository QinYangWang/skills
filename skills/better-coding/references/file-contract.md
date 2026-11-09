# File contract

The loop needs four layers. Each layer has one job; when a file starts doing
another layer's job, it grows into a document nobody reads.

| Layer | File | Job |
| --- | --- | --- |
| Router | `AGENTS.md` | Which doc owns this task, and which commands run. |
| Memory | `LESSONS.md` | What recent work got wrong, with evidence. |
| Law | `docs/code-standards.md` | Rules a reviewer checks, plus acceptance criteria. |
| Proof | `scripts/verify.sh` and tests | The commands that make the rules executable. |

## Complete file list

`Required` means the loop breaks without it. `Recommended` means the loop works
but the agent will waste time or miss evidence. `Optional` means add it only
when the project has that problem.

| Path | Status | Purpose | Read when | Update when | Budget |
| --- | --- | --- | --- | --- | --- |
| `AGENTS.md` | Required | Router: identity, read order, project facts, task-to-doc table, evidence rule, agent safety, human gates. | Every session, first. | A doc, command, subsystem or boundary changes. | ≤ 120 lines + measured context budget |
| `CLAUDE.md` | Recommended | Three-line shim for Claude Code: `@AGENTS.md` and `@LESSONS.md`. | Claude Code starts. | `AGENTS.md` changes. | ≤ 5 lines |
| `LESSONS.md` | Required | Error notebook: rule, evidence, fix, done-right, `Seen N× (dates)`. | Before changing code; search for the area and symptom. | Nightly review; promotion. | ≤ 800 lines |
| `docs/code-standards.md` | Required | Hard rules a reviewer checks, tests rules, acceptance criteria, review checklist, commit rules. | Before a change and during review. | A lesson is seen on 3 separate days; an owner changes a rule. | ≤ 250 lines |
| `docs/subsystems/README.md` | Required if >1 area | Map of subsystem references, maintenance rules, semantic-change description, review steps. | Before choosing where to work. | A subsystem is added, split, merged or retired. | ≤ 60 lines |
| `docs/subsystems/<area>.md` | Required for each high-risk area | Design reference: responsibilities, source of truth, runtime path, state, contracts, failure behavior, verification — the cross-component behavior a reader cannot get from one file. | Before changing that area. | A documented responsibility, interface, state transition or failure behavior changes. | ≤ 300 lines each |
| `scripts/verify.sh` | Required | One command for the local gates: fast changed-scope check, tests, real-use check, not-run report. The full suite may run in CI; the script must say where. | Before every commit. | A command or environment requirement changes. | ≤ 100 lines |
| Nightly job (cron, scheduled workflow or local command) | Recommended | Runs the review prompt from the last `reviewed-through` SHA and opens a PR. | Daily, after the day's merges. | The schedule, range or prompt changes. | One job |
| `docs/nightly-review.md` | Required | The nightly prompt, range, output rules and the local command. | When running or changing the review. | The review rules or scheduler change. | ≤ 80 lines |
| `.agents/skills/<project>-coding/SKILL.md` | Recommended | Project adapter for skill-aware agents: read order, exact commands, local invariants, boundaries. | Every session in that repo. | Commands, stack or boundaries change. | ≤ 100 lines |
| `.agents/skills/test-<project>-app/SKILL.md` | Optional | Real-client verification skill: start the app in isolated state, drive the affected flow with the product's own tools, capture before/after, retain for the user, stop only what you started. | A UI or integration change. | The app's test harness or surfaces change. | ≤ 120 lines |
| `docs/surface-matrix.md` | Optional | The surfaces a change must consider: entry points, clients, providers, agents, contracts, reverse states, connection modes, docs. | Before a cross-surface change. | A surface is added or removed. | ≤ 60 lines |
| `evals/` | Optional | Real-model cases for prompts, tool descriptions, generated titles and other model-facing text. | When model-facing text changes. | A new case, model or grader. | 3–7 cases to start |
| Agent context budget (`<context-budget.json>` or equivalent) + measuring test | Optional | Byte budget for the text the model loads up front; a test keeps it equal to the measured text; CI fails on growth. | When the router or skills grow. | The owner approves growth, or text shrinks. | One file + one test |
| `.github/review-agents/<concern>.md` | Optional | One scoped AI review concern: include/exclude, changed lines only, budget, exact no-findings output. | When adding AI review. | The concern or its scope changes. | ≤ 80 lines each |
| `.github/pull_request_template.md` | Optional | Forces the evidence block into every PR. | Opening a PR. | The evidence format changes. | ≤ 40 lines |
| `docs/contributors.md` | Optional | Community PR policy: harm check, close-without-review rules, credit, blocking. | Reviewing an external PR. | Policy or list changes. | ≤ 120 lines |
| `docs/reference.md` | Optional | User-facing reference: CLI, API, config, file formats. | A user-visible contract changes. | The contract changes. | As needed |

Do not add: a separate process document, meeting notes, an agent diary, a
second copy of the rules, or a "roadmap" that no gate reads. If a fact is not
read by an agent or checked by a reviewer, it does not belong in this set.

## If a file is missing

A repo does not have to be fully adopted before the loop is useful. Use this
fallback and say which one you used:

| Missing | Fallback |
| --- | --- |
| `AGENTS.md` | Read `README`, `CONTRIBUTING` and the nearest subsystem doc. Propose the router before a large change. |
| `LESSONS.md` | Search the last 90 days of git history for reverts, hotfixes and repeated fixes. Do not invent a lesson. Propose the notebook. |
| `docs/code-standards.md` | Use the project's contributing guide plus the process rules in `templates/code-standards.md`. Propose the file. |
| A subsystem reference | Read the source and tests. Write a short reference before changing a high-risk area. |
| `scripts/verify.sh` | Run the documented commands manually and record them. Propose the script. |
| A project skill | Use `AGENTS.md` and the docs directly; the skill is an adapter, not a dependency. |

A missing file is a finding. Do not silently substitute a generic rule for the
project's actual contract.

## Minimum viable adoption

For a small single-service repo, start with seven files:

```
AGENTS.md
LESSONS.md
docs/code-standards.md
docs/subsystems/README.md
docs/subsystems/core.md
scripts/verify.sh
docs/nightly-review.md
```

Add the project skill and PR template when more than one agent or more than one
contributor touches the repo. Add `docs/contributors.md` only when outside PRs
arrive. Add `docs/reference.md` only when users depend on a contract.

## Example structure: single service

```
relayd/
├── AGENTS.md
├── CLAUDE.md
├── LESSONS.md
├── docs/
│   ├── code-standards.md
│   ├── nightly-review.md
│   └── subsystems/
│       ├── README.md
│       ├── cache.md
│       └── http.md
├── scripts/
│   └── verify.sh
├── .agents/
│   └── skills/
│       └── relayd-coding/
│           └── SKILL.md
└── .github/
    └── pull_request_template.md
```

## Example structure: multi-subsystem product

```
magpie-like/
├── AGENTS.md
├── CLAUDE.md
├── LESSONS.md
├── docs/
│   ├── code-standards.md
│   ├── contributors.md
│   ├── reference.md
│   ├── nightly-review.md
│   ├── surface-matrix.md          # optional, multi-surface product
│   └── subsystems/
│       ├── README.md
│       ├── gateway-routing.md
│       ├── agent-wiring.md
│       ├── gui-shell.md
│       └── providers-accounts.md
├── evals/                         # optional, model-facing text
├── scripts/
│   └── verify.sh
├── .agents/
│   └── skills/
│       ├── magpie-coding/
│       │   └── SKILL.md
│       └── test-magpie-app/       # optional, real-client verification
│           └── SKILL.md
└── .github/
    ├── pull_request_template.md
    ├── review-agents/             # optional, scoped AI review
    │   └── test-review.md
    └── workflows/
        └── nightly-review.yml
```

The nightly workflow is optional. A local cron job or a scheduled agent session
is enough; the prompt is the part that matters. See
`references/lesson-loop.md`.

## What goes in each file

### `AGENTS.md`

- One paragraph: who writes, reviews, merges and releases; what this repo is.
- Read order, with the fallback when a file is missing.
- Project facts: stack, build, fast check, full suite **and where it runs**,
  real-use check, platforms, release command.
- Task-to-doc table. Keep it short; link out.
- The rule that a documented subsystem's reference is updated in the same
  change.
- The evidence rule: what a commit body must contain, and which evidence type
  matches which change.
- Agent safety: kill only a captured PID, never write the live state directory,
  stop what you started, do not bake origins.
- Human gates: the decisions the agent must not make alone.
- The escape hatch: if a rule fights the task, say so and get the owner's
  sign-off before breaking it.

It must **not** contain the code standards, a full architecture, a changelog or
release notes. Those live elsewhere. A router that duplicates its
destinations drifts from them.

### `LESSONS.md`

- `<!-- reviewed-through: <sha> (<date>) -->` at the top.
- One paragraph: who writes/reviews/merges, what this file is, and the
  promotion rule.
- Categories that match how the project fails (reading the report, fix the
  class, user files, verification, concurrency, red tests, merging/releasing).
- Entries in the format in `references/lesson-loop.md`.
- A `Moved to the code standards` section with links to the promoted rules.
- `Done right` examples, because agents copy what they see.

It must **not** contain generic advice ("write clean code"), unverified claims,
duplicates of the code standards, or a lesson with no commit/issue/date.

### `docs/code-standards.md`

- Opening: these rules come from this project's reviews; a reviewer checks each
  one and names the rule in the comment.
- Tables of `Rule | What a reviewer looks at`. One row per rule, phrased as a
  behavior, not a slogan.
- A tests section: red check, break check, no network, real inputs, behavior
  not implementation, red on main, teardown, timing room, one layer (the lowest
  that fails on main), extend before add, and no unreasoned skip.
- The evidence matrix: test for logic, capture for visual, transcript for
  server-only, eval/context budget for model-facing.
- Acceptance criteria: numbered, runnable, and explicit about what does not
  count.
- Review checklist: what the reviewer does, not only what they read.
- Commit and merge rules.

It must **not** be a language style guide. If a linter or formatter can enforce
it, configure the tool and link to it; do not spend a rule on it.

### `docs/subsystems/README.md`

- A table: subsystem, one-line responsibility, link to the reference.
- Maintenance rule: update the owning reference in the same change when a
  documented contract changes.
- A semantic-change description format: trigger, before, after, affected
  interfaces/state/failure behavior, verification.
- Review steps: find the runtime path, compare claimed behavior with the diff,
  check links, check that the cited tests exercise the behavior, report what
  was not run.

### `docs/subsystems/<area>.md`

- Responsibilities and boundaries.
- Source of truth: files and named symbols.
- Main runtime paths: entry point to side effect.
- State and transitions, including who writes each field and under which lock.
- Contracts and invariants, including compatibility and user-set values.
- Failure behavior: what a failed read/parse/timeout means.
- Verification: exact tests and commands.
- Links to source and tests. Link to symbols, not line numbers.

Keep current behavior separate from proposed changes. A proposal belongs in an
issue or PR, not in the reference.

### Documentation budget

Write a doc only for a decision, a constraint that spans components, or a
failure mode the code cannot show. If reading the code answers the question,
leave it out. Do not enumerate fields or methods, narrate control flow,
maintain a file catalog, or append a PR summary. When a documented decision
changes, rewrite or remove the old text; do not append another account of the
new behavior. A local reason goes in a short comment beside the code. User docs
cover the task and the unintuitive part, not every visible control.

### `docs/nightly-review.md`

The nightly prompt, the range it reviews, the output rules (lessons, promotions,
PR only) and the local command or scheduler. Keep it short; the detailed lesson
format lives in `references/lesson-loop.md`. The agent must not invent evidence
or push to main.

### `scripts/verify.sh`

- `set -euo pipefail`.
- One section per gate, printing the command and a short result.
- A fast changed-scope section before the full suite.
- A temporary sandbox for tests and real-use checks; never the live config.
- A final `not run` section that is explicit, not silently skipped.
- Exit non-zero on any failure or on an unfilled `TODO`.
- If the full suite runs in CI, say so and record the run at the pushed head;
  do not print a passing full-suite line you did not run.

### `.agents/skills/<project>-coding/SKILL.md`

- Frontmatter with a routing description that names the project.
- Read order pointing at the repo docs.
- Exact commands, copied from `verify.sh`, not re-invented.
- Local invariants and "never touch" paths.
- A link back to `docs/code-standards.md` instead of a copy of it.

### `.agents/skills/test-<project>-app/SKILL.md`

Only when the product has a UI or a real integration surface worth verifying
through the product itself. Cover: how to start the app in isolated worktree
state, how to read the real ports/pairing URL, the free replay/fixture path
before a paid model, the flow to exercise, what evidence to capture, how to
retain the environment for the user, and how to stop only the processes the
agent started. See `templates/verification-skill-SKILL.md`.

### `docs/surface-matrix.md`

Only for a multi-surface product. One row per surface category: entry points,
clients, providers, agents, contracts, reverse states, connection modes, docs.
Each row says whether it applies, what changes, and how it was verified. N/A
needs a reason.

### Review agents

One concern per file. Include/exclude globs, changed lines only, a budget, a
neutral conclusion, and an exact no-findings output. A test-review agent may
ask for fewer or smaller tests, never more coverage. A review agent never
merges or changes policy. See `templates/review-agent.md`.

### `docs/contributors.md`

Only when outside PRs arrive. Cover: what stops a review for possible harm;
what is closed without a full review; how a reporter's patch/fixture is
credited; when an author is proposed for blocking, with evidence; and that only
the owner decides a block.

## Naming and ownership

- One fact, one home. If two files state the same rule, one is a link.
- A subsystem reference is named for the behavior, not the package:
  `gateway-routing.md`, not `internal-gateway.md`.
- The owner of a product decision is named in `AGENTS.md` or the subsystem
  reference. "The maintainer" is enough if there is exactly one.
- Every generated file starts with a header naming the generator and date only
  if the project uses generated docs. Otherwise, no banner: the file is owned
  by the repo.

## Validation

Before calling the setup complete:

- `AGENTS.md` routes to every doc in the tree; no dead links.
- Every command in the docs was run in this repo, or is marked `TODO`.
- `LESSONS.md` entries all cite a commit, issue or owner decision.
- `docs/code-standards.md` contains no rule that a reviewer cannot check.
- Each subsystem reference links to files that exist.
- `scripts/verify.sh` runs from the repo root and fails on a deliberate break.
- If a context budget exists, its test passes and CI would fail on growth.
- If a surface matrix exists, every row has a decision and verification.
- If review agents exist, each has one concern, explicit scope and a budget.
- The full suite's location (local or CI) is named, and the record points at the
  pushed head.
- A fresh agent can find the verify command in at most three reads.
- The nightly prompt names the range, the output, and the promotion threshold.
