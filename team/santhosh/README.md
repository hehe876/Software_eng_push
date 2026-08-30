# Santhosh S — 24BCE5169

Owns: Budget (SRS 4.3, REQ-3.1–3.5), Emergency Assistance (SRS 4.5,
REQ-5.1, 5.3, 5.4)

Branches: `flex/budget`, `flex/emergency`

Folders you may edit: `lib/features/budget/`, `lib/features/emergency/`,
`lib/services/overpass_service.dart`

**Note on REQ-5.2:** directions inside the Emergency panel is Sanjay's
task now, not yours — see "Why you have these two features" below. You
still own the rest of Emergency.

---

## Current implementation note

**Vishwa is currently implementing Budget and Emergency on your behalf**,
in a Claude Code session, so the team keeps moving on these two features.
This is an implementation arrangement, not an ownership transfer:

- You remain the **owner** of both features — REQ responsibility (REQ-3.x
  and REQ-5.1/5.3/5.4) and project credit for them are still yours.
- `docs/OWNERSHIP.md` is the canonical record of this arrangement (and of
  Sanjay's REQ-5.2 exception, which works the same way in reverse).
- Everything below — the task breakdown, the AI prompt pack, the
  planner — stays accurate reference material for you, whether you're
  reviewing Vishwa's work, picking up a piece of it yourself, or resuming
  full implementation later. Nothing here assumes you must personally
  write every line, and nothing prohibits you from doing so either.

---

## Step 0 — Load context before you start

Free ChatGPT and Claude cannot read your repo, so the context has to be
pasted. Do this once at the start of each new chat:

1. Open `README.md` and copy the sections "What this project is", "What we
   are honest about", and "Tech stack".
2. Open this file (`team/santhosh/README.md`) and copy the task you are
   working on.
3. Open `db/schema.sql` and copy only the tables your feature uses.
4. Open `lib/models/CONTRACT.md` and copy the class(es) matching those
   tables.
5. Paste all four, then your question.

[`AI-PROMPT-PACK.md`](AI-PROMPT-PACK.md) already has this bundled into each
prompt — for the six main tasks below, skip straight to the matching
prompt in the pack instead of doing these steps by hand. Use the manual
steps above only for things the pack doesn't cover.

---

## Why you have these two features (and not REQ-5.2)

Budget and Emergency are the two most self-contained features in the
project — Budget is mostly one table's worth of arithmetic, and Emergency
is mostly wiring up two free APIs. That's the whole reason they went to
you: it's about message limits, not capability. You're on free-tier AI, so
the features you own can't be the ones that need forty back-and-forth
messages to debug a routing edge case. Say this plainly if anyone asks —
it's a scheduling decision, not a judgment on the work.

That's also exactly why REQ-5.2 — directions inside this panel — moved to
Sanjay. It's the one Emergency task that means reading and integrating
someone else's live implementation (Vishwa's `routing_service.dart`), and
that kind of cross-branch integration is hard to do well from a pasted
prompt with no repo access. Sanjay is building a small wrapper function
around it. Once it exists and is documented in
`lib/services/README.md`, you call it from your Emergency screen exactly
like you call `overpass_service.dart` — you're not blocked on
understanding routing internals, just on Sanjay's branch landing.

---

## Feature 1: Budget (REQ-3.1–3.5)

Target merge: end of Sprint 2, **27 Sep 2026**.
Dependencies: `Trip` (from Sanjay's Itinerary) for the `trip_id` foreign
key — but the table itself already exists once `db/schema.sql` is run in
Sprint 0, so you are not blocked. Runs in parallel with Itinerary.

### Starting before your dependency lands

Build the budget setup and expense screens now against hardcoded data in
a local `List<Budget>` / `List<Expense>`:

```dart
// TODO: replace with Supabase query once flex/itinerary is merged
final budgets = [Budget(id: '1', tripId: 'placeholder', category: 'Food', allocatedAmount: 5000)];
```

Swap in a real `tripId` once Sanjay's trips exist to attach to.

### Tasks

1. Build the budget setup screen: allocate an amount per category for a
   trip, writing `Budget` rows.
2. Build the expense form: category, amount, date, description, writing
   `Expense` rows.
3. Build a `BudgetProvider` (Provider/`ChangeNotifier`) that fetches
   expenses for a trip and exposes totals per category. **Do not store a
   running "spent" total in a field or column** — it desynchronises the
   moment an expense gets edited or deleted, and now the number on screen
   is wrong until someone notices. Recalculate on read instead:
   ```sql
   select category, sum(amount) as spent
   from expenses
   where trip_id = $1
   group by category;
   ```
4. Add the 90% threshold alert. This is two `if` statements on data you
   already fetched for the balances view — not a notification service,
   not a background task, nothing async.
5. Guard the percentage calculation against divide-by-zero when a category
   has an allocation of zero.

### Done when

- [ ] Budget can be set per category for a trip — REQ-3.1
- [ ] Expenses can be logged with category, amount, date, description —
      REQ-3.2, REQ-3.3
- [ ] Balances are computed live from `expenses`, never a stored total —
      REQ-3.4
- [ ] A 90% threshold alert shows per category, with no divide-by-zero on
      an empty allocation — REQ-3.5

---

## Feature 2: Emergency Assistance (REQ-5.1, 5.3, 5.4)

Target merge: end of Sprint 3, **18 Oct 2026**.
Dependencies: none for REQ-5.1/5.3/5.4 — Overpass and
`emergency_contacts` don't need anyone else's branch. REQ-5.2 (directions)
depends on Sanjay's wrapper and is his task, not yours; call it once it
lands, don't build your own copy of it.

### Tasks

1. Build `lib/services/overpass_service.dart`, querying Overpass for
   `amenity=hospital` and `amenity=police` near the user's location. It's
   free and keyless — see `lib/services/README.md` for the signature to
   build against.
2. Handle slow or rate-limited Overpass responses and OSM entries that have
   no name — don't let either crash the panel or show a blank entry with no
   fallback label.
3. Keep the default helplines (112, 100, 108, 101, plus the extras in
   `db/seed.sql`) visible at all times, even when Overpass returns nothing.
   They come from `EmergencyContact` rows via Supabase, not from Overpass.
4. Build one-tap calling with `url_launcher`'s `launchUrl(Uri(scheme:
   'tel', path: phoneNumber))` — no telephony package beyond what's
   already in `pubspec.yaml`.
5. Add the safety disclaimer. **This is required by SRS Section 5.2**, not
   optional polish (a different "5.2" from the REQ-5.2 directions task —
   don't confuse the two): the panel must state that in a life-threatening
   emergency the user should also call local services directly.
6. Build the last-known-location fallback (REQ-5.4). This has two parts,
   both required: fall back to the last saved `LastKnownLocation` when
   live location isn't available, **and** visibly flag on screen that the
   shown location may be stale.

### Done when

- [ ] Nearby hospitals and police stations load from Overpass —
      REQ-5.1
- [ ] Unnamed OSM entries and slow/rate-limited responses are handled, not
      crashing the panel — REQ-5.1
- [ ] Default helplines are always visible, independent of Overpass —
      REQ-5.3
- [ ] Tap-to-call works via `url_launcher` — REQ-5.3
- [ ] Safety disclaimer is present and visible — SRS Section 5.2
- [ ] Last-known location is used as a fallback and marked as possibly
      stale — REQ-5.4
- [ ] Directions to the nearest service call Sanjay's REQ-5.2 wrapper once
      it's merged — not built or duplicated here

---

## Working with your AI tool

You're on free tier — no repo access, and every message counts. Use
[`AI-PROMPT-PACK.md`](AI-PROMPT-PACK.md) for the six tasks above: it has
each prompt pre-loaded with the Flutter/Supabase stack, the relevant
schema, the matching model class, and the constraints, so you're not
retyping context every time. Start a fresh chat per task. Ask for complete
files, not fragments — a fragment you have to merge by hand costs you a
second message when it doesn't quite fit.

**Stuck on the same error for more than 30 minutes?** Post it in the group
chat for Vishwa or Sanjay to run through their Pro session. This is the
intended workflow, not a failure — it's specifically why the ground rules
ask them to check in when you flag a blocker.

See `docs/WORKFLOW.md` for how this fits into the team's shared
expectations. No specific AI tool or workflow is prescribed for you
beyond what's documented here and in `docs/OWNERSHIP.md` — this pack and
the current Vishwa-implementing arrangement can both be true at once.
