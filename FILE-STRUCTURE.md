# FILE-STRUCTURE.md

**Originally a build spec for the React scaffold; now a reference for
where things belong in the Flutter rebuild.** The structure below is what
exists in the repo today. Read this together with `README.md` and
`CLAUDE.md` before adding anything new.

---

## 1. Target tree

```
smart-travel-assistant/
├── README.md                          project overview, stack, ground rules
├── START-HERE.md                        git + Flutter setup guide
├── RUN.md                                exact `flutter run` command and the two --dart-define keys
├── FILE-STRUCTURE.md                     this file
├── CLAUDE.md                              project context for Claude Code
├── .gitignore
├── pubspec.yaml                          fixed dependency list — no additions without asking
├── analysis_options.yaml
│
├── .github/
│   └── pull_request_template.md
│
├── docs/                                  contents gitignored, structure tracked
│   ├── .gitignore
│   ├── README.md                          ⚠ flags the SRS/diagrams as web-app-era and out of date
│   ├── srs/.gitkeep
│   ├── wbs/.gitkeep
│   ├── gantt/.gitkeep
│   └── images/.gitkeep
│
├── team/
│   ├── README.md
│   ├── vishwa/
│   │   ├── README.md                     task brief, includes the build/review workflow section
│   │   └── PLANNER.md
│   ├── sanjay/
│   │   ├── README.md                     includes the REQ-5.2 directions task
│   │   └── PLANNER.md
│   └── santhosh/
│       ├── README.md
│       ├── PLANNER.md
│       └── AI-PROMPT-PACK.md             Flutter/Dart prompts, schema + model classes baked in
│
├── db/
│   ├── schema.sql                        ALL tables for ALL features. FROZEN.
│   └── seed.sql                           demo data for recommendations and helplines
│
└── lib/
    ├── main.dart                          entry point: Supabase.initialize + Provider tree
    │
    ├── models/                            ★ THE FROZEN INTERFACE CONTRACT
    │   ├── CONTRACT.md                    every class, every field — read before touching any model
    │   ├── trip.dart
    │   ├── itinerary_item.dart
    │   ├── budget.dart
    │   ├── expense.dart
    │   ├── recommendation.dart
    │   ├── emergency_contact.dart
    │   ├── user_profile.dart
    │   ├── offline_pack.dart
    │   └── last_known_location.dart
    │
    ├── services/                          anything that talks outside the phone
    │   ├── README.md                      documents every service's signature (files below don't exist yet — owners write them)
    │   ├── supabase_service.dart          OWNER: Vishwa
    │   ├── routing_service.dart           OWNER: Vishwa — OSRM; Sanjay's REQ-5.2 wrapper calls this
    │   ├── overpass_service.dart          OWNER: Santhosh
    │   └── location_service.dart          OWNER: Vishwa
    │
    ├── providers/                         state, one per feature area (built by owners as features land)
    │
    ├── features/                          one folder per SRS feature, one owner each
    │   ├── accounts/README.md             Vishwa    — REQ-1.x
    │   ├── itinerary/README.md            Sanjay    — REQ-2.x
    │   ├── budget/README.md               Santhosh  — REQ-3.x
    │   ├── maps/README.md                 Vishwa    — REQ-4.x
    │   ├── emergency/README.md            Santhosh  — REQ-5.1, 5.3, 5.4
    │   └── recommendations/README.md      Sanjay    — REQ-6.x, and REQ-5.2
    │
    ├── screens/                           top-level navigation (built as features land)
    └── widgets/                           shared UI (built as features land)
```

Folders that hold only future work (`providers/`, `screens/`, `widgets/`,
and the `.dart` files under `services/`) currently contain nothing but a
`.gitkeep` — that's expected. They belong to feature owners; this scaffold
only documents where their code goes.

---

## 2. Project facts

**Project:** Smart Travel Planning Assistant and Budget Management System
**Institution:** Vellore Institute of Technology, Chennai — software
engineering course project
**Timeline:** implementation runs 24 Aug 2026 → 20 Nov 2026

**Team and ownership:**

| Person | Reg. No | Features owned | Branches | AI access |
| --- | --- | --- | --- | --- |
| Vishwa Thangapandiyan | 24BCE1415 | Accounts (4.1), Maps & Offline (4.4) | `feat/accounts`, `feat/maps` | Claude Pro |
| Sanjay Sivakumar | 24BCE1948 | Itinerary (4.2), Recommendations (4.6), REQ-5.2 | `feat/itinerary`, `feat/recommendations` | Claude Pro, possibly Max |
| Santhosh S | 24BCE5169 | Budget (4.3), Emergency (4.5, minus REQ-5.2) | `feat/budget`, `feat/emergency` | **None — free tier only** |

**Git experience:** Sanjay knows GitHub reasonably. Vishwa and Santhosh
have never used it.

**Six features and their requirement ranges:**

| # | Feature | Folder | REQs | Owner |
| --- | --- | --- | --- | --- |
| 4.1 | User Account Management | `accounts` | REQ-1.1–1.4 | Vishwa |
| 4.2 | Trip and Itinerary Planning | `itinerary` | REQ-2.1–2.4 | Sanjay |
| 4.3 | Budget and Expense Management | `budget` | REQ-3.1–3.5 | Santhosh |
| 4.4 | Maps, Navigation & Offline Access | `maps` | REQ-4.1–4.3 | Vishwa |
| 4.5 | Emergency Assistance | `emergency` | REQ-5.1, 5.3, 5.4 | Santhosh |
| — | — directions inside Emergency | (wrapper in `recommendations/` or `services/`) | REQ-5.2 | Sanjay |
| 4.6 | Destination Recommendations | `recommendations` | REQ-6.1–6.4 | Sanjay |

REQ-5.2's move from Santhosh to Sanjay is documented in full in
`CLAUDE.md`, `team/sanjay/README.md`, and `team/santhosh/README.md` —
reason: it needs integrating someone else's live implementation
(`routing_service.dart`), which isn't practical from a pasted prompt with
no repo access.

**Stack (fixed — do not substitute):** Flutter + Dart, Provider,
Supabase (auth + Postgres), flutter_map + OpenStreetMap, OSRM public demo
server for routing, Overpass API for emergency services, Hive for
offline. No custom backend. No API keys beyond the Supabase anon key. No
credit card anywhere. Full dependency list in `pubspec.yaml` — see
`CLAUDE.md` for the "do not substitute" table.

**Sprint schedule:**

| Sprint | Dates | Focus |
| --- | --- | --- |
| 0 | Aug 24 – Aug 30 | Setup: everyone running Flutter locally, Supabase live |
| 1 | Aug 31 – Sep 13 | Accounts (Vishwa). Others build UI on hardcoded data. |
| 2 | Sep 14 – Sep 27 | Itinerary (Sanjay), Budget (Santhosh) |
| 3 | Sep 28 – Oct 18 | Maps & Offline (Vishwa), Emergency (Santhosh), REQ-5.2 (Sanjay) |
| 4 | Oct 19 – Nov 1 | Recommendations (Sanjay), integration |
| 5 | Nov 2 – Nov 8 | Testing |
| 6 | Nov 9 – Nov 20 | Deploy, user guide, final report, viva |

**Dependency chain:** Accounts must land first (every table keys on
`user_id`). Itinerary's `trips`/`itinerary_items` must exist before Maps
can plot markers. Emergency reuses Sanjay's REQ-5.2 wrapper around
Vishwa's `routing_service.dart`, and Overpass independently. Recommendations
ships last because REQ-6.4 permits it to degrade gracefully.

---

## 3. lib/models/ — the frozen contract

Every table in `db/schema.sql` has exactly one matching Dart class in
`lib/models/`. `lib/models/CONTRACT.md` documents every field, its type,
and its owner — self-contained enough to paste into a chat with no other
context. This is the single most load-bearing file in the migration:
Santhosh has no Claude Code access and can only paste code into a chat
window, so without a fixed, written contract, whatever AI he uses will
invent field names and his branch won't compile against anyone else's
work.

**Do not change a class in `lib/models/` without raising it in the group
chat first.** A silent field rename breaks the other two branches, not
just yours.

---

## 4. lib/services/ — the service contract

`lib/services/README.md` documents the public method signature of every
service file before that file exists — most importantly
`routing_service.dart`, since Sanjay's REQ-5.2 wrapper (and, through it,
Santhosh's Emergency screen) calls it directly. Build against the
documented signature; if it needs to change, say so in the group chat
first, same rule as the models.

---

## 5. Secrets — the answer to "are the Supabase keys safe?"

Short version: **the anon key is safe, the `service_role` key is not, and
neither one gets committed to the repo either way.**

This project does not use a `.env` file. Flutter has no built-in
equivalent, and adding a package (`flutter_dotenv` or similar) just to
simulate one wasn't worth a new dependency. Instead, both Supabase values
are passed at build/run time with `--dart-define`, and
`lib/main.dart` reads them with `String.fromEnvironment`. See `RUN.md`
for the exact command.

| Key | Safe in a compiled app? | Safe to commit? |
| --- | --- | --- |
| Supabase project URL | Yes | Harmless, but still don't hardcode it in a committed file |
| Supabase anon/public key | **Yes, by design** | Technically harmless, still keep it out of the repo |
| `service_role` key | **Never** | **Never.** Bypasses all security. |

The anon key is *public by design* — anyone who decompiles a shipped
Flutter APK can find it. That is expected and fine, because the anon key
alone grants nothing. **Row Level Security is what actually protects the
data**, which is why `db/schema.sql` enables it on every table. An app
with RLS switched off is wide open regardless of how well the key is
hidden.

So the reason the keys never land in a committed file is habit and blast
radius, not because the anon key is a secret: a repo where secrets are
casually committed trains bad reflexes, and the `service_role` key is a
different story entirely.

**Rules for whoever builds this:** never write a real key into any
committed file — not a script, not a checked-in `launch.json`, nowhere.
`RUN.md` documents where local, gitignored config for your editor can
live if you want to avoid retyping the command. If the `service_role` key
ever leaks, rotate it in the Supabase dashboard immediately.

---

## 6. The context-loading step

Every team member's README includes this before any task, because a task
brief read without the SRS produces work that drifts from the
requirements. Reproduced in full in `START-HERE.md` §7 — see that file
for the exact wording used for Vishwa/Sanjay (Claude Code) versus
Santhosh (paste-into-a-chat).

---

## 7. Build rules

1. **`db/schema.sql` and `PROJECT-UNDERSTANDING.md` are frozen.** Neither
   gets edited casually.
2. **`lib/models/` is frozen.** See §3.
3. **Never create `.env`.** This project doesn't use one — see §5 and
   `RUN.md`.
4. **Do not run `flutter pub get`, `flutter create`, or install anything**
   as part of scaffolding work — that's for whoever actually builds a
   feature to run locally.
5. **Feature folders under `lib/features/*/` get a README and nothing
   else.** The code inside belongs to that folder's owner.
6. **Do not invent facts.** Names, dates, REQ numbers, and the schema all
   come from §2 above, `db/schema.sql`, and `PROJECT-UNDERSTANDING.md`. If
   something is genuinely unspecified — see `PROJECT-UNDERSTANDING.md`
   Part 13 — leave it flagged as undecided rather than guessing.
