<!-- FILL: remove this block after filling. Keep this file under 50 lines. -->
## Change kind and base

- Kind: <fix | feature | breaking | chore | refactor>
- Base branch: <stable line | next minor | major line> — <why this branch>
- Design note: <link, for new surface only>

## Goal

<What user-visible or system behavior changes, and why. Link the issue/report.>

## Semantic change

- Trigger: <what starts the path>
- Before: <behavior>
- After: <behavior>
- Affected contracts: <interfaces, state, compatibility, failure behavior>
- Docs updated: <owning reference>

## Cost

<Hot path, bundle size, extra requests, memory: measured, or "not on a hot
path". Dev-only code sits behind the project's dev flag and stays tree-shakable.>

## Evidence

```
Ran at <pushed sha>:
- Red check: <test> failed before with <output>; passes after.
- Break check: <mutations> each made <test> red.
- Full suite: <local command or CI run> at <sha> -> <summary>.
- Real use: <what, where>.
- Not run: <check> (<why>).
```

## Risk and rollback

<What can go wrong, who is affected, and how to undo it.>

## Checklist

- [ ] The base branch matches the change kind, and the branch holds one kind.
- [ ] A fix names its reproduction; a new surface names its approved design
      note; a refactor names its measured reason.
- [ ] No reformat, rename or drive-by refactor is mixed into the diff.
- [ ] The header matches the commit convention and produces the changelog
      entry a user should read; a break carries `BREAKING CHANGE:`.
- [ ] One goal; unrelated changes are separate.
- [ ] The new test fails without the change.
- [ ] Deliberate breaks are caught by the tests.
- [ ] Full suite ran at the pushed head (local or CI, named above).
- [ ] Real use was tried, or is listed as not run.
- [ ] The evidence type matches the change (test / capture / transcript / eval).
- [ ] If a surface matrix exists, it is filled and N/A rows have reasons.
- [ ] If a context budget exists, its measuring test passes.
- [ ] The owning subsystem reference is updated, or the change says why not.
- [ ] The commit body carries the evidence, at the head being merged.
