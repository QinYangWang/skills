<!-- FILL: instantiate this template. Replace every <PLACEHOLDER>, run every
command once, delete this block. Budget: 80 lines. -->
---
name: repro-<project>
description: >-
  Turn a reported failure in <PROJECT> into a test that fails on the base commit
  and stays as a guard. Use when an issue, chat message or user says something
  broke, and before any fix is written.
---

# Reproduce <PROJECT> bug

A fix starts with a failing test at the layer that owns the behavior. A
reproduction that only exists in the terminal disappears the moment the branch
merges, and the next agent breaks it again.

<!-- repo-governance skill: repro v1 -->

## When this runs

A report says something broke, and no test covers it yet. Not for a refactor, a
request for a feature, or a report with no reproduction path the reporter can
describe — ask once for the missing field, then proceed with it marked unknown.

## If it did not help

If the case does not reproduce after the configurations in step 5, say so with
the list and the outputs. Do not write a test for a nearby case and call the
report closed; the untested claim goes in the commit's not-run list.

## 1. Capture the report as data

Record: version, platform, config, exact steps, expected, actual, and what the
reporter's data looked like (size, encoding, history). A screenshot is not a
config. Ask once for a missing field, then proceed with it marked unknown.

## 2. Choose the lowest layer that fails

unit → module/integration → product (`verify-<project>`). Write the test one
layer below the surface the report came from. Only when the defect is
reproducible through the product alone do you drive the product, and then the
lower-layer test stays as the guard.

## 3. Prove it red on the base

```bash
git stash --include-untracked        # or: git checkout <base>
<focused test command>               # must fail, naming the behavior
```

The failure must be behavioral. A compile error, a missing fixture or a skip is
not a red. Record the output verbatim.

## 4. Keep the reproduction

- Name: `<Behavior>Keeps<Guarantee>` — the guarantee, not the function.
- Fixtures from real bytes: a real truncation, payload or config. Never
  hand-write the shape you assume.
- Assert behavior a caller or user observes, not implementation detail.
- Isolation: temp HOME/config, no network, everything it starts ends with it.
- One layer: the lowest that fails on main.

## 5. Report what you ruled out

If it does not reproduce, list every configuration tried, its output, and what
stays unverified. "Cannot reproduce" with no list is not a finding, and no fix
is claimed from a reproduction you did not observe.

## 6. Hand off

Give the fixer: test name and file, base SHA, the red output, the caller/sibling
map, and the layer you stopped at.