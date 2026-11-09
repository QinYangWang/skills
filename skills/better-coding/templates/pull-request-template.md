<!-- FILL: remove this block after filling. Keep this file under 40 lines. -->
## Goal

<What user-visible or system behavior changes, and why. Link the issue/report.>

## Semantic change

- Trigger: <what starts the path>
- Before: <behavior>
- After: <behavior>
- Affected contracts: <interfaces, state, compatibility, failure behavior>
- Docs updated: <owning reference>

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

- [ ] One goal; unrelated changes are separate.
- [ ] The new test fails without the change.
- [ ] Deliberate breaks are caught by the tests.
- [ ] Full suite ran at the pushed head (local or CI, named above).
- [ ] Real use was tried, or is listed as not run.
- [ ] The evidence type matches the change (test / capture / transcript / eval).
- [ ] If a surface matrix exists, it is filled and N/A rows have reasons.
- [ ] If a context budget exists, its measuring test passes.
- [ ] The owning subsystem reference is updated, or the change says why not.
- [ ] The commit body carries the evidence.
