# Vishwa Thangapandiyan — 24BCE1415

Owns: Accounts (SRS 4.1, REQ-1.1–1.4), Maps & Offline (SRS 4.4, REQ-4.1–4.3)

Branches: `feat/accounts`, `feat/maps`

Folders you may edit: `lib/features/accounts/`,
`lib/services/supabase_service.dart`, `lib/features/maps/`,
`lib/services/routing_service.dart`, `lib/services/location_service.dart`

---

## Step 0 — Load context before you start

From the repo root, run `claude`. It reads `CLAUDE.md` automatically. Then,
in your first message of the session:

```
Read these before doing anything:
- README.md (what the project is, the stack, the rules)
- CLAUDE.md (project context and constraints)
- team/vishwa/README.md (my tasks)
- team/vishwa/PLANNER.md (what is due right now)
- db/schema.sql (the frozen database schema)
- lib/models/CONTRACT.md (the frozen Dart data contract)
- lib/services/README.md (the service signatures other people depend on)
- docs/srs/ (the requirements — check REQ numbers before building)

Then tell me which task I should be on based on today's date, and show me
the plan before writing any code.
```

Do this once per session. Skipping it means Claude writes code against
guessed requirements rather than the actual SRS.

---

## Why you have these two features

Accounts is the critical path — every other table in `db/schema.sql` keys
on `user_id`, and Sanjay and Santhosh are both building UI against
hardcoded data until it lands. It has to go first, and it has to be solid.
Maps is the hardest build in the project — flutter_map, routing, and an
offline cache all in one feature — so it goes to the person with Claude
Pro, since debugging it will take real back-and-forth with the AI.

---

## Feature 1: Accounts (REQ-1.1–1.4)

Target merge: end of Sprint 1, **13 Sep 2026**.
Dependencies: none — this is what everyone else waits on.

### Tasks

1. Set up the Supabase project (see your planner — this happens in Sprint
   0, before coding starts). Run `db/schema.sql` in the SQL Editor.
2. Add `supabase_flutter` initialisation in `lib/main.dart` (already
   scaffolded — see `Supabase.initialize(...)`). Build sign-up and sign-in
   screens, including Google sign-in. Supabase Auth handles password
   hashing and sessions — none of that gets written by hand.
3. Handle the gap between `auth.users` and `profiles`: Supabase Auth
   creates a row in `auth.users` on sign-up, but **not** in `profiles`.
   Insert the profile row yourself right after sign-up (or use a database
   trigger) — otherwise the profile screen loads empty for every new user.
   Use the `UserProfile` model from `lib/models/user_profile.dart`.
4. Build the profile screen: full name, default currency, preferences.
5. Map Supabase auth error codes to human-readable inline messages for
   REQ-1.4. Never show a raw `AuthException` to the user.

### Done when

- [ ] Sign-up creates both an `auth.users` row and a matching `profiles`
      row — REQ-1.1
- [ ] Sign-in works, including Google — REQ-1.1
- [ ] Profile screen reads and updates `profiles` via the `UserProfile`
      model (name, currency, preferences) — REQ-1.2, REQ-1.3
- [ ] Auth errors show as human-readable messages, not raw error text —
      REQ-1.4

---

## Feature 2: Maps & Offline (REQ-4.1–4.3)

Target merge: end of Sprint 3, **18 Oct 2026**.
Dependencies: `Trip` and `ItineraryItem` from Sanjay's Itinerary
feature — you're plotting stops that already exist.

### Tasks

1. Set up `flutter_map` with an OpenStreetMap tile layer. Add the
   `INTERNET` permission to `android/app/src/main/AndroidManifest.xml` —
   without it the app can request tiles from nowhere and the map stays
   blank with no error telling you why.
2. Add a `RichAttributionWidget` (or equivalent) showing OSM attribution
   on the map. This is a licence condition, not a style choice.
3. Plot itinerary stops as markers, reading from `ItineraryItem.latitude`
   / `.longitude` (see `lib/models/CONTRACT.md`).
4. Build `lib/services/routing_service.dart` as a plain function — see
   `lib/services/README.md` for the exact signature. Sanjay imports it
   as-is for the REQ-5.2 directions wrapper he builds for Emergency, so
   don't fold it into a widget or change the signature without telling
   him and Santhosh.
5. Build the offline download: cache the trip, its itinerary items, guide
   text, and one static map image per destination into Hive (`hive` +
   `hive_flutter`). This is **not** a pannable offline tile cache — don't
   attempt one. Write an `OfflinePack` row (Supabase) for the record of
   what's downloaded; the actual payload goes into a Hive box.
6. Test offline mode with the device/emulator in Airplane Mode, not by
   disabling Wi-Fi only — some emulators keep a loopback connection alive
   even with Wi-Fi off, which makes the offline path look like it works
   when it wouldn't on a real phone.
7. Add the `ACCESS_FINE_LOCATION` (and `ACCESS_COARSE_LOCATION`) permission
   to the Android manifest for `geolocator` — this feature needs a
   position for "route from here" even before Emergency needs one for
   "nearby hospitals".

### Done when

- [ ] Map renders with visible tiles and correct markers — REQ-4.1
- [ ] Routing between itinerary stops works via OSRM, callable from
      `lib/services/routing_service.dart` — REQ-4.2
- [ ] OSM attribution is visible — REQ-4.1
- [ ] A downloaded trip (itinerary + guide text + static map image) loads
      correctly in Airplane Mode — REQ-4.3

---

## Working with your AI tool

You have Claude Pro and Claude Code, and the full workflow described in
**"Build and review workflow"** below. Run Step 0 at the start of every
session — don't skip it because "it's a small change." Keep sessions
scoped to one feature at a time so Claude isn't holding both Accounts and
Maps context at once. When you hit something gnarly in Maps (routing
edge cases, offline sync bugs), that's exactly what the Pro budget is for
— don't ration it the way Santhosh has to.

---

## Build and review workflow

This section covers how to actually run your Claude Code sessions once
Step 0 has loaded context — the plugin to install, the loop to follow, and
how to use ChatGPT as an independent second reviewer.

### Superpowers plugin — install first

Inside a Claude Code session:

```
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
```

Then quit and restart Claude Code. It adds `/brainstorm`, `/write-plan`,
and `/execute-plan`, and enforces a plan-before-code, test-first,
two-stage-review workflow instead of letting the agent dump code
immediately.

Standard loop for any non-trivial task:

```
/brainstorm      → talk through the approach before any file is touched
/write-plan      → produce a written plan to review and correct
/execute-plan    → implement against the approved plan
```

Do not skip straight to `/execute-plan`. The planning steps are the entire
point of the plugin.

### Two-model build/review split

**BUILDER — Claude Code (this repo, full file access)**

- **Opus 5** — planning, architecture, anything touching `lib/models/` or
  `lib/services/`.
- **Sonnet 5** — routine execution: screens, forms, CRUD.
- Note: Claude Pro has limited Opus access. Spend it on planning and
  review passes, not on routine widget building.

**REVIEWER — ChatGPT Go (no repo access — paste files in)**

Reviews Claude Code's output cold. The point is that it has no investment
in the choices Claude Code made, so it catches assumptions the author
cannot see.

Review loop:

1. Claude Code builds a feature; read the diff yourself first.
2. Paste the changed file(s) plus `lib/models/CONTRACT.md` into ChatGPT:
   "Review this Flutter code. Does it match this contract? What breaks at
   runtime? What is overcomplicated for a student project?"
3. Bring real findings back to Claude Code to fix — some findings will be
   wrong, do not apply them blindly.
4. You make the final call.

When to run a review: anything touching Supabase queries, RLS
assumptions, `lib/models/`, `lib/services/`, or auth. Skip it for routine
forms — ChatGPT Go has its own usage limits and reviewing low-risk code
wastes them. Batch related files into one review rather than going file by
file.

**Honest limitation:** cross-review catches implementation bugs. It does
not catch "we built the wrong thing." That check stays with the human.
