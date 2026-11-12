---
name: repo-governance
description: Writes the five documents an agent needs in a repository — an index, a collaboration guide, review rules, decisions and postmortems — and keeps them true. Use when a repo has no such docs, a partial or stale set, or an entry that claims a harness it does not have.
---

# Repo Governance

One run. Five files. Then the repository runs itself.

This is a reference, not a compliance checklist: every rule below names why it exists, and the run reports what it skipped.

## What it writes

| File | Job | One rule |
| --- | --- | --- |
| `AGENTS.md` | Index: what the repo is, the commands, one row per module, routes to the four documents, what needs the owner. | It points; it does not explain. |
| `docs/COLLAB.md` | Which branch a change kind takes, how to develop, how to commit and open a PR. | One branch, one kind. |
| `docs/REVIEW.md` | What a reviewer checks, by change kind. | Every row cites `D-###`, `P-###` or an issue. |
| `docs/DECISIONS.md` | Settled choices: what, why, what it forbids, who, when. | Append-only. |
| `docs/POSTMORTEMS.md` | What broke, why, which layer, and the review row it produced. | No row, no entry. |

Modules keep their own docs and index: an existing `README.md`, `AGENTS.md` or `docs/modules/<module>.md`. `AGENTS.md` only points at them.

## Read this much

This file. A template only while you write that file. Nothing else in this skill.

## Process

### 1. Survey the repository

```bash
ls
git log --oneline -30
git branch -a && git tag --sort=-v:refname | head -5
ls .github/workflows .gitlab-ci.yml Makefile justfile 2>/dev/null
grep -rl "CONTRIBUTING\|CODE_OF_CONDUCT" . --include='*.md' 2>/dev/null | head
```

Record: stack and package manager, install/test/build/lint commands (run them), the branch that ships, the modules and where each one's docs live, owner gates, and what already documents this repo.

**Done when** every fact is a command you ran or a file you read — not an assumption.

### 2. Pick the size

- **No history yet** (few commits, no CI): write all five, each short. Zero postmortems is a valid result; write `None yet — add one after the first regression.`
- **Some history**: same five; mine up to five incidents from the last 90 days.
- **Already has docs**: keep them. Add the missing ones, point `AGENTS.md` at what exists, and never move a file without the owner.

A sixth file needs the failure mode it catches. Say which, in the report.

### 3. Write in this order

`COLLAB.md` → `REVIEW.md` → `DECISIONS.md` → `POSTMORTEMS.md` → `AGENTS.md` last, so the index only points at what exists.

### 4. Fill real facts

- Run every command before writing it. A command that fails stays out, or is written as a known red with the failure.
- A branch model comes from CI, branch protection or the owner. If none says, ask once; do not invent one.
- A decision needs an owner and a date. If you cannot name them, it is not a decision — it is your preference.
- A postmortem needs a commit, issue or incident, plus the layer: process, code, permissions, docs. The layer decides the fix: a gate, a test, a constraint, a sentence.
- Branch and commit rules, review rows and decisions are the owner's, not yours. Ask.

### 5. Validate

- From `AGENTS.md`, through one module's docs, a reader reaches the file to change. Two hops, not three.
- Every row in `REVIEW.md` cites a source.
- Every postmortem names a review row.
- No `FILL` block and no unfilled `<PROJECT>`, `<module>` or `<command>` left; branch
  patterns like `fix/<slug>` keep their shape.
- Commands run from the repo root as written.
- Run the whole thing again: it reports `already current` and writes nothing.

### 6. Report

State what you detected, which files you wrote or kept, which postmortems and decisions came from evidence, what you could not verify, and which files you deliberately skipped with the reason.

## Rules

- **Five files.** No nightly job, no verify script, no per-project skills. If the repo already has one of those, point at it instead of replacing it.
- **No invented facts.** Unknown branch model, unknown owner, unknown command: ask, or write `TODO` and say so in the report. Never fill it with a plausible default.
- **No numbers.** No budgets, no hit rates, no saved-percentage. Length is controlled by promotion: a rule that becomes a test leaves the postmortem, and a row that catches nothing is deleted.
- **Idempotent.** A stamp, not a diff: `<!-- repo-governance: v3 -->` under the title. A second run with the same stamp changes nothing.

## Legacy layouts

A repository written by an earlier draft may carry `docs/subsystems/`, `docs/code-standards.md`, `LESSONS.md`, `scripts/verify.sh` or project skills. Do not delete them. Map and keep: subsystem pages are module docs, `code-standards.md` becomes `REVIEW.md`, `LESSONS.md` becomes `POSTMORTEMS.md`, and the extra scripts stay where they are and get a pointer. Report what moved.

## Stop and ask

Before: reversing a decision; changing CI, release scripts, permissions or secrets; changing the branch model; deleting or moving an existing document; an irreversible migration; publishing, spending, contacting users, or making a public claim.