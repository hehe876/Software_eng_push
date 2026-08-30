# Sanjay's Planner

This file is the answer when the instructor asks where the project stands.
Tick items off as you finish them and commit the change — an unticked item
that's actually done is as misleading as a ticked item that isn't.

---

## Sprint 0 — Aug 24 – Aug 30: Setup

- [ ] Flutter SDK, Git installed (see `START-HERE.md` §1)
- [ ] `flutter doctor` passes with no blocking issues
- [ ] An emulator or physical Android device running (`flutter devices`
      shows at least one)
- [ ] Repo cloned, `flutter pub get` run, app runs via `flutter run`
- [ ] GitHub account made, username sent to the group for collaborator access
- [ ] `--dart-define` values noted once Vishwa posts the Supabase keys (see
      `RUN.md`)

## Sprint 1 — Aug 31 – Sep 13: UI shells on hardcoded data

Accounts isn't merged yet — you are **not blocked**. Build against
hardcoded Dart lists now, swap in real Supabase queries once
`flex/accounts` lands.

- [ ] Trip creation screen built against a hardcoded `List<Trip>`
- [ ] Itinerary day view built against hardcoded `ItineraryItem`s
- [ ] `// TODO: replace with Supabase query once flex/accounts is merged`
      comments left on every hardcoded data point

## Sprint 2 — Sep 14 – Sep 27: Itinerary

- [ ] Create-trip form writes to `trips` via the `Trip` model (destination,
      dates, coordinates)
- [ ] `TripProvider` built, holding the current trip's itinerary state
- [ ] Itinerary item CRUD (add/edit/delete) working against
      `itinerary_items` via `ItineraryItem`
- [ ] Reordering via up/down buttons swapping `order_index` (REQ-2.3
      minimum)
- [ ] Notes field on itinerary items
- [ ] PR opened and merged to `main` — target **27 Sep 2026**

## Sprint 3 — Sep 28 – Oct 18: REQ-5.2 (directions inside Emergency)

This moved to you from Santhosh — see `team/sanjay/README.md` and
`team/santhosh/README.md` for why. Maps and Emergency land this sprint on
the other two branches; this is what connects them.

- [ ] Confirmed `lib/services/routing_service.dart`'s signature with
      Vishwa before starting
- [ ] Wrapper function built around `routing_service.dart`, callable by
      Santhosh's Emergency screen
- [ ] Signature documented in `lib/services/README.md`
- [ ] Confirmed with Santhosh that he can call it as documented
- [ ] Merged to `main` — target **18 Oct 2026**, same as Maps and
      Emergency

## Sprint 4 — Oct 19 – Nov 1: Recommendations + integration

- [ ] Recommendations feed built, querying `recommendations` by destination
      and category, ordered by rating, mapped to `Recommendation`
- [ ] Seed data for 3–5 destinations (10–15 real places each) added to
      `db/seed.sql`, replacing the `-- TODO (Sanjay)` marker
- [ ] "Add to itinerary" from a recommendation card writes a new
      `ItineraryItem`
- [ ] PR opened and merged to `main` — target **1 Nov 2026**
- [ ] Participate in full-app integration testing

## Sprint 5 — Nov 2 – Nov 8: Testing

- [ ] Trip with an end date before the start date — validation catches it
- [ ] Reordering the only item in a day (edge of the list) — no crash
- [ ] Recommendations query for a destination with no seeded places —
      graceful empty state, not a broken query (REQ-6.4)
- [ ] Adding the same recommendation to an itinerary twice — decide and
      test the intended behaviour (allowed or blocked)
- [ ] Similarity ranking (if built) — hard stop check: is it done by today,
      or does it get cut per the plan?
- [ ] REQ-5.2 wrapper: call it with a location far from any hospital and
      confirm it degrades sensibly rather than throwing unhandled

## Sprint 6 — Nov 9 – Nov 20: Deploy, docs, viva prep

- [ ] Verify Itinerary, Recommendations, and the REQ-5.2 wrapper work
      against a release build, not just a debug run on your machine
- [ ] User guide section for Itinerary + Recommendations written
- [ ] Final report section for Itinerary + Recommendations written
- [ ] Viva prep: can explain why reordering doesn't require drag-and-drop
      to satisfy REQ-2.3, why the recommendation ranking is described as a
      ranking function and not an ML model, and why REQ-5.2 is yours and
      not Santhosh's

---

## Blockers

| Date | Blocker | Status |
| --- | --- | --- |
| | | |
