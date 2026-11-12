<!-- FILL: instantiate this template. Replace every <PLACEHOLDER>, run every
command once, delete this block. Budget: 120 lines. A generated skill that was
never executed is a draft, not a deliverable. -->
---
name: verify-<project>
description: >-
  Prove <PROJECT> changes through the product itself: launch an isolated
  instance, drive a mapped user journey, capture before/after evidence, clean
  up. Use for any user-facing change in <PROJECT>, and whenever a claim needs
  more than a unit test.
---

# Verify <PROJECT>

`scripts/verify.sh` proves the gates. This proves the product. Run it for a
change a user can see, click or call; skip it for a change with no reachable
surface, and say why in the commit.

<!-- repo-governance skill: verify v1 -->

## When this runs

A change to something a user can reach: a screen, a command, an endpoint, a
notification. Not for a rename, a log line, or a change whose only reader is the
test suite — say which, and skip.

## If it did not help

If the journey could not be driven (missing seed data, a broken base, no
harness), stop and report it with the exact blocker. Do not fall back to a unit
test and call the product verified; write what you could not check in the
commit's not-run list.

## Launch

- Isolated state, never the live one: `<STATE_DIR>` is a one-way copy of
  `<source>`, built for this run.
- Command: `<exact command>` from `<repo root or worktree>`.
- Ready means usable, not "a process answers": `<log line / prompt that means a
  real request can be served>`. A health check can pass while migrations and
  seed data are still running. Wait for it, do not sleep and hope:

  ```bash
  for _ in $(seq 1 <attempts>); do <readiness check> && break; sleep <seconds>; done
  ```
- Ports: read the real one from `<runner output / config>`. Never hard-code it
  or bake the origin into the bundle.
- Teardown: `<how this instance is stopped>`.
- If the checkout does not start as-is, fix that first or report the exact
  failure. Do not drive a broken base and call it a regression.

## Doctor

One read-only check that answers "is this instance worth driving?":

```bash
<process alive> && <right build or version> && <port owned by this instance> && <auth valid>
```

Run it first whenever anything looks off. A skill that drives the wrong instance
teaches wrong evidence.

## Drive

- Harness: `<existing Playwright/Cypress spec | tmux/PTY | curl + jq | CDP>`.
  Prefer what the repo already has; do not add a second automation stack for one
  proof.
- Reach the flow the way a user does: `<entry point> → <action> → <result>`.
- Prefer stable handles: ARIA labels, `data-*` hooks, route paths, prompt
  strings. Coordinates and tab order are not handles.
- Journeys live in `features/`. Use the mapped one; when the map lists several
  entry points, one convenient entry point is not the whole proof.
- Never weaken a journey to make it pass. A failing seed precondition is a
  finding: record it in that feature's `Gotchas`.

## Evidence

- Capture `<screenshot | terminal transcript | response bodies | rows or files
  written | exit codes>` into `<location the user can open>`.
- Standards: the real user path, not internal setters or test-only endpoints;
  the action and the resulting state, not only the final screen; side effects
  observed (file written, row inserted, message sent), not inferred.
- Mock only where a production boundary already isolates the external system.
- When the safe path is a dry run or test mode, verify what it actually skips by
  observing files, network and refs. Some dry runs still go to the network.
- A red on this surface is reported with its transcript, not softened into
  "mostly works".

## Cleanup

- Kill only what you started, by the PID or session you captured. Never kill by
  name or pattern.
- Remove the scratch instance and its state. Keep the evidence at
  `<location>`; cleanup never deletes proof. If teardown eats the screenshot,
  teardown is broken.

## Helpers

```bash
<path to any script this skill ships>   # what it does, arguments
```

Every helper is executable and invoked here. A helper the reader has to
reverse-engineer is not a helper.

## Feature map

`features/README.md` indexes the user-facing features; `features/<feature>.md`
carries sub-features, how a user reaches it, how to drive it, and its gotchas.
A change that adds, moves or retires a user-visible feature updates the map in
the same commit.