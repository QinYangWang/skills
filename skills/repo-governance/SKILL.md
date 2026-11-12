---
name: repo-governance
description: Gives one repository the documents its agents read on demand — an index entry, per-area pages, review rules, decisions and postmortems — and keeps them current. Use when a repo has no harness, a partial one, a foreign AGENTS.md, or an older harness stamp.
---

# Repo Governance

One run brings this repository to the shape below, then leaves it alone. It is a reference, not a compliance checklist.

## What this is not

- **A default path, not a requirement.** Each deliverable below names when it is not needed. Skip one, and say why in the report.
- **A policy the owner did not choose.** Branch rules, review rules and decisions come from the repo's CI, its history or its owner. Missing, ask; never invent.
- **A documentation tree.** Five jobs, a handful of pages. A page nobody reads is a bug, not a deliverable.

## The shape

| Job | File | Rule |
| --- | --- | --- |
| Index | `AGENTS.md` | One screen. What the repo is, the repo-wide commands, a table of areas pointing at their pages, and the routes to the four documents below. No rule text, no per-area commands, no history. |
| Area | `docs/subsystems/<area>.md` | Each area maintains its own page: what it owns, its entry points, **its own commands and its own index**, its known failure modes, its decisions. An area's facts live here, never in the index. |
| Law | `docs/code-standards.md` | Rules a reviewer checks. Every row names its source: `← D-003`, `← P-002` or `← #412`. A rule with no source is deleted. |
| Constraints | `D-<area>-<n>` inside the area page | Decisions the owner made: what is settled, why, and what it forbids. An agent may not reverse one; if the task needs it, stop and ask. |
| Postmortems | `LESSONS.md` | What went wrong, why, and **which review question now catches it**. Search it by area and symptom; never read it end to end. |

Two hard rules make the shape real:

1. **Every review rule traces to a decision or a postmortem.** A rule nobody's mistake or decision produced is generic advice.
2. **Every postmortem produces one review question.** A postmortem entry with no `Review: R-xx` is unfinished, not filed.

Plus the mechanical ones:

- The generated entry opens with alignment: restate the goal, the smallest change and the acceptance; ask only for product or preference calls; go on reversible single-area work; wait for anything irreversible, public, cross-area or new.
- `CLAUDE.md` is two lines pointing at the index; there is no second entry and no per-project coding skill.
- The commit body carries the evidence: red check, break check, full suite and where it ran, real use, not-run list.
- `AGENTS.md` carries `<!-- repo-governance harness: v3 -->` on the line under the title. Project skills carry their own preset stamp. Stamps change only when the conventions do.
- A second run reports `already current` and writes nothing.

## State Gate

Read `AGENTS.md`, then its stamp. No entry means the repo is empty.

| State | Action |
| --- | --- |
| No harness, or some files without an entry | Build what is missing; the index last. |
| repo-governance entry, older stamp | Upgrade first, then finish anything missing. |
| repo-governance entry, current stamp | Check the shape; repair a named drift only. |
| `AGENTS.md` this skill did not write | Do not convert it. Merge its facts into a new index and report what moved. |

The same gate applies to each installed project skill, by its own `<!-- repo-governance skill: <preset> v1 -->` stamp: current, older (patch the named sections), or no stamp (not ours — merge, never overwrite).

## Process

### 1. Detect

```bash
ls AGENTS.md CLAUDE.md LESSONS.md docs scripts/verify.sh 2>/dev/null
sed -n '1,3p' AGENTS.md 2>/dev/null
find . -maxdepth 3 -type d -name skills -not -path './node_modules/*' -not -path './.git/*'
git log --oneline -90 | head -30
```

Name the state, and for every existing file say keep, merge, rewrite or delete. Note which areas the repo already documents, and where.

**Complete when:** the state is named, every existing file has a decision, and the areas are listed.

### 2. Load the procedure

`references/converge.md` for the fill order and version table; `references/file-contract.md` for what each file holds and what it must not; `references/skill-presets.md` for optional project skills; `templates/` and `templates/skills/` for shapes.

### 3. Build, areas first

Areas, then the law, then the postmortems, then the index last — it can only index what exists. Install a project skill only where its failure mode exists.

**Complete when:** every required page exists with no `FILL` or placeholder left, and the index points only at pages that exist.

### 4. Fill real facts

Run every command before writing it down. Mine 3–8 postmortems from the last 60–90 days; each names its evidence and its fix layer (process, code, permissions, docs).

**Complete when:** each command ran here, and each entry cites a commit, issue or owner decision.

### 5. Validate

- **Two hops.** From `AGENTS.md`, through one area page, a reader reaches the file to change. Three hops means the index holds what the area page should.
- **Traceability.** Every review row cites `D-` or `P-` or an issue; every postmortem names its review row.
- **No duplication.** A rule appears once; a second mention is a link.
- **Stamps** match, and a pasted `FILL` fails the skills gate in `verify.sh`.
- `scripts/verify.sh` runs; a bad commit header fails its lint.
- Each installed skill ran once end to end.
- Second run reports `already current` and changes nothing.

### 6. Report

The state, what happened to each file, the postmortems and the review rows they produced, decisions recorded, skills installed or skipped with the reason, commands run, what is unverified, and any owner decision still open.

## Keep this skill honest

The harness is a draft until a repo uses it.

- Record in each run's report which area page was **not** reached when the task needed it, and which review row failed to catch something it was written for.
- The same miss three times means the trigger is wrong: fix the route or the page's title, not the agent's discipline.
- A page or preset that helps twice in a row and never after gets deleted, or turned into a check the repo runs.
- Never report a hit rate or a saved-percentage figure. Only what was counted.

## Stop and ask

Before: reversing a decision; changing CI, release scripts, permissions or secrets; changing the branch model or commit lint; landing a new surface without its design note; writing a live state directory; an irreversible migration or deletion; spending money, contacting users or making a public claim; renaming or deleting an existing area page or project skill.

Adapted from magpie's agent workflow and Vue's contributor guide.