<!-- FILL: replace every <…>, delete this block. Keep this to one screen: it is the
only file an agent reads before starting. Facts about a module live in that
module's own docs, not here. -->
# <PROJECT> — start here
<!-- repo-governance: v3 -->

<One sentence: what this is and who uses it.> Agents write, review and release
here; the owner guards the decisions below.

## Align before you work

Open with three lines: what the user gets, the smallest change that delivers it,
and what will show it worked.

- Anything a run can answer, answer by running it; only product and preference
  calls go to the user.
- Name the choices that are the user's, each with your default beside it.
- Reversible, inside one module: restate, then go.
- Irreversible, public, cross-module, spending or new surface: restate and wait.

## Modules

Each module owns its docs and index; this table only points at them. Two hops:
this row, the module's docs, the file.

| Module | What it owns | Docs |
| --- | --- | --- |
| `<module>` | <one line> | `<module>/README.md` or `docs/modules/<module>.md` |
| `<module>` | <one line> | `—` |

## Commands

| What | Command |
| --- | --- |
| Install | `<command>` |
| Test | `<command>` |
| Build | `<command>` |
| Lint | `<command or none>` |

## Documents

| When | Read |
| --- | --- |
| Starting a change | [`docs/COLLAB.md`](docs/COLLAB.md) — branch, commit, PR |
| Before merging | [`docs/REVIEW.md`](docs/REVIEW.md) — what a reviewer checks |
| A decision that looks settled | [`docs/DECISIONS.md`](docs/DECISIONS.md) — do not reverse one |
| "This broke before" | [`docs/POSTMORTEMS.md`](docs/POSTMORTEMS.md) — grep the module or the symptom |

## Needs the owner

- `<paths: secrets, release scripts, migrations, live data>`
- Anything under "Stop and ask" in the collaboration guide.