# Santhosh S — 24BCE5169

Owns: Budget (SRS 4.3, REQ-3.1–3.5), Emergency Assistance (SRS 4.5, REQ-5.1–5.4)

Branches: `feat/budget`, `feat/emergency`

Folders you may edit: `src/features/budget/`, `src/features/emergency/`

---

## Step 0 — Load context before you start

Free ChatGPT and Claude cannot read your repo, so the context has to be
pasted. Do this once at the start of each new chat:

1. Open `README.md` and copy the sections "What this project is", "What we
   are honest about", and "Tech stack".
2. Open this file (`team/santhosh/README.md`) and copy the task you are
   working on.
3. Open `db/schema.sql` and copy only the tables your feature uses.
4. Paste all three, then your question.

[`AI-PROMPT-PACK.md`](AI-PROMPT-PACK.md) already has this bundled into each
prompt — for the six main tasks below, skip straight to the matching
prompt in the pack instead of doing these steps by hand. Use the manual
steps above only for things the pack doesn't cover.

---

## Why you have these two features

Budget and Emergency are the two most self-contained features in the
project — Budget is mostly one table's worth of arithmetic, and Emergency
is mostly wiring up two free APIs. That's the whole reason they went to
you: it's about message limits, not capability. You're on free-tier AI, so
the features you own can't be the ones that need forty back-and-forth
messages to debug a routing edge case. Say this plainly if anyone asks —
it's a scheduling decision, not a judgment on the work.

---

## Feature 1: Budget (REQ-3.1–3.5)

Target merge: end of Sprint 2, **27 Sep 2026**.
Dependencies: `trips` (from Sanjay's Itinerary) for the `trip_id` foreign
key — but the table itself already exists once `db/schema.sql` is run in
Sprint 0, so you are not blocked. Runs in parallel with Itinerary.

### Starting before your dependency lands

Build the budget setup and expense screens now against hardcoded data in
`useState`:

```js
// TODO: replace with Supabase query once feat/itinerary is merged
const [budgets, setBudgets] = useState([{ category: 'Food', allocated_amount: 5000 }])
```

Swap in a real `trip_id` once Sanjay's trips exist to attach to.

### Tasks

1. Build the budget setup screen: allocate an amount per category for a
   trip, writing to `budgets`.
2. Build the expense form: category, amount, date, description, writing to
   `expenses`.
3. Build the balances view. **Do not store a running "spent" total in a
   column** — it desynchronises the moment an expense gets edited or
   deleted, and now the number on screen is wrong until someone notices.
   Recalculate on read instead:
   ```sql
   select category, sum(amount) as spent
   from expenses
   where trip_id = $1
   group by category;
   ```
4. Add the 90% threshold alert. This is two client-side `if` statements on
   data you already fetched for the balances view — not a notification
   service, not a cron job, nothing async.
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

## Feature 2: Emergency Assistance (REQ-5.1–5.4)

Target merge: end of Sprint 3, **18 Oct 2026**.
Dependencies: reuses the Leaflet map setup and `src/lib/routing.js` from
Vishwa's Maps feature — wait for that branch before starting the map parts.

### Tasks

1. Query Overpass for `amenity=hospital` and `amenity=police` near the
   user's location. It's free and keyless.
2. Handle slow or rate-limited Overpass responses and OSM entries that have
   no name — don't let either crash the panel or show a blank entry with no
   fallback label.
3. Keep the default helplines (112, 100, 108, 101, plus the extras in
   `db/seed.sql`) visible at all times, even when Overpass returns nothing.
   They come from `emergency_contacts`, not from Overpass.
4. Build one-tap calling as a plain `<a href="tel:...">` link — no
   telephony API, no library.
5. Add the safety disclaimer. **This is required by SRS Section 5.2**, not
   optional polish: the panel must state that in a life-threatening
   emergency the user should also call local services directly.
6. Build the last-known-location fallback (REQ-5.4). This has two parts,
   both required: fall back to the last saved location in
   `last_known_location` when live location isn't available, **and**
   visibly flag on screen that the shown location may be stale.

### Done when

- [ ] Nearby hospitals and police stations load from Overpass —
      REQ-5.1
- [ ] Unnamed OSM entries and slow/rate-limited responses are handled, not
      crashing the panel — REQ-5.1
- [ ] Default helplines are always visible, independent of Overpass —
      REQ-5.3
- [ ] Tap-to-call works via `tel:` links — REQ-5.2
- [ ] Safety disclaimer is present and visible — SRS 5.2
- [ ] Last-known location is used as a fallback and marked as possibly
      stale — REQ-5.4

---

## Working with your AI tool

You're on free tier — no repo access, and every message counts. Use
[`AI-PROMPT-PACK.md`](AI-PROMPT-PACK.md) for the six tasks above: it has
each prompt pre-loaded with the stack, the relevant schema, and the
constraints, so you're not retyping context every time. Start a fresh chat
per task. Ask for complete files, not fragments — a fragment you have to
merge by hand costs you a second message when it doesn't quite fit.

**Stuck on the same error for more than 30 minutes?** Post it in the group
chat for Vishwa or Sanjay to run through their Pro session. This is the
intended workflow, not a failure — it's specifically why the ground rules
ask them to check in when you flag a blocker.
