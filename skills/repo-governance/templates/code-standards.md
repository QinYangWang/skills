<!-- FILL: remove this block after filling. Keep this file under 250 lines. -->
# Code standards

These rules come from this project's reviews. A reviewer checks each one, and a
change that does not meet one gets a comment naming the rule. How to describe
and review a change to a subsystem is in
[`docs/subsystems/README.md`](docs/subsystems/README.md).

Read this file on demand: grep the rule you are unsure of. It is not part of the
first read; `AGENTS.md` carries the digest a change always needs.

Keep only the rules this project has actually needed. Delete a rule that no
longer applies; do not carry it as decoration.

## What a change contains

Every row names its source: a decision (`D-<area>-<n>`), a postmortem (`P-00x`)
or an issue. A rule with no source is generic advice; delete it instead of
debating it.

| Rule | What a reviewer looks at | Source |
| --- | --- | --- |
| A change does only what its goal needs. | Every behavior change has a reason. Unrelated refactors, extra features and policy changes go in their own change. `← <D-… / P-00x / #issue>` |
| The smallest complete change wins. | Ask in order: does it need to exist, is it already here, does the platform give it, is it an installed dependency, is it one line, then the minimum. Never cut validation at trust boundaries, error handling that prevents data loss, security or accessibility. | `← <D-… / P-00x / #issue>` |
| A change sits on the branch its kind belongs to. | A fix on `<stable>`, new surface on `<next minor>`, a break behind the owner. A branch with two kinds is split before review. `← <D-… / P-00x / #issue>` |
| A fix adds no new surface. | No new option, export, flag or config key inside a bug fix. New surface names its approved design note and ships in the minor line. `← <D-… / P-00x / #issue>` |
| A fix contains no stylistic refactor. | No reformat, rename or reorganisation. A refactor names its measured reason and goes alone; formatting belongs in the formatter. `← <D-… / P-00x / #issue>` |
| A fix covers exactly the cases it means to. | Which cases change, and which neighboring ones stay the same. Different errors are not handled as one. `← <D-… / P-00x / #issue>` |
| A change holds on the whole path. | Follow it from the user's input to the end result, through callers, state and side effects. One correct function does not make the operation correct. `← <D-… / P-00x / #issue>` |
| A fix reaches every sibling of the bug. | Grep for the same pattern: every route, command, provider, platform branch, guard and caller of a changed predicate. If a sibling is left alone, file it in the same change and name it. `← <D-… / P-00x / #issue>` |
| A change re-derives everything built on what it changes. | When a formula, list, layout breakpoint, timing or saved format changes, find every caller, saved copy and test that assumed the old meaning, and run it. `← <D-… / P-00x / #issue>` |
| A failed read, parse or hash means "unknown". | It never means "empty", "none" or "equal". Keep the last good value, copy the unreadable file aside before writing over it, and fix the shared reader rather than writing a strict one beside it. A guard list fails closed. Test with the file unreadable, truncated and corrupt. `← <D-… / P-00x / #issue>` |
| The project's default never overrides a value the user set. | Before writing a setting, list every place it is read. Test with a user-set value present. A migration names the users who set it and leaves their value alone, or says why not. `← <D-… / P-00x / #issue>` |
| Another app's values come from that app. | Take each field's type, unit, default and URL from that app's own data, binary, merge code or docs. A plausible field name is not a contract. `← <D-… / P-00x / #issue>` |
| Nothing that can block runs under a lock its reader needs. | Never send on a channel or call something that can block while holding a lock the receiver takes first. Set shared state before the handoff. A fake's handler runs on many goroutines: guard what it records. `← <D-… / P-00x / #issue>` |
| Checks cover the edges the change touches. | Numbers: boundaries. Paths: each platform. Concurrency: races and stale state. Pick checks by risk. `← <D-… / P-00x / #issue>` |

## Tests

| Rule | What a reviewer looks at | Source |
| --- | --- | --- |
| A fix comes with a test that fails without it. | Put the old code back and run the new test. It must fail with a real `FAIL` that names the behavior. A compile error or a skip does not count. Say what it failed with. `← <D-… / P-00x / #issue>` |
| A test never reaches the network. | A vendor is served by a local fake built from real bytes. A package comes from a lock file, not a registry's latest. Break the change and watch where the test's requests go. `← <D-… / P-00x / #issue>` |
| Tests use real inputs. | Fixtures look like real requests, real serialized output and real files on disk, including missing fields, empty values and defaults. `← <D-… / P-00x / #issue>` |
| Tests check behavior, not implementation. | Assert what the user or caller needs. Formatting and internal refactors should not break a test unless exact bytes are the requirement. `← <D-… / P-00x / #issue>` |
| A test sits at one layer. | The lowest layer that fails on `main`. Do not repeat the case in a wrapper, at each call site, or in web and mobile copies of the same logic. `← <D-… / P-00x / #issue>` |
| Extend before adding. | If an existing test or table covers the behavior, add a row or an assertion there. Write a new `it` only when no case fits. `← <D-… / P-00x / #issue>` |
| A test waits for state, not time. | No sleep, polling loop, per-test timeout, retry or wall-clock delta. Await the event, queue or drain the worker. A test that needs a timeout to pass is wrong. `← <D-… / P-00x / #issue>` |
| A skip names a tracking issue. | `it.skip` and friends need `// quarantine: #1234 <why>` on the line above. Flaky tests are fixed, not retried. `← <D-… / P-00x / #issue>` |
| Review asks for less, not more. | Ask for a missing test only when it would catch a real regression. Do not ask for one assertion per constant, label or `switch` case. A test-review agent may ask for fewer or smaller tests, never more coverage. `← <D-… / P-00x / #issue>` |
| A test that fails on main is a bug to fix now. | "Fails the same on origin/main" is not a baseline. Fetch main, name the SHA, and fix or file the cause before shipping on top of it. `← <D-… / P-00x / #issue>` |
| Whatever a test starts ends when it does. | A fake process, goroutine or async refresh is stopped or waited for before the test returns, or it writes into the next test. `← <D-… / P-00x / #issue>` |
| A timing test leaves room on both sides. | Never bound a test by wall-clock time a loaded runner can exceed. Reproduce a timing failure by injecting the delay, not by rerunning until it fails. `← <D-… / P-00x / #issue>` |

## Acceptance criteria

Items 1–7 apply to every change. Then add the line for your change kind, and
check only that one — a fix does not answer a feature's list.

- **Fix** — the reporter's exact case reproduced on their surface; the same
  pattern fixed in every sibling; no new surface and no drive-by rename.
- **Feature** — design note approved; the new path's error, empty and
  permission-denied states exercised; the docs for the new surface exist; a test
  at the lowest failing layer.
- **Refactor** — behavior preserved, with evidence that names each contract kept;
  no formatting noise; the measured reason for the change named.
- **Docs** — every command and link executed; no claim the code contradicts.
- **Dependency** — why the project cannot do it itself, license, exact pin,
  rollback path.
- **Release** — the artifact users install was opened; every version string
  matches what was published.

1. **A test that fails without the change.** Put the old code back and run the
   new test. It must fail with a real `FAIL` that names the behavior. Then
   restore the change and check the test passes.
2. **Tests in a sandbox.** Use a temporary home/config and pinned caches. A test
   never reads or writes a live user config, credential or the project's real
   state directory.
3. **The build and the full suite.** Run the formatter/linter check, the build,
   and the full test suite, including the guard tests in packages you did not
   touch. The full suite may run locally or in CI; either way it runs at the
   pushed head, not an older base. A timed-out package is a failure. Record
   where it ran and the SHA.
4. **Real use where possible.** A change to an integration is checked against
   the real thing: a real account/key, the real config format, the vendor's real
   reply, the binary the user runs. Use a sandbox copy. If a real check is not
   possible, say so. What was not tried is not built on and is not told to users
   as working.
5. **Evidence matches the change.** Logic gets a failing test; visual spacing
   gets before/after captures; server-only behavior gets a runtime transcript;
   model-facing text gets an eval or a measured context budget; release
   packaging gets a packaged artifact smoke.
6. **Every platform the change reaches.** A cross-OS build does not run the
   tests. A platform report is checked on that platform. A browser engine is
   not a native webview.
7. **The record.** The commit header follows the convention and the changelog
   entry it generates says what a user needs to read. The body says what was
   run, at which head, where the full suite ran, and what was not run. The merge
   names the reviewed head. A tag waits for a completed green run on that
   commit.

## Reviewing a change

These patterns come from real reviews. A reviewer checks each one that applies:

- **Run it.** Pull the head, merge it onto current main in your own worktree,
  and run the acceptance checks. Reading the diff alone is not a review.
- **Break it on purpose.** Revert the fix, or break the code in several ways,
  and check that the new tests catch each break.
- **Check the vendor, not the PR's account of it.** Read the upstream source or
  docs for a vendor's behavior. Try it against a real upstream where possible.
- **Check each platform and architecture.** An `int` conversion safe on arm64
  can wrap on amd64. A refused connection has a different code on Windows.
- **Follow the whole path.** A value saved under one name and read under
  another is a bug. A button that updates the wrong binary is a bug.
- **Classify narrowly.** A mark or error class covers only the case it
  describes.
- **A preview writes nothing.** A dry run, plan or preview has no side effects.
- **Do not reverse deliberate decisions.** The owner's product decisions are
  not a PR's to change.
- **Docs match the source.** Check every link and every named symbol.
- **Keep the PR to its goal.** Unrelated tests and refactors go elsewhere.
- **Known problems are fixed or filed.** Never merge past a red or a known-wrong
  behavior.

## Commits and merges

- **Branch by kind.** A fix, chore, doc or test goes to `<stable>`; a new
  user-visible surface goes to `<next minor>`; a break waits for the owner. A
  branch carries one kind. Never commit to a long-lived branch.
- **Header follows the convention:** `<type>(<scope>): <subject>`, types
  `feat|fix|perf|docs|refactor|test|build|ci|chore|revert`; imperative,
  lowercase, no trailing dot, at most 50 characters.
- **Footer carries the link and the break:** `close #123`, and
  `BREAKING CHANGE: <what users must do>` when the change breaks a contract.
- **The changelog is generated from headers.** Only `feat`, `fix`, `perf` and a
  break appear in it. Nobody edits it by hand, and a behavior change cannot hide
  under `chore`.
- One commit, one goal. Two reports fixed together are two commits.
- The body says how it was verified and which test fails without the change.
- The record is in the commit body, not in a chat, a push note or only on the
  PR.
- Merge only the reviewed head:
  `gh pr merge --match-head-commit <reviewed sha>`.
- A push after the review triggers a new review, not a merge. An owner push is
  a push.
- A fix that ships in the next minor is cherry-picked forward with
  `git cherry-pick -x <sha>`; the stable line is never merged into the minor
  line.
- A tag is not a release. Verify the tag is on the line it ships from, the CI
  run finished green, and the release has its assets and the latest marker.

## Project-specific rules

<!-- FILL: add rules promoted after three separate days. One row each, with the
evidence in the review notes or the linked lesson. Delete this comment. -->

| Rule | What a reviewer looks at |
| --- | --- |
| <Rule from a promoted lesson.> | <The check a reviewer performs.> `← <D-… / P-00x / #issue>` |
