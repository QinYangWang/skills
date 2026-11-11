# Converge: one run, to the current harness

One invocation does everything. The agent never picks a mode: it reads the
repository's state and then builds, upgrades, repairs, or reports that nothing is
needed. Building and upgrading are the two things this procedure can do, not two
commands a user has to know.

Read `../SKILL.md` for the contract this writes and `file-contract.md` for what
each file is for. Use `../templates/`.

## 0. Detect the state

Read `AGENTS.md` if it exists; otherwise treat the repo as empty. The stamp on
the line under the title (`<!-- repo-governance harness: v2 -->`) is the only
version signal.

A legacy `<!-- better-coding harness: v2 -->` stamp is the same harness v2: the
skill was renamed, nothing else changed. Treat such a repo as current and
rewrite the line to the new name on the next run.

| State | Signal | What this run does |
| --- | --- | --- |
| **Empty** | no `AGENTS.md`, no harness files | Full build: write the core set, then the conditional files that apply. |
| **Partial** | some harness files, no entry, or an entry without the rest | Full build around what exists: keep what is true, add what is missing, point the route table at real files. |
| **Older** | a repo-governance entry whose stamp is older than the current harness | Upgrade first (section 2), then finish the build for anything still missing. |
| **Current** | stamp equals the current harness | Check the shape with section 3's first two bullets. If nothing drifted, report "already current" and change nothing. |
| **Foreign** | `AGENTS.md` is not a repo-governance entry: no stamp, a different shape | Do not convert it silently. Merge its facts into a new entry, keep every rule it carries, and say what moved where. |
| **Drifted** | current stamp, but a second entry file, a missing on-demand doc, or an entry that no longer carries the first read | Repair only the named drift; do not rebuild. |

State what you detected and what you did with each file. A run that changes
nothing is a valid result and must say so.

## 1. Full build

The output is not a documentation tree: it is **one entry file, docs read on
demand, and one command that runs the gates**.

### The one rule

A fresh agent must be able to start from `AGENTS.md` alone:

- it names the commands (fast check, full suite, real use);
- it holds the rules that apply to every change;
- it routes to at most one more document for the area being changed;
- it does not require `LESSONS.md`, `docs/code-standards.md` or a subsystem
  reference to be read before the first edit.

Every other file exists for a question the agent asks later. A file that must be
read before starting is a bug in the entry file.

### Core — always

| # | Path | What it must contain | Done when |
| --- | --- | --- | --- |
| 1 | `AGENTS.md` | Entry: harness stamp, identity, commands (fast/full/real use), the rules in one screen, branch and commit rules, task-to-doc route table, evidence block, agent safety, human gates. ≤ 150 lines. | A fresh agent reaches the verify command and the owning doc from this file alone, in one read; the stamp names the current harness. |
| 2 | `LESSONS.md` | 3–8 real lessons (rule, evidence, fix, `Seen N×`), `reviewed-through` SHA, promotion rule. Header says: search it, do not read it end to end. | Every entry cites a commit/issue/owner decision. |
| 3 | `docs/code-standards.md` | Reviewer-checkable rules, test rules, evidence matrix, acceptance criteria, commit and merge rules. Header says: grep the rule you need. | No rule is a slogan; every row says what a reviewer checks. |
| 4 | `docs/subsystems/README.md` + 3–7 `docs/subsystems/<area>.md` | Map of high-risk areas; each reference has responsibilities, source links, runtime path, contracts, failure behavior, verification. | Every source link resolves; only non-obvious cross-component behavior is documented. |
| 5 | `scripts/verify.sh` | One command for the local gates: commit lint, changed-scope check, tests, real-use, not-run report. Full suite may be CI; the script says where. | Runs from the repo root; fails on a deliberate break or an unfilled `TODO`. |
| 6 | `CLAUDE.md` | `@AGENTS.md` and `@LESSONS.md`, nothing else. | Claude Code loads the same entry. |
| 7 | `.github/pull_request_template.md` | Change kind and base branch, goal, semantic change, cost, evidence, risk/rollback, checklist. | An empty PR cannot be opened without naming its evidence. |
| 8 | `docs/nightly-review.md` + scheduler | Prompt from `templates/nightly-review-prompt.md`, filled with project name and range; runs from `reviewed-through`, opens a PR, never pushes the stable line. | A dry run updates `reviewed-through` and invents no evidence. |

### Conditional — only when the failure mode exists

| # | Path | Add it when | Done when |
| --- | --- | --- | --- |
| 9 | `docs/surface-matrix.md` | More than one client, entry point, provider, connection mode or reverse state. | Every row has applies/N/A, what changes, verification; N/A has a reason. |
| 10 | `.agents/skills/test-<project>-app/SKILL.md` | There is a UI or integration surface worth driving through the product itself. | A real-client pass leaves the environment usable and the evidence attached. |
| 11 | Agent context budget + measuring test | The model loads an entry file, skills or tool schemas up front and the text tends to grow. | Editing the budget alone fails; growth needs the owner's approval. |
| 12 | `evals/` | The product has prompts, tool descriptions, generated titles or other model-facing text. | A case actually fails on the old text before passing on the new. |
| 13 | `.github/review-agents/<concern>.md` | The repo uses AI review and needs one concern per agent. | A dry run finds only in-scope issues; empty review is unambiguous. |
| 14 | `docs/contributors.md` + triage contract | Outside PRs arrive and policy must be enforced. | A missing policy file stops the run; PR text cannot change exemptions. |
| 15 | `docs/contributing.md` + commit lint + generated changelog | More than one release line, outside contributors, or a changelog assembled from commits. | A feature opened against the stable line breaks the rule; a bad header fails the lint; the changelog regenerates from the range. |
| 16 | `docs/plans/<date>-<slug>.md` | New API surface is proposed and needs approval before code. | The note names problem, surface, rejected alternatives, cost and migration, with the owner's approval. |
| 17 | Release candidate pipeline | Releases are frequent and packaging is non-trivial. | The artifact users install was opened and executed before publishing. |

Do not add a conditional file because the tree looks symmetric. Add it when the
failure mode is present, and say which one in the handoff.

### Fill them

**Detect the facts.** Record, do not guess:

- languages, package managers, build, format/lint, typecheck, unit, integration
  and full-suite commands; whether the full suite runs locally or in CI;
- how CI selects jobs, and whether selection fails open when the diff is
  unresolved;
- long-lived branches, the target-branch rule, commit lint and changelog
  generation;
- release/tag/publish path, artifact smoke, channels;
- platforms, state directories, config formats, credentials, migrations;
- test isolation (temp home, pinned caches, fakes), and existing test lint;
- agent-facing context (entry file, skills, tool descriptions/schemas);
- surfaces (clients, entry points, providers, contracts, connection modes,
  reverse states);
- model-facing text (prompts, tool descriptions, titles);
- high-risk areas and existing docs.

Run every command you plan to write. Record the output and duration. If a command
fails on a clean tree, it is a known red: file it, do not write it as a passing
gate.

**Mine 3–8 real lessons.** Use the last 60–90 days or 200 commits. Look for
reverts, hotfixes, repeated fixes, reopened reports, PRs merged with a known
problem, cancelled CI runs and release incidents. For each candidate answer: what
rule would have caught this? If the answer is "be more careful", it is not a
lesson. Keep only entries with a commit, issue, PR, CI run or owner decision. Do
not invent history; a new repo may start with no seeded lessons.

**Write in this order:** subsystem references; code standards; lessons; the entry
file last, so it routes to what exists; `verify.sh`; `CLAUDE.md` and the PR
template; the nightly prompt; the conditional files that apply.

Use the templates, fill real commands and evidence, and remove every `FILL`
comment and placeholder row with no rule behind it.

## 2. Upgrade an older harness

The entry file carries its harness version. An older stamp, or none on a file
that is already a repo-governance entry, means the repo predates the current
conventions.

### Current harness

| Harness | Contract | Upgrade by |
| --- | --- | --- |
| v1 | Two skills (`repo-governance` + `repo-governance-init`); the agent read `AGENTS.md`, one subsystem doc, `LESSONS.md` and `docs/code-standards.md` before editing; a per-project coding skill duplicated the entry; twelve rules; no branch model. | The v1 → v2 steps below. |
| **v2 (current)** | One skill, one run. `AGENTS.md` is the only mandatory read and holds a one-screen rule digest; everything else is on demand; no per-project coding skill; sixteen rules; branch and commit gates; PR template names change kind, base branch and cost. | — |

### Plan first

Upgrading is a patch, not a rewrite. Before editing, print the plan and stop for
the owner when any row is a delete or a rename:

```
Detected: harness v1 (no stamp; read-order section present; project skill found)
Target:   v2
| File | Action | Why |
| AGENTS.md | rewrite entry sections, keep facts and gates | entry contract changed |
| .agents/skills/x-coding/SKILL.md | delete | one entry, one first read |
| CLAUDE.md | rewrite to two lines | shim, not a second entry |
| LESSONS.md, docs/code-standards.md | add header line | on-demand markers |
| verify.sh | add commit-lint step | new first gate |
Left alone: docs/subsystems/*, lesson entries, docs/plans/*, project values, owner decisions.
```

### v1 → v2

Do these in order; a step that does not apply is skipped and said so.

1. **Stamp and entry shape.** Add the stamp. In `AGENTS.md`, keep the project
   facts, commands, subsystem decisions and human gates; replace the read-order
   list with a route table that names at most one document per task, and add the
   one-screen rule digest. Budget ≤150 lines.
2. **Remove the second entry.** Delete `.agents/skills/<project>-coding/` (or
   shrink it to two pointer lines), and make `CLAUDE.md` exactly `@AGENTS.md` +
   `@LESSONS.md`.
3. **Mark the on-demand files.** `LESSONS.md`: search it, do not read it end to
   end. `docs/code-standards.md`: grep the rule you need.
4. **Branch and commit section.** Target-branch table, header convention, footer
   links (`close #`, `BREAKING CHANGE:`), generated changelog, design-note gate
   for new surface. Add `docs/contributing.md` when the repo has more than one
   release line.
5. **PR template.** Change kind, base branch, design note, cost; keep the
   evidence block.
6. **verify.sh.** Add the commit-header lint step as the first gate.
7. **Rules table.** Bring any locally added rule across; do not drop a project
   rule to fit the sixteen.
8. **Stamp the current version** and validate.

### Upgrade rules

1. **Keep every fact the repo added.** Commands, thresholds, names, paths and
   owner decisions survive verbatim. The upgrade rewrites structure, not the
   project's content.
2. **Only the named sections move.** A section the version table does not name
   stays byte for byte.
3. **Never delete evidence.** `LESSONS.md` entries, subsystem references,
   `docs/plans/`, release notes and the change log stay.
4. **Idempotent.** Running the whole procedure again must change nothing,
   because the stamp matches. If it plans changes again, the stamp or the plan is
   wrong.
5. **One commit.** `chore(repo-governance): converge harness v1 -> v2`, body naming
   the plan and what was left alone.
6. **Owner gates hold.** Deleting a file, renaming the entry, touching CI or
   branch protection goes through the human gates in `SKILL.md`.
7. **No inventing.** If an old file holds content the new shape has no home for,
   say where it goes or ask; never drop it silently.

## 3. Validate the run

- **One-read trace.** From `AGENTS.md` alone, a reader reaches the owning
  subsystem doc, the relevant lesson and the verify command. If they must open a
  second file before the first edit, the entry file is wrong.
- **Harness stamp.** `AGENTS.md` carries the current stamp, so the next run knows
  whether anything is due.
- **Commands.** `verify.sh` runs from the repo root. Every command in `AGENTS.md`
  matches it. No `TODO` remains unless explicitly marked not run.
- **Links and budgets.** Every relative link resolves; every named symbol
  exists. `AGENTS.md` ≤150 lines, code standards ≤250, lessons ≤800.
- **Evidence.** Every lesson cites a commit/issue/owner decision; every rule is
  reviewer-checkable.
- **Deliberate break.** Revert a recent fix in a scratch branch, run the test
  named in its commit; it must fail. Restore. If it does not, the test is not a
  guard.
- **Bad-change test.** Make a plausible mistake (old value on an error path,
  skipped write, wrong unit) and confirm at least one gate catches it.
- **Branch and commit gates, if added.** A feature opened against the stable line
  breaks the documented rule; a bad commit header fails the lint; the changelog
  regenerates from the same range.
- **Second run.** Run the procedure again; it must report "already current" and
  change nothing.
- **Nightly dry run.** Run the prompt against the last day; it must update
  `reviewed-through` and invent nothing.

## Non-negotiables

1. **No invented commands.** Run every command before writing it down.
2. **No invented lessons.** Every entry cites real evidence.
3. **No generic advice.** "Write clean code" is not a rule. A reviewer must be
   able to check it.
4. **No copying another project's incidents or configuration.** Reuse a process
   rule only when it is true here; never copy a commit hash, vendor rule or
   threshold.
5. **No overwriting existing agent docs.** Read `AGENTS.md`, `CLAUDE.md`,
   `.cursorrules`, `.github/copilot-instructions.md` and existing skills first;
   merge, do not erase.
6. **No writing outside the repo** without asking. Do not install dependencies,
   change CI permissions, or touch credentials.
7. **No conditional deliverable without its failure mode.**
8. **No second entry file.** A per-project skill that repeats `AGENTS.md` doubles
   the first read. Keep the entry in one place; `CLAUDE.md` is a two-line shim.

## Adapting

- **Small repo:** core only; one smoke test, one real-use check, 3–5 lessons.
- **Monorepo:** root `AGENTS.md` routes to package docs; one root `verify.sh`
  calls per-package scripts; one code-standards file unless packages diverge.
- **No CI:** pre-push hook plus local cron; the full suite still needs a record.
- **Legacy code:** characterize the area with tests first; write subsystem docs
  from the code, not the old wiki.
- **Large/multi-surface:** add the surface matrix, real-client verification
  skill, fast/full split, context budget and scoped review agents.
- **More than one release line:** add the branch model, the target-branch table,
  the design-note gate, commit lint and a generated changelog.
- **Model-facing:** add the context budget and evals.
- **Frequent packaged releases:** add the release candidate pipeline.

## Handoff

Report:

- the state detected and what was done to each file (built, upgraded, repaired,
  kept, moved);
- files created and why;
- commands run, with result and duration;
- lessons seeded, each with its evidence;
- conditional deliverables added, and the failure mode each catches;
- what is `TODO` / not run and why;
- the first nightly review date and trigger;
- owner decisions still needed.

Do not claim the run is complete if a gate is unverified. Say what is
unverified. "Already current" is a complete report when it is true.

## Copy-paste invocation

```
Use repo-governance on this repository.

1. Detect the state: empty, partial, older harness, current, foreign entry or
   drifted. Say which, and what each existing file needs.
2. Build what is missing, or upgrade an older harness with a plan first. Keep
   every project fact, lesson, subsystem reference and design note; never stop
   because a file already exists.
3. Validate: one-read trace from AGENTS.md alone, verify.sh, a deliberate bad
   change, a bad commit header, and a second run that reports "already current".
4. Report what changed, what was left alone, and what the owner must decide.

Do not invent a command, lesson or rule. Do not overwrite existing agent docs;
merge them. Do not push the stable line.
```

An audit-only run:

```
Use repo-governance in audit-only mode: detect the state, name the files that are
missing, stale or duplicated, list the 5 strongest lessons with evidence, and
propose the 3 riskiest subsystems. Do not write files yet.
```
