# Santhosh's Planner

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
- [ ] Read `AI-PROMPT-PACK.md` once fully, so you know what's already
      written for you before Sprint 2 starts

## Sprint 1 — Aug 31 – Sep 13: UI shells on hardcoded data

Accounts isn't merged yet — you are **not blocked**. Build against
hardcoded Dart lists now, swap in real Supabase queries once
`flex/accounts` lands.

- [ ] Budget setup screen built against a hardcoded `List<Budget>`
- [ ] Expense form built against a hardcoded `List<Expense>`
- [ ] `// TODO: replace with Supabase query once flex/accounts is merged`
      comments left on every hardcoded data point

## Sprint 2 — Sep 14 – Sep 27: Budget

- [ ] Budget setup screen writes `Budget` rows (category + allocated amount)
- [ ] Expense form writes `Expense` rows
- [ ] `BudgetProvider` computes balances live with `SUM(amount) GROUP BY
      category` — no stored "spent" field anywhere
- [ ] 90% threshold alert working, divide-by-zero on empty allocation
      guarded against
- [ ] PR opened and merged to `main` — target **27 Sep 2026**

## Sprint 3 — Sep 28 – Oct 18: Emergency

- [ ] `lib/services/overpass_service.dart` built, querying
      `amenity=hospital` and `amenity=police`
- [ ] Slow/rate-limited Overpass responses handled (loading/error state)
- [ ] Unnamed OSM entries shown with a fallback label, not blank
- [ ] Default helplines (112, 100, 108, 101, + seed data) always visible,
      independent of Overpass, via `EmergencyContact`
- [ ] `url_launcher` `tel:` calling working (REQ-5.3 — not REQ-5.2, that's
      Sanjay's directions task)
- [ ] Safety disclaimer visible (SRS Section 5.2)
- [ ] Last-known-location fallback working via `LastKnownLocation`, with a
      visible "may be stale" flag (REQ-5.4 — both halves, not just the
      fallback)
- [ ] Confirmed Sanjay's REQ-5.2 wrapper signature and wired the call into
      the Emergency screen once his branch merges
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
- [ ] Location permission denied — falls back to `LastKnownLocation` and
      flags it as possibly stale
- [ ] `tel:` link tapped on an actual phone (see Sprint 6 — do a first pass
      here too if a phone is available)

## Sprint 6 — Nov 9 – Nov 20: Deploy, docs, viva prep

- [ ] Verify Budget and Emergency work against a release build, not just a
      debug run on your machine
- [ ] Test `tel:` links on an actual phone, not just an emulator — an
      emulator may not even prompt to call
- [ ] User guide section for Budget + Emergency written
- [ ] Final report section for Budget + Emergency written
- [ ] Viva prep: can explain why "spent" is never stored as a field, what
      the safety disclaimer says and why it's required, and why REQ-5.2
      (directions) is Sanjay's task and not yours

---

## Blockers

Restating the rule: **stuck on the same error for more than 30 minutes
means posting it in the group chat.** Log it here too, so it's visible
without anyone having to scroll the chat history.

| Date | Blocker | Asked the group? | Status |
| --- | --- | --- | --- |
| | | | |
