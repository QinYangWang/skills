<!-- FILL: fill one row per surface. N/A needs a reason. Add project-specific
surfaces; keep the categories. Use this before calling a cross-surface change
done, and paste the result into the PR. -->
# Surface matrix: <change>

| Surface | Applies? | What changes | Verified |
| --- | --- | --- | --- |
| Entry points (main view, settings, command palette, keybinding) | Yes / N/A | <which entries reach the behavior> | <test / capture / not run> |
| Clients (web, desktop, mobile, shared runtime) | Yes / N/A | <which clients> | <test / capture / not run> |
| Providers / adapters | Yes / N/A | <decision per adapter, even "not supported here"> | <test / real use / not run> |
| Agents / automation / scheduled tasks | Yes / N/A | <can an agent reach it? same service path?> | <test / transcript / not run> |
| Contracts (wire schema, saved format, API) | Yes / N/A | <schema and every consumer> | <typecheck / migration test / not run> |
| Reverse states (undo, close/reopen, snooze/unsnooze) | Yes / N/A | <the way out and the way to see it> | <test / not run> |
| Connection modes (local, remote, relay, tunnel) | Yes / N/A | <which modes> | <real use / not run> |
| Docs (internal reference, user guide) | Yes / N/A | <updated / not needed, why> | <link check> |
| Release / packaging | Yes / N/A | <artifact or migration affected> | <smoke / not run> |

## Notes

- The most common defect is a change that works on the path you tested and is
  missing everywhere else. The matrix is not a checkbox ritual; it is a list of
  the surfaces you did **not** test.
- If a surface is N/A, write why. "N/A" without a reason is not a decision.
- Keep the row names stable across changes; add project-specific rows at the
  end. The living copy can live in `docs/surface-matrix.md`.
