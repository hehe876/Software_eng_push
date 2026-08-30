# Sanjay Sivakumar — 24BCE1948

Owns: Itinerary (SRS 4.2, REQ-2.1–2.4), Recommendations (SRS 4.6, REQ-6.1–6.4),
**and REQ-5.2** (directions inside Emergency — see below)

Branches: `flex/itinerary`, `flex/recommendations`

Folders you may edit: `lib/features/itinerary/`,
`lib/features/recommendations/` (REQ-5.2's wrapper also lives in one of
these two — your call, document it in your PR)

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
- lib/models/CONTRACT.md (the frozen Dart data contract)
- lib/services/README.md (the service signatures other people depend on)
- docs/srs/ (the requirements — check REQ numbers before building)

Then tell me which task I should be on based on today's date, and show me
the plan before writing any code.
```

Do this once per session. Skipping it means Claude writes code against
guessed requirements rather than the actual SRS.

---

## Why you have these two features (and REQ-5.2)

Itinerary is the spine the rest of the app reads from — Maps plots its
stops, Budget attaches to its trips, and its `Trip` model is the second
thing built after Accounts. It needs to be right early. Recommendations is
the optional stretch: REQ-6.4 explicitly allows it to degrade gracefully,
so it's the feature that can flex if time runs short, and it's paired with
Itinerary because you have the Git experience to handle two branches with
some overlap in timing.

REQ-5.2 moved to you from Santhosh. It's the one Emergency task that
requires reading and integrating someone else's live implementation
(Vishwa's `lib/services/routing_service.dart`) — exactly what Santhosh
can't do, since he's on free-tier AI with no repo access. You build a
self-contained wrapper with a documented signature; Santhosh calls it from
his own Emergency screen like any other service, the same way he calls
Overpass. He still owns the rest of the Emergency UI — this is one
function, not a feature handoff.

---

## Feature 1: Itinerary (REQ-2.1–2.4)

Target merge: end of Sprint 2, **27 Sep 2026**.
Dependencies: `UserProfile`/`auth.users` from Vishwa's Accounts — trips key
on `user_id`.

### Starting before your dependency lands

Accounts isn't done until Sprint 1 ends. Don't wait — build the itinerary
screens now against hardcoded data in a local `List<Trip>`:

```dart
// TODO: replace with Supabase query once flex/accounts is merged
final trips = [Trip(id: '1', userId: 'placeholder', destination: 'Goa', ...)];
```

Swapping the data source for a real query later is an afternoon of work,
not a rewrite, as long as you're already using the `Trip` and
`ItineraryItem` models from `lib/models/`.

### Tasks

1. Build "create a trip": destination, start date, end date. Store
   destination coordinates (`Trip.latitude`/`.longitude`) at creation
   time — Maps needs them later and the schema is frozen, so this can't be
   added retroactively without a group conversation.
2. Build a `TripProvider` (Provider/`ChangeNotifier`) holding the current
   trip's itinerary items, so the itinerary screen and the map screen stay
   in sync without manually passing data between them.
3. Build plain CRUD for itinerary items first — add, edit, delete a stop
   for a given day, via `TripProvider`. Get this fully working before
   touching reordering.
4. Build reordering. REQ-2.3 says "reorder", not "drag to reorder" —
   up/down buttons that swap `order_index` between two adjacent rows
   satisfy the requirement completely. Ship that first. Flutter's built-in
   `ReorderableListView` can do drag-to-reorder as an enhancement on top,
   only if time allows — it's part of the Flutter SDK already, not a new
   dependency, so it doesn't need a group conversation to add.
5. Add notes per itinerary item.

### Done when

- [ ] Creating a trip stores destination, dates, and coordinates —
      REQ-2.1
- [ ] Itinerary items can be added, edited, and deleted per day —
      REQ-2.2
- [ ] Items can be reordered within a day (arrow buttons at minimum) —
      REQ-2.3
- [ ] Notes can be added to an item — REQ-2.4

---

## REQ-5.2: Directions inside Emergency

Target merge: as part of Sprint 3, **18 Oct 2026** — same sprint as Maps
and Emergency, since this is what connects them.
Dependencies: Vishwa's `lib/services/routing_service.dart` must exist
first. Check with him before starting — don't build against a guessed
signature when the real one is one message away.

### The task

Build a small, self-contained wrapper function around
`routing_service.dart`'s `getRoute(...)` that Santhosh's Emergency screen
can call without needing to understand routing internals. Something like:

```dart
Future<RouteResult> getDirectionsToNearestEmergencyService({
  required double fromLat,
  required double fromLng,
  required double toLat,
  required double toLng,
}) {
  // thin wrapper — calls routing_service.dart's getRoute(...) directly.
  // Exists as its own function so Santhosh has one documented call to
  // make instead of learning routing_service.dart's internals.
}
```

Document the exact signature you ship in `lib/services/README.md` (add a
short section under `routing_service.dart`'s entry) and tell Santhosh
directly — he's building against this from a pasted-in prompt, not by
reading your code.

### Done when

- [ ] Wrapper function exists, calls `routing_service.dart`, and is
      documented in `lib/services/README.md` — REQ-5.2
- [ ] Santhosh has confirmed he can call it from Emergency with the
      signature as documented

---

## Feature 2: Recommendations (REQ-6.1–6.4)

Target merge: end of Sprint 4, **1 Nov 2026**.
Dependencies: Itinerary (adding a recommendation to a trip needs
`ItineraryItem` writes to work) and the seed data in `db/seed.sql`.

### Tasks

1. Build the recommendations feed: query `recommendations` filtered by
   destination and category, ordered by rating, mapped to
   `Recommendation` objects. This `ORDER BY` ranking **is** the required
   deliverable for REQ-6.4, not a fallback — don't treat it as something
   to replace with "real" ML later in this project.
2. Seed real place names for your chosen 3–5 destinations (10–15 places
   each) in `db/seed.sql`, replacing the `-- TODO (Sanjay)` marker there.
   "Restaurant 1" / "Restaurant 2" looks exactly like a placeholder — use
   actual listings.
3. Build "add to itinerary" from a recommendation card: construct a new
   `ItineraryItem` from the tapped `Recommendation`'s fields and write it
   via `TripProvider`.
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
building features with real dependencies between them (Recommendations
writes to itinerary items; REQ-5.2 depends on Vishwa's service existing),
keep sessions scoped to one feature so Claude isn't reasoning about
multiple branches' state at once. You know Git reasonably well — if
Vishwa or Santhosh get stuck on something Git-related, you're the one who
can walk them through it faster than the docs will.

Your model, effort level, and session workflow are your own call — see
`docs/WORKFLOW.md` for the shared project-wide expectations (repo-aware
tooling, planning before substantial changes, respecting ownership and
frozen contracts) versus what's personal to each contributor.
