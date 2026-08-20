# FILE-STRUCTURE.md

**This is a build specification, not documentation.** It tells Claude Code exactly what directories and files to create, and what goes in each one. Once the structure is built, this file stays in the repo as a reference for where things belong.

Read this together with `README.md` before creating anything.

---

## 1. Target tree

Create exactly this. Nothing more, nothing less.

```
smart-travel-assistant/
├── README.md                          ← already written, do not overwrite
├── FILE-STRUCTURE.md                  ← this file, do not overwrite
├── START-HERE.md                      ← CREATE (spec in §4.1)
├── CLAUDE.md                          ← CREATE EMPTY (see §5 — important)
├── .gitignore                         ← CREATE (verbatim, §3.1)
├── .env.example                       ← CREATE (verbatim, §3.2)
├── .env                               ← DO NOT CREATE. Never. See §6.
├── package.json                       ← CREATE (verbatim, §3.3)
├── vite.config.js                     ← CREATE (verbatim, §3.4)
├── index.html                         ← CREATE (verbatim, §3.5)
│
├── .github/
│   └── pull_request_template.md       ← CREATE (spec in §4.7)
│
├── docs/                              ← contents gitignored, structure tracked
│   ├── .gitignore                     ← CREATE (verbatim, §3.6)
│   ├── README.md                      ← CREATE (spec in §4.6)
│   ├── srs/.gitkeep                   ← CREATE EMPTY
│   ├── wbs/.gitkeep                   ← CREATE EMPTY
│   ├── gantt/.gitkeep                 ← CREATE EMPTY
│   └── images/.gitkeep                ← CREATE EMPTY
│
├── team/
│   ├── README.md                      ← CREATE (spec in §4.5)
│   ├── vishwa/
│   │   ├── README.md                  ← CREATE (spec in §4.2)
│   │   └── PLANNER.md                 ← CREATE (spec in §4.4)
│   ├── sanjay/
│   │   ├── README.md                  ← CREATE (spec in §4.2)
│   │   └── PLANNER.md                 ← CREATE (spec in §4.4)
│   └── santhosh/
│       ├── README.md                  ← CREATE (spec in §4.2)
│       ├── PLANNER.md                 ← CREATE (spec in §4.4)
│       └── AI-PROMPT-PACK.md          ← CREATE (spec in §4.3)
│
├── db/
│   ├── schema.sql                     ← CREATE (spec in §4.8)
│   └── seed.sql                       ← CREATE (spec in §4.9)
│
├── public/.gitkeep                    ← CREATE EMPTY
│
└── src/
    ├── main.jsx                       ← CREATE (verbatim, §3.7)
    ├── App.jsx                        ← CREATE (verbatim, §3.8)
    ├── styles/global.css              ← CREATE (verbatim, §3.9)
    ├── lib/
    │   └── supabase.js                ← CREATE (verbatim, §3.10)
    ├── components/.gitkeep            ← CREATE EMPTY
    ├── pages/.gitkeep                 ← CREATE EMPTY
    └── features/
        ├── accounts/README.md         ← CREATE (spec in §4.10)
        ├── itinerary/README.md        ← CREATE (spec in §4.10)
        ├── budget/README.md           ← CREATE (spec in §4.10)
        ├── maps/README.md             ← CREATE (spec in §4.10)
        ├── emergency/README.md        ← CREATE (spec in §4.10)
        └── recommendations/README.md  ← CREATE (spec in §4.10)
```

---

## 2. Project facts (needed to write the files above)

Do not invent details. Everything you need is here.

**Project:** Smart Travel Planning Assistant and Budget Management System
**Institution:** Vellore Institute of Technology, Chennai — software engineering course project
**Timeline:** implementation runs 24 Aug 2026 → 20 Nov 2026

**Team and ownership:**

| Person | Reg. No | Features owned | Branches | AI access |
| --- | --- | --- | --- | --- |
| Vishwa Thangapandiyan | 24BCE1415 | Accounts (4.1), Maps & Offline (4.4) | `feat/accounts`, `feat/maps` | Claude Pro |
| Sanjay Sivakumar | 24BCE1948 | Itinerary (4.2), Recommendations (4.6) | `feat/itinerary`, `feat/recommendations` | Claude Pro, possibly Max |
| Santhosh S | 24BCE5169 | Budget (4.3), Emergency (4.5) | `feat/budget`, `feat/emergency` | **None — free tier only** |

**Git experience:** Sanjay knows GitHub reasonably. Vishwa and Santhosh have never used it.

**Six features and their requirement ranges:**

| # | Feature | Folder | REQs | Owner |
| --- | --- | --- | --- | --- |
| 4.1 | User Account Management | `accounts` | REQ-1.1–1.4 | Vishwa |
| 4.2 | Trip and Itinerary Planning | `itinerary` | REQ-2.1–2.4 | Sanjay |
| 4.3 | Budget and Expense Management | `budget` | REQ-3.1–3.5 | Santhosh |
| 4.4 | Maps, Navigation & Offline Access | `maps` | REQ-4.1–4.3 | Vishwa |
| 4.5 | Emergency Assistance | `emergency` | REQ-5.1–5.4 | Santhosh |
| 4.6 | Destination Recommendations | `recommendations` | REQ-6.1–6.4 | Sanjay |

**Stack (fixed — do not substitute):** React + Vite, plain CSS, Supabase (auth + Postgres), Leaflet + OpenStreetMap, OSRM public demo server for routing, Overpass API for emergency services, IndexedDB via `idb` for offline. No custom backend. No API keys beyond the Supabase anon key. No credit card anywhere.

**Sprint schedule:**

| Sprint | Dates | Focus |
| --- | --- | --- |
| 0 | Aug 24 – Aug 30 | Setup: everyone running locally, Supabase live |
| 1 | Aug 31 – Sep 13 | Accounts (Vishwa). Others build UI on hardcoded data. |
| 2 | Sep 14 – Sep 27 | Itinerary (Sanjay), Budget (Santhosh) |
| 3 | Sep 28 – Oct 18 | Maps & Offline (Vishwa), Emergency (Santhosh) |
| 4 | Oct 19 – Nov 1 | Recommendations (Sanjay), integration |
| 5 | Nov 2 – Nov 8 | Testing |
| 6 | Nov 9 – Nov 20 | Deploy, user guide, final report, viva |

**Dependency chain:** Accounts must land first (every table keys on `user_id`). Itinerary's `trips` table must exist before Maps can plot markers. Emergency reuses the Leaflet setup and `src/lib/routing.js` from Maps. Recommendations ships last because REQ-6.4 permits it to degrade gracefully.

---

## 3. Files to create verbatim

Copy these exactly.

### 3.1 `.gitignore`

```
# ---- Secrets : NEVER commit these ----
.env
.env.local
.env.*.local

# ---- Dependencies ----
node_modules/

# ---- Build output ----
dist/
dist-ssr/
build/
*.local

# ---- Editors ----
.vscode/*
!.vscode/extensions.json
.idea/
*.swp

# ---- OS junk ----
.DS_Store
Thumbs.db
desktop.ini

# ---- Logs ----
npm-debug.log*
yarn-debug.log*
yarn-error.log*
logs/
*.log

# ---- Testing ----
coverage/

# ---- Misc ----
*.pem
.cache/
```

### 3.2 `.env.example`

```
# Copy this file to .env and fill in the real values:
#   cp .env.example .env
#
# The actual keys are posted in the team group chat by Vishwa.
# .env is gitignored. Never commit it.

# Supabase project URL  (Project Settings -> API -> Project URL)
VITE_SUPABASE_URL=https://your-project-ref.supabase.co

# Supabase anon/public key  (Project Settings -> API -> anon public)
# Safe in a frontend app: it ends up in the browser bundle by design,
# and Row Level Security is what actually protects the data.
# The service_role key is NOT safe. Never put that one in here.
VITE_SUPABASE_ANON_KEY=your-anon-key-here
```

### 3.3 `package.json`

```json
{
  "name": "smart-travel-assistant",
  "private": true,
  "version": "0.1.0",
  "type": "module",
  "description": "Smart Travel Planning Assistant and Budget Management System",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "@supabase/supabase-js": "^2.45.0",
    "idb": "^8.0.0",
    "leaflet": "^1.9.4",
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "react-leaflet": "^4.2.1",
    "react-router-dom": "^6.26.0"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.3.1",
    "vite": "^5.4.0"
  }
}
```

### 3.4 `vite.config.js`

```js
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: { port: 5173, open: true },
})
```

### 3.5 `index.html`

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Smart Travel Planning Assistant</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
```

### 3.6 `docs/.gitignore`

Course deliverables are binary files. Git stores a whole new copy on every edit and the diffs are unreadable, so the contents are ignored while the folder structure stays tracked.

```
# Course deliverables and design artifacts.
# Kept locally for reference and submission — NOT pushed to GitHub.

srs/*
wbs/*
gantt/*
images/*

# Keep the folders themselves so a fresh clone shows where things belong
!srs/.gitkeep
!wbs/.gitkeep
!gantt/.gitkeep
!images/.gitkeep

# Keep this folder's own README tracked
!README.md
```

### 3.7 `src/main.jsx`

```jsx
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.jsx'
import './styles/global.css'

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
)
```

### 3.8 `src/App.jsx`

```jsx
// App shell. Routing gets wired up as features land.
// OWNER: shared — coordinate in the group chat before editing.

export default function App() {
  return (
    <div className="app-shell">
      <h1>Smart Travel Planning Assistant</h1>
      <p>Setup is working. Open your task brief in team/ to start.</p>
    </div>
  )
}
```

### 3.9 `src/styles/global.css`

```css
:root {
  font-family: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
  line-height: 1.5;
  color: #1a1a1a;
  background: #fafafa;
}

* { box-sizing: border-box; }
body { margin: 0; }

.app-shell {
  max-width: 900px;
  margin: 0 auto;
  padding: 2rem 1rem;
}

code {
  background: #eee;
  padding: 0.15em 0.4em;
  border-radius: 3px;
  font-size: 0.9em;
}
```

### 3.10 `src/lib/supabase.js`

```js
// Shared Supabase client.
// OWNER: Vishwa (feat/accounts). Everyone imports from here.
// Reads config from .env — never hardcode keys in this file.

import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error(
    'Missing Supabase config. Copy .env.example to .env and fill in the keys ' +
    'from the group chat. See START-HERE.md section 2.'
  )
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey)
```

---

## 4. Files to author from spec

For these, write the content yourself following the outline given. Use the facts in §2. Do not invent requirements, dates, or people.

**Tone for all of them:** direct and plain. Short sentences. No marketing language, no filler, no emoji. These are read by three tired students, not customers.

### 4.1 `START-HERE.md`

The onboarding guide. Two of three team members have never used Git, so assume zero knowledge.

Sections, in order:

1. **One-time setup** — install Node 20+, Git, VS Code (table with how to verify each worked). `git config --global user.name/user.email`. Note that Windows users should use Git Bash, not Command Prompt. Making a GitHub account and sending the username to the group for collaborator access.
2. **Cloning the project** — `git clone`, `cd`, `npm install`, `cp .env.example .env`, paste keys, `npm run dev`, open localhost:5173.
3. **The everyday workflow** — the core section. Include an ASCII diagram showing `main` → branch → commit → push → PR → merge → back to `main`. Then each step as a numbered subsection with the exact commands: `git checkout main && git pull`, `git checkout -b feat/x`, `git status` / `git add <folder>` / `git commit -m`, `git push -u origin feat/x`, then opening a PR on GitHub in the browser (describe where the button is), then merging and deleting the branch. Explain *why* pulling first matters. Advise against bare `git add .`. Say commit messages should describe what changed.
4. **Things that will go wrong** — wrong branch (`git stash` fix), merge conflicts (show the `<<<<<<<` markers and how to resolve, and say to ask the group rather than guess which version to keep), rejected push (`git pull --rebase`), starting over (`git checkout -- .`), npm install failing.
5. **Cheat sheet** — a two-column table of task → command.
6. **Where do I go now** — table pointing each person to their `team/<name>/` folder.
7. **Loading project context before you work** — reproduce §7 of this spec exactly. This is the step that makes everything else work.

### 4.2 `team/<person>/README.md` — three files, one per person

Each is that person's task brief. Structure:

- **Header** — name, reg. no, features owned with SRS section numbers, branch names, which folders they may edit.
- **Step 0: Load context** — reproduce the relevant half of §7 below. This must be the first thing after the header, before any task. For Vishwa and Sanjay use the Claude Code version; for Santhosh use the paste-into-a-chat version and point at `AI-PROMPT-PACK.md`.
- **Why you have these two features** — one honest paragraph. Vishwa: Accounts is the critical path that blocks two people, and Maps is the hardest build so it goes to someone with Pro. Sanjay: Itinerary is the spine other features read from, and Recommendations carries the optional ML stretch. Santhosh: these are the two most self-contained features, chosen because they don't require long AI debugging sessions — state plainly that this is about message limits, not capability.
- **Feature 1, then Feature 2** — each with a target merge date from the sprint table, its dependencies, numbered tasks, and a "Done when" checklist mapping to specific REQ numbers.
- **Working with your AI tool** — Claude Code invocation and habits for Vishwa/Sanjay; the prompt pack workflow and message-saving rules for Santhosh.

Technical guidance to include in the tasks (this is knowledge the team already worked out — include it, don't rediscover it):

- *Accounts:* Supabase Auth handles hashing and sessions, so none of that gets written by hand. Auth creates a row in `auth.users` but **not** in `profiles` — insert it after sign-up or use a trigger, otherwise the profile screen loads empty for every new user. REQ-1.4 needs Supabase error codes mapped to human-readable inline messages, never raw error objects.
- *Maps:* Leaflet's CSS must be imported or the map renders as a grey mess; default marker icons break under Vite and need the standard icon-path fix. OSM attribution must stay visible — licence condition. Offline scope is cached itinerary data + guide text + one static map image per destination, explicitly **not** a pannable tile cache. Put the OSRM call in `src/lib/routing.js` as a plain function because Santhosh reuses it for REQ-5.2. Test offline with DevTools set to Offline, not by turning off Wi-Fi.
- *Itinerary:* build plain CRUD fully before attempting reordering. REQ-2.3 says "reorder", not "drag to reorder" — up/down arrow buttons swapping `order_index` satisfy it completely, so ship those first and treat `dnd-kit` as an enhancement. Store destination coordinates at trip creation; Maps needs them and the schema is frozen.
- *Recommendations:* ranking is a database `ORDER BY`. REQ-6.4 makes this the required deliverable, not a compromise. Seed real place names — "Restaurant 1", "Restaurant 2" looks exactly like what it is. The similarity ranking is optional with a hard stop of Nov 8, and if built must be described as a ranking function, not a trained model.
- *Budget:* never store a running "spent" total in a column — it desynchronises the first time an expense is edited or deleted. Recalculate with `select category, sum(amount) ... group by category`. The 90% alert is two client-side `if` statements on data already fetched, not a notification service. Guard against dividing by zero when a category has no allocation.
- *Emergency:* Overpass is free and keyless, querying `amenity=hospital` and `amenity=police`. Handle slow/rate-limited responses and unnamed OSM entries. One-tap calling is `<a href="tel:...">`, no telephony API. Default helplines (112, 100, 108, 101) must stay visible even when Overpass returns nothing. **The safety disclaimer is required by SRS Section 5.2** — the panel must state that in a life-threatening emergency the user should also call local services directly. REQ-5.4 has two halves: fall back to last-known location *and* visibly flag that it may be stale.

For Sanjay and Santhosh, include a "starting before your dependencies land" note: build every screen against hardcoded data in `useState`, marked `// TODO: replace with Supabase query once feat/<x> is merged`. Swapping the data source later is an afternoon, not a rewrite.

### 4.3 `team/santhosh/AI-PROMPT-PACK.md`

Copy-paste prompts for free-tier ChatGPT or Claude. Santhosh has no subscription, so every message has to count.

- **How to use it** — fresh chat per task; copy the whole block; bundle multiple questions into one message; ask for complete files rather than fragments.
- **Six prompts**, each fully self-contained with the stack description, the relevant table DDL from `db/schema.sql`, and the constraints. Prompts 1–3 cover Budget (setup screen, expense form, balances + threshold alerts). Prompts 4–6 cover Emergency (Overpass nearby services, contacts + `tel:` links, last-known-location hook). Every prompt must ask for a complete file, plain CSS, no new dependencies, and comments explaining anything non-obvious "because a student has to explain this in a viva".
- **A debugging prompt template** with bracketed placeholders for the file, the exact error, expected behaviour, and actual behaviour. Note that pasting the full error beats summarising it.
- **A message-saving table** — inefficient habit → efficient alternative.
- **The escalation rule** — stuck on the same error for 30 minutes means posting it in the group chat for Vishwa or Sanjay to run through their Pro session. Frame this as the intended workflow, not a failure.

### 4.4 `team/<person>/PLANNER.md` — three files

Dated checklists. Same six sprints as §2 for everyone, with each person's own tasks under each sprint. Every item a `- [ ]` checkbox.

- Sprint 0 is setup for all three. Vishwa's also includes creating the Supabase project and running `schema.sql`, because he blocks the other two.
- Sprint 1: Vishwa builds Accounts; Sanjay and Santhosh build UI on hardcoded data. Say explicitly that they are not blocked.
- Sprints 2–4 follow the dependency chain in §2, with PR merge deadlines as checkboxes.
- Sprint 5 testing items should name concrete edge cases per feature.
- Sprint 6 deployment items: Vishwa's must include setting environment variables on the host and updating the Google OAuth redirect URL to the deployed domain, or Google sign-in breaks in production. Santhosh's must include testing `tel:` links on an actual phone.
- Every planner ends with a **Blockers table** (date / blocker / status). Santhosh's has an extra "asked the group?" column and restates the 30-minute rule.
- Open with a line explaining these files are the answer when the instructor asks about progress, so they must be ticked off and committed.

### 4.5 `team/README.md`

Short index. Table of person → folder → features → branches. What each folder contains. A pointer to `START-HERE.md` for the two who haven't used Git. A line that a planner nobody updates is worse than no planner, because it lies.

### 4.6 `docs/README.md`

Explains that the subfolders are gitignored — binary course deliverables kept locally for reference and submission. Table of what goes in `srs/`, `wbs/`, `gantt/`, `images/`. How to set up a local copy from the shared drive.

Reference notes to include: the SRS is the source of truth for scope and uses `REQ-<feature>.<number>` labels; the ER diagram must stay in sync with `db/schema.sql`; **do not run the Gantt `.xlsx` through a converter or automated recalculation step because it strips the conditional-formatting fill colours that draw the bars**; diagrams were generated from Python scripts via cairosvg, so regenerate rather than editing the PNGs.

### 4.7 `.github/pull_request_template.md`

Short. What this does / requirements covered (REQ numbers) / what works / what does not work yet (say honesty here is useful information, not a confession) / how to test / checklist covering: only touched my own feature folder, did not change `db/schema.sql`, `.env` not included, `npm run dev` runs clean, planner updated.

### 4.8 `db/schema.sql`

Every table for all six features in one file, so nobody creates their own and hits mismatched foreign keys in October. Header comment saying it is run once in the Supabase SQL Editor and is **frozen** afterwards — schema changes break everyone's queries, not just yours.

Group tables by feature with a comment banner naming the feature, owner, and REQ range:

- **4.1 Accounts** — `profiles` (id references `auth.users`, full_name, default_currency default 'INR', preferences jsonb, created_at). Comment that Supabase Auth already stores the account itself, so we do not recreate it.
- **4.2 Itinerary** — `trips` (id, user_id, destination, start_date, end_date, latitude, longitude, created_at) and `itinerary_items` (id, trip_id, day_number, title, location_name, latitude, longitude, start_time, order_index, notes, created_at). Index on `(trip_id, day_number, order_index)`.
- **4.3 Budget** — `budgets` (id, trip_id, category, allocated_amount, unique on trip_id+category) and `expenses` (id, trip_id, category, amount, spent_on, description). Index on `(trip_id, category)`. Include the SUM-grouped-by-category query as a comment, and note there is no stored "spent" column by design.
- **4.4 Maps** — `offline_packs` (id, user_id, trip_id, guide_text, static_map_url, downloaded_at, unique on user_id+trip_id). Comment that map rendering and routing need no tables, and that the cached payload lives in IndexedDB because it must be readable with no network.
- **4.5 Emergency** — `emergency_contacts` (id, region, service_name, phone_number, is_default) and `last_known_location` (user_id primary key, latitude, longitude, recorded_at). Comment that nearby services come live from Overpass and are not stored.
- **4.6 Recommendations** — `recommendations` (id, destination, name, category, description, rating, price_level, tags text[], latitude, longitude, image_url). Index on `(destination, category)`.

Then a **Row Level Security** section enabling RLS on every table and adding policies. Explain in a comment that this is what enforces SRS Section 5.3 and the business rule that a user sees only their own data — without it, any signed-in user could read everyone's trips and expenses. Own-row policies via `auth.uid()` for `profiles`, `trips`, `offline_packs`, `last_known_location`; parent-trip `exists` subquery policies for `itinerary_items`, `budgets`, `expenses`; read-only-for-authenticated policies for `recommendations` and `emergency_contacts`, with a comment that the team updates those two directly in the Supabase dashboard per SRS Section 2.3.

Annotate individual columns with the REQ number they serve.

### 4.9 `db/seed.sql`

Header noting it runs after `schema.sql`, owned by Sanjay for recommendations and Santhosh for contacts.

Insert Indian emergency helplines: 112 (all services), 100 (police), 108 (ambulance), 101 (fire), 1091 (women), 1363 (tourist) — with a comment that these must work even when Overpass returns nothing.

Then two example `recommendations` rows with real place names and plausible ratings, followed by a `-- TODO (Sanjay)` marking where the remaining 10–15 places per destination go, across 3–5 chosen destinations.

### 4.10 `src/features/<name>/README.md` — six files

Four to six lines each. Feature name and REQ range as the heading; owner, branch, SRS section; one line on what the feature does; a pointer to the task brief in `team/<owner>/README.md`; and a line saying only that owner edits the folder.

Add the cross-dependencies where they exist: `maps` exports `src/lib/routing.js` which `emergency` reuses for REQ-5.2; `emergency` also notes the safety disclaimer requirement; `itinerary` notes that maps reads its tables; `recommendations` notes it ships last and may degrade per REQ-6.4.

---

## 5. `CLAUDE.md` — create it empty

Create the file at the repo root with **no content**, or a single placeholder line:

```
<!-- Project context for Claude Code. Generated after the SRS, WBS, and design docs are added to docs/. See FILE-STRUCTURE.md section 5. -->
```

**Do not write project context into it yet.** Vishwa will drop the SRS, WBS, Gantt, and diagrams into `docs/` after the structure exists, and then run a second pass to generate this file from those real documents. Writing it now from summary information would produce a worse file that the real one has to overwrite.

When that second pass happens, `CLAUDE.md` should cover: what the project is, the fixed stack with a "do not substitute" table, the hard rules (stay in your own feature folder, `db/schema.sql` is frozen, never touch `.env` or hardcode keys, match SRS scope and do not build beyond it, prefer boring readable code, no new dependencies), the feature ownership table, and the build order with its dependencies.

---

## 6. Secrets — the answer to "are the Supabase keys safe?"

Short version: **the anon key is safe, the service_role key is not, and `.env` still gets gitignored either way.**

| Key | Safe in the frontend? | Safe to commit? |
| --- | --- | --- |
| `VITE_SUPABASE_URL` | Yes | Harmless, but keep it in `.env` |
| `VITE_SUPABASE_ANON_KEY` | **Yes, by design** | Technically harmless, still keep it out |
| `service_role` key | **Never** | **Never.** Bypasses all security. |

Anything prefixed `VITE_` is compiled into the JavaScript bundle the browser downloads. The anon key is *public by design* — anyone who opens DevTools on a deployed Supabase app can read it. That is expected and fine, because the anon key alone grants nothing. **Row Level Security is what actually protects the data**, which is why `schema.sql` enables it on every table. An app with RLS switched off is wide open regardless of how well the key is hidden.

So the reasons `.env` stays gitignored are habit and blast radius, not because the anon key is a secret: the same file will eventually hold something that genuinely is one, and a repo where secrets are casually committed trains bad reflexes. Sharing the anon key in the team group chat is fine.

The `service_role` key bypasses RLS entirely. It must never appear in `.env`, in the frontend, in a commit, or in the group chat. If it ever leaks, rotate it in the Supabase dashboard immediately.

**Rules for whoever builds this:** never create `.env`. Never write a real key into any file. Never hardcode a key in `src/lib/supabase.js` — it reads from `import.meta.env` and throws a helpful error if the values are missing. `.env.example` contains placeholders only.

---

## 7. The context-loading step

Every team member's README must include this before any task, because a task brief read without the SRS produces work that drifts from the requirements.

**For Vishwa and Sanjay (Claude Code):**

> **Step 0 — Load context before you start.** From the repo root, run `claude`. It reads `CLAUDE.md` automatically. Then, in your first message of the session:
>
> ```
> Read these before doing anything:
> - README.md (what the project is, the stack, the rules)
> - CLAUDE.md (project context and constraints)
> - team/<yourname>/README.md (my tasks)
> - team/<yourname>/PLANNER.md (what is due right now)
> - db/schema.sql (the frozen database schema)
> - docs/srs/ (the requirements — check REQ numbers before building)
>
> Then tell me which task I should be on based on today's date, and show me
> the plan before writing any code.
> ```
>
> Do this once per session. Skipping it means your AI writes code against guessed requirements rather than the actual SRS.

**For Santhosh (free tier — no repo access from the chat):**

> **Step 0 — Load context before you start.** Free ChatGPT and Claude cannot read your repo, so the context has to be pasted. Do this once at the start of each new chat:
>
> 1. Open `README.md` and copy the sections "What this project is", "What we are honest about", and "Tech stack".
> 2. Open your own `team/santhosh/README.md` and copy the task you are working on.
> 3. Open `db/schema.sql` and copy only the tables your feature uses.
> 4. Paste all three, then your question.
>
> `AI-PROMPT-PACK.md` already has this bundled into each prompt, so for the six main tasks you can skip straight to copying the relevant prompt. Use these manual steps for anything the pack does not cover.

**Once the design documents are in `docs/`,** Vishwa should run a second Claude Code pass to generate the real `CLAUDE.md` from them:

```
Read docs/srs/, docs/wbs/, docs/gantt/, and docs/images/, plus README.md and
FILE-STRUCTURE.md. Write CLAUDE.md at the repo root following the outline in
FILE-STRUCTURE.md section 5. Ground every requirement claim in the actual SRS
text — do not summarise from memory or invent REQ numbers.
```

---

## 8. Build rules

For whoever or whatever creates this structure:

1. **Do not overwrite `README.md` or `FILE-STRUCTURE.md`.** They already exist.
2. **Create `CLAUDE.md` empty.** §5.
3. **Never create `.env`.** §6.
4. **Do not install dependencies or run `npm install`.** Create `package.json`; the team installs.
5. **Do not write feature code.** Only the scaffolding files listed in §1. `src/features/*/` gets a README and nothing else — those folders belong to their owners.
6. **Do not invent facts.** Names, dates, REQ numbers, and the schema all come from §2 and §4. If something is genuinely unspecified, leave a clearly marked `TODO` rather than guessing.
7. **Verify before finishing.** Print the tree, confirm it matches §1 exactly, confirm no `.env` exists, confirm `CLAUDE.md` is empty, and report anything that deviates.
