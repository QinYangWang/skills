<!-- FILL: replace <…>, delete this block. Keep every row checkable: a reviewer
must be able to answer yes or no without asking the author what it meant.
Delete a row that has no source — a rule nobody's mistake or decision produced
is generic advice. -->
# Review

Every row cites where it came from: `D-###` (a decision), `P-###` (a postmortem)
or an issue. If you cannot cite one, the row does not belong.

A reviewer answers each row with what they ran or saw, or writes `not run` and
why. "Looks good" is not an answer.

## Every change

| Check | Source |
| --- | --- |
| The change does only what its goal needs: no drive-by reformat, rename, or extra feature. | `← <D-… / P-00x / #issue>` |
| It holds on the whole path: input → callers → state → side effect. | `← …` |
| The same pattern is fixed in every sibling it reaches (routes, commands, platforms, guards). | `← …` |
| Nothing built on what changed still assumes the old meaning: callers, saved copies, tests, docs. | `← …` |
| A failed read, parse or hash means "unknown", never "empty". | `← …` |
| A value the user set is never overwritten by a default. | `← …` |
| The tests fail without the change, and the ones the author did not mention were run too. | `← …` |
| The commit body says what ran, at which head, and what was not run. | `← …` |

## By kind

- **Fix** — the reporter's exact case reproduced on their surface; siblings
  swept; no new surface.
- **Feature** — the new path's error, empty and denied states exercised; its docs
  exist; a test at the lowest failing layer.
- **Refactor** — behavior preserved with evidence; the measured reason named; no
  behavior change hidden in it.
- **Docs** — every command and link executed; no claim the code contradicts.
- **Dependency** — why the project cannot do it itself, license, exact pin,
  rollback path.
- **Release** — the artifact users install was opened and run; version strings
  match what was published.

## Refuse, or stop the merge, when

- a decision in [`DECISIONS.md`](DECISIONS.md) is reversed without the owner;
- a red test is called "the same on main" without naming the SHA and filing it;
- evidence is a rerun that hides a red first attempt;
- a claim has no command behind it.

## UI and other visual changes

Capture before and after into `docs/evidence/<change>/`, render offscreen when a
window cannot be opened, and keep the images in the PR. A description of what it
should look like is not evidence.