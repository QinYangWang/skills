# Agent Skills

[![skills.sh](https://skills.sh/b/QinYangWang/skills)](https://skills.sh/QinYangWang/skills)

Two skills for agents that do real work in real repositories:

- **[align-with-me](./skills/align-with-me/SKILL.md)** — agree on the requirement, the plan and the acceptance criteria before any work starts.
- **[repo-governance](./skills/repo-governance/SKILL.md)** — give a repository the harness its agents read, once, then keep it current.

## Install

From GitHub:

```bash
npx skills add QinYangWang/skills -g
```

Choose `align-with-me` and `repo-governance` for your agent (Pi, Claude Code,
Codex, Cursor, and the rest). To list first:

```bash
npx skills add QinYangWang/skills --list
```

While developing this folder locally, use `npx skills add ./ -g` instead.

## Two skills, two moments

**Before the work: align.** A vague request is not a plan. `align-with-me` makes
the agent interview the user in rounds — every question that can be asked now,
numbered, with a recommended answer — until the requirement, the plan and the
acceptance criteria are agreed in writing. Only then does it execute.

**Once per repository: govern.** An agent-maintained repo fails in predictable
ways: the fix covers the screenshot but not the class, the new test passes on the
old code, the full suite was never run, the commit says "tests passed" without
saying what ran. `repo-governance` writes the harness that prevents those: one
entry file (`AGENTS.md`), docs read on demand, a verify command, and the nightly
lesson loop.

## Reference

- **[align-with-me](./skills/align-with-me/SKILL.md)** — the design tree, the
  question rounds with recommended answers, the Spec block (understood / plan /
  acceptance / not doing / assumptions), the questionnaire for what the user
  cannot answer, and the rule that nothing executes before confirmation.
- **[repo-governance](./skills/repo-governance/SKILL.md)** — one command that
  detects the state and converges the repository on the current harness:
  `AGENTS.md` as the only mandatory read, everything else on demand, a harness
  stamp, and an idempotent second run.

> `repo-governance` was published as `better-coding`. A repository stamped
> `<!-- better-coding harness: v2 -->` is treated as current and renamed to the
> new stamp on its next run.

## Use

### 1. Align before a task

```
/skill:align-with-me
Add export to the settings page.
```

The agent reads the code, asks the decisions in one numbered round with
recommendations, then writes the Spec block and waits. It starts only after you
confirm. If a decision needs someone else's knowledge, it writes
`align-questionnaire-<slug>.md` for you to hand over.

### 2. Set up a repository once

```bash
cd /path/to/your/repo
```

```
/skill:repo-governance
```

It detects the state — no harness, a partial one, an older harness, a foreign
`AGENTS.md` — and converges the repo on the current harness: the entry file,
the docs it routes to, `scripts/verify.sh`, the PR template and the nightly
review. It reports what happened to every file, then stops being needed.

### 3. The repository runs itself

From here the work is the repository's own loop: an agent reads `AGENTS.md`,
follows its route table, and leaves the evidence block in the commit. Neither
skill needs to be loaded again.

### 4. When the conventions change

Run `/skill:repo-governance` again. The entry file carries a harness stamp; an
older stamp makes the run print a plan, patch only the sections the version
table names, keep every project fact and all evidence, and stamp the new
version. A second run must report `already current`.

## Repository layout

```
skills/
├── align-with-me/
│   └── SKILL.md
└── repo-governance/
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

- **Align before executing.** A request is a starting point, not a spec. The
  requirement, the plan and the acceptance criteria are agreed in writing first.
- **One entry file.** A repo's agent reads `AGENTS.md` once; everything else is
  on demand and named by its route table.
- **One convergent command.** The same run builds, upgrades or reports nothing
  to do, guided by the stamp in the entry file.
- **No generic advice.** Every generated rule cites a commit, issue, incident or
  explicit owner decision.
- **No invented commands.** Unverified commands stay `TODO`.
- **A generated file must earn its read.** If nobody reads it and no gate checks
  it, it does not belong in the repository.
- **Human gates stay human:** product decisions, security, credentials,
  irreversible migrations, spending and community conduct.
- **Portable.** Markdown and shell only; no runtime dependency.

## License

MIT. See [LICENSE](./LICENSE).
