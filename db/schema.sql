-- Smart Travel Planning Assistant and Budget Management System
-- Full database schema — every table for every feature.
--
-- Run once in the Supabase SQL Editor. FROZEN after that: if your feature
-- needs a column that isn't here, say so in the group chat before adding
-- it. A schema change here breaks everyone's queries, not just yours.

-- ============================================================
-- 4.1 ACCOUNTS  (owner: Vishwa, REQ-1.1–1.4)
-- ============================================================
-- Supabase Auth already stores the account itself (auth.users: email,
-- password hash, session tokens). We do not recreate any of that here.
-- This table only holds the profile data auth.users doesn't have.

create table profiles (
  id uuid primary key references auth.users(id),      -- REQ-1.1
  full_name text,                                      -- REQ-1.1
  default_currency text not null default 'INR',        -- REQ-1.2
  preferences jsonb,                                    -- REQ-1.3
  created_at timestamptz not null default now()
);

-- ============================================================
-- 4.2 ITINERARY  (owner: Sanjay, REQ-2.1–2.4)
-- ============================================================

create table trips (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id),     -- REQ-2.1
  destination text not null,                            -- REQ-2.1
  start_date date not null,                              -- REQ-2.1
  end_date date not null,                                -- REQ-2.1
  latitude double precision,                             -- REQ-4.1 (Maps needs this at trip creation)
  longitude double precision,                            -- REQ-4.1
  created_at timestamptz not null default now()
);

create table itinerary_items (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references trips(id) on delete cascade,  -- REQ-2.2
  day_number integer not null,                            -- REQ-2.2
  title text not null,                                     -- REQ-2.2
  location_name text,                                      -- REQ-2.2
  latitude double precision,                               -- REQ-4.1
  longitude double precision,                               -- REQ-4.1
  start_time time,                                          -- REQ-2.2
  order_index integer not null,                             -- REQ-2.3 (reorder)
  notes text,                                                -- REQ-2.4
  created_at timestamptz not null default now()
);

create index idx_itinerary_items_order
  on itinerary_items (trip_id, day_number, order_index);

-- ============================================================
-- 4.3 BUDGET  (owner: Santhosh, REQ-3.1–3.5)
-- ============================================================
-- No stored "spent" total, by design — it desynchronises the first time an
-- expense is edited or deleted. Recalculate on read instead:
--
--   select category, sum(amount) as spent
--   from expenses
--   where trip_id = $1
--   group by category;

create table budgets (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references trips(id) on delete cascade,  -- REQ-3.1
  category text not null,                                  -- REQ-3.1
  allocated_amount numeric not null,                        -- REQ-3.1
  unique (trip_id, category)
);

create table expenses (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references trips(id) on delete cascade,  -- REQ-3.2
  category text not null,                                  -- REQ-3.2
  amount numeric not null,                                   -- REQ-3.2
  spent_on date not null,                                    -- REQ-3.2
  description text                                            -- REQ-3.3
);

create index idx_expenses_trip_category
  on expenses (trip_id, category);

-- ============================================================
-- 4.4 MAPS, NAVIGATION & OFFLINE ACCESS  (owner: Vishwa, REQ-4.1–4.3)
-- ============================================================
-- Map rendering and routing need no tables of their own — Leaflet reads
-- trips/itinerary_items directly, and OSRM is called live. The cached
-- offline payload itself lives in IndexedDB in the browser, because it
-- must be readable with no network. This table just tracks what's been
-- downloaded and where the static assets are.

create table offline_packs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id),
  trip_id uuid not null references trips(id) on delete cascade,  -- REQ-4.3
  guide_text text,                                          -- REQ-4.3
  static_map_url text,                                       -- REQ-4.3
  downloaded_at timestamptz not null default now(),
  unique (user_id, trip_id)
);

-- ============================================================
-- 4.5 EMERGENCY ASSISTANCE  (owner: Santhosh, REQ-5.1–5.4)
-- ============================================================
-- Nearby hospitals/police come live from Overpass and are not stored here.

create table emergency_contacts (
  id uuid primary key default gen_random_uuid(),
  region text,                                              -- REQ-5.3
  service_name text not null,                                -- REQ-5.3
  phone_number text not null,                                -- REQ-5.3
  is_default boolean not null default false                  -- REQ-5.3 (112/100/108/101 etc.)
);

create table last_known_location (
  user_id uuid primary key references auth.users(id),
  latitude double precision not null,                        -- REQ-5.4
  longitude double precision not null,                        -- REQ-5.4
  recorded_at timestamptz not null default now()              -- REQ-5.4 (staleness flag reads this)
);

-- ============================================================
-- 4.6 DESTINATION RECOMMENDATIONS  (owner: Sanjay, REQ-6.1–6.4)
-- ============================================================

create table recommendations (
  id uuid primary key default gen_random_uuid(),
  destination text not null,                                 -- REQ-6.1
  name text not null,                                          -- REQ-6.1
  category text not null,                                       -- REQ-6.2
  description text,                                              -- REQ-6.1
  rating numeric,                                                 -- REQ-6.2
  price_level integer,                                             -- REQ-6.2
  tags text[],                                                      -- REQ-6.2
  latitude double precision,                                         -- REQ-6.3 (add to itinerary)
  longitude double precision,                                         -- REQ-6.3
  image_url text
);

create index idx_recommendations_destination_category
  on recommendations (destination, category);

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================
-- This is what enforces SRS Section 5.3 and the rule that a user sees only
-- their own data. Without it, any signed-in user could read everyone's
-- trips and expenses through the auto-generated REST API — RLS is the only
-- thing standing between "signed in" and "sees everyone's data".

alter table profiles enable row level security;
alter table trips enable row level security;
alter table itinerary_items enable row level security;
alter table budgets enable row level security;
alter table expenses enable row level security;
alter table offline_packs enable row level security;
alter table last_known_location enable row level security;
alter table recommendations enable row level security;
alter table emergency_contacts enable row level security;

-- Own-row tables: policy checks auth.uid() directly against a user_id (or id) column.

create policy "own profile" on profiles
  for all using (auth.uid() = id);

create policy "own trips" on trips
  for all using (auth.uid() = user_id);

create policy "own offline packs" on offline_packs
  for all using (auth.uid() = user_id);

create policy "own last known location" on last_known_location
  for all using (auth.uid() = user_id);

-- Parent-trip tables: the row itself has no user_id, so the policy checks
-- ownership through the trip it belongs to via an exists subquery.

create policy "own itinerary items" on itinerary_items
  for all using (
    exists (
      select 1 from trips
      where trips.id = itinerary_items.trip_id
      and trips.user_id = auth.uid()
    )
  );

create policy "own budgets" on budgets
  for all using (
    exists (
      select 1 from trips
      where trips.id = budgets.trip_id
      and trips.user_id = auth.uid()
    )
  );

create policy "own expenses" on expenses
  for all using (
    exists (
      select 1 from trips
      where trips.id = expenses.trip_id
      and trips.user_id = auth.uid()
    )
  );

-- Shared reference data: every signed-in user can read, nobody writes from
-- the app. The team updates these two directly in the Supabase dashboard,
-- per SRS Section 2.3.

create policy "read recommendations" on recommendations
  for select using (auth.role() = 'authenticated');

create policy "read emergency contacts" on emergency_contacts
  for select using (auth.role() = 'authenticated');
