# Better Coding Skills

[![skills.sh](https://skills.sh/b/QinYangWang/skills)](https://skills.sh/QinYangWang/skills)

Skills for agents that write, review, merge and release code.

Most agent-maintained repositories fail in the same places: the fix covers the
screenshot but not the class, the new test passes on the old code, the full
suite was never run, and the commit says "tests pass" without saying what ran.
These skills make the repository the agent's memory and make evidence the gate.

## Install

From GitHub:

```bash
npx skills add QinYangWang/skills -g
```

Choose `better-coding` and `better-coding-init` for your agent (Pi, Claude
Code, Codex, Cursor, and the rest). To list them first:

```bash
npx skills add QinYangWang/skills --list
```

To install both to Pi globally without prompts:

```bash
npx skills add QinYangWang/skills -g --skill '*' -a pi -y
```

While developing this folder locally, use `npx skills add ./ -g` instead.

## Reference

- **[better-coding](./skills/better-coding/SKILL.md)** — the working loop:
  read order, reproduction, sibling scope, red/break checks, real use, commit
  evidence, merge/release gates, and the nightly lesson review.
- **[better-coding-init](./skills/better-coding-init/SKILL.md)** — the
  generator: inspect a repository, mine real history for lessons, and produce
  the core plus conditional deliverables.

`better-coding` is what an agent uses on a normal task. `better-coding-init` is
what you run once per repository to create the files the loop reads.

## Use

### 1. Adopt the method in a repository

```bash
cd /path/to/your/repo
```

Then invoke the generator:

```
/skill:better-coding-init
```

Or say:

```
Use better-coding-init on this repository.
Generate the core deliverables first.
Add a conditional deliverable only where its failure mode exists.
Do not invent commands, lessons or rules.
```

### 2. Review the generated files

The generator produces the core set:

- `AGENTS.md`
- `LESSONS.md`
- `docs/code-standards.md`
- `docs/subsystems/` (3–7 high-risk areas)
- `scripts/verify.sh`
- `.agents/skills/<project>-coding/SKILL.md`
- `CLAUDE.md`
- `.github/pull_request_template.md`
- `docs/nightly-review.md`

It adds conditional files only when they apply: a surface matrix, a real-client
verification skill, an agent context budget, `evals/`, review-agent contracts,
contribution triage, or a release-candidate pipeline.

Fill the real commands and run `scripts/verify.sh`. Then revert a recent fix in
a scratch branch and confirm the named test fails.

### 3. Work normally

```
/skill:better-coding
Fix <the bug>. Follow the repository's evidence format.
```

The agent reads `AGENTS.md`, the owning subsystem reference, `LESSONS.md` and
`docs/code-standards.md` before editing. It must leave a red check, a break
check, the full-suite record, real use, and a `not run` list.

### 4. Run the nightly review

Use `docs/nightly-review.md` with a scheduled agent session, cron, or manually:

```
Follow docs/nightly-review.md for yesterday's merged commits.
Only edit LESSONS.md and docs/code-standards.md. Open a PR; never push main.
```

A lesson seen on three separate days is promoted into the code standards and,
where possible, a guard test.

## Repository layout

```
skills/
├── better-coding/
│   ├── SKILL.md
│   ├── references/
│   └── templates/
└── better-coding-init/
    └── SKILL.md
```

Every skill is a directory with a `SKILL.md`. Reference and template files stay
inside the skill they belong to.

## Design rules

- No generic advice. Every generated rule cites a commit, issue, incident or
  explicit owner decision.
- No invented commands. Unverified commands stay `TODO`.
- Small budgets. The router routes; the code standards hold the rules; the
  lesson notebook holds the evidence.
- Human gates stay human: product decisions, security, credentials,
  irreversible migrations, spending and community conduct.
- Portable. Markdown and shell only; no runtime dependency.

## License

MIT. See [LICENSE](./LICENSE).
