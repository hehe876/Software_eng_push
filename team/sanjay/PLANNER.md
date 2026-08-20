# Sanjay's Planner

This file is the answer when the instructor asks where the project stands.
Tick items off as you finish them and commit the change — an unticked item
that's actually done is as misleading as a ticked item that isn't.

---

## Sprint 0 — Aug 24 – Aug 30: Setup

- [ ] Node 20+, Git, VS Code installed and verified (see `START-HERE.md` §1)
- [ ] Repo cloned, `npm install` run, dev server starts at localhost:5173
- [ ] GitHub account made, username sent to the group for collaborator access
- [ ] `.env` filled in once Vishwa posts the Supabase keys

## Sprint 1 — Aug 31 – Sep 13: UI shells on hardcoded data

Accounts isn't merged yet — you are **not blocked**. Build against
hardcoded `useState` data now, swap in real queries once `feat/accounts`
lands.

- [ ] Trip creation screen built against a hardcoded trip list
- [ ] Itinerary day view built against hardcoded items
- [ ] `// TODO: replace with Supabase query once feat/accounts is merged`
      comments left on every hardcoded data point

## Sprint 2 — Sep 14 – Sep 27: Itinerary

- [ ] Create-trip form writes to `trips` (destination, dates, coordinates)
- [ ] Itinerary item CRUD (add/edit/delete) working against `itinerary_items`
- [ ] Reordering via up/down arrows swapping `order_index` (REQ-2.3 minimum)
- [ ] Notes field on itinerary items
- [ ] PR opened and merged to `main` — target **27 Sep 2026**

## Sprint 3 — Sep 28 – Oct 18: (Maps + Emergency land — not your branch)

- [ ] Available if Vishwa or Santhosh have questions about the shape of
      `trips` / `itinerary_items` while building Maps
- [ ] No PR expected from you this sprint — this is a checkpoint, not a task

## Sprint 4 — Oct 19 – Nov 1: Recommendations + integration

- [ ] Recommendations feed built, querying `recommendations` by destination
      and category, ordered by rating
- [ ] Seed data for 3–5 destinations (10–15 real places each) added to
      `db/seed.sql`, replacing the `-- TODO (Sanjay)` marker
- [ ] "Add to itinerary" from a recommendation card writes to
      `itinerary_items`
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

## Sprint 6 — Nov 9 – Nov 20: Deploy, docs, viva prep

- [ ] Verify Itinerary and Recommendations work against the deployed build,
      not just localhost
- [ ] User guide section for Itinerary + Recommendations written
- [ ] Final report section for Itinerary + Recommendations written
- [ ] Viva prep: can explain why reordering doesn't require drag-and-drop
      to satisfy REQ-2.3, and why the recommendation ranking is described
      as a ranking function and not an ML model

---

## Blockers

| Date | Blocker | Status |
| --- | --- | --- |
| | | |
