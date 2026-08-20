# Vishwa Thangapandiyan — 24BCE1415

Owns: Accounts (SRS 4.1, REQ-1.1–1.4), Maps & Offline (SRS 4.4, REQ-4.1–4.3)

Branches: `feat/accounts`, `feat/maps`

Folders you may edit: `src/features/accounts/`, `src/lib/supabase.js`,
`src/features/maps/`, `src/lib/routing.js`, `src/lib/offline.js`

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
Maps is the hardest build in the project — Leaflet, routing, and an
offline cache all in one feature — so it goes to the person with Claude
Pro, since debugging it will take real back-and-forth with the AI.

---

## Feature 1: Accounts (REQ-1.1–1.4)

Target merge: end of Sprint 1, **13 Sep 2026**.
Dependencies: none — this is what everyone else waits on.

### Tasks

1. Set up the Supabase project (see your planner — this happens in Sprint
   0, before coding starts). Run `db/schema.sql` in the SQL Editor.
2. Build sign-up and sign-in screens, including Google sign-in. Supabase
   Auth handles password hashing and sessions — none of that gets written
   by hand.
3. Handle the gap between `auth.users` and `profiles`: Supabase Auth
   creates a row in `auth.users` on sign-up, but **not** in `profiles`.
   Insert the profile row yourself right after sign-up (or use a database
   trigger) — otherwise the profile screen loads empty for every new user.
4. Build the profile screen: full name, default currency, preferences.
5. Map Supabase auth error codes to human-readable inline messages for
   REQ-1.4. Never show a raw error object to the user.

### Done when

- [ ] Sign-up creates both an `auth.users` row and a matching `profiles`
      row — REQ-1.1
- [ ] Sign-in works, including Google — REQ-1.1
- [ ] Profile screen reads and updates `profiles` (name, currency,
      preferences) — REQ-1.2, REQ-1.3
- [ ] Auth errors show as human-readable messages, not raw error text —
      REQ-1.4

---

## Feature 2: Maps & Offline (REQ-4.1–4.3)

Target merge: end of Sprint 3, **18 Oct 2026**.
Dependencies: `trips` and `itinerary_items` from Sanjay's Itinerary
feature — you're plotting stops that already exist.

### Tasks

1. Import Leaflet's CSS. Skip this and the map renders as a grey box with
   no tiles.
2. Apply the standard Leaflet marker-icon fix — the default marker icons
   break under Vite's asset handling unless you point them at the bundled
   icon paths explicitly.
3. Plot itinerary stops as markers, reading from `itinerary_items`.
4. Put the OSRM routing call in `src/lib/routing.js` as a plain,
   standalone function — Santhosh imports it as-is for REQ-5.2, so don't
   fold it into a component.
5. Keep OSM attribution visible on the map. This is a licence condition,
   not a style choice.
6. Build the offline download: cached itinerary data, cached guide text,
   and one static map image per destination, saved via IndexedDB (`idb`).
   This is **not** a pannable offline tile cache — don't attempt one. Write
   to `offline_packs` (Supabase) for the record of what's downloaded, and
   the actual payload into IndexedDB.
7. Test offline mode with DevTools' Network tab set to **Offline**, not by
   turning off Wi-Fi — turning off Wi-Fi doesn't reliably kill an
   already-open connection the way DevTools does.

### Done when

- [ ] Map renders with visible tiles and correct markers — REQ-4.1
- [ ] Routing between itinerary stops works via OSRM, callable from
      `src/lib/routing.js` — REQ-4.2
- [ ] OSM attribution is visible — REQ-4.1
- [ ] A downloaded trip (itinerary + guide text + static map image) loads
      with DevTools set to Offline — REQ-4.3

---

## Working with your AI tool

You have Claude Pro and Claude Code. Run Step 0 at the start of every
session — don't skip it because "it's a small change." Keep sessions
scoped to one feature at a time so Claude isn't holding both Accounts and
Maps context at once. When you hit something gnarly in Maps (routing
edge cases, offline sync bugs), that's exactly what the Pro budget is for
— don't ration it the way Santhosh has to.
