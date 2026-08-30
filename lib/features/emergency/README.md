# Emergency Assistance — REQ-5.1, 5.3, 5.4

Flutter feature folder. Owner: Santhosh · Branch: `flex/emergency` · SRS 4.5

Vishwa is currently implementing this feature on Santhosh's behalf — see
`docs/OWNERSHIP.md` (canonical). This is an implementation arrangement,
not an ownership change.

Nearby hospitals and police stations with one-tap calling, plus default
national helplines.

REQ-5.2 (directions inside this panel) is **not** built here — it's a
self-contained wrapper Sanjay builds around Vishwa's
`lib/services/routing_service.dart` (see `lib/features/maps/README.md`
and `lib/features/recommendations/README.md`). This screen calls Sanjay's
wrapper like any other service, once it exists. You still own the whole
Emergency UI, including where that call slots in.

Carries the safety disclaimer required by SRS Section 5.2 — this is not a
certified emergency-dispatch system, and the panel must say so.

Task brief: [`team/santhosh/README.md`](../../../team/santhosh/README.md)

Only Santhosh edits this folder.
