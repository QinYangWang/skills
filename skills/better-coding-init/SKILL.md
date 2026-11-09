---
name: better-coding-init
description: >-
  Install the better-coding harness into a specific repository. Use when the
  user asks to set up agent-maintained coding, create or improve AGENTS.md,
  LESSONS.md, code standards or subsystem references, generate a
  project-specific coding skill, or add a nightly quality review. Detects the
  repo, mines real evidence, writes a fixed deliverable set, and validates it.
---

# Better-coding init

You install a harness into one repository. The output is a file set a future
agent will actually read, plus the evidence loop that keeps it honest. Do not
write a methodology essay into the repo.

Read `../better-coding/SKILL.md` and
`../better-coding/references/file-contract.md` first. Use the templates in
`../better-coding/templates/`. These two skills are installed as siblings; if
`../better-coding` is missing, install it first rather than guessing.

## Deliverables

Produce this set. "Core" is always required. "Conditional" is added only when
the matching failure mode exists.

| # | Path | Type | What it must contain | Done when |
| --- | --- | --- | --- | --- |
| 1 | `AGENTS.md` | Core | Router, read order, project facts (fast check, full suite and where it runs), evidence block, agent safety, human gates. Under 120 lines. | A new agent can reach the owning doc and the verify command in ≤3 reads. |
| 2 | `LESSONS.md` | Core | 3–8 real lessons (rule, evidence, fix, `Seen N×`), `reviewed-through` SHA, promotion rule. | Every entry cites a commit/issue/owner decision. |
| 3 | `docs/code-standards.md` | Core | Reviewer-checkable rules, test rules, evidence matrix, acceptance criteria, commit/merge rules. | No rule is a slogan; every row says what a reviewer checks. |
| 4 | `docs/subsystems/README.md` + 3–7 `docs/subsystems/<area>.md` | Core | Map of high-risk areas; each reference has responsibilities, source links, runtime path, contracts, failure behavior, verification. | Every source link resolves; only non-obvious cross-component behavior is documented. |
| 5 | `scripts/verify.sh` | Core | Local gates: changed-scope check, tests, real-use, not-run. Full suite may be CI; the script says where. | Runs from the repo root; fails on a deliberate break or an unfilled `TODO`. |
| 6 | `.agents/skills/<project>-coding/SKILL.md` | Core | Thin adapter: read order, exact commands, invariants, boundaries. Links to the docs; does not duplicate them. | Commands match `verify.sh`; no conflicting rule. |
| 7 | `CLAUDE.md` | Recommended | `@AGENTS.md` and `@LESSONS.md`. | Claude Code loads the same instructions. |
| 8 | `.github/pull_request_template.md` | Core if GitHub PRs | Goal, semantic change, evidence, surface matrix link, risk/rollback, checklist. | An empty PR cannot be opened without naming evidence. |
| 9 | `docs/nightly-review.md` + scheduler | Core | Prompt in `templates/nightly-review-prompt.md`, filled with project name and range; runs from `reviewed-through`, opens a PR, never pushes main. | A dry run updates `reviewed-through` and invents no evidence. |
| 10 | `docs/surface-matrix.md` | Conditional | Entry points, clients, providers/adapters, agents, contracts, reverse states, connection modes, docs, release. | Every row has applies/N/A, what changes, verification; N/A has a reason. |
| 11 | `.agents/skills/test-<project>-app/SKILL.md` | Conditional | Start in isolated state, read real ports, free replay before paid model, exercise the flow, capture evidence, retain for user, stop only what you started. | A real-client pass leaves the environment usable and the evidence attached. |
| 12 | Agent context budget + measuring test | Conditional | One byte count per model-facing block; a test generates the exact text and asserts the budget; CI compares with main. | Editing the budget alone fails; growth needs the owner's label. |
| 13 | `evals/` | Conditional | 3–7 cases from real incidents, fail-before-fix, controls, repeated samples, baseline, no user data, cost. | A case actually fails on the old text before passing on the new. |
| 14 | Review-agent contract(s) | Conditional | One concern per file; include/exclude; changed lines only; budget; exact `All clear`; never merge or change policy. | A dry run finds only in-scope issues; empty review is unambiguous. |
| 15 | `docs/contributors.md` + triage contract | Conditional | Prior approval, one problem per PR, evidence, trusted-policy loading, fail-closed, closure with rule/evidence/remedy, no merge. | A missing policy file stops the run; PR text cannot change exemptions. |
| 16 | Release candidate pipeline | Conditional | Preview run of the real pipeline; verified candidate; packaged smoke against old data; stable promotes that commit; only stable is latest. | The artifact users install was opened and executed before publishing. |

Do not create a file because the tree looks symmetric. Add a conditional row
only when the failure mode is present, and say which one:

- **Surface matrix:** the product has more than one client, entry point,
  provider, connection mode or reverse state.
- **Real-client verification skill:** there is a UI or integration surface
  worth driving through the product itself.
- **Agent context budget:** the model loads a router, skills or tool schemas up
  front and the text tends to grow.
- **Evals:** the product has prompts, tool descriptions, generated titles or
  other model-facing text.
- **Review agents:** the repo uses AI review and needs one concern per agent.
- **Contribution triage:** outside PRs arrive and policy must be enforced.
- **Release candidate pipeline:** releases are frequent and packaging is
  non-trivial.

## How to fill them

### 1. Detect the facts

Record, do not guess:

- languages, package managers, build, format/lint, typecheck, unit, integration
  and full-suite commands; whether the full suite runs locally or in CI;
- how CI selects jobs, and whether selection fails open when the diff is
  unresolved;
- release/tag/publish path, artifact smoke, channels;
- platforms, state directories, config formats, credentials, migrations;
- test isolation (temp home, pinned caches, fakes), and existing test lint;
- agent-facing context (router, skills, tool descriptions/schemas);
- surfaces (clients, entry points, providers, agents, contracts, connection
  modes, reverse states);
- model-facing text (prompts, tool descriptions, titles);
- high-risk areas and existing docs.

Run every command you plan to write. Record the output and duration. If a
command fails on a clean tree, it is a known red; file it, do not write it as a
passing gate.

### 2. Mine 3–8 real lessons

Use the last 60–90 days or 200 commits. Look for reverts, hotfixes, repeated
fixes, reopened reports, PRs merged with a known problem, cancelled CI runs,
and release incidents.

For each candidate, answer: what rule would have caught this? If the answer is
"be more careful", it is not a lesson. Keep only entries with a commit, issue,
PR, CI run or owner decision. Do not invent history. A new repo may start with
no seeded lessons.

### 3. Write the deliverables

Use the templates. Fill real commands, real evidence, real links. Remove every
`FILL` comment and every placeholder row with no rule behind it.

Order:

1. subsystem references (the 3–7 highest-risk areas);
2. code standards (process rules first, project-specific rows only from mined
   evidence);
3. lessons;
4. AGENTS.md;
5. verify.sh;
6. project skill;
7. CLAUDE.md and PR template;
8. nightly prompt and scheduler;
9. conditional deliverables that apply.

### 4. Validate before handoff

- **Commands.** `verify.sh` runs from the repo root. Every command in
  `AGENTS.md` and the project skill matches. No `TODO` remains unless it is
  explicitly marked not run.
- **Links and budgets.** Every relative link resolves; every named symbol
  exists. `AGENTS.md` ≤120 lines, code standards ≤250, lessons ≤800; trim.
- **Evidence.** Every lesson cites a commit/issue/owner decision; every rule is
  reviewer-checkable.
- **Deliberate break.** Revert a recent fix in a scratch branch, run the test
  named in its commit; it must fail. Restore. If it does not, the test is not a
  guard.
- **Fresh-agent trace.** From `AGENTS.md` alone, a reader finds the owning
  subsystem doc, the relevant lesson and the verify command in ≤3 reads.
- **Bad-change test.** Make a plausible mistake (old value on an error path,
  skipped write, wrong unit) and confirm at least one gate catches it.
- **Nightly dry run.** Run the prompt against the last day; it must update
  `reviewed-through` and invent nothing.
- **Conditional checks.** If added: the context budget re-measures; the surface
  matrix has no unexplained N/A; review agents stay in scope; an eval case
  failed before the fix; the packaged artifact opened.

## Non-negotiables

1. **No invented commands.** Run every command before writing it down.
2. **No invented lessons.** Every entry cites real evidence.
3. **No generic advice.** "Write clean code" is not a rule. A reviewer must be
   able to check it.
4. **No copying another project's incidents or configuration.** Reuse a process
   rule only when it is true here; never copy a commit hash, vendor rule, bot
   name or threshold.
5. **No overwriting existing agent docs.** Read `AGENTS.md`, `CLAUDE.md`,
   `.cursorrules`, `.github/copilot-instructions.md` and existing skills first;
   merge, do not erase.
6. **No writing outside the repo** without asking. Do not install dependencies,
   change CI permissions, or touch credentials.
7. **No conditional deliverable without its failure mode.** A context budget,
   review bot or release train is not a default.

## Adapting

- **Small repo:** core only; one smoke test, one real-use check, 3–5 lessons.
- **Monorepo:** root `AGENTS.md` routes to package docs; one root `verify.sh`
  calls per-package scripts; one code-standards file unless packages diverge.
- **No CI:** pre-push hook + local cron; the full suite still needs a record.
- **Legacy code:** characterize the area with tests first; write subsystem docs
  from the code, not the old wiki.
- **Large/multi-surface:** add the surface matrix, real-client verification
  skill, fast/full split, context budget and scoped review agents.
- **Model-facing:** add the context budget and evals.
- **Frequent packaged releases:** add the release candidate pipeline.

## Handoff

Report:

- files created and why;
- commands run, with result and duration;
- lessons seeded, each with its evidence;
- conditional deliverables added, and the failure mode each catches;
- what is `TODO` / `not run` and why;
- the first nightly review date and trigger;
- owner decisions still needed.

Do not claim the setup is complete if a gate is unverified. Say what is
unverified.

## Copy-paste invocation

```
Use better-coding-init on this repository.

1. Detect the real stack, commands, CI, release path, surfaces and high-risk
   areas.
2. Mine the last 90 days of reverts, hotfixes and repeated fixes for 3-8
   lessons with commit/issue evidence.
3. Produce the core deliverables: AGENTS.md, CLAUDE.md, LESSONS.md,
   docs/code-standards.md, docs/subsystems/ (3-7 areas), scripts/verify.sh,
   a project-specific skill, a PR template and the nightly review.
4. Add a conditional deliverable only where its failure mode exists: surface
   matrix, real-client verification skill, agent context budget, evals, scoped
   review agents, contribution triage, release candidate pipeline.
5. Validate: run verify.sh, revert a recent fix and confirm the test fails,
   check links/budgets, dry-run the nightly prompt.
6. Report what was verified, what is not run, and what the owner must decide.

Do not invent a command, lesson or rule. Do not overwrite existing agent docs;
merge them. Do not push to main.
```

For an audit-only pass:

```
Use better-coding-init in audit-only mode: inspect this repo, propose the
deliverable set, the gate map, the 5 strongest lessons with evidence, and the
3 riskiest subsystems. Do not write files yet.
```
