# Sanjay Sivakumar — 24BCE1948

Owns: Itinerary (SRS 4.2, REQ-2.1–2.4), Recommendations (SRS 4.6, REQ-6.1–6.4)

Branches: `feat/itinerary`, `feat/recommendations`

Folders you may edit: `src/features/itinerary/`, `src/features/recommendations/`

---

## Step 0 — Load context before you start

From the repo root, run `claude`. It reads `CLAUDE.md` automatically. Then,
in your first message of the session:

```
Read these before doing anything:
- README.md (what the project is, the stack, the rules)
- CLAUDE.md (project context and constraints)
- team/sanjay/README.md (my tasks)
- team/sanjay/PLANNER.md (what is due right now)
- db/schema.sql (the frozen database schema)
- docs/srs/ (the requirements — check REQ numbers before building)

Then tell me which task I should be on based on today's date, and show me
the plan before writing any code.
```

Do this once per session. Skipping it means Claude writes code against
guessed requirements rather than the actual SRS.

---

## Why you have these two features

Itinerary is the spine the rest of the app reads from — Maps plots its
stops, Budget attaches to its trips, and its `trips` table is the second
thing built after Accounts. It needs to be right early. Recommendations is
the optional stretch: REQ-6.4 explicitly allows it to degrade gracefully,
so it's the feature that can flex if time runs short, and it's paired with
Itinerary because you have the Git experience to handle two branches with
some overlap in timing.

---

## Feature 1: Itinerary (REQ-2.1–2.4)

Target merge: end of Sprint 2, **27 Sep 2026**.
Dependencies: `profiles`/`auth.users` from Vishwa's Accounts — trips key on
`user_id`.

### Starting before your dependency lands

Accounts isn't done until Sprint 1 ends. Don't wait — build the itinerary
screens now against hardcoded data in `useState`:

```js
// TODO: replace with Supabase query once feat/accounts is merged
const [trips, setTrips] = useState([{ id: '1', destination: 'Goa', ... }])
```

Swapping the data source for a real query later is an afternoon of work,
not a rewrite, as long as your component shapes match the schema.

### Tasks

1. Build "create a trip": destination, start date, end date. Store
   destination coordinates (`latitude`/`longitude` on `trips`) at creation
   time — Maps needs them later and the schema is frozen, so this can't be
   added retroactively without a group conversation.
2. Build plain CRUD for itinerary items first — add, edit, delete a stop
   for a given day. Get this fully working before touching reordering.
3. Build reordering. REQ-2.3 says "reorder", not "drag to reorder" — up/down
   arrow buttons that swap `order_index` between two adjacent rows satisfy
   the requirement completely. Ship that first. Treat `dnd-kit` (or
   similar) as an enhancement on top, only if time allows.
4. Add notes per itinerary item.

### Done when

- [ ] Creating a trip stores destination, dates, and coordinates —
      REQ-2.1
- [ ] Itinerary items can be added, edited, and deleted per day —
      REQ-2.2
- [ ] Items can be reordered within a day (arrow buttons at minimum) —
      REQ-2.3
- [ ] Notes can be added to an item — REQ-2.4

---

## Feature 2: Recommendations (REQ-6.1–6.4)

Target merge: end of Sprint 4, **1 Nov 2026**.
Dependencies: Itinerary (adding a recommendation to a trip needs
`itinerary_items` to exist) and the seed data in `db/seed.sql`.

### Tasks

1. Build the recommendations feed: query `recommendations` filtered by
   destination and category, ordered by rating. This `ORDER BY` ranking
   **is** the required deliverable for REQ-6.4, not a fallback — don't
   treat it as something to replace with "real" ML later in this project.
2. Seed real place names for your chosen 3–5 destinations (10–15 places
   each) in `db/seed.sql`, replacing the `-- TODO (Sanjay)` marker there.
   "Restaurant 1" / "Restaurant 2" looks exactly like a placeholder — use
   actual listings.
3. Build "add to itinerary" from a recommendation card, writing a new
   `itinerary_items` row.
4. If time allows before **8 Nov 2026** (hard stop), add a similarity
   ranking on top of the base ordering. If you build it, describe it in
   the code and docs as a ranking function — not a trained model. It
   isn't one, and calling it one is the kind of overclaim that doesn't
   survive a viva question.

### Done when

- [ ] Recommendations feed shows real places for the destination, ranked
      by a database query — REQ-6.1, REQ-6.2, REQ-6.4
- [ ] A recommendation can be added straight to the itinerary —
      REQ-6.3
- [ ] Seed data covers 3–5 destinations with real place names — REQ-6.1
- [ ] (Optional, stop by Nov 8) similarity ranking, described as a
      ranking function

---

## Working with your AI tool

You have Claude Pro, possibly Max. Run Step 0 every session. Since you're
building two features with a dependency between them (Recommendations
writes to `itinerary_items`), keep sessions scoped to one feature so
Claude isn't reasoning about both branches' state at once. You know Git
reasonably well — if Vishwa or Santhosh get stuck on something Git-related,
you're the one who can walk them through it faster than the docs will.
