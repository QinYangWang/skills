---
name: repo-governance
description: Converges one repository's agent harness (AGENTS.md plus the docs it reads on demand) to the current version, then leaves it alone. Use when a repo has no harness, a partial one, a foreign AGENTS.md, or an older harness stamp.
---

# Repo Governance

One run brings this repository to the harness contract below. After it, `AGENTS.md` runs the work and this skill is read again only when the conventions move.

## Harness Contract

- `AGENTS.md` is the only mandatory read: ≤150 lines, one read, start to end. It names the commands, the rules every change needs, and a route table pointing to at most one more document per task.
- Everything else is on demand: `LESSONS.md` searched, `docs/code-standards.md` grepped, one `docs/subsystems/<area>.md` read, `scripts/verify.sh` run and never read.
- One entry only. No per-project coding skill; `CLAUDE.md` is two lines pointing at the entry.
- The commit body is the evidence: red check, break check, full suite and where it ran, real use, not-run list.
- Every rule cites a commit, issue, incident or owner decision. A command nobody ran stays `TODO`.
- `AGENTS.md` carries its harness stamp on the line under the title: `<!-- repo-governance harness: v2 -->`. The stamp changes only when the conventions do.
- The run is idempotent: once the stamp matches, a second run reports `already current` and writes nothing.

## State Gate

Read `AGENTS.md`, then its stamp. If there is no entry, the repo is empty.

| State | Action |
| --- | --- |
| No harness, or some files without an entry | Build what is missing, entry last. |
| repo-governance entry, older stamp | Upgrade first, then finish anything still missing. |
| repo-governance entry, current stamp | Check the shape; repair a named drift only; otherwise change nothing. |
| `AGENTS.md` that this skill did not write | Do not convert it. Merge its facts and rules into a new entry and report what moved. |

Never stop because a file already exists, and never convert a foreign entry silently.

## Process

### 1. Detect the state

```bash
ls AGENTS.md CLAUDE.md LESSONS.md docs scripts/verify.sh 2>/dev/null
sed -n '1,3p' AGENTS.md 2>/dev/null
git status --short && git log --oneline -5
```

Name the state, and for every existing harness file say keep, merge, rewrite or delete.

**Complete when:** the state is named and every existing file has a decision.

### 2. Load the procedure

Read `references/converge.md` for the deliverable tables, the fill order, the version table and the upgrade rules. Read `references/file-contract.md` for budgets and what each file is for. Take shapes from `templates/`.

**Complete when:** the required file list for this repo is known, core and conditional separated.

### 3. Build or upgrade

Build: write subsystem references, code standards, lessons, `AGENTS.md` last (it routes to what exists), `verify.sh`, `CLAUDE.md`, the PR template, the nightly prompt. Add a conditional file only where its failure mode exists.

Upgrade: print the plan as a table (file, action, why) before editing. Apply only the sections `converge.md`'s version table names, keep every project fact verbatim, and stop for the owner on any delete or rename.

**Complete when:** every required file exists with no `FILL` or placeholder left, and an upgrade has its plan applied or explicitly refused.

### 4. Fill real facts

Run every command before writing it down. Mine 3–8 lessons from the last 60–90 days: reverts, hotfixes, repeated fixes, reopened reports, cancelled runs. A lesson without a commit, issue or owner decision is not a lesson.

**Complete when:** each command in `AGENTS.md` ran here with recorded output, and each lesson names its evidence.

### 5. Validate

- From `AGENTS.md` alone, reach the owning subsystem doc, the relevant lesson and the verify command. A second file needed before the first edit is a bug in the entry.
- Stamp matches the current harness.
- `scripts/verify.sh` runs; a commit with a bad header fails its lint.
- Revert a recent fix in a scratch branch and watch its named test fail.
- Make a plausible mistake and confirm a gate catches it.
- Run the skill again: it must report `already current` and change nothing.

**Complete when:** each check passed, or is listed as not run with the reason.

### 6. Report

State the detected state, what happened to each file (built, merged, upgraded, kept, moved), commands run, lessons seeded, conditional files added with their failure mode, unverified items, and owner decisions still open.

**Complete when:** the report answers every item and `already current` is said plainly when it is true.

## Stop and ask

Stop before: reversing an owner decision or documented rule; touching security, credentials, permissions, release scripts or update feeds; changing the branch model, branch protection or commit lint; approving or landing a new API surface without its design note; writing a live state directory or a running dev server; an irreversible migration or deletion; spending money, contacting users or making a public claim; blocking a community author.

Adapted from magpie's agent workflow and Vue's contributor guide.
