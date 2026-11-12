# Agent Skills

[![skills.sh](https://skills.sh/b/QinYangWang/skills)](https://skills.sh/QinYangWang/skills)

One skill: **repo-governance** — it writes the five documents an agent needs in a
repository, then leaves the repository alone.

## Install

```bash
npx skills add QinYangWang/skills -g
```

Choose `repo-governance` for your agent. To list first:

```bash
npx skills add QinYangWang/skills --list
```

While developing locally, use `npx skills add ./ -g`.

## What it writes

| File | Job |
| --- | --- |
| `AGENTS.md` | Index: what the repo is, the commands, one row per module, routes to the four documents, what needs the owner. |
| `docs/COLLAB.md` | Which branch a change kind takes, how to develop, how to commit and open a PR. |
| `docs/REVIEW.md` | What a reviewer checks, by change kind, every row traced to a decision or a postmortem. |
| `docs/DECISIONS.md` | Settled choices: what, why, what it forbids, who, when. Append-only. |
| `docs/POSTMORTEMS.md` | What broke, why, which layer, and the review row it produced. |

Modules keep their own docs and index; the entry only points at them. Two hops
from `AGENTS.md` to the file you change.

## Why five files

An agent-maintained repo fails in predictable ways: the fix covers the screenshot
but not the class, the new test passes on the old code, the full suite was never
run, the commit says "tests passed" without saying what ran, and the same
mistake returns a month later.

Five documents answer those, in the order a change meets them: where things are,
how to work, what a reviewer checks, what is already settled, and what has gone
wrong before. A sixth file needs the failure mode it catches.

The skill itself is 89 lines and five templates; it carries no process library,
no budgets and no metrics. Reading it costs a minute, which is the only way a
governance skill pays for itself.

## Use

```
/skill:repo-governance
```

It surveys the repository, writes or keeps the five documents, fills them with
commands it actually ran and incidents it actually found, and reports what it
skipped and why. Running it again on the same repo changes nothing.

A repository written by an earlier draft keeps its extra files: subsystem pages
become module docs, `code-standards.md` becomes `REVIEW.md`, `LESSONS.md`
becomes `POSTMORTEMS.md`.

## Design rules

- **Index, not manual.** `AGENTS.md` points; module facts live in module docs.
- **Every review row has a source.** A rule nobody's mistake or decision
  produced is generic advice and is deleted.
- **Every postmortem has a review row.** Otherwise it is a story.
- **No invented facts.** Unknown commands, branches, owners and incidents are
  asked or marked `TODO`, never filled with a plausible default.
- **No numbers.** No budgets, no hit rates, no saved percentages. Promotion and
  deletion control length.
- **Idempotent.** A stamp, not a diff.
- **Portable.** Markdown only; no runtime dependency.

## Repository layout

```
skills/
└── repo-governance/
    ├── SKILL.md
    └── templates/
        ├── AGENTS.md
        ├── COLLAB.md
        ├── REVIEW.md
        ├── DECISIONS.md
        └── POSTMORTEMS.md
```

## License

MIT. See [LICENSE](./LICENSE).