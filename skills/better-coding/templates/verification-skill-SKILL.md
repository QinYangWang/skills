<!-- FILL: remove this block after filling. Keep this file under 120 lines. -->
---
name: test-<project>-app
description: >-
  Verify <PROJECT>'s UI or integration through the product's own browser/device
  tools against isolated development state. Use for real-client verification,
  before/after captures, pairing recovery, and test fixtures. Use the coding
  skill for implementation.
---

# Test <PROJECT> app

Use the product's own verification tools. Do not install or switch to another
automation system. If the tools are absent, report the blocker and stop; do not
fake a pass.

## Start

- Reuse this task's healthy dev server. Otherwise start it and retain the
  terminal session.
- Use the worktree's ignored state directory. Never run against the live
  `~/.<project>/userdata` or the developer's real config.
- Read the actual ports, pairing URL and run id from the dev-runner output.
  Do not hard-code them or bake them into the bundle.
- Seed meaningful data. An empty database is a bad test. Use the one-way
  fixture script; copy, never symlink, and remove auth/scheduled-task/link
  records the flow does not need.
- If a native client is missing or outdated, install it from the shared cache;
  do not rebuild from scratch unless the cache has no match.

## Drive

- Prefer the free replay/fixture path that runs through the real adapter and
  orchestration. Use a paid model only when the change depends on that
  provider's behavior, and then use its cheapest model.
- Exercise the affected flow end to end: entry point, action, result, reverse
  state. Check the console/network for errors the UI hides.
- Capture the evidence the change type needs: before/after for visual, a short
  recording for motion/timing, a transcript for server-only behavior.
- Keep credentials, pairing links and user data out of screenshots, logs and
  commits.

## Verify

- Confirm the intended project/thread/account is the one you meant to use.
- Confirm the changed behavior on the surface the reporter or user uses, not
  only the path that is easy to automate.
- If a surface cannot be checked, say `not run` and why. Do not claim it works.
- Leave the app, server and state available for the user to inspect. Do not
  tear down while they may still be iterating.

## Teardown

- Stop only the processes you started, by the PID or terminal session you
  retained. Never `pkill` by pattern.
- Remove disposable connections and close the device/browser session.
- Do not clean the live state directory. If you created a worktree, remove it
  when done.
