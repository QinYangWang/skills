# The lesson loop

The loop is the part that makes the rest self-correcting. Without it, an agent
repeats the same mistake with more confidence; with it, a repeated mistake
becomes a rule and then a check.

Magpie's `LESSONS.md` describes the loop in one sentence: *each night the day's
commits are reviewed for what had to be fixed again, what shouldn't have merged
and what was verified too thinly.* This file is a portable reconstruction.
Magpie does not publish its trigger or prompt; adapt the scheduler and wording
to the project.

## When it runs

Once a day, after the day's work is merged, before the next day's work starts.
Options, in order of preference:

1. A scheduled agent session (cron, a scheduled CI job, or the agent platform's
   scheduler) that opens a PR against the repo.
2. A local script the owner runs each morning.
3. A manual session with the prompt in `templates/nightly-review-prompt.md`.

It must not push directly to main. The output is a proposed diff to
`LESSONS.md` and, when earned, `docs/code-standards.md`, plus a short review
report in the PR body.

## Inputs

- the `reviewed-through` SHA at the top of `LESSONS.md`, or the last 24 hours if
  there is none;
- `git log --oneline --decorate <range>`;
- merge commits, PR descriptions, review comments and linked issues;
- CI runs, including cancelled and re-run attempts;
- reverts, follow-up fixes, "fix the fix" commits, and commits that touch the
  same behavior twice;
- the current `LESSONS.md` and `docs/code-standards.md` for deduplication.

## The three questions

For every merged change in the range, ask:

### 1. Did this have to be fixed again?

Look for a later commit, revert, issue or PR that fixes the same behavior. The
classic signs:

- the same test name appears in a later fix;
- the same file is touched by a "fix" within days;
- a report is reopened, or a second report describes the same goal;
- a change covers one agent/provider/route and a sibling follows;
- a release is followed by a hotfix for the thing it just changed.

The lesson is not "be more careful". It is the specific rule that would have
caught it: reproduce the reporter's case, fix every sibling, re-derive the
tests, read the unreadable file as unknown.

### 2. Should this have merged?

- Was the goal unclear or mixed with unrelated work?
- Did it reverse a deliberate owner decision?
- Was it merged without running it, or at a head nobody reviewed?
- Did it break a documented contract and not update the reference?
- Did a known problem get merged past instead of fixed or filed?
- Was a community PR merged on its description without a harm check?

The lesson is a merge rule, not a blame statement.

### 3. Was the verification too thin?

- No test, or a test that passes on the old code.
- No break check; the test was never seen to fail.
- Only chosen packages were run; a guard test elsewhere went red.
- The suite ran at an older base, or a green rerun hid a red first attempt.
- A timing test used a duration; a fixed date was wrong in another timezone.
- A fake encoded the author's assumption; the real vendor was never tried.
- A platform/architecture claim was only cross-compiled.
- A check that wasn't run was omitted from the record.

The lesson is a gate change: what must be run, and what must be written down.

## Which layer did it come from

Before writing the rule, name the layer. It picks the fix, and a fix in the
wrong layer is why the same thing happens again.

| Layer | Looks like | Fix |
| --- | --- | --- |
| `process` | A gate nobody ran, a review that asked the wrong question, a branch that carried two kinds. | Add or sharpen the review row; change the branch rule; make the step unavoidable. |
| `code` | A shared reader that turns failure into empty, a lock held across a call, a fixture that encoded an assumption. | The smallest complete change plus a guard test at the lowest failing layer. |
| `permissions` | An agent wrote where it should not, read a live state directory, acted on a credential it was given for one task. | A constraint: a path it may not touch, a command it may not run, an approval it must ask for. |
| `docs` | The page said the old behavior, the decision was never written down, the map pointed at a file that moved. | One sentence, with the incident linked. Do not write a new document for it. |

Most incidents have a code layer and a process layer. Fix the one whose absence
let it ship, and say which one you did not fix.

## Entry format

Keep one rule per entry. Put the rule first, in imperative form, then the
evidence, then the fix and the done-right example, then the count.

```md
**P-001 — <One-sentence rule, imperative.>**
- <What happened: #issue / commit, the consequence.>
- <What the fix was, or what would have caught it.>
- Done right: <commit/issue where the rule was followed, optional.>
- Seen 1× (YYYY-MM-DD). `layer: <process|code|permissions|docs>`.
- `tags: <area, symptom>` — the words an agent would type when it hits this.
- Review: `R-xx` — the review row this entry produced.
```

Example:

```md
**P-002 — A failed cache read means "unknown", not "a miss".**
- #412: `readIndex` returned `nil, nil` for a corrupt index; the writer treated
  it as empty and overwrote 12k entries (commit 9f2c1a).
- Fix 4b7e0d reads the corrupt file aside and keeps the last good index.
- Done right: 8c1d2e keeps the old index when the new one does not parse.
- Seen 2× (2026-03-04, 2026-03-19). `layer: code`.
- `tags: cache, index, restart, empty-on-error`.
- Review: `R-04` — "a failed read keeps the last good value".
```

Rules for entries:

- The rule must be checkable by a reviewer. "Be careful with files" is not a
  lesson.
- Evidence must be real: a commit, issue, PR, CI run or owner decision. If you
  cannot cite it, do not write it.
- One line of cause, one line of fix. Do not write an incident report.
- Name the function or behavior, not a line number; lines go stale.
- If the same rule already exists, add the new evidence and increment `Seen`.
- `Seen N×` counts **separate days**, not comments or occurrences in one day.

## Deduplication

Before adding an entry, search `LESSONS.md` for:

- the same rule in different words;
- the same test name;
- the same subsystem and symptom;
- the same fix pattern (failed read, sibling, re-derive, user value, lock).

If it exists, update it rather than adding a near-duplicate. A notebook with
three versions of one lesson is a notebook nobody trusts.

If a lesson is already in `docs/code-standards.md`, do not add it back to
`LESSONS.md`; add evidence to the code-standard row or its review note instead.

## Promotion: three days, then law

When the same lesson is seen on **three separate days**, move it into
`docs/code-standards.md`:

1. Write the rule as a reviewer-checkable row: `Rule | What a reviewer looks
   at`.
2. Add the best evidence from the three sightings in the row or in the review
   notes; the row itself stays short.
3. Add a guard test, lint rule or script check where one can enforce the rule.
   Prose is the fallback, not the goal.
4. Remove the entry from `LESSONS.md` and list it under
   `Moved to the code standards`, with a link and the dates.
5. If the rule is project-specific and cannot be checked, do not promote it;
   keep it in `LESSONS.md` and say why.

The threshold matters: one bad day is noise, two is a pattern, three is a
property of the workflow. It also keeps the code standards small enough that a
reviewer can actually check every row.

## Done right

Record examples of the rule being followed, not only failures. Agents copy what
they see. A `Done right` entry is one line: the commit/issue, what was done, and
which rule it demonstrates. Do not turn it into a praise section; it is
training data for the next agent.

## Keeping it short

Length is controlled by promotion, not by a number. A notebook is long when it
holds rules that are no longer current, and short when each entry has moved on.

- **Promotion removes an entry.** Three separate days and the rule lives in
  `docs/code-standards.md`; `LESSONS.md` keeps a line under
  `Moved to the code standards`.
- **A guard test removes the body.** Once a test catches it, the entry keeps one
  line naming the test. The test is the lesson; the prose is a duplicate.
- **A constraint removes the reason to repeat it.** After a permissions or
  process fix, the same mistake is blocked rather than remembered.
- **Stale entries are archived, not deleted.** Not seen in 90 days and the rule
  is either enforced or obsolete: move it to `Archived` with the number kept.
- **One rule, one home.** If a rule is in both files, `LESSONS.md` holds the
  history and the standards hold the current sentence.

When the file feels long, the cause is almost always one of: duplicates, rules
whose fix never landed, or entries written as stories. Fix the cause; do not
compress the writing.

## Output

The nightly review produces:

1. A proposed diff to `LESSONS.md`:
   - new entries,
   - updated `Seen` counts and evidence,
   - promoted entries removed and listed under `Moved to the code standards`,
   - the `reviewed-through` header updated to the last commit reviewed.
2. A proposed diff to `docs/code-standards.md` for promotions.
3. In the PR body: the range, the commits reviewed, the three questions'
   findings, what was promoted, what was merged/closed as a duplicate, and what
   could not be verified.
4. Optionally, issues for reds or risks found during the review.

Open a PR. Do not merge it. The owner reviews promotions, because a promotion
changes what every future review checks.

## Failure modes of the loop

| Failure | Symptom | Fix |
| --- | --- | --- |
| Lesson dump | 30 new entries after one day; none checkable. | Cap new entries at the few that explain rework; merge duplicates. |
| Blame log | Entries name people, not behaviors. | Rewrite as a rule and a system cause. |
| Unverifiable rule | "Communicate better", "be careful". | Require a reviewer check or delete it. |
| Stale law | Code standards full of rules nobody has hit in months. | Prune on a schedule; archive with evidence. |
| Performative review | Every night says "all good". | Review the reviewer: sample a known rework commit and see whether it was caught. |
| Private context | Lessons refer to a chat nobody can read. | Cite commits/issues only. |
| Promotion by vibe | A rule moves after one dramatic day. | Enforce three separate dates. |
| Code-only fix | The same rule reappears after a code fix. | Name the layer; when the fault is process or permission, change that instead. |
| Invented numbers | "Hit rate 92%", "saved 3k lines". | Count what happened: entries, sightings, days. Never estimate. |

## Verifying the loop itself

Once a month, take a change that had to be fixed again and check:

- Did the nightly review catch it? If not, why?
- Did the resulting lesson name the rule that would have caught it?
- Did the rule get promoted when it should have?
- Did the promoted rule become a check, or is it still prose?
- Does every entry from the last month point at a review row?

If the loop cannot catch its own misses, fix the loop before adding more rules.
