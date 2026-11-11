#!/usr/bin/env bash
# Local gates for the project. Fill every TODO before using it as evidence.
# The full suite may run in CI; if it does, this script must say so and the
# commit must point at the CI run at the pushed head. Never fake that line.
# Run from anywhere; the script resolves the repository root itself.
set -euo pipefail
cd "$(dirname "$0")/.."

todo() {
  printf 'TODO: %s\n' "$*" >&2
  printf 'Fill scripts/verify.sh before using it as evidence.\n' >&2
  exit 2
}

section() {
  printf '\n== %s\n' "$*"
}

# If a gate is genuinely not applicable, replace its TODO with an explicit
# NOT RUN line and repeat it in the commit body. Do not silently exit 0.
not_run() {
  printf 'NOT RUN: %s\n' "$*"
}

section "commit convention"
# Every commit in the range being pushed must match
#   <type>(<scope>): <subject>
# with type in feat|fix|perf|docs|refactor|test|build|ci|chore|revert, and a
# behavior change may not hide under chore. Fill the project's own lint.
# Example: npx commitlint --from origin/main --to HEAD
todo "commit convention check is not configured"

section "changed-scope check"
# Format, lint, typecheck affected packages and their dependents, and run the
# tests beside the changed files. This is for iteration, not the merge gate.
# Example: pnpm check:changed
todo "changed-scope check is not configured"

section "tests beside changes"
# Example: go test ./internal/cache ./internal/settings
todo "focused test command is not configured"

section "full suite"
# The full suite is the merge gate. Run it here, or let CI own it and record
# the run at the pushed head. Pin caches and use a temporary HOME/config where
# the project needs it.
# Example: go test ./...
todo "full suite command is not configured"

section "real use"
# Try the real config/account/binary in a sandbox. If impossible here, use:
#   not_run "Windows real-use check (no Windows box in CI)"
todo "real-use check is not configured"

# Optional: if the repo measures the agent-facing context (AGENTS.md, skills,
# tool schemas), run that budget check here. It is a test, not a suggestion.

section "summary"
printf 'All configured gates passed. Record where the full suite ran.\n'
