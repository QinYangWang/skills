---
name: align-with-me
description: Agree on the requirement, the planned implementation and the acceptance criteria before any of the work happens. Use before a non-trivial request, when scope or acceptance is unclear, or when the user says align, grill me, or check with me first.
---

# Align With Me

Do not start. First settle three things — what is wanted, how it will be done, how it will be judged done — then execute.

## Contract

- No edits, no state-changing commands, no file writes before the Spec block is confirmed. Reading, searching and looking facts up is always allowed.
- Facts are yours. Decisions are the user's. Look up anything the environment can answer; ask only what needs a choice: scope, behavior, trade-off, priority.
- Ask in rounds, not a trickle. One round carries every question whose prerequisites are settled, numbered, each with your recommended answer. Then wait.
- A question whose answer depends on another question still open belongs to the next round.
- One idea per question, short, concrete. Word it so "yes" accepts your recommendation.
- Nothing is silently assumed. If you inferred it, it goes in the Spec block as an assumption.
- Execute only after the user confirms the spec. Silence is not confirmation.

## When this applies

Run it for a request that touches more than one file, has more than one plausible approach, changes user-facing behavior, or leaves the acceptance unclear.

Skip it for a one-line fix, a typo, a question, a read-only look, or an explicit "just do it".

## Process

### 1. Turn the request into a design tree

Read the request and the code it touches. Map the decisions it implies as a tree:

- **Outcome** — what the user gets, in their words.
- **Scope** — what is in, and what is deliberately out.
- **Behavior** — the cases that change, including error, empty and boundary states.
- **Constraints** — compatibility, performance, platforms, data, deadlines.
- **Acceptance** — the checkable statements that will prove it done.

Separate facts you can look up from decisions only the user can make.

**Complete when:** every unknown is either something you can look up or a decision on the table.

### 2. Ask the frontier

The frontier is every decision whose prerequisites are settled. Send the whole frontier in one round:

```
❓ **Q1 — <title>**: <one decision, in a sentence or two, with the options that matter>

➡️ <your recommended answer>
```

Look up facts yourself before asking; never ask the user for something the repository, the docs or a command can answer. Ask the rest of the round without waiting for those lookups.

**Complete when:** every settled decision has been put to the user with a recommendation, and you are waiting for answers.

### 3. Fold in the answers

Each answer settles a decision and pushes the frontier outward. Recompute the tree: new decisions that were blocked are now askable, answers that contradict earlier ones reopen them.

**Complete when:** the frontier is empty and no branch of the tree is left assumed.

### 4. Write the spec block

Put the agreement in the chat, in this shape:

```
Understood: <the requirement in one or two sentences, in the user's terms>
Plan:
  1. <step, with the file or surface it touches>
  2. ...
Acceptance:
  - <a checkable statement: behavior, command, output>
  - ...
Not doing: <scope the user excluded, or "nothing">
Assumptions: <anything you inferred and did not confirm, or "none">
Open: <anything still unanswered, or "none">
```

**Complete when:** the user can answer "yes" without a follow-up question, and every acceptance statement is checkable.

### 5. Wait, then execute

Stop after the spec block. A "yes", a correction, or an edit that keeps its shape is the confirmation. Execute the plan, then check each acceptance statement and report the result against it.

If executing reveals a decision the tree did not cover, stop and reopen step 2 — do not decide it alone.

**Complete when:** every acceptance statement is checked, or reported as not run with the reason.

## When the user cannot answer

If a decision needs knowledge the user does not have and can only get from someone else, do not guess it. Write a short questionnaire they can hand over:

- Ask the user only what they can answer: who the recipient is, and what answer they need back.
- Target the questions at the gap between that person's knowledge and the user's need.
- One question per decision, most important first, an answer stub under each, and a one-line "why this matters" only where the question could be misread.
- Save it as `align-questionnaire-<slug>.md` and give the path.

**Complete when:** every blocked decision is covered by one question and the file exists.

## Stop and ask

Stop the alignment and say so plainly when: the request contradicts a documented rule or an earlier decision; the work needs credentials, money, a public claim or a destructive migration; or two of the user's own statements cannot both be true. Never resolve those by picking one silently.
