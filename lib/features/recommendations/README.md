# Destination Recommendations — REQ-6.1–6.4

Flutter feature folder. Owner: Sanjay · Branch: `flex/recommendations` · SRS 4.6

Suggests places near the trip destination that can be added straight to
the itinerary. Ranking is a plain database `ORDER BY` — REQ-6.4 makes
this the required deliverable, not a stand-in for something smarter later.

Ships last in the build order. REQ-6.4 explicitly allows this feature to
degrade gracefully if it isn't finished.

**Also owns REQ-5.2**, the directions-inside-Emergency wrapper around
Vishwa's `lib/services/routing_service.dart` — see
`lib/features/emergency/README.md` for why this moved from Santhosh, and
`team/sanjay/README.md` for the task itself. It lives in this folder or
`lib/services/`, not in `emergency/`.

Task brief: [`team/sanjay/README.md`](../../../team/sanjay/README.md)

Only Sanjay edits this folder.
