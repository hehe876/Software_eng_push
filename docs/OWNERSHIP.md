# docs/OWNERSHIP.md

**This is the canonical record of feature ownership and current
implementation responsibility.** Where any other document (a feature
README, a team brief, a planner) says something different about who owns
or is implementing a feature, this file wins — update it first, then fix
the other document to match.

## Ownership vs. implementation

These are two different things:

- **Ownership** — who is accountable for a feature's requirements (REQs),
  who signs off that it's actually done, and who gets project credit for
  it. Ownership is fixed for the semester (see `CLAUDE.md`) and does not
  change just because someone else is currently writing the code.
- **Implementation** — who is, right now, the person actually writing the
  Dart code for a feature. This can differ from the owner, as an explicit,
  documented exception. An implementation arrangement never transfers
  ownership, REQ responsibility, or project credit on its own — only an
  update to this file does that.

## Current record

| Feature | REQs | Owner | Current implementer | Notes |
| --- | --- | --- | --- | --- |
| Accounts | REQ-1.1–1.4 | Vishwa | Vishwa | — |
| Itinerary | REQ-2.1–2.4 | Sanjay | Sanjay | — |
| Budget | REQ-3.1–3.5 | **Santhosh** | **Vishwa** | Implementation arrangement, not an ownership transfer — see below |
| Maps & Offline | REQ-4.1–4.3 | Vishwa | Vishwa | — |
| Emergency | REQ-5.1, 5.3, 5.4 | **Santhosh** | **Vishwa** | Implementation arrangement, not an ownership transfer — see below |
| REQ-5.2 (directions inside Emergency) | REQ-5.2 | **Sanjay** | Sanjay | Exception — lives conceptually inside Emergency, but owned and built by Sanjay; see below |
| Recommendations | REQ-6.1–6.4 | Sanjay | Sanjay | — |

## Exception 1 — Budget and Emergency: Vishwa implementing for Santhosh

Vishwa is currently implementing Budget and Emergency (`lib/features/budget/`,
`lib/features/emergency/`, `lib/services/overpass_service.dart`) in a
Claude Code session, on Santhosh's behalf.

- Santhosh remains the **owner** of both features: REQ-3.1–3.5 and
  REQ-5.1/5.3/5.4 responsibility, and project credit for them, stay his.
- This is not a branch or folder reassignment — the branches are still
  `flex/budget` and `flex/emergency`, named by feature, not by whoever is
  currently pushing to them.
- `team/santhosh/README.md` and `team/santhosh/AI-PROMPT-PACK.md` remain
  accurate reference material for Santhosh throughout — whether he's
  reviewing what Vishwa built, picking up a piece of it himself, or
  resuming full implementation later.

## Exception 2 — REQ-5.2: owned by Sanjay, not Santhosh

REQ-5.2 (directions inside the Emergency panel) is owned and implemented
by Sanjay, even though it lives conceptually inside the Emergency
feature. Reason: it requires reading and integrating someone else's live
implementation (`lib/services/routing_service.dart`, owned by Vishwa) —
not practical for Santhosh to do from a pasted prompt with no repo
access. Sanjay builds a self-contained wrapper with a documented
signature (see `lib/services/README.md`); Santhosh's Emergency screen
calls it like any other service, once it lands. Santhosh still owns the
rest of the Emergency UI.

## Keeping this current

If an implementation arrangement changes — Santhosh resumes Budget or
Emergency himself, or anything else shifts — update the table above in
the same change that makes it true. Don't let this file describe a past
arrangement.
