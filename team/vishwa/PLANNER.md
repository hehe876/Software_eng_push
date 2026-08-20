# Vishwa's Planner

This file is the answer when the instructor asks where the project stands.
Tick items off as you finish them and commit the change — an unticked item
that's actually done is as misleading as a ticked item that isn't.

---

## Sprint 0 — Aug 24 – Aug 30: Setup

- [ ] Node 20+, Git, VS Code installed and verified (see `START-HERE.md` §1)
- [ ] Repo cloned, `npm install` run, dev server starts at localhost:5173
- [ ] GitHub account made, username sent to the group for collaborator access
- [ ] Create the Supabase project
- [ ] Run `db/schema.sql` in the Supabase SQL Editor
- [ ] Run `db/seed.sql` in the Supabase SQL Editor
- [ ] Post the Supabase URL and anon key to the group chat so Sanjay and
      Santhosh can fill in their `.env`
- [ ] `.env` filled in locally from `.env.example`

## Sprint 1 — Aug 31 – Sep 13: Accounts

- [ ] Sign-up screen (email/password)
- [ ] Google sign-in wired up
- [ ] `profiles` row created on sign-up (trigger or explicit insert after
      sign-up — auth.users alone is not enough)
- [ ] Profile screen: view/edit full name, default currency, preferences
- [ ] Supabase auth error codes mapped to human-readable messages
- [ ] PR opened and merged to `main` — target **13 Sep 2026**

## Sprint 2 — Sep 14 – Sep 27: (Itinerary + Budget land — not your branch)

- [ ] Available to unblock Sanjay/Santhosh if they hit an Accounts-related
      question (their trip/expense rows depend on your `user_id` and
      `profiles` work)
- [ ] No PR expected from you this sprint — this is a checkpoint, not a task

## Sprint 3 — Sep 28 – Oct 18: Maps & Offline

- [ ] Leaflet CSS imported, map renders with visible tiles
- [ ] Marker icon path fix applied (Vite breaks the default Leaflet icons)
- [ ] Markers plotted for itinerary stops (`itinerary_items`)
- [ ] OSM attribution visible on the map
- [ ] `src/lib/routing.js` built as a plain function, OSRM call working
- [ ] Offline download: cached itinerary + guide text + static map image,
      stored via IndexedDB
- [ ] `offline_packs` row written on download
- [ ] Tested offline with DevTools set to Offline (not Wi-Fi off)
- [ ] PR opened and merged to `main` — target **18 Oct 2026**

## Sprint 4 — Oct 19 – Nov 1: Integration

- [ ] All six features integrated on `main`, app runs end-to-end for one
      full user flow (sign up → create trip → add itinerary → set budget →
      log expense → view map → check emergency panel)
- [ ] Any cross-feature bugs found during integration logged and assigned

## Sprint 5 — Nov 2 – Nov 8: Testing

- [ ] Sign-up with an email already in use — correct inline error, no crash
- [ ] Sign-in with wrong password — human-readable message, not raw error
- [ ] Map with zero itinerary items — no crash, sensible empty state
- [ ] Offline mode with a trip that was never downloaded — clear message,
      not a blank screen
- [ ] Routing call when OSRM is slow/unreachable — timeout handled, no
      infinite spinner

## Sprint 6 — Nov 9 – Nov 20: Deploy, docs, viva prep

- [ ] App deployed to hosting (Vercel/Netlify or similar)
- [ ] Environment variables (`VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY`)
      set on the host — the deployed build will not read your local `.env`
- [ ] Google OAuth redirect URL updated in the Supabase dashboard to the
      deployed domain — **Google sign-in will break in production if this
      step is skipped**
- [ ] User guide section for Accounts + Maps written
- [ ] Final report section for Accounts + Maps written
- [ ] Viva prep: can explain RLS, the auth.users/profiles split, and the
      offline scope honesty point from README.md §2 without notes

---

## Blockers

| Date | Blocker | Status |
| --- | --- | --- |
| | | |
