# CLAUDE.md

Project context for Claude Code. Documentation authority, most to least:

1. `PROJECT-UNDERSTANDING.md` — product requirements, agreed
   functionality, scope, and system behaviour. Wins any disagreement with
   anything below.
2. `CLAUDE.md` (this file) — Claude Code-specific hard constraints,
   architecture rules, ownership boundaries.
3. Feature READMEs and `team/` docs — feature-specific implementation
   guidance and project-management detail.

Read `PROJECT-UNDERSTANDING.md` first if you haven't.

## What this project is

Smart Travel Planning Assistant and Budget Management System — a Flutter
mobile app (Android-first) that puts trip planning, budget tracking, map
routing, offline access, emergency assistance, and destination
recommendations in one place. A user signs in, creates a trip with a
destination and dates, sets a budget split by category, builds a
day-by-day itinerary by hand (typing stops in or tapping suggestions),
sees those stops on a map with routing between them, downloads the trip
for offline use, logs expenses as they spend, and can pull up nearby
hospitals and police with one-tap calling if something goes wrong. All
logic runs on the phone. There is no server-side code anywhere in this
system — Supabase stores rows and answers queries, nothing more. Software
engineering course project, Vellore Institute of Technology, Chennai.

## The stack — do not substitute

| Layer | Choice |
| --- | --- |
| App | Flutter + Dart |
| State management | Provider |
| Auth + Database | Supabase (Postgres + Auth), free tier |
| Offline storage | Hive |
| Maps | flutter_map + OpenStreetMap tiles |
| Routing | OSRM public demo server |
| Nearby places (emergency) | Overpass API |
| GPS | geolocator |
| Calling | url_launcher (`tel:` links) |
| HTTP | http |
| Dates | intl |

That's the full dependency list, and it's fixed — see `pubspec.yaml`. Do
not add a package without raising it in the group chat first. No new
dependencies is a hard rule, not a suggestion.

## Hard rules

1. **Stay in your own feature folder.** `lib/features/<name>/` belongs to
   one owner — see the ownership table below. Ownership and
   implementation are separate: an owner can have someone else
   implementing their feature on their behalf, recorded as an exception
   in `docs/OWNERSHIP.md` (the canonical source — check it before
   assuming a folder is off-limits). If something outside your folder —
   and outside any recorded exception — needs to change, say so in the
   group chat first.
2. **`db/schema.sql` is FROZEN.** Every table for every feature is already
   in there. A schema change breaks every branch's queries, not just
   yours — get agreement before touching it.
3. **`lib/models/` is FROZEN.** These classes are the shared contract
   across all three branches — see `lib/models/CONTRACT.md`. Changing a
   field name or type there silently breaks code on branches you can't
   see. If a feature genuinely needs a new field, that's a schema change
   too — same rule as above.
4. **Never touch `.env` or hardcode keys.** There is no `.env` file in
   this project — Supabase config is passed at build time via
   `--dart-define`, see `RUN.md`. Never write a real Supabase key into any
   committed file.
5. **No new dependencies beyond `pubspec.yaml`.** If a task seems to need
   one, that's a sign to ask the group before writing the code, not after.
6. **Prefer boring, readable code.** Every line has to be defensible when
   a student explains it in a viva. That means no cleverness for its own
   sake, no abstraction built for a use case that doesn't exist yet, and
   comments only where the *why* isn't obvious from the code itself.
7. **Do not invent excluded functionality.** See "What does NOT exist"
   below and `PROJECT-UNDERSTANDING.md` Part 13 — if something is
   genuinely undecided, leave it flagged as undecided rather than
   guessing.

## Feature ownership

Branches use `flex/<page-or-feature>` naming, not contributor names —
see `docs/WORKFLOW.md`.

| Feature | Folder | REQs | Owner | Branch |
| --- | --- | --- | --- | --- |
| Accounts | `lib/features/accounts/` | REQ-1.1–1.4 | Vishwa | `flex/accounts` |
| Itinerary | `lib/features/itinerary/` | REQ-2.1–2.4 | Sanjay | `flex/itinerary` |
| Budget | `lib/features/budget/` | REQ-3.1–3.5 | Santhosh | `flex/budget` |
| Maps & Offline | `lib/features/maps/` | REQ-4.1–4.3 | Vishwa | `flex/maps` |
| Emergency | `lib/features/emergency/` | REQ-5.1, 5.3, 5.4 | Santhosh | `flex/emergency` |
| Recommendations | `lib/features/recommendations/` | REQ-6.1–6.4 | Sanjay | `flex/recommendations` |

Ownership above is fixed and does not change when someone else is
currently implementing a feature — see `docs/OWNERSHIP.md` for who is
currently implementing what (e.g. Budget and Emergency are currently
implemented by Vishwa, on Santhosh's behalf; ownership stays Santhosh's).

**Exception — REQ-5.2 (directions inside Emergency):** owned by Sanjay,
not Santhosh, even though it lives conceptually inside the Emergency
feature. Reason: it's the one Emergency task that requires reading and
integrating someone else's live implementation
(`lib/services/routing_service.dart`, owned by Vishwa) — exactly what
Santhosh can't do without repo-aware AI tooling (he's on free tier, no
Claude Code access). Sanjay builds a self-contained wrapper with a
documented signature (see `lib/services/README.md`); Santhosh calls it
from his own Emergency screen like any other service. Santhosh still owns
the rest of the Emergency UI. See `docs/OWNERSHIP.md` for this and the
Budget/Emergency exception recorded in one place.

## Build order

Not arbitrary — it's a dependency chain:

```
1. Accounts        (Vishwa)     — everything keys on user_id
       │
       ├── 2. Itinerary  (Sanjay)     — creates trips/itinerary_items, which Maps reads
       │        │
       │        └── 4. Maps + Offline (Vishwa)   — plots itinerary stops, builds routing_service.dart
       │                 │
       │                 └── 5. Emergency (Santhosh)  — calls Sanjay's REQ-5.2 wrapper around routing_service.dart
       │
       └── 3. Budget     (Santhosh)   — independent, runs parallel with Itinerary
                │
                └── 6. Recommendations (Sanjay)  — last; REQ-6.4 lets it degrade gracefully
```

(Owner labels above are fixed; the current implementer for a step can
differ from the owner — see `docs/OWNERSHIP.md`.)

## What does NOT exist — do not invent these

Straight from `PROJECT-UNDERSTANDING.md` Part 13. If you write code or
docs implying any of the following, you're building something that was
never agreed to:

- **Itinerary auto-generation.** Nothing turns a destination, dates,
  budget, and preferences into a day-by-day plan. The user builds the
  itinerary by hand, one stop at a time, either typing it in or tapping a
  recommendation. There is no planning engine.
- **Any connection between budget and itinerary.** They are entirely
  disconnected systems. A stop has no price. Adding expensive places to a
  day changes nothing on the budget screen until the user separately,
  manually logs an expense. Nothing checks whether a day's stops are
  geographically sensible either — distance between stops is not
  validated.
- **Any ML model.** Recommendation ranking is a plain database `ORDER BY`
  on a hand-seeded table. If a similarity ranking gets built on top, it is
  a scoring function, not a trained model — describe it that way.
- **Any server-side logic.** Flutter does all the thinking. Supabase
  stores rows and answers queries; it never reaches out to OSRM, Overpass,
  or anything else on its own.
- **Background location tracking.** Agreed as a stretch goal, discussed,
  never designed. Only one-off position lookups (nearby hospitals, route
  from here) and caching the last known position as a fallback are in
  core scope. Continuous tracking with the app closed, a "Trip Mode"
  session, watchdog check-ins, and location sharing are all explicitly
  out of scope for now.

Also not decided, so don't build against an assumption either way: what
happens when someone edits a trip while offline, when cached data should
expire, and SMS emergency alerts to contacts.

## Claude Code workflow

Claude Code is the repository-aware implementation environment. It may
use Superpowers, skills, plugins, subagents, MCP, hooks, and
code-intelligence tooling where appropriate — this file doesn't restate
what those do. Plan before substantial changes; skip the ceremony for
small, obvious ones. Never silently override an architecture or
ownership decision made outside the repo.

Branch/PR naming is `flex/<page-or-feature>`, project-wide, with no
contributor names in branch or PR titles. See `docs/WORKFLOW.md` for the
full workflow philosophy, including which parts are project-wide rules
versus individual contributor tooling choices — specific AI models and
effort levels are personal preferences, not repository requirements.
