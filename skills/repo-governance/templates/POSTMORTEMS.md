<!-- FILL: delete this block. One entry per thing that actually went wrong. No
commit, issue or incident, no entry. Search this file by module or symptom; do
not read it end to end. -->
# Postmortems

What went wrong, why, and what now catches it. Each entry ends in a review row;
that row is the reason the entry is kept.

## P-001 — <rule, one line, imperative>

- **What happened**: <#issue / commit>, <the consequence>.
- **Cause**: <one line — the mechanism, not the person>.
- **Layer**: <process | code | permissions | docs>.
- **Fix**: <commit or decision>.
- **Review**: <the row in REVIEW.md that now asks this>.
- **Tags**: `<module, symptom, platform>`.

## Why the layer matters

The layer picks the fix: `process` → a review row or a branch rule; `code` → the
change plus a guard test at the lowest failing layer; `permissions` → a
constraint, a path it may not touch, an approval; `docs` → one sentence with the
incident linked.

Most incidents have a code layer and a process layer. Fix the one whose absence
let it ship, and say which one you did not fix.

## Keeping it short

- A rule seen three times is no longer a lesson: it moves to `REVIEW.md` and the
  entry keeps one line pointing there.
- A rule now covered by a test keeps one line naming the test. The test is the
  lesson.
- Not seen in 90 days and already enforced: archive it at the bottom with its
  number. Old entries are kept, not read.

## Archived

- `P-00x` — <rule>. Superseded by `<test>` / `<row>` (<date>).