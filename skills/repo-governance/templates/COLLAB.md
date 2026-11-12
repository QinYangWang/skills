<!-- FILL: replace the placeholders that name this repo, delete this block. Branch
patterns (`fix/<slug>`) keep their shape. The branch table is the owner's
decision, not yours: take it from CI, branch protection, or an answer. -->
# Working in <PROJECT>

## Before the first edit

1. Find the module's docs from the table in [`../AGENTS.md`](../AGENTS.md).
2. Reproduce the reported case, or write the failing test.
3. Say in one message what changes, and what will show it worked.

## Which branch

| Change | Branch | Base |
| --- | --- | --- |
| Fix | `fix/<slug>` | `<stable>` |
| Feature | `feat/<slug>` | `<next minor>` |
| Refactor | `refactor/<slug>` | `<stable>` |
| Docs, chore, tests | `<type>/<slug>` | `<stable>` |
| Breaking | owner decides | `<major>` |

One branch, one kind. A fix adds no new surface, no reformat, no rename.

## Develop

1. Failing test or reproduction.
2. Smallest complete change; fix the sibling cases the same pattern reaches.
3. Run the module's tests, then the whole suite, then the real thing.
4. Update the module's docs in the same change when a contract changes.

## Commit

`<type>(<scope>): <subject>` — imperative, ≤50 characters, no period.
Types: `feat fix perf docs refactor test build ci chore revert`.

Body: what changed and why; what you ran; what you did not run.
Footer: `close #123`, `BREAKING CHANGE: <what users must do>`.

```
fix(cache): keep the last good index when the file is corrupt

readIndex returned (nil, nil) for an unreadable file, so startup treated it as
an empty cache and overwrote it.

Ran: go test ./internal/cache, go test ./..., relayd --once on a sandbox copy.
Not run: Windows.
```

## Pull request

- Title is the commit subject; one kind per PR.
- Body: the goal, before/after, how it was verified, what is risky, what was not run.
- Link the issue and the postmortem if one exists.

## Stop and ask

Before: reversing a decision in [`DECISIONS.md`](DECISIONS.md); changing CI,
release scripts, permissions or secrets; changing this branch table; deleting or
moving a document; an irreversible migration; publishing, spending, contacting
users or making a public claim.