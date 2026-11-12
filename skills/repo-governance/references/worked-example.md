# Worked example

A fictional project, `relayd`, shows how the files connect. It is a small HTTP
cache service in Go with a JSON index on disk. The numbers and hashes are
illustrative.

## The report

Issue #412:

> After a power cut, relayd started with an empty cache. The index file was
> there but truncated. It overwrote the index and lost 12,000 entries. I'm on
> Linux, relayd v1.8.2, ext4.

## Reads, one at a time

`AGENTS.md` is the whole first read. The rest happen only because the task asks
for them, and two of them are searches rather than cover-to-cover reads.

1. `AGENTS.md` — routes "cache/index" to `docs/subsystems/cache.md`, says the
   full suite is `go test ./...`, and names the real-use check.
2. `docs/subsystems/cache.md` — the index is written temp-and-rename; a read
   failure must keep the last good value; `readIndex` is the shared reader.
3. `LESSONS.md`, searched for "failed read" — finds a related entry: *A failed
   read means unknown* (seen once, on a settings file).
4. `docs/code-standards.md`, searched for "failed read" — "A failed read, parse
   or hash means unknown" is not yet a standard; the tests section requires a red
   check and a break check.
5. Source: `internal/cache/index.go`, `internal/cache/store.go`, and the last
   five commits that touched them.

## Reproduction

```bash
cp testdata/index.json /tmp/relayd/index.json
truncate -s 17 /tmp/relayd/index.json
RELAYD_HOME=/tmp/relayd go run ./cmd/relayd
# logs: "index: 0 entries"; the file is rewritten with {}
```

The failing test:

```go
func TestCorruptIndexKeepsLastGood(t *testing.T) {
    dir := t.TempDir()
    writeFile(t, dir+"/index.json", validIndex(12000))
    truncate(t, dir+"/index.json", 17)

    idx, err := readIndex(dir)
    if err == nil {
        t.Fatalf("readIndex returned no error for a truncated index")
    }
    if idx != nil {
        t.Fatalf("readIndex returned an index on failure; want nil")
    }
}
```

The first version of the test asserts `len(idx.Entries) == 0`, which passes on
the old code. It is rewritten to assert the behavior the fix must provide: an
error, and no empty index handed to the writer.

## Scope list

- `readIndex` callers: startup, reload, the admin `cache verify` command.
- The writer: `loadOrCreateIndex` treats `nil, nil` as "new cache".
- The temp file: `writeIndex` already renames, but it removes the `.tmp` before
  reading it.
- The settings reader has the same `nil, nil` pattern (a sibling).
- Tests: `TestIndexReload`, `TestAdminVerify`, `TestStartupWithNoIndex`.
- Docs: `docs/subsystems/cache.md` says "a missing index starts empty"; it does
  not say what a corrupt index does.

## The change

1. `readIndex` returns a typed error for a read/parse failure; it never returns
   `nil, nil` for a file that exists.
2. `loadOrCreateIndex` only creates an empty index when the file is absent, not
   when it is unreadable.
3. The corrupt file is copied to `index.json.bad-<timestamp>` before a new one
   is written.
4. The shared settings reader is fixed the same way; a guard test covers both
   readers.
5. `docs/subsystems/cache.md` gains a "Failure behavior" paragraph.
6. `scripts/verify.sh` gains the cache corruption case.

## Gates

### Red check

```
$ git stash && go test ./internal/cache -run TestCorruptIndexKeepsLastGood
--- FAIL: TestCorruptIndexKeepsLastGood (0.00s)
    index_test.go:41: readIndex returned no error for a truncated index
FAIL
$ git stash pop && go test ./internal/cache -run TestCorruptIndexKeepsLastGood
ok  	relayd/internal/cache	0.02s
```

### Break check

| Mutation | Test result |
| --- | --- |
| Return `nil, nil` on parse error | red: "returned no error" |
| Remove the `.bad-` copy | red: "last good index was not preserved" |
| Create an empty index when the file exists but cannot be read | red: "overwrote a corrupt index" |
| Skip the settings sibling fix | red: `TestCorruptSettingsKeepsLastGood` |

### Full suite

```
$ go test ./...
ok  	relayd/internal/cache	1.204s
ok  	relayd/internal/settings	0.881s
ok  	relayd/internal/http	3.512s
... 41 packages ok
```

Run at the pushed head `a1b2c3d`, not at the base.

### Real use

In a temp `RELAYD_HOME`, copied from a real cache:

```bash
cp -a /var/lib/relayd /tmp/relayd-real
truncate -s 17 /tmp/relayd-real/index.json
RELAYD_HOME=/tmp/relayd-real ./relayd --once
# logs: "index unreadable; kept last good copy at index.json.bad-..."
# curl localhost:8080/health -> 200
# cache still serves the 12k entries from the last good copy
```

### Not run

```
Not run: Windows (the reporter is on Linux; the change is platform-neutral,
but the file-rename path is untested there).
```

## Commit

```
cache: keep the last good index when the index file is corrupt

Fixes #412 (lin on Discord).
Root cause: readIndex returned (nil, nil) for an unreadable file, and
loadOrCreateIndex treated that as "new cache" and overwrote the file.

Ran at a1b2c3d:
- Red check: TestCorruptIndexKeepsLastGood failed before with "readIndex
  returned no error for a truncated index"; passes after.
- Break check: returning nil on parse error, dropping the .bad copy, and
  creating an empty index for an existing file each made the test red.
- Full suite: go test ./... -> 41 packages ok.
- Real use: truncated a copy of a real cache under a temp RELAYD_HOME;
  served 12k entries and kept index.json.bad-...
- Not run: Windows (platform-neutral change; rename path untested there).
Docs: docs/subsystems/cache.md, failure behavior.
```

## The nightly review

Night 1 entry:

```md
**A failed read, parse or hash means "unknown", never "empty".**
- #412: `readIndex` returned `(nil, nil)` for a truncated index; startup
  overwrote 12k entries (9f2c1a).
- Fix a1b2c3d keeps the last good index and copies the corrupt file aside.
- Done right: 8c1d2e keeps the old settings file when the new one does not
  parse.
- Seen 1× (2026-03-04).
```

Night 2, the same pattern in a provider config reader:

```md
**A failed read, parse or hash means "unknown", never "empty".**
- #412: ... (9f2c1a).
- #431: `readProviderConfig` read a truncated YAML as "no providers"; the
  gateway offered none until restart (b7d1e2).
- Fix 4b7e0d, a1b2c3d.
- Done right: 8c1d2e.
- Seen 2× (2026-03-04, 2026-03-19).
```

Night 3, a third reader:

```md
**A failed read, parse or hash means "unknown", never "empty".**
- ...
- Seen 3× (2026-03-04, 2026-03-19, 2026-04-02).
```

Promotion to `docs/code-standards.md`:

```md
| Rule | What a reviewer looks at |
| --- | --- |
| A failed read, parse or hash means "unknown". | Keep the last good value; copy the unreadable file aside before writing over it; fail closed for a guard list. Test with the file unreadable, truncated and corrupt. A new reader uses the shared reader, not a stricter copy beside it. |
```

The guard test:

```go
func TestReadersNeverTurnFailureIntoEmpty(t *testing.T) {
    for _, tc := range []struct{
        name string
        read func(string) (int, error)
    }{
        {"index", func(d string) (int, error) { i, err := readIndex(d); return len(i.Entries), err }},
        {"settings", func(d string) (int, error) { s, err := readSettings(d); return len(s.Providers), err }},
    } {
        t.Run(tc.name, func(t *testing.T) {
            dir := t.TempDir()
            writeFile(t, dir+"/"+tc.name+".json", "{")
            n, err := tc.read(dir)
            if err == nil {
                t.Fatalf("read %s with no error", tc.name)
            }
            if n != 0 {
                t.Fatalf("returned %d entries on failure", n)
            }
        })
    }
}
```

The lesson is removed from `LESSONS.md` and listed under
`Moved to the code standards`, with the three dates and the guard test.

## The index, the decision, the review row

`AGENTS.md` holds one row for the cache and nothing else about it:

```md
| Cache and index | keeps the last good index, serves reads | docs/subsystems/cache.md |
```

`docs/subsystems/cache.md` owns the facts — its commands (`go test
./internal/cache`), its own index (`internal/cache/index.go`,
`internal/cache/store.go`), its failure modes and this decision:

```md
- `D-cache-1` — a corrupt index is never rewritten in place; the file is copied
  aside and the last good index is served. (owner, 2026-02-11). Why: #412 lost
  12k entries. Forbids: a repair path that overwrites the file it failed to read.
```

The postmortem from that incident produced one review row, which is the only
reason the lesson is kept:

```md
| A failed read keeps the last good value. | The corrupt file is copied aside; nothing writes over a file it could not parse; test with file unreadable, truncated and corrupt. | `← P-002` |
```

Days later a reviewer asks "does the repair path overwrite in place?" without
having read the postmortem. That is the loop working: the story became a
question.

## The project skills

`AGENTS.md` routes a user-facing change to `verify-relayd` and a report to
`repro-relayd`. Both were installed because the product has an HTTP API and a
`relayd cache` CLI, and reports arrive as issues.

`verify-relayd/SKILL.md`, trimmed to its facts:

```md
## Launch
- `cp -a /var/lib/relayd /tmp/relayd-<run>` (one way), `RELAYD_HOME=/tmp/relayd-<run>`.
- `go run ./cmd/relayd` from the worktree.
- Ready when `curl -s localhost:8080/health | jq -e '.index == "loaded"'` is true.
  A 200 alone is not ready: the index loads after the listener binds.

## Drive
- `curl -s localhost:8080/v1/cache/get?key=<seeded key> | jq -r .value`
- CLI reverse state: `relayd cache verify --json`
```

One feature file, `features/cache-verify.md`: reach it with `relayd cache verify
--json` or `GET /v1/cache/verify`; drive it with the two commands above;
observable end state is `{"entries":12000,"index":"ok"}`.

The first version of that skill used the plain `/health` 200 as its readiness
check. Running it once showed a request answered before the index was loaded, so
the check changed to the `.index == "loaded"` field. That detail would not have
fit in the entry file, and reading the code had not revealed it.

`repro-relayd` chose `internal/cache` as the lowest failing layer, because the
report's symptom is a reader. Its step 5 report listed the product-level drive
as the second half: truncate a copy of a real index, start the app, watch it
serve 12k entries.

## What the example demonstrates

- `AGENTS.md` routes; it does not contain the fix.
- The subsystem reference defines the failure contract before the change.
- `LESSONS.md` catches the pattern across three unrelated readers.
- `code-standards.md` gains a rule a reviewer can check, not a story.
- The guard test makes the rule executable.
- The reproduction lives at the layer that owns the behavior, so it survives the
  branch and the next agent.
- The index is a table of areas; the cache's facts live on the cache page, two
  hops from the entry.
- The decision is written where the change happens, so the next agent cannot
  silently reverse it.
- The postmortem survives as a review row, not as a story someone must remember.
- The entry routes to a skill that was executed before it was handed over; its
  readiness check was wrong until it ran.
- The commit body is enough for a later reviewer to reconstruct what ran.
