<!-- FILL: remove this block after filling. Keep this page under 300 lines. -->
# <Subsystem>

Write only the cross-component behavior a reader cannot get from one file.
Link to source rather than copying implementation details.

## Responsibilities and boundaries

<What this subsystem is responsible for, and what it explicitly is not. Name the
callers and the services it owns.>

## Source of truth

- [`<path/to/file>`](<relative link>) — <what it owns>.
- [`<path/to/file>`](<relative link>) — <what it owns>.

## Index of this area

What an agent should know before reading the code. One line each; link, do not
paste. This is the second hop from `AGENTS.md`, so it must land on a file, not
on another index.

| What | Where | Why it matters |
| --- | --- | --- |
| `<concept or file>` | [`<path>`](<relative link>) | <one line> |

## Commands for this area

- `<test command>` — <what it covers>.
- `<build or run command>` — <what it starts>.

## Main runtime paths

1. <Entry point> → <caller> → <state write> → <side effect>.
2. <Entry point> → <caller> → <state write> → <side effect>.

## State and transitions

<The state this subsystem keeps, who writes each field and under which lock, and
which transitions are legal. Include retries, restarts, migrations and
rollbacks.>

## Contracts and invariants

- <A contract another subsystem or the user depends on.>
- <A value that must never be overwritten: user-set config, a credential, a
  compatibility field.>
- <An ordering or atomicity guarantee.>

## Failure behavior

- A failed read/parse/hash means <unknown / keep the last good value / fail
  closed>.
- A timeout or cancellation means <...>.
- A partial write is handled by <temp-and-rename / last good copy / ...>.

## Compatibility

<Versioned formats, old clients, migrations, deprecations, and what happens to
data written by an older version.>

## Verification

- `<command>` — <what it proves>.
- `<test name>` — <which behavior it guards>.
- Real use: <account/config/binary/sandbox recipe>.

## Known failure modes

The two or three ways this area has broken before. Read these before changing
anything here; each links to the postmortem that produced it.

| Failure | What it looked like | Postmortem | Review |
| --- | --- | --- | --- |
| <symptom> | <one line> | `P-00x` | `R-xx` |

## Decisions

Settled by the owner. Append only; an agent that needs to reverse one stops and
asks.

- `D-<area>-1` — <what is settled>. (<owner>, <date>). Why: <one line>. Forbids:
  <what a change may no longer do>.

## Open questions

<Only current, actionable unknowns. Link the issue. Do not put proposals or
roadmap here.>
