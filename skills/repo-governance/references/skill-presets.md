# Skill presets: the harness's hands

`AGENTS.md` says what a change must prove. A project skill is how an agent
proves it without improvising: the launch command, the drive recipe, the capture
location, the publish step. Converge installs the presets whose failure mode
exists, in the same run that writes the docs.

## Why a skill and not a doc

A doc is read; a skill is executed. The entry routes "a user-facing change" to
the verify skill, and the agent runs launch → doctor → drive → evidence. That is
four commands and a state rule, and it would not fit in a 150-line entry. A
skill that repeats the rules is a coding skill and stays banned; a skill that
carries a command the entry cannot hold is required.

## The catalog

| Preset | Installs as | Install when | Catches |
| --- | --- | --- | --- |
| `verify` | `.agents/skills/verify-<project>/SKILL.md` + `features/` | A user drives a surface: web UI, CLI/TUI, desktop app, service endpoint. | "The unit test is green and the product is broken"; a proof that never leaves an internal API. |
| `repro` | `.agents/skills/repro-<project>/SKILL.md` | Reports arrive (issues, chat, a user says it broke), or fixes land without a failing test first. | "Fixed by reading the code"; a screenshot-level fix; a reproduction that vanishes when the branch merges. |
| `release` | `.agents/skills/release-<project>/SKILL.md` | The repo publishes an artifact users install: package, binary, image, extension, app build. | "The tag is pushed and nobody opened the artifact"; a version string that names an unpublished build. |

Not presets, because they are read rather than run: branch policy
(`docs/contributing.md`), lessons (`LESSONS.md`), nightly review
(`docs/nightly-review.md`). Do not grow a skill around them.

## Placement

`<skills>` is the folder the repo already uses. Detect it before choosing:

```bash
find . -maxdepth 3 -type d -name skills -not -path './node_modules/*' -not -path './.git/*'
```

Prefer the folder that exists. Otherwise use the harness default: `.agents/skills/`
for Codex, OpenCode, Pi and the other `.agents` harnesses, `.claude/skills/` for
Claude Code, `.cursor/skills/` for Cursor. One folder per repo. A repo with
`verify-*` in two harness folders has two entries by the back door.

## Names and stamps

- Directory: `<preset>-<project-slug>/SKILL.md`, where the slug is the repo name
  lowercased with `-` for spaces.
- v2 installed the verify preset as `test-<project>-app/`. That is the same
  preset under its old name: keep the directory, add the stamp, and do not
  rename it for cosmetics. A rename is a human gate.
- Stamp on the line under the title: `<!-- repo-governance skill: verify v1 -->`.
  It is the only version signal; a later run reads it and nothing else.
- A `SKILL.md` with no stamp is not ours. Merge its commands into the preset an
  agent will actually read, keep every project fact, and report what moved.
  Never overwrite it silently.
- Frontmatter is mandatory (`name`, `description`): without it the skill never
  registers. The description names the project, the surface and the trigger, not
  the category.

## Install procedure

1. **Read the facts; do not ask for them.** Dev command, ports, state directory,
   seed data, existing automation (Playwright/Cypress/expect/tmux/curl), publish
   path. Every command in the skill must have run in this repo.
2. **Pick by failure mode**, not because the tree looks symmetric. No driveable
   surface means no verify skill; say why in the report.
3. **Instantiate from `templates/skills/`.** Replace every `<PROJECT>`,
   `<command>`, `<port>` and `FILL`. A placeholder left in a generated skill is a
   failed build, not a TODO.
4. **Seed the feature map** (verify only): `features/README.md` plus the top 3–5
   user-facing features, each with the four H2s. Journeys come from routes,
   commands, menus or docs, never from the test suite's most convenient path.
5. **Run it once, end to end**: launch, doctor, drive one mapped feature,
   capture, clean up, confirm the evidence survived. Fix what fails. An
   unexecuted skill is a draft, not a deliverable.
6. **Route to it.** One row in the entry's `## Project skills` table, one row in
   its task route table, and the placeholder gate in `scripts/verify.sh`.
7. **Report it**: preset, path, why it applies, what you proved, what you did not.

## The entry rows

At most three rows, one line each, inside the 150-line budget:

```md
## Project skills

Run the skill; do not read it end to end.

| When | Skill |
| --- | --- |
| A user-facing flow changed | `.agents/skills/verify-<project>/SKILL.md` — launch, drive the mapped journey, capture evidence |
| A report says it broke | `.agents/skills/repro-<project>/SKILL.md` — a failing test at the lowest layer first |
| Cutting a release | `.agents/skills/release-<project>/SKILL.md` — open the artifact users install |
```

A repo where no preset applies gets one line instead:
`No project skill applies: <why>`. That line is a decision, not a gap.

## Verify.sh gate

```bash
section "project skills"
# A generated skill may not ship placeholders.
if [ -d .agents/skills ]; then
  if grep -rn 'FILL\|<PROJECT>' .agents/skills --include='SKILL.md'; then
    printf 'unfilled placeholder in a project skill\n' >&2
    exit 1
  fi
fi
```

Wire each skill's doctor command into the same section when it is cheap and
read-only. A skill whose first command is wrong is worse than no skill, because
it reads as proof.

## Idempotency and upgrades

- Same stamp → report `skills current`, write nothing.
- Older skill stamp → print a plan, patch only the sections the preset's version
  names, keep every project fact (commands, ports, feature journeys) verbatim,
  then stamp.
- A project fact the new shape has no home for goes to `features/` or the entry
  file; never drop it silently.
- Running converge twice must leave every skill byte-identical.

## A preset this catalog does not have

Add one only when a failure mode repeats and no gate catches it. It needs:

- the failure mode, with the commit, issue or owner decision as evidence;
- the commands the entry file cannot hold;
- a template in `templates/skills/`;
- a catalog row with its install condition and the check that proves it ran;
- a stamp, a version, and an upgrade rule in `converge.md`.

A preset nobody can run is a doc. A preset no gate checks is a doc that lies.

## Whether it worked

A preset is a hypothesis: that this repo needs this proof, at this cost. Test it
like one.

- **Every preset states its own boundary**: `When this runs`, `When this does
  not`, `If it did not help`. The last one tells the next agent what to write
  when the skill sent it the wrong way.
- **A miss is a finding, not a failure.** When a change needed the skill and
  nobody ran it, say so in the run's report and fix the trigger: the title, the
  description, or the route row. Three misses on the same situation means the
  skill is invisible where it matters.
- **A skill that helps twice and never again gets deleted**, or turned into a
  check the repo runs. Keeping it costs a read every time someone decides
  against it.
- **A preset with no recorded use is unproven.** Delete it, or run it once on a
  real change and keep the evidence. Do not carry it "for later".
- **Numbers are counted, never estimated.** How many times it ran, on what, with
  what outcome. No hit rate, no saved percentage.

## What not to install

- A coding skill (`<project>-coding`) — it repeats `AGENTS.md` and doubles the
  first read.
- A skill around a single command `verify.sh` already runs.
- A skill whose only path needs credentials or a paid model.
- A checklist skill with no command: the entry file's evidence block already is
  that checklist.