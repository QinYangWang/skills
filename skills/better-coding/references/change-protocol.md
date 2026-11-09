# Change protocol

A change has three phases: before you edit, while you edit, after you edit. The
gates are in `quality-gates.md`; this file is the operating discipline that
makes them meaningful.

## Before you edit

### 1. Route the task

Name the subsystem and the real runtime path. Read the owning reference in
`docs/subsystems/`. If the task crosses subsystems, name each one and the
contract between them.

If no reference exists for a high-risk area, write one before changing the
area, or ask the owner whether the area is high-risk. A change to undocumented
behavior is a change nobody can review.

### 2. Reproduce the exact case

Use the reporter's surface: their platform, provider, config, input bytes, UI
or command. If the report is a screenshot, reproduce the screenshot's goal,
not the step that happens to be visible.

If there is no reporter, write the failing test first. The test is the
reproduction. If you cannot make it fail, you do not yet know what is broken.

### 3. Map the whole path

Before editing, write a short scope list:

- entry point → callers → state writes → side effects;
- the same pattern in sibling routes, agents, providers, platforms or commands;
- every test, fixture, saved copy and doc that assumed the old meaning;
- every default or migration that could overwrite a user-set value;
- the reverse state: if you add a way in, add the way out and the way to see it
  (snooze needs unsnooze; close needs reopen);
- the owner decision, if the change touches one.

Grep for the pattern, not the reported line. If the bug is "a key is read under
one id and written under another", find every id pair in the area. If the bug is
"the parser drops a field", find every parser of that format.

For a product with more than one surface, fill
`templates/surface-matrix.md` before calling the change done: entry points,
clients, providers, agents, contracts, reverse states, connection modes and
docs. Mark each N/A with a reason. The most common defect is a change that
works on the surface you tested and is missing everywhere else.

### 4. Declare the goal and non-goals

One goal per change. Write down what you are deliberately not doing. Unrelated
refactors, extra features and policy changes go in their own change. If you find
a second bug on the way, file it or fix it in a separate commit; do not bundle
it.

## Agent safety in a live environment

When the agent works on the same machine as the developer, three mistakes do
the most damage:

1. **Killing by pattern.** Never `pkill -f`, `pgrep | kill`, or kill a PID found
   by matching a name, path or worktree. Your own process contains that path,
   and the machine may run other dev servers. Kill only a PID you captured at
   spawn, or the owner of your port from `ss -H -ltnp` after confirming
   `/proc/<pid>/cwd` is your worktree.
2. **Writing to the live install.** The real state directory is in use while
   you work. Read and copy from it, never open it read-write, never start a
   server against it, never clean it up.
3. **Baking in origins.** Do not set dev HTTP/WS URL env vars; read the real
   ports from the dev runner. A baked localhost origin breaks every remote
   browser.

Also: use a worktree, not `/tmp`; stop what you started, by the PID you
tracked; do not consume the user's pairing link or print credentials; copy
real data into the sandbox one way, never symlink it back.

## While you edit

- **Smallest complete diff.** The first option that fully works. Do not add an
  abstraction, option, wrapper or config nobody asked for.
- **Keep the structure.** Use the project's existing helpers, layers and
  conventions. A native platform feature beats a new dependency.
- **Preserve error handling and validation.** Moving or merging code keeps its
  checks. A failed read stays "unknown"; it never becomes "empty".
- **Write through a temp file and rename** when another process may read the
  file. Keep the last good value when a parse fails.
- **Do not let a default override a user-set value.** Before writing a key,
  find every place the user can set it. Test with a user value present.
- **Do not block under a lock its reader needs.** Set shared state before the
  handoff that lets another goroutine see it. A struct copied by value that
  holds a map is not a copy.
- **Take another app's values from that app.** Read its source, binary, merge
  code or docs for the type, unit and meaning; field names alone are not enough.
- **Re-derive what is built on the change.** If a formula, list, layout
  breakpoint, timing or saved format changes, find every caller, cache, test and
  doc that assumed the old meaning and run it.
- **Fix the siblings in the same change.** Every agent, route, subcommand,
  provider, platform branch and caller of a changed predicate gets the fix. If a
  sibling is intentionally left alone, file an issue in the same commit and name
  it in the body.

## After you edit

### 1. Run the gates

Run `references/quality-gates.md` in order. At minimum:

- the new test fails with the old code and passes with the change;
- two or three deliberate breaks each make a test red;
- the full suite runs at the pushed head, locally or in CI; the record names
  where it ran and the SHA;
- the real thing is tried where the change meets one;
- the evidence type matches the change: failing test for logic, before/after for
  visual, transcript for server-only, eval or context budget for model-facing;
- every check not run is listed with a reason.

### 2. Write the documentation budget

Most code changes do not need an internal doc; agents can read the code. Write
prose only for a decision, a constraint that spans components, or a failure
mode the code cannot show. Do not enumerate fields or methods, narrate control
flow, maintain a file catalog, or append a PR summary. A local reason goes in a
short comment beside the code. When a documented decision changes, rewrite or
remove the old text; do not append another account of the new behavior.

If reading the code answers the question, leave the doc out.

### 3. Read your own diff

Read it as a reviewer who did not write it:

- Does every behavior change have a reason in the goal?
- Did you touch a file outside the goal?
- Did you leave a debug print, a temporary skip, a widened type, a changed
  timeout or a loosened assertion?
- Did you update the owning subsystem reference, the command list or the
  project skill?
- Did you add a test that would pass on the old code?
- Does the commit body name the pushed head and the real output?

### 4. Stage explicitly

Never `git add -A` in a shared checkout. Stage the files you changed. Check
`git diff --cached --stat` and `git status` before committing. If another
session shares the machine, use your own worktree.

### 5. Write the record

```
<area>: <what the user now sees, as behavior>

Fixes #<n> (<reporter>).
Root cause: <one or two sentences>.
Ran at <pushed sha>:
- Red check: <test> failed before with <real output>; passes after.
- Break check: <mutations> each made <test> red.
- Full suite: <command, or CI run> at <sha> -> <summary>.
- Real use: <what, where>.
- Not run: <check> (<why>).
Docs: <owning reference updated>.
```

Rules:

- The subject is one short line. The body carries the evidence.
- Name the commit or issue the change responds to.
- If the body is longer than a few KB, squash it; a 500 KB default squash
  message is not a record.
- A placeholder such as `SUITE_LINE` is not a record. Grep the body before you
  push.
- If a community patch, fixture or root cause was used, credit the reporter.

### 6. Open the PR with the evidence

Use the template in `templates/pull-request-template.md`:

```md
## Goal
## Semantic change (trigger, before, after)
## Evidence
- Red check
- Break check
## Full suite at <sha>
## Real use
## Not run
## Risk and rollback
```

A PR that says "tests pass" without the command and the output is not ready.

## The twelve rules in detail

### 1. Reproduce the reporter's exact case, on the surface they use

A report comes with a surface: provider, plan, agent, platform, layout, config.
Fixing the one visible instance while missing the surface produces a second
report. Reproduce the goal, not the step: the title shows, the drag works, the
reason is readable.

**Check:** run the reporter's case before the fix. After the fix, run it again
on the same surface. If you cannot, say so and keep the issue open.

### 2. Fix the class, not the sample

The same bug usually exists in every sibling: another agent, route, provider,
platform branch, message, parser or caller. Grep for the pattern and fix them
together. If a sibling is out of scope, file it in the same commit.

**Check:** list the siblings before editing; after editing, list which changed
and which did not. A fix that names a sibling and leaves it alone is not done.

### 3. Re-derive everything built on what you change

Changing a formula, list, layout breakpoint, timing or serialized format
invalidates callers, saved copies, caches, fixtures and tests that assumed the
old meaning. Run them; update them in the same change. A test that waits on a
value whose appearance time changed must be re-read.

**Check:** search for the old value, the old unit and the old ordering. Run the
tests that pin them.

### 4. A failed read, parse or hash means "unknown", never "empty"

If a file cannot be read or parsed, keep the last good value, copy the
unreadable file aside before writing over it, and fix the shared reader. A guard
list that cannot be read fails closed. A cache index that cannot be parsed is
not "zero entries".

**Check:** test with the file unreadable, truncated and corrupt. Test the
old-code path: does it overwrite or admit everything?

### 5. The project's default never overrides a value the user set

Before writing a setting, find every place the agent or the project reads it.
Test with a user-set value present. A migration that rewrites a setting names
the users who set it themselves and leaves their value alone or explains why
not.

**Check:** a test that starts with a user value and runs the default/migration
path. It must still see the user value.

### 6. Another app's values come from that app

When you write another app's file or speak for it, take each field's type,
unit, default and redirect/URL from that app's own data, binary, merge code or
docs. A plausible field name is not a contract.

**Check:** diff your output against the app's real output for the same input.
If you cannot, say "not verified against the app" and do not claim it works.

### 7. Nothing that can block runs under a lock its reader needs

Never send on a channel or call something that can block while holding a lock
the receiver takes first. Set shared state before the handoff. A fake server's
handler runs on many goroutines: guard what it records, and count only the calls
the test makes. A change that starts a goroutine or timer runs under `-race`.

**Check:** `-race`, repeated runs, an injected delay in the writer. Find the
lock order, not just the lock.

### 8. A test must fail without the change, and be broken on purpose

Put the old code back and run the new test. It must fail with a real `FAIL`
that names the behavior. Then break the code in two or three ways and watch the
test catch each break. A test that passes on the old code guards nothing.

**Check:** record the failing output and each mutation. Restore the change and
confirm green.

### 9. A red on main is a bug to fix now

"Fails the same on main" is not a baseline. "Passes alone" is not a pass. A red
under load is a timing assumption a user will meet on a busy machine. Read the
red's issue to its last comment; if a patch exists, take it first. Fix the
cause, or file an issue with the output and an owner, in a commit of its own,
before shipping on top of it.

**Check:** fetch `origin/main` and name the SHA you ran. Search the test's name
and read every comment. Do not rerun until green.

### 10. One commit, one goal; the body records what was run at the pushed head

Two reports fixed together are two commits. A fix found on the way is its own
commit. The body says what was run, at which head, and what was not run. A
record at an older base or a different worktree is not a record for the pushed
head.

**Check:** `git show --stat HEAD` lists your files and only yours. Re-run the
size/suite checks after a rebase. Grep the body for placeholders.

### 11. Merge only the reviewed head; a tag waits for a completed green run

A push during review stops the merge. Use `--match-head-commit <reviewed sha>`.
A cancelled run is not a pass. A tag is not a release: verify the artifacts, the
version and the latest marker. A release published after a newer one must not
steal "latest"; check the publish step.

**Check:** the merge command names the reviewed SHA. The release page has the
expected assets. `git tag` shows no duplicate. The version was not already
published.

### 12. Real use before claiming it works; list what was not run

A vendor integration is checked with a real account, key, config format or
binary, in a sandbox copy. A platform report is checked on that platform. A
build for another OS is not a test. What was not tried is not built on and is
not told to users as working.

**Check:** name the real account/config/binary and the sandbox. If a check is
impossible, write `Not run: <check> (<why>)` in the commit and the PR.

## Reviewer protocol

A reviewer does not read the diff and approve. They:

1. Pull the head and merge it onto current main (or rebase it) in their own
   worktree.
2. Run the acceptance gates; compare the result with the claim.
3. Break the fix by hand in several ways and confirm the new tests catch each.
4. Check each platform and architecture the change reaches.
5. Follow the whole path: the value is saved and read under the same name; the
   button updates the binary that actually runs; aliases do not collide.
6. Check the vendor's source, not the PR's account of the vendor.
7. Check that docs match the code and every link resolves.
8. Keep the PR to its goal; unrelated changes go elsewhere.
9. Write what was run, at which head, before merging. Merge only that head.

If a review finds a known-wrong behavior that is out of scope, file it and name
it; do not merge silently past it.

## Stop and ask

Stop before:

- reversing an owner's deliberate decision;
- changing `.github/`, release scripts, update feeds, permissions or secrets;
- touching real credentials, a live gateway or a user's live config;
- a migration or deletion with no rollback;
- spending money, contacting users, or making a public claim;
- blocking a community author.

The agent proposes; the owner decides. Write the evidence for the owner, not a
 verdict they have to reverse.
