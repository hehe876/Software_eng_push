# AI Prompt Pack

Copy-paste prompts for free-tier ChatGPT or Claude. You don't have a
subscription, so every message has to count — these are pre-loaded with the
context a paid tool would read from the repo automatically.

## How to use it

- **Start a fresh chat per task.** Old chats accumulate context that isn't
  relevant to the new question and eats into what the model can hold.
- **Copy the whole block**, including the stack description and schema —
  don't trim it to save characters. Missing context is what causes a
  wrong-shaped answer that costs you a second message to fix.
- **Bundle multiple questions into one message** where you can — "build the
  form, and also handle the empty-category case" beats two separate
  messages.
- **Ask for complete files, not fragments.** A fragment you have to merge
  by hand yourself is a second message waiting to happen when it doesn't
  quite fit.

---

## Prompt 1: Budget setup screen

```
I'm building a React (Vite, no TypeScript) feature for a student project —
a travel budget tracker. Stack: React + Vite, plain CSS (no framework),
Supabase for auth/database (already set up, I import `supabase` from
`src/lib/supabase.js`). No new npm dependencies — use what's already in the
project.

Relevant table:

create table budgets (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references trips(id) on delete cascade,
  category text not null,
  allocated_amount numeric not null,
  unique (trip_id, category)
);

Build a complete React component for a "set your budget" screen: given a
trip_id, let the user add categories (e.g. Food, Stay, Transport) with an
allocated amount each, save them to the `budgets` table via Supabase, and
list the categories already saved for this trip. Handle the case where a
category is entered twice for the same trip (the unique constraint will
reject it — show a plain error message, don't crash).

Give me the complete file, plain CSS (inline or a separate .css file, your
choice), and comments explaining anything non-obvious — I have to explain
this code in a viva, so a comment on *why* something is done a certain way
is more useful than one restating what the line does.
```

## Prompt 2: Expense form

```
Same project as before — React + Vite, plain CSS, Supabase, no new
dependencies.

Relevant table:

create table expenses (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references trips(id) on delete cascade,
  category text not null,
  amount numeric not null,
  spent_on date not null,
  description text
);

Build a complete React component: a form to log an expense (category,
amount, date, optional description) for a given trip_id, saving to the
`expenses` table via Supabase, plus a list of expenses already logged for
that trip, most recent first. Category should be a dropdown populated from
the trip's existing `budgets` rows (import the supabase client from
src/lib/supabase.js).

Give me the complete file, plain CSS, and comments on anything non-obvious
— I need to be able to explain this code in a viva.
```

## Prompt 3: Balances and threshold alerts

```
Same project — React + Vite, plain CSS, Supabase, no new dependencies.

Relevant tables:

create table budgets (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references trips(id) on delete cascade,
  category text not null,
  allocated_amount numeric not null,
  unique (trip_id, category)
);

create table expenses (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references trips(id) on delete cascade,
  category text not null,
  amount numeric not null,
  spent_on date not null,
  description text
);

Build a complete React component that shows, per category for a trip: the
allocated amount, the amount spent (SUM of expenses.amount grouped by
category — do NOT store a running total anywhere, compute it live on every
load), the remaining balance, and a visible warning when spending has
crossed 90% of the allocation for that category. Guard against divide by
zero when a category's allocated_amount is 0.

Give me the complete file, plain CSS, and comments on anything non-obvious
for a viva explanation. Keep the 90% check as plain if-statements on data
already fetched — no external notification service.
```

## Prompt 4: Nearby emergency services (Overpass)

```
Same project — React + Vite, plain CSS, no new dependencies (the project
already uses Leaflet for maps if you need to show a marker, but this
component itself can be plain HTML/CSS).

I need a complete React component that queries the Overpass API for nearby
hospitals (amenity=hospital) and police stations (amenity=police) given a
latitude/longitude, and lists them with name and distance. Handle: Overpass
being slow or rate-limited (show a loading/error state, don't hang
forever), and OSM entries with no name tag (show "Unnamed hospital" or
similar instead of a blank line). This is a genuine free, keyless public
API — no API key handling needed.

Give me the complete file, plain CSS, and comments on anything non-obvious
for a viva explanation.
```

## Prompt 5: Emergency contacts and tel: links

```
Same project — React + Vite, plain CSS, Supabase, no new dependencies.

Relevant table:

create table emergency_contacts (
  id uuid primary key default gen_random_uuid(),
  region text,
  service_name text not null,
  phone_number text not null,
  is_default boolean not null default false
);

Build a complete React component that lists emergency contacts from this
table (national defaults always shown, e.g. 112, 100, 108, 101) as tappable
`<a href="tel:...">` links — no telephony API or library. This list must
still render correctly even if a separate "nearby services" component
(different task) fails to load — treat this as independent, not dependent
on Overpass being up. Also render a fixed, always-visible disclaimer text:
that this is not a certified emergency-dispatch system, and in a genuine
life-threatening emergency the user should call local services directly.

Give me the complete file, plain CSS, and comments on anything non-obvious
for a viva explanation.
```

## Prompt 6: Last-known-location fallback

```
Same project — React + Vite, plain CSS, Supabase, no new dependencies.

Relevant table:

create table last_known_location (
  user_id uuid primary key references auth.users(id),
  latitude double precision not null,
  longitude double precision not null,
  recorded_at timestamptz not null default now()
);

Build a complete React hook (e.g. useLocation) that: tries to get the
browser's live geolocation first; if that fails or is denied, falls back to
reading the user's last saved location from the `last_known_location` table
via Supabase; and in the fallback case, returns a flag indicating the
location may be stale (compare recorded_at to now — if it's more than, say,
30 minutes old, flag it) so the calling component can show a visible "this
location may be out of date" warning. When a live location IS obtained
successfully, write/update it to `last_known_location` for next time.

Give me the complete file and comments on anything non-obvious for a viva
explanation.
```

---

## Debugging prompt template

When something breaks, don't describe it from memory — paste the exact
error. A full error message beats a summary of what you think it means;
summarizing loses the one detail (a line number, a specific undefined
value) that would have made the fix obvious in one pass.

```
I'm working on [file name/path] in a React + Vite + Supabase project.

Exact error message:
[paste the full error, including stack trace if there is one]

What I expected to happen:
[expected behaviour]

What actually happened:
[actual behaviour]

Relevant code:
[paste the function or component involved — not the whole file unless it's short]

What I've already tried:
[anything you changed before asking, so we don't repeat it]
```

---

## Message-saving habits

| Inefficient | Efficient instead |
| --- | --- |
| Pasting one error, waiting, pasting the next related error separately | Bundle all related errors from one test run into a single message |
| Asking for a snippet, then asking again for the surrounding file | Ask for the complete file up front |
| Describing an error from memory | Paste the exact error text and stack trace |
| Asking "why doesn't this work" with no code attached | Always attach the actual code you're asking about |
| Iterating fix → test → new chat → re-explain everything | Stay in the same chat until the task is fully done |
| Asking the AI to guess your schema | Paste the relevant `CREATE TABLE` block every time |

---

## The escalation rule

**Stuck on the same error for more than 30 minutes? Post it in the group
chat.** Vishwa or Sanjay can run it through their Pro session and hand back
a fix in one exchange where you might burn your remaining free messages on
the same bug. This is the intended workflow for your two features, not a
sign you're behind — see the ground rules in the main `README.md`.
