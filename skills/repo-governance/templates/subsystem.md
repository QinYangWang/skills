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

## Open questions

<Only current, actionable unknowns. Link the issue. Do not put proposals or
roadmap here.>
