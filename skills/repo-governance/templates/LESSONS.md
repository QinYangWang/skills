<!-- reviewed-through: <sha> (<YYYY-MM-DD HH:MM timezone>) -->
<!-- FILL: remove this block after filling. Keep this file under 800 lines. -->
# Lessons from merged work

<PROJECT>'s code is written, reviewed, merged and released by agents. Each
night the day's merged work is reviewed for what had to be fixed again, what
should not have merged and what was verified too thinly. What we learned is
kept here. Search it for the area and the symptom before changing code; do not
read it end to end.

Each lesson is a rule, then why, then the evidence. `Seen N×` counts the
separate days a review found it. A lesson seen on **3 or more separate days**
moves into [`docs/code-standards.md`](docs/code-standards.md) and, where
possible, becomes a guard test. Do not add a lesson without a commit, issue or
owner decision to cite.

Three fields make a lesson findable and useful:

- `tags:` — the area and the symptom words an agent would type. This is what
  `scripts/lessons.sh <area>` searches, and what the owning area page links to.
- `layer:` — where the fault was: `process`, `code`, `permissions` or `docs`.
  The layer decides the fix: a gate, a test, a constraint, or a sentence.
- `Review:` — the review row this lesson produced. A lesson with no review row
  is unfinished; the point of keeping it is that the next merge is asked.

When the rule becomes a guard test, replace the body with one line naming the
test. The test is the lesson. When it is superseded, move it to the archive at
the bottom and keep the number.

## Reading the report

**P-001 — <Rule, one sentence, imperative.>**
- <What happened: #issue / commit, the consequence.>
- <What the fix was, or what would have caught it.>
- Done right: <commit/issue where the rule was followed, optional.>
- Seen 1× (<YYYY-MM-DD>). `layer: code`. `tags: report, version, config`.
- Review: `R-07` in `docs/code-standards.md`.

## Fix the class, not the sample

**P-00x — <Rule.>**
- <Evidence.>
- Seen 1× (<YYYY-MM-DD>). `layer: <process|code|permissions|docs>`. `tags: <area, symptom>`.
- Review: `R-xx`.

## The user's own files and settings

**P-00x — <Rule.>**
- <Evidence.>
- Seen 1× (<YYYY-MM-DD>). `layer: <process|code|permissions|docs>`. `tags: <area, symptom>`.
- Review: `R-xx`.

## Verification

**P-00x — <Rule.>**
- <Evidence.>
- Seen 1× (<YYYY-MM-DD>). `layer: <process|code|permissions|docs>`. `tags: <area, symptom>`.
- Review: `R-xx`.

## Concurrency and tests

**P-00x — <Rule.>**
- <Evidence.>
- Seen 1× (<YYYY-MM-DD>). `layer: <process|code|permissions|docs>`. `tags: <area, symptom>`.
- Review: `R-xx`.

## Red tests and releases

**P-00x — <Rule.>**
- <Evidence.>
- Seen 1× (<YYYY-MM-DD>). `layer: <process|code|permissions|docs>`. `tags: <area, symptom>`.
- Review: `R-xx`.

## Merging and closing

**P-00x — <Rule.>**
- <Evidence.>
- Seen 1× (<YYYY-MM-DD>). `layer: <process|code|permissions|docs>`. `tags: <area, symptom>`.
- Review: `R-xx`.

## Archived

Rules that are now a guard test, a gate, or replaced by a later entry. Kept for
the number and the history, not read.

- `P-00x` — <rule>. Superseded by `<test>` / `R-xx` (<date>).

## Moved to the code standards

These were seen on three or more separate days. The rules and their evidence
are in [`docs/code-standards.md`](docs/code-standards.md); a review checks each
one.

- **<Rule>** (<dates>). <One line of evidence.>
