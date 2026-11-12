<!-- FILL: remove this block after filling. Keep this file under 60 lines. -->
# Subsystem design references

These pages describe current responsibilities, runtime paths, state and
contracts. You arrive here from the area table in `AGENTS.md`: read the one page
your task names, follow its own index to the file you change, and verify against
the source. Two hops, then code — a third page means this page is doing too
little.

Each area page owns its own facts: commands, index, known failure modes and
decisions. Do not repeat them here, and do not move them into `AGENTS.md`.

| Subsystem | Reference | Source |
| --- | --- | --- |
| <One-line responsibility> | [`<area>.md`](<area>.md) | [`<path>`](../<path>) |
| <One-line responsibility> | [`<area>.md`](<area>.md) | [`<path>`](../<path>) |
| <One-line responsibility> | [`<area>.md`](<area>.md) | [`<path>`](../<path>) |

A subsystem can span several packages, apps or repositories. Its reference
describes the behavior those parts provide together; it does not need to list
every function.

## Maintain a reference

Update the owning reference in the same change when a change alters a documented
responsibility, interface, state transition, runtime path, compatibility rule or
failure behavior. An internal refactor that preserves these contracts does not
need a prose change.

Keep each fact in one reference and link to it from agent instructions or other
pages. Link to source files and named symbols rather than copying
implementation details that change frequently. Explain field meanings and
constraints that signatures alone do not express.

For a new reference, include the responsibilities and boundaries, source of
truth, main runtime paths, state transitions, important constraints and
existing verification commands. Include failure and compatibility behavior
where relevant. Document current behavior separately from proposed changes; the
proposal belongs in its issue or PR.

## Describe a change's semantic effect

For each affected subsystem, explain the observable change with its trigger and
before/after behavior. Include changes to interfaces, state, compatibility and
failure behavior when relevant. Link the affected reference, implementation and
verification evidence. State when a refactor preserves the documented behavior.

This is an author-provided explanation that a reviewer verifies against the diff
and the surrounding code. It is not an automatically proven compatibility
verdict.

## Review a change

1. Identify the affected subsystem and the actual runtime path.
2. Compare the claimed before/after behavior with the base and head
   implementation. Trace callers and state transitions beyond the changed lines.
3. Check that changed contracts appear in the owning reference and that source
   links still resolve.
4. Check that the cited tests or runtime evidence exercise the claimed behavior.
   Report checks that were not run.

A documentation update alone does not prove the implementation. Existing tests
and runtime evidence remain necessary for behavior changes.
