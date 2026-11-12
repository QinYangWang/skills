<!-- FILL: seed this map with 3–5 features, then delete this block. -->
# Feature map

One file per user-facing feature. This map is the source of truth for **what a
proof must cover**; `../SKILL.md` is **how** to drive it.

| Feature | Reached at | Drive file | State |
| --- | --- | --- | --- |
| `<feature>` | `<route / command / menu>` | `features/<feature>.md` | verified / seeded, not yet driven |

## Rules

- A proof that drives one convenient entry point is incomplete when the map
  lists others.
- A journey never weakens to pass. A missing seed precondition is a finding, and
  it goes in that feature's `Gotchas`.
- Add a feature when it becomes user-reachable; delete one when it is retired.
  Keep the map small enough to run in one session.
- Each file answers, from the user's point of view: what it is, how to reach it,
  how to drive it, and what observable end state proves it works.

## Adding a feature

1. Name it the way a user would.
2. Find its entry points in the code: routes, commands, menu items, shortcuts.
3. Write the journey with handles the harness can actually use.
4. Drive it once and paste the evidence path.
5. Note the gotchas: seed data, auth, timing, platform quirks.