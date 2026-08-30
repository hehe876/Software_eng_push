# Smart Travel Planning Assistant and Budget Management System

A Flutter mobile app combining itinerary planning, budget tracking, map
navigation with offline access, emergency assistance, and destination
recommendations.

Software engineering course project — Vellore Institute of Technology,
Chennai.

| Name | Reg. No | Owns |
| --- | --- | --- |
| Vishwa Thangapandiyan | 24BCE1415 | Accounts, Maps & Offline |
| Sanjay Sivakumar | 24BCE1948 | Itinerary, Recommendations |
| Santhosh S | 24BCE5169 | Budget, Emergency Assistance |

**Why Flutter, not a web app.** This project started as a React + Vite web
app. It was rebuilt as Flutter because background location tracking — the
foundation for a later "Trip Mode" and live-sharing direction the team
wants to build toward — is not possible in a web app on any platform.
Flutter can do it; a browser tab can't. To be precise about scope:
background tracking itself is **not built and not in the core plan** — see
`PROJECT-UNDERSTANDING.md` Part 10 and Part 13. It's a stretch goal. The
platform decision was made now, ahead of actually needing it, so the app
isn't rebuilt a second time later.

---

## 0. New here? Read this first

**Do not start coding from this file.** Open [`START-HERE.md`](START-HERE.md) —
it covers cloning the repo, making a branch, pushing your work, and
opening a pull request, written for people who have never used Git.

Then open your own folder in [`team/`](team/) and follow the brief there.
**Step 0 of that brief loads project context into your AI tool** — do not
skip it. A task read without the requirements behind it produces code that
drifts from the SRS.

---

## 1. What this project is

Planning a trip means juggling four or five apps — maps in one, a budget
spreadsheet in another, itinerary notes in a third. This app puts them in
one place.

A user signs in, creates a trip with dates and a destination, builds a
day-wise itinerary, sets a budget split across categories, and logs
expenses as they spend. Itinerary stops appear on a map with routing.
Before travelling, they can download a destination for offline use so the
app still works when the connection drops. If something goes wrong, an
emergency panel lists nearby hospitals and police stations with one-tap
calling. A recommendations feed suggests places near the destination that
can be added straight to the itinerary.

Six features, all specified in the SRS. Nothing outside those six ships in
v1.

Read `PROJECT-UNDERSTANDING.md` for how these six features actually fit
together end to end — it's the authoritative description of the system,
more detailed and more current than this file.

## 2. What we are honest about

Worth keeping in mind for every document, PR, and the viva. These are the
project's real limits, and stating them plainly beats being caught
overclaiming:

- **Nothing generates an itinerary.** The user builds it manually, one
  stop at a time — either by typing it in or by tapping a recommendation.
  There is no planning engine, and none was ever designed. See
  `PROJECT-UNDERSTANDING.md` Part 3.
- **Budget and itinerary are entirely disconnected systems.** A stop has
  no price attached to it. Adding expensive places to a day changes
  nothing on the budget screen until the user separately, manually logs an
  expense. Nothing checks whether a day's stops are even close to each
  other geographically.
- **Offline mode is not a fully pannable offline map.** It is cached
  itinerary data, cached guide text, and one static map image per
  destination. Still a legitimate offline mode — just sized to what three
  students finish in a semester.
- **We are not load-testing at production scale.** The SRS says so
  explicitly. The app should feel responsive for one user; that is the
  bar.
- **Offline coverage is limited to a handful of chosen destinations**, not
  everywhere.
- **The recommendation engine is a database-driven ranking**, not a
  trained ML model. REQ-6.4 deliberately allows this. Any similarity
  ranking we add is a ranking function, and we describe it that way.
- **This is not a certified emergency-dispatch system.** The Emergency
  panel states that in a real emergency the user should also call local
  services directly.
- **Background location tracking is a stretch goal, not a built feature.**
  See the note at the top of this file and `PROJECT-UNDERSTANDING.md`
  Part 10.

## 3. Tech stack

| Layer | Choice | Why |
| --- | --- | --- |
| App | Flutter + Dart | One codebase, targeting Android first — and unlike a web app, it can access background location, which is the reason this isn't a browser app anymore (see the note above). |
| State management | Provider | Holds data several screens share (e.g. budget totals) so they redraw together when it changes, without passing data down by hand. |
| Auth + Database | Supabase (free tier) | Free Postgres, built-in auth with Google sign-in, auto-generated API. We do not hand-roll password hashing or sessions. |
| Maps | flutter_map + OpenStreetMap | Completely free, **no credit card required**. Google Maps' free tier still demands a billing account — a pointless blocker for a student project. |
| Routing | OSRM public demo server | Free, no key, fine for a demo. |
| Emergency data | Overpass API | Free, no key, queries OpenStreetMap for hospitals and police stations. |
| Offline storage | Hive | A small database that lives on the phone, so cached trip data survives with no connection. |

**On "where is the backend?"** — Supabase generates an API over our
Postgres database and enforces per-user access with Row Level Security.
That is the application server / API layer described in SRS Section 2.1.
We are not skipping the backend; we are using a hosted one instead of
writing our own. Defensible in the viva, and it saves weeks.

## 4. Repo structure

```
smart-travel-assistant/
├── README.md                  this file
├── START-HERE.md               git + flutter setup guide, read this first
├── RUN.md                       exact flutter run command, with Supabase keys
├── FILE-STRUCTURE.md            build spec — what lives where and why
├── CLAUDE.md                    project context for Claude Code
├── .gitignore
├── pubspec.yaml                fixed dependency list — no additions without asking
├── analysis_options.yaml
│
├── team/                      per-person task briefs and planners
│   ├── vishwa/                Accounts, Maps & Offline
│   ├── sanjay/                Itinerary, Recommendations
│   └── santhosh/               Budget, Emergency  (+ AI prompt pack)
│
├── db/
│   ├── schema.sql             ALL tables for ALL features. Frozen — see rule 2.
│   └── seed.sql                demo data for recommendations and helplines
│
├── lib/
│   ├── main.dart               entry point, Provider setup, Supabase init
│   │
│   ├── models/                 ★ the frozen interface contract
│   │   ├── CONTRACT.md         read this before touching any model
│   │   └── *.dart               one class per table in db/schema.sql
│   │
│   ├── services/                anything that talks to the outside world
│   │   └── README.md            documents every service's signature
│   │
│   ├── providers/               state, one per feature area
│   │
│   ├── features/                one folder per SRS feature, one owner each
│   │   ├── accounts/            Vishwa    — REQ-1.x
│   │   ├── itinerary/            Sanjay    — REQ-2.x
│   │   ├── budget/                Santhosh  — REQ-3.x
│   │   ├── maps/                   Vishwa    — REQ-4.x
│   │   ├── emergency/               Santhosh  — REQ-5.x (except REQ-5.2, see below)
│   │   └── recommendations/          Sanjay    — REQ-6.x (and REQ-5.2)
│   │
│   ├── screens/                 top-level navigation
│   └── widgets/                  shared UI
│
└── docs/                      SRS, WBS, Gantt, diagrams — NOT pushed to GitHub
    ├── srs/  wbs/  gantt/  images/
```

`docs/` contents are gitignored on purpose — they are binary submission
artifacts, not source. The folder structure stays tracked so a fresh clone
shows where things belong. See [`docs/README.md`](docs/README.md).

## 5. Ownership and branches

Each person owns two features and works on their own branch. **Only touch
your own feature folder** — or a folder you're an authorized implementer
for, see below.

Branches are named `flex/<page-or-feature>`, not by contributor — the
name stays the same regardless of who is currently implementing it.
Current implementer exceptions (e.g. Budget and Emergency currently being
implemented by Vishwa on Santhosh's behalf) are recorded in
[`docs/OWNERSHIP.md`](docs/OWNERSHIP.md), the canonical source — ownership
itself doesn't change because of who's implementing.

| Branch | Owner | Folders they edit |
| --- | --- | --- |
| `flex/accounts` | Vishwa | `lib/features/accounts/`, `lib/services/supabase_service.dart` |
| `flex/maps` | Vishwa | `lib/features/maps/`, `lib/services/routing_service.dart`, `lib/services/location_service.dart` |
| `flex/itinerary` | Sanjay | `lib/features/itinerary/` |
| `flex/recommendations` | Sanjay | `lib/features/recommendations/`, plus the REQ-5.2 directions wrapper (see `lib/features/emergency/README.md`) |
| `flex/budget` | Santhosh | `lib/features/budget/` |
| `flex/emergency` | Santhosh | `lib/features/emergency/`, `lib/services/overpass_service.dart` |

## 6. Ground rules

1. **Touch only your own feature folder.** If something in
   `lib/screens/`, `lib/widgets/`, `lib/models/`, or `db/schema.sql` needs
   changing, say so in the group chat first. Silent edits to shared files
   are how three people end up with three broken branches.

2. **`db/schema.sql` is frozen once we run it.** Every table for every
   feature is already in there. If your feature needs a column that does
   not exist, tell the group before adding it — a schema change breaks
   everyone's queries, not just yours.

3. **`lib/models/` is frozen.** These are the shared Dart classes every
   branch reads and writes against — see `lib/models/CONTRACT.md`.
   Changing a field breaks the other two branches silently. Same rule as
   the schema, because it's the same problem one layer up.

4. **Never touch `.env` or hardcode a key.** There is no `.env` file in
   this project — Supabase config is passed with `--dart-define` at run
   time, see `RUN.md`. (The Supabase anon key is public by design and safe
   in a compiled app — Row Level Security is what protects the data. The
   `service_role` key is a different story and must never appear
   anywhere.)

5. **Pull before you start, every time.** `git checkout main && git pull`
   before making a branch. Skipping this is the number-one cause of merge
   conflicts.

6. **Small PRs, often.** One PR per working piece — "login screen works" —
   not one giant PR at the end of the month.

7. **Update your planner.** Each `team/<name>/PLANNER.md` has dated
   milestones. Tick things off as you finish. When the instructor asks
   where we are, that file is the answer.

8. **Blocked for more than a day? Say so.** Especially Santhosh — you are
   on free-tier AI, and burning ten free messages on one bug is worse than
   someone with Pro pasting the error into their session and handing back
   a fix in one.

## 7. Build order

Not arbitrary — it is a dependency chain.

```
1. Accounts        (Vishwa)     ← everything keys on user_id. Nothing works until this does.
       │
       ├── 2. Itinerary  (Sanjay)     ← creates the trips table Maps needs
       │        │
       │        └── 4. Maps + Offline (Vishwa)   ← plots itinerary stops, builds routing_service.dart
       │                 │
       │                 └── 5. Emergency (Santhosh)  ← calls Sanjay's REQ-5.2 wrapper around routing_service.dart
       │
       └── 3. Budget     (Santhosh)   ← independent, runs parallel with Itinerary
                │
                └── 6. Recommendations (Sanjay)  ← last; REQ-6.4 lets it degrade gracefully
```

**Weeks 1–2 are not idle for Sanjay and Santhosh.** While Accounts is being
built, they build their screens against hardcoded data and swap in real
queries once auth lands. Details in the individual planners.

## 8. Running it locally

Full instructions with troubleshooting are in [`START-HERE.md`](START-HERE.md).
Short version:

```bash
git clone <repo-url>
cd smart-travel-assistant
flutter pub get
flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
```

The real values for the two `--dart-define` flags are posted in the group
chat by Vishwa. See [`RUN.md`](RUN.md) for the full command and why there's
no `.env` file to copy.

## 9. Timeline

Semester runs to **20 November 2026**. Planning, SRS, and design
documentation are complete. We are in **Phase 4: Implementation**.

| Sprint | Dates | Focus |
| --- | --- | --- |
| 0 | Aug 24 – Aug 30 | Everyone: setup, Flutter running locally, Supabase connected |
| 1 | Aug 31 – Sep 13 | Accounts (Vishwa). Others build UI shells on hardcoded data. |
| 2 | Sep 14 – Sep 27 | Itinerary (Sanjay), Budget (Santhosh) |
| 3 | Sep 28 – Oct 18 | Maps & Offline (Vishwa), Emergency (Santhosh) |
| 4 | Oct 19 – Nov 1 | Recommendations (Sanjay), integration of all six features |
| 5 | Nov 2 – Nov 8 | Testing — unit, integration, demo dry-run |
| 6 | Nov 9 – Nov 20 | Deploy, user guide, final report, viva prep |

Sprint dates match the Gantt chart in `docs/gantt/`.
