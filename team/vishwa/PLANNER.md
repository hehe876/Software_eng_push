# Vishwa's Planner

This file is the answer when the instructor asks where the project stands.
Tick items off as you finish them and commit the change — an unticked item
that's actually done is as misleading as a ticked item that isn't.

---

## Sprint 0 — Aug 24 – Aug 30: Setup

- [ ] Flutter SDK, Git, Android Studio (or VS Code + Flutter extension)
      installed (see `START-HERE.md` §1)
- [ ] `flutter doctor` passes with no blocking issues
- [ ] An emulator or physical Android device running (`flutter devices`
      shows at least one)
- [ ] Repo cloned, `flutter pub get` run, app runs via `flutter run` (see
      `RUN.md` for the required `--dart-define` flags)
- [ ] GitHub account made, username sent to the group for collaborator access
- [ ] Create the Supabase project
- [ ] Run `db/schema.sql` in the Supabase SQL Editor
- [ ] Run `db/seed.sql` in the Supabase SQL Editor
- [ ] Post the Supabase URL and anon key to the group chat so Sanjay and
      Santhosh can fill in their `--dart-define` flags (see `RUN.md`)

## Sprint 1 — Aug 31 – Sep 13: Accounts

- [ ] Sign-up screen (email/password)
- [ ] Google sign-in wired up
- [ ] `profiles` row created on sign-up (trigger or explicit insert after
      sign-up — `auth.users` alone is not enough), using the `UserProfile`
      model
- [ ] Profile screen: view/edit full name, default currency, preferences
- [ ] Supabase auth error codes mapped to human-readable messages
- [ ] PR opened and merged to `main` — target **13 Sep 2026**

## Sprint 2 — Sep 14 – Sep 27: (Itinerary + Budget land — not your branch)

- [ ] Available to unblock Sanjay/Santhosh if they hit an Accounts-related
      question (their trip/expense rows depend on your `user_id` and
      `profiles` work)
- [ ] No PR expected from you this sprint — this is a checkpoint, not a task

## Sprint 3 — Sep 28 – Oct 18: Maps & Offline

- [ ] `flutter_map` set up with an OpenStreetMap tile layer
- [ ] `INTERNET` permission added to `AndroidManifest.xml` (map stays
      blank with no error if this is missing)
- [ ] OSM attribution widget visible on the map
- [ ] Markers plotted for itinerary stops (`ItineraryItem.latitude`/`.longitude`)
- [ ] `lib/services/routing_service.dart` built as a plain function, OSRM
      call working, signature documented in `lib/services/README.md`
- [ ] `ACCESS_FINE_LOCATION`/`ACCESS_COARSE_LOCATION` permissions added for
      `geolocator`
- [ ] Offline download: cached itinerary + guide text + static map image,
      stored via Hive
- [ ] `OfflinePack` row written to Supabase on download
- [ ] Tested offline with the device/emulator in Airplane Mode (not just
      Wi-Fi off — some emulators keep a loopback connection alive)
- [ ] PR opened and merged to `main` — target **18 Oct 2026**

## Sprint 4 — Oct 19 – Nov 1: Integration

- [ ] All six features integrated on `main`, app runs end-to-end for one
      full user flow (sign up → create trip → add itinerary → set budget →
      log expense → view map → check emergency panel)
- [ ] Any cross-feature bugs found during integration logged and assigned

## Sprint 5 — Nov 2 – Nov 8: Testing

- [ ] Sign-up with an email already in use — correct inline error, no crash
- [ ] Sign-in with wrong password — human-readable message, not raw error
- [ ] Map with zero itinerary items — no crash, sensible empty state
- [ ] Offline mode with a trip that was never downloaded — clear message,
      not a blank screen
- [ ] Routing call when OSRM is slow/unreachable — timeout handled, no
      infinite spinner

## Sprint 6 — Nov 9 – Nov 20: Deploy, docs, viva prep

- [ ] Release APK built (`flutter build apk` with both `--dart-define`
      flags — see `RUN.md`)
- [ ] Google OAuth redirect configured in the Supabase dashboard for the
      app's actual redirect scheme — **Google sign-in will break on a real
      device if this step is skipped**
- [ ] User guide section for Accounts + Maps written
- [ ] Final report section for Accounts + Maps written
- [ ] Viva prep: can explain RLS, the auth.users/profiles split, and the
      offline scope honesty point from README.md §2 without notes

---

## Blockers

| Date | Blocker | Status |
| --- | --- | --- |
| | | |
