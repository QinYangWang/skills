<!-- reviewed-through: <sha> (<YYYY-MM-DD HH:MM timezone>) -->
<!-- FILL: remove this block after filling. Keep this file under 800 lines. -->
# Lessons from merged work

<PROJECT>'s code is written, reviewed, merged and released by agents. Each
night the day's merged work is reviewed for what had to be fixed again, what
should not have merged and what was verified too thinly. What we learned is
kept here. Read this before changing code.

Each lesson is a rule, then why, then the evidence. `Seen N×` counts the
separate days a review found it. A lesson seen on **3 or more separate days**
moves into [`docs/code-standards.md`](docs/code-standards.md) and, where
possible, becomes a guard test. Do not add a lesson without a commit, issue or
owner decision to cite.

## Reading the report

**<Rule, one sentence, imperative.>**
- <What happened: #issue / commit, the consequence.>
- <What the fix was, or what would have caught it.>
- Done right: <commit/issue where the rule was followed, optional.>
- Seen 1× (<YYYY-MM-DD>).

## Fix the class, not the sample

**<Rule.>**
- <Evidence.>
- Seen 1× (<YYYY-MM-DD>).

## The user's own files and settings

**<Rule.>**
- <Evidence.>
- Seen 1× (<YYYY-MM-DD>).

## Verification

**<Rule.>**
- <Evidence.>
- Seen 1× (<YYYY-MM-DD>).

## Concurrency and tests

**<Rule.>**
- <Evidence.>
- Seen 1× (<YYYY-MM-DD>).

## Red tests and releases

**<Rule.>**
- <Evidence.>
- Seen 1× (<YYYY-MM-DD>).

## Merging and closing

**<Rule.>**
- <Evidence.>
- Seen 1× (<YYYY-MM-DD>).

## Moved to the code standards

These were seen on three or more separate days. The rules and their evidence
are in [`docs/code-standards.md`](docs/code-standards.md); a review checks each
one.

- **<Rule>** (<dates>). <One line of evidence.>
