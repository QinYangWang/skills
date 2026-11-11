# Better Coding Skills

[![skills.sh](https://skills.sh/b/QinYangWang/skills)](https://skills.sh/QinYangWang/skills)

One skill for agents that write, review, merge and release code: the loop, and
the setup that writes the files the loop reads.

Most agent-maintained repositories fail in the same places: the fix covers the
screenshot but not the class, the new test passes on the old code, the full
suite was never run, and the commit says "tests pass" without saying what ran.
This skill makes the repository the agent's memory and makes evidence the gate.

## Install

From GitHub:

```bash
npx skills add QinYangWang/skills -g
```

Choose `better-coding` for your agent (Pi, Claude Code, Codex, Cursor, and the
rest). To list first:

```bash
npx skills add QinYangWang/skills --list
```

While developing this folder locally, use `npx skills add ./ -g` instead.

## The idea: one entry file, one read

A run writes exactly one file the agent must read before starting: `AGENTS.md`.
It carries the commands, the rules a change always needs, and a route table that
names at most one more document per task.

Everything else — `LESSONS.md`, the code standards, the subsystem references,
the verify script — is read **on demand**: searched, grepped, or run. Reading the
whole docs tree is the failure mode this skill removes.

After setup the repository runs itself. An agent that opens `AGENTS.md` and works
by it needs nothing from this skill.

## One command

`/better-coding` converges a repository on the current harness. It reads the
state and acts; there is no mode to choose:

| State it finds | What it does |
| --- | --- |
| no harness, or a partial one | writes what is missing — entry first, then the docs it routes to |
| an older harness stamp | applies the version delta, keeping every project fact and all evidence |
| the current stamp | verifies the shape and changes nothing |
| a foreign `AGENTS.md` | merges its facts into a new entry and says what moved |
| a drift after setup | repairs only the named drift |

Run it once per repository. Later, run the same command to upgrade when this
skill's conventions move. The procedure is
[`references/converge.md`](./skills/better-coding/references/converge.md).

## Use

### 1. Run it once

```bash
cd /path/to/your/repo
```

Then invoke the skill:

```
/skill:better-coding
```

Or say:

```
Use better-coding on this repository.
Detect the state and converge: build what is missing, upgrade an older harness,
or say it is already current.
AGENTS.md is the only entry the agent reads; the rest is on demand.
Add a conditional file only where its failure mode exists.
Do not invent commands, lessons or rules.
```

### 2. Review the generated files

The core set:

- `AGENTS.md` — the only mandatory read: facts, commands, rules in one screen,
  route table, evidence block, gates.
- `LESSONS.md`, `docs/code-standards.md`, `docs/subsystems/` — read on demand.
- `scripts/verify.sh` — run, do not read.
- `CLAUDE.md` — a two-line shim to `AGENTS.md`.
- `.github/pull_request_template.md`, `docs/nightly-review.md`.

Conditional files are added only when they apply: a surface matrix, a
real-client verification skill, an agent context budget, `evals/`, review-agent
contracts, contribution triage, a branch model with commit lint, design notes,
or a release-candidate pipeline.

Fill the real commands and run `scripts/verify.sh`. Then revert a recent fix in
a scratch branch and confirm the named test fails.

### 3. The repository runs itself

From here the work is the repository's own loop, not this skill: an agent reads
`AGENTS.md`, follows its route table, and leaves the evidence block. Nothing
from this skill needs to be loaded again.

### 4. Run the nightly review

Use `docs/nightly-review.md` with a scheduled agent session, cron, or manually:

```
Follow docs/nightly-review.md for yesterday's merged commits.
Only edit LESSONS.md and docs/code-standards.md. Open a PR; never push the
stable line.
```

A lesson seen on three separate days is promoted into the code standards and,
where possible, a guard test.

### 5. When the skill changes

Run the same command again. The entry file carries the harness stamp; when it is
older than the skill, the run prints a plan, patches only the sections the
version table names, keeps every project fact and every piece of evidence, and
stamps the new version. There is no separate migrate command and nothing to
choose.

```
/skill:better-coding
```

The upgrade is a patch, not a rewrite, and running it again afterwards must
change nothing. The version table and the v1 → v2 steps are in
[`references/converge.md`](./skills/better-coding/references/converge.md).

## Repository layout

```
skills/
└── better-coding/
    ├── SKILL.md
    ├── references/
    │   ├── converge.md
    │   ├── file-contract.md
    │   ├── contribution-and-branches.md
    │   ├── change-protocol.md
    │   ├── quality-gates.md
    │   ├── lesson-loop.md
    │   └── worked-example.md
    └── templates/
```

Every skill is a directory with a `SKILL.md`. Reference and template files stay
inside the skill they belong to.

## Design rules

- No generic advice. Every generated rule cites a commit, issue, incident or
  explicit owner decision.
- No invented commands. Unverified commands stay `TODO`.
- One entry file. A repo's agent reads `AGENTS.md` once; everything else is on
  demand and named by its route table.
- One convergent command. The same run builds a repo, upgrades an old harness or
  repairs a drift, guided by the stamp in its entry file; it never asks which.
- A generated file must be worth a read. If nobody reads it and no gate checks
  it, it does not belong in the repository.
- Small budgets. The entry file routes; the code standards hold the rules; the
  lesson notebook holds the evidence.
- Branch by change kind: a fix ships from the stable line, new surface waits on
  the next minor behind a design note, a breaking change asks the owner.
- Human gates stay human: product decisions, security, credentials,
  irreversible migrations, spending and community conduct.
- Portable. Markdown and shell only; no runtime dependency.

## License

MIT. See [LICENSE](./LICENSE).
