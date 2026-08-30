# docs/WORKFLOW.md

This document distinguishes two different kinds of rule:

1. **Project-wide engineering expectations** — apply to everyone,
   regardless of what tools they use.
2. **Individual contributor tooling** — each person's personal choice of
   AI model, tool, and process. Not mandated for anyone else.

Where a document elsewhere in this repo (a feature README, a team brief)
describes someone's personal workflow, it's an example of #2, not a
repository requirement — this file is where that distinction is made
explicit and canonical.

---

## 1. Project-wide engineering expectations

These apply no matter what tool or model a contributor is using:

- Understand the repository before making a substantial change — don't
  guess at requirements or existing structure.
- Respect feature ownership boundaries — see `docs/OWNERSHIP.md` for who
  owns what, and who is currently implementing what when that differs.
- Respect frozen contracts — `db/schema.sql` and `lib/models/` do not
  change without group agreement, same rule either way.
- Respect `PROJECT-UNDERSTANDING.md` as the source of truth for product
  scope and behaviour — don't build or document functionality it says
  doesn't exist (see its Part 13, and `CLAUDE.md`'s "What does NOT exist").
- Plan substantial work before implementing it. For small, obvious
  changes, skip unnecessary ceremony.
- Test and verify changes before calling them done.
- Never silently alter architecture or requirements — if something needs
  to change outside your own scope, say so before doing it.
- Use repository-aware development tooling appropriate to the task at
  hand, rather than working blind against guessed file contents.

## 2. Individual contributor tooling

No single AI stack is mandated for the whole team. Each contributor picks
their own tools within the expectations above.

**Sanjay** — uses Claude Code for repository-aware implementation. Chooses
his own Claude model and effort level per task; that choice is personal
and not dictated by this repository.

**Santhosh** — remains owner of Budget and Emergency. Vishwa is currently
implementing those two features on his behalf (see `docs/OWNERSHIP.md`
for the canonical record). No specific AI workflow is prescribed for
Santhosh beyond documenting this arrangement — `team/santhosh/AI-PROMPT-PACK.md`
stays available to him as fallback/reference for whenever he's reviewing,
picking pieces back up, or resuming full implementation.

**Vishwa** — current personal workflow, documented here as an example,
not a requirement for anyone else:

```
GPT-5.6 Luna
  ↓  architecture / planning / task decisions
Claude Code
  ↓  Sonnet 5
  ↓  Superpowers / relevant skills / plugins / subagents
  ↓  implementation + testing
Codex and/or other independent review
  ↓
GPT-5.6 final review
```

- GPT-5.6 Luna is Vishwa's external architecture/planning layer, used
  before and around Claude Code sessions.
- Claude Code is Vishwa's primary repository-aware implementation agent.
  It may draw on Superpowers, skills, plugins, subagents, MCP, hooks, and
  code-intelligence tooling where appropriate — this document doesn't
  restate what those do.
- For substantial or complex implementation work, Sonnet 5 at HIGH effort
  is Vishwa's preferred configuration; lower effort is used for trivial
  or mechanical edits.
- Codex and/or other tools provide independent review of Claude Code's
  output before Vishwa treats work as final.
- GPT-5.6 gives final architectural judgement on Vishwa's own work.
- For UI/UX work specifically, Vishwa may also use **Google Antigravity**
  for visual exploration, UI/UX experimentation, browser-based iteration,
  and visual inspection. Antigravity is Vishwa's personal tooling — it is
  not a project-wide requirement and has no architectural authority over
  this repository.

None of the above — GPT-5.6, Sonnet 5, Antigravity, Codex, or the
specific pipeline shape — is a requirement for Sanjay or Santhosh. It's
recorded here so the team has visibility into how Vishwa's own work
(including his current implementation of Santhosh's Budget and Emergency
modules) gets built and reviewed.

## 3. Claude Code's role in this repository

For whoever is using it, Claude Code is the repository-aware
implementation environment. It may use Superpowers, skills, plugins,
subagents, MCP, hooks, and LSP/code-intelligence tooling where
appropriate — this document doesn't duplicate what those systems do.

For substantial implementation tasks, use an appropriate planning pass
before making broad changes. For small, obvious changes, skip
unnecessary ceremony. In no case should Claude Code silently override an
architectural or ownership decision made outside the repository — if
something looks wrong or undecided, it gets flagged, not resolved by
guessing.

## 4. PR / branch naming — universal

Branches and PRs are named by feature or page, not by contributor:

```
flex/<page-or-feature-being-updated>
```

Examples: `flex/landing-page`, `flex/login`, `flex/accounts`,
`flex/maps`, `flex/itinerary`, `flex/budget`, `flex/emergency`,
`flex/recommendations`.

Contributor names never appear in a branch or PR name. Who owns a
feature, and who is currently implementing it, are documented separately
in `docs/OWNERSHIP.md` — not encoded into the branch name.
