# Agent Skills

[![skills.sh](https://skills.sh/b/QinYangWang/skills)](https://skills.sh/QinYangWang/skills)

One skill for agents that do real work in real repositories:

- **[repo-governance](./skills/repo-governance/SKILL.md)** — give a repository the harness its agents read on demand, once, then keep it current. It also writes the rule that starts every task: align with the user first.

## Install

From GitHub:

```bash
npx skills add QinYangWang/skills -g
```

Choose `repo-governance` for your agent (Pi, Claude Code, Codex, Cursor, and
the rest). To list first:

```bash
npx skills add QinYangWang/skills --list
```

While developing this folder locally, use `npx skills add ./ -g` instead.

## One skill, one moment

**Once per repository: govern.** An agent-maintained repo fails in predictable
ways: the fix covers the screenshot but not the class, the new test passes on the
old code, the full suite was never run, the commit says "tests passed" without
saying what ran. `repo-governance` writes the harness that prevents those: an
index entry (`AGENTS.md`), one page per area that owns its own facts, review
rules that trace to a decision or a postmortem, the project skills that drive the
product and reproduce a report, and the lesson loop.

**Before every task: align.** The generated entry opens with the rule that used
to be a second skill: restate the goal, the smallest change and the acceptance;
ask only for a call a run cannot settle; go on reversible single-area work, and
wait before anything irreversible, public or cross-area.

## Reference

- **[repo-governance](./skills/repo-governance/SKILL.md)** — one command that
  detects the state and converges the repository on the current harness:
  `AGENTS.md` as an index, one page per area, review rows traced to decisions and
  postmortems, the project skills the failure modes call for, a stamp, and an
  idempotent second run.

> `repo-governance` was published as `better-coding`. A repository stamped
> `<!-- better-coding harness: v2 -->` is treated as current and renamed to the
> new stamp on its next run.

## Use

### 1. Set up a repository once

```bash
cd /path/to/your/repo
```

```
/skill:repo-governance
```

It detects the state — no harness, a partial one, an older harness, a foreign
`AGENTS.md` — and converges the repo on the current harness: the entry file,
the docs it routes to, `scripts/verify.sh`, the PR template, the nightly review,
and the project skills the repo's failure modes call for. Each skill is
instantiated from a preset, run once end to end, and routed to from the entry.
It reports what happened to every file and every skill, then stops being needed.

### 2. The repository runs itself

From here the work is the repository's own loop: an agent reads `AGENTS.md`,
follows its route table, and leaves the evidence block in the commit. The skill is
not needed again.

### 3. When the conventions change

Run `/skill:repo-governance` again. The entry file carries a harness stamp; an
older stamp makes the run print a plan, patch only the sections the version
table names, keep every project fact and all evidence, and stamp the new
version. A second run must report `already current`.

## Repository layout

```
skills/
└── repo-governance/
    ├── SKILL.md
    ├── references/
    │   ├── converge.md
    │   ├── file-contract.md
    │   ├── contribution-and-branches.md
    │   ├── change-protocol.md
    │   ├── quality-gates.md
    │   ├── lesson-loop.md
    │   ├── skill-presets.md
    │   └── worked-example.md
    └── templates/
        ├── AGENTS.md, verify.sh, ...
        └── skills/
            ├── verification-SKILL.md
            ├── repro-SKILL.md
            ├── release-SKILL.md
            ├── feature-map-README.md
            └── feature.md
```

Every skill is a directory with a `SKILL.md`. Reference and template files stay
inside the skill they belong to. `templates/skills/` holds the project-skill
presets: the run instantiates one into the target repo's own skill folder when
the matching failure mode exists.

## Design rules

- **Align before executing.** The generated entry's first rule: the need, the
  plan and the acceptance are restated and confirmed before a file changes.
- **One entry file, and it is an index.** A repo's agent reads `AGENTS.md` once;
  it points at one area page per task, and each area page owns its own facts,
  commands, index, failure modes and decisions.
- **One convergent command.** The same run builds, upgrades or reports nothing
  to do, guided by the stamp in the entry file.
- **Docs are read; skills are run.** A preset exists only for a command the
  entry cannot hold (launch, drive, capture, publish) and only where its failure
  mode exists; a skill that repeats a rule is still a second entry.
- **No generic advice.** Every review row cites a decision, a postmortem or an
  issue; every postmortem produces one review row, or it is unfinished.
- **No invented commands.** Unverified commands stay `TODO`.
- **A generated file must earn its read.** If nobody reads it and no gate checks
  it, it does not belong in the repository.
- **Human gates stay human:** product decisions, security, credentials,
  irreversible migrations, spending, public releases and community conduct.
- **A generated skill that was never executed is a draft.** The run proves each
  installed preset on one real journey before routing the entry at it.
- **Portable.** Markdown and shell only; no runtime dependency.

## License

MIT. See [LICENSE](./LICENSE).
