# Santhosh's Planner

This file is the answer when the instructor asks where the project stands.
Tick items off as you finish them and commit the change — an unticked item
that's actually done is as misleading as a ticked item that isn't.

---

## Sprint 0 — Aug 24 – Aug 30: Setup

- [ ] Node 20+, Git, VS Code installed and verified (see `START-HERE.md` §1)
- [ ] Repo cloned, `npm install` run, dev server starts at localhost:5173
- [ ] GitHub account made, username sent to the group for collaborator access
- [ ] `.env` filled in once Vishwa posts the Supabase keys
- [ ] Read `AI-PROMPT-PACK.md` once fully, so you know what's already
      written for you before Sprint 2 starts

## Sprint 1 — Aug 31 – Sep 13: UI shells on hardcoded data

Accounts isn't merged yet — you are **not blocked**. Build against
hardcoded `useState` data now, swap in real queries once `feat/accounts`
lands.

- [ ] Budget setup screen built against a hardcoded category list
- [ ] Expense form built against a hardcoded expense list
- [ ] `// TODO: replace with Supabase query once feat/accounts is merged`
      comments left on every hardcoded data point

## Sprint 2 — Sep 14 – Sep 27: Budget

- [ ] Budget setup screen writes to `budgets` (category + allocated amount)
- [ ] Expense form writes to `expenses`
- [ ] Balances computed live with `SUM(amount) GROUP BY category` — no
      stored "spent" column
- [ ] 90% threshold alert working, divide-by-zero on empty allocation
      guarded against
- [ ] PR opened and merged to `main` — target **27 Sep 2026**

## Sprint 3 — Sep 28 – Oct 18: Emergency

- [ ] Overpass query for `amenity=hospital` and `amenity=police` working
- [ ] Slow/rate-limited Overpass responses handled (loading/error state)
- [ ] Unnamed OSM entries shown with a fallback label, not blank
- [ ] Default helplines (112, 100, 108, 101, + seed data) always visible,
      independent of Overpass
- [ ] `tel:` links working for one-tap calling
- [ ] Safety disclaimer visible (SRS Section 5.2)
- [ ] Last-known-location fallback working, with a visible "may be stale"
      flag (REQ-5.4 — both halves, not just the fallback)
- [ ] PR opened and merged to `main` — target **18 Oct 2026**

## Sprint 4 — Oct 19 – Nov 1: (Recommendations lands — not your branch)

- [ ] Participate in full-app integration testing
- [ ] No PR expected from you this sprint — this is a checkpoint, not a task

## Sprint 5 — Nov 2 – Nov 8: Testing

- [ ] Expense that exceeds the category allocation — alert still shows
      correctly past 100%, not just at the 90% line
- [ ] Category with zero allocated amount — no divide-by-zero crash on the
      balances screen
- [ ] Overpass returning zero results for a remote location — default
      helplines still show
- [ ] Location permission denied — falls back to `last_known_location` and
      flags it as possibly stale
- [ ] `tel:` link tapped on an actual phone (see Sprint 6 — do a first pass
      here too if a phone is available)

## Sprint 6 — Nov 9 – Nov 20: Deploy, docs, viva prep

- [ ] Verify Budget and Emergency work against the deployed build, not
      just localhost
- [ ] Test `tel:` links on an actual phone, not just desktop Chrome — a
      desktop browser may not even prompt to call
- [ ] User guide section for Budget + Emergency written
- [ ] Final report section for Budget + Emergency written
- [ ] Viva prep: can explain why "spent" is never stored as a column, and
      what the safety disclaimer says and why it's required

---

## Blockers

Restating the rule: **stuck on the same error for more than 30 minutes
means posting it in the group chat.** Log it here too, so it's visible
without anyone having to scroll the chat history.

| Date | Blocker | Asked the group? | Status |
| --- | --- | --- | --- |
| | | | |
