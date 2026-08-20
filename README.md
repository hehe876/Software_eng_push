# Smart Travel Planning Assistant and Budget Management System

Web-based travel planning app combining itinerary planning, budget tracking, map navigation with offline access, emergency assistance, and destination recommendations.

Software engineering course project — Vellore Institute of Technology, Chennai.

| Name | Reg. No | Owns |
| --- | --- | --- |
| Vishwa Thangapandiyan | 24BCE1415 | Accounts, Maps & Offline |
| Sanjay Sivakumar | 24BCE1948 | Itinerary, Recommendations |
| Santhosh S | 24BCE5169 | Budget, Emergency Assistance |

---

## 0. New here? Read this first

**Do not start coding from this file.** Open [`START-HERE.md`](START-HERE.md) — it covers cloning the repo, making a branch, pushing your work, and opening a pull request, written for people who have never used Git.

Then open your own folder in [`team/`](team/) and follow the brief there. **Step 0 of that brief loads project context into your AI tool** — do not skip it. A task read without the requirements behind it produces code that drifts from the SRS.

---

## 1. What this project is

Planning a trip means juggling four or five apps — maps in one, a budget spreadsheet in another, itinerary notes in a third. This app puts them in one place.

A user signs in, creates a trip with dates and a destination, builds a day-wise itinerary, sets a budget split across categories, and logs expenses as they spend. Itinerary stops appear on a map with routing. Before travelling, they can download a destination for offline use so the app still works when the connection drops. If something goes wrong, an emergency panel lists nearby hospitals and police stations with one-tap calling. A recommendations feed suggests places near the destination that can be added straight to the itinerary.

Six features, all specified in the SRS. Nothing outside those six ships in v1.

## 2. What we are honest about

Worth keeping in mind for every document, PR, and the viva. These are the project's real limits, and stating them plainly beats being caught overclaiming:

- **Offline mode is not a fully pannable offline map.** It is cached itinerary data, cached guide text, and one static map image per destination. Still a legitimate offline mode — just sized to what three students finish in a semester.
- **We are not load-testing at production scale.** The SRS says so explicitly. The app should feel responsive for one user; that is the bar.
- **Offline coverage is limited to a handful of chosen destinations**, not everywhere.
- **The recommendation engine is a database-driven ranking**, not a trained ML model. REQ-6.4 deliberately allows this. Any similarity ranking we add is a ranking function, and we describe it that way.
- **This is not a certified emergency-dispatch system.** The Emergency panel states that in a real emergency the user should also call local services directly.

## 3. Tech stack

| Layer | Choice | Why |
| --- | --- | --- |
| Frontend | React + Vite | Standard, fast dev server, everyone can run it |
| Auth + Database | Supabase (free tier) | Free Postgres, built-in auth with Google sign-in, auto-generated REST API. We do not hand-roll password hashing or sessions. |
| Maps | Leaflet + OpenStreetMap | Completely free, **no credit card required**. Google Maps' free tier still demands a billing account — a pointless blocker for a student project. |
| Routing | OSRM public demo server | Free, no key, fine for a demo |
| Emergency data | Overpass API | Free, no key, queries OpenStreetMap for hospitals and police stations |
| Offline storage | IndexedDB (via `idb`) | Browser storage that survives with no connection |
| Styling | Plain CSS | No framework to learn on top of everything else |

**On "where is the backend?"** — Supabase generates a REST API over our Postgres database and enforces per-user access with Row Level Security. That is the application server / API layer described in SRS Section 2.1. We are not skipping the backend; we are using a hosted one instead of writing our own. Defensible in the viva, and it saves weeks.

## 4. Repo structure

```
smart-travel-assistant/
├── README.md                  this file
├── START-HERE.md              git + setup guide, read this first
├── FILE-STRUCTURE.md          build spec — what lives where and why
├── CLAUDE.md                  project context for Claude Code
├── .env.example               copy to .env and fill in your Supabase keys
│
├── team/                      per-person task briefs and planners
│   ├── vishwa/                Accounts, Maps & Offline
│   ├── sanjay/                Itinerary, Recommendations
│   └── santhosh/              Budget, Emergency  (+ AI prompt pack)
│
├── db/
│   ├── schema.sql             ALL tables for ALL features. Frozen — see rule 2.
│   └── seed.sql               demo data for recommendations and helplines
│
├── src/
│   ├── features/              one folder per SRS feature, one owner each
│   │   ├── accounts/          Vishwa    — REQ-1.x
│   │   ├── itinerary/         Sanjay    — REQ-2.x
│   │   ├── budget/            Santhosh  — REQ-3.x
│   │   ├── maps/              Vishwa    — REQ-4.x
│   │   ├── emergency/         Santhosh  — REQ-5.x
│   │   └── recommendations/   Sanjay    — REQ-6.x
│   ├── components/            shared UI used by more than one feature
│   ├── pages/                 top-level screens and routing
│   ├── lib/                   supabase client, routing, offline helpers
│   └── styles/
│
└── docs/                      SRS, WBS, Gantt, diagrams — NOT pushed to GitHub
    ├── srs/  wbs/  gantt/  images/
```

`docs/` contents are gitignored on purpose — they are binary submission artifacts, not source. The folder structure stays tracked so a fresh clone shows where things belong. See [`docs/README.md`](docs/README.md).

## 5. Ownership and branches

Each person owns two features and works on their own branch. **Only touch your own feature folder.**

| Branch | Owner | Folders they edit |
| --- | --- | --- |
| `feat/accounts` | Vishwa | `src/features/accounts/`, `src/lib/supabase.js` |
| `feat/maps` | Vishwa | `src/features/maps/`, `src/lib/routing.js`, `src/lib/offline.js` |
| `feat/itinerary` | Sanjay | `src/features/itinerary/` |
| `feat/recommendations` | Sanjay | `src/features/recommendations/` |
| `feat/budget` | Santhosh | `src/features/budget/` |
| `feat/emergency` | Santhosh | `src/features/emergency/` |

## 6. Ground rules

1. **Touch only your own feature folder.** If something in `src/components/`, `src/pages/`, or `db/schema.sql` needs changing, say so in the group chat first. Silent edits to shared files are how three people end up with three broken branches.

2. **`db/schema.sql` is frozen once we run it.** Every table for every feature is already in there. If your feature needs a column that does not exist, tell the group before adding it — a schema change breaks everyone's queries, not just yours.

3. **Never commit `.env`.** It is gitignored; keep it that way. (The Supabase anon key is public by design and safe in the browser — Row Level Security is what protects the data. The `service_role` key is a different story and must never appear anywhere.)

4. **Pull before you start, every time.** `git checkout main && git pull` before making a branch. Skipping this is the number-one cause of merge conflicts.

5. **Small PRs, often.** One PR per working piece — "login screen works" — not one giant PR at the end of the month.

6. **Update your planner.** Each `team/<name>/PLANNER.md` has dated milestones. Tick things off as you finish. When the instructor asks where we are, that file is the answer.

7. **Blocked for more than a day? Say so.** Especially Santhosh — you are on free-tier AI, and burning ten free messages on one bug is worse than someone with Pro pasting the error into their session and handing back a fix in one.

## 7. Build order

Not arbitrary — it is a dependency chain.

```
1. Accounts        (Vishwa)     ← everything keys on user_id. Nothing works until this does.
       │
       ├── 2. Itinerary  (Sanjay)     ← creates the trips table Maps needs
       │        │
       │        └── 4. Maps + Offline (Vishwa)   ← plots itinerary stops
       │                 │
       │                 └── 5. Emergency (Santhosh)  ← reuses Leaflet + OSRM setup
       │
       └── 3. Budget     (Santhosh)   ← independent, runs parallel with Itinerary
                │
                └── 6. Recommendations (Sanjay)  ← last; REQ-6.4 lets it degrade gracefully
```

**Weeks 1–2 are not idle for Sanjay and Santhosh.** While Accounts is being built, they build their screens against hardcoded data and swap in real queries once auth lands. Details in the individual planners.

## 8. Running it locally

Full instructions with troubleshooting are in [`START-HERE.md`](START-HERE.md). Short version:

```bash
git clone <repo-url>
cd smart-travel-assistant
npm install
cp .env.example .env      # then paste in the Supabase keys from the group chat
npm run dev
```

Opens at `http://localhost:5173`.

## 9. Timeline

Semester runs to **20 November 2026**. Planning, SRS, and design documentation are complete. We are in **Phase 4: Implementation**.

| Sprint | Dates | Focus |
| --- | --- | --- |
| 0 | Aug 24 – Aug 30 | Everyone: setup, repo running locally, Supabase connected |
| 1 | Aug 31 – Sep 13 | Accounts (Vishwa). Others build UI shells on hardcoded data. |
| 2 | Sep 14 – Sep 27 | Itinerary (Sanjay), Budget (Santhosh) |
| 3 | Sep 28 – Oct 18 | Maps & Offline (Vishwa), Emergency (Santhosh) |
| 4 | Oct 19 – Nov 1 | Recommendations (Sanjay), integration of all six features |
| 5 | Nov 2 – Nov 8 | Testing — unit, integration, demo dry-run |
| 6 | Nov 9 – Nov 20 | Deploy, user guide, final report, viva prep |

Sprint dates match the Gantt chart in `docs/gantt/`.
