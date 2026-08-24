# lib/services/ — the service contract

This folder holds the Flutter/Dart code that talks to anything outside
the phone. The files themselves don't exist yet — each is built by its
owner as part of their feature. This README documents the public signature each one must
expose, because at least one signature (`routing_service.dart`) is called
from a screen someone else owns. Build against what's written here; if a
signature needs to change, say so in the group chat first — the same rule
as `lib/models/CONTRACT.md`.

None of these services hold state, do UI work, or know about Provider.
They take plain values in, return plain values (or model classes from
`lib/models/`) out.

---

## supabase_service.dart

Owner: Vishwa.

```dart
SupabaseClient get supabaseClient;
```

A single shared getter over `Supabase.instance.client`, initialised once
in `lib/main.dart`. Every other service and provider imports from here
instead of calling `Supabase.instance.client` directly — one place to
change if initialisation ever needs to differ.

---

## routing_service.dart

Owner: Vishwa. **Read this one carefully if you are not Vishwa** — this is
the one function another feature calls directly.

```dart
class RoutePoint {
  final double latitude;
  final double longitude;
  const RoutePoint(this.latitude, this.longitude);
}

class RouteResult {
  final List<RoutePoint> points;   // the path, in order, for drawing on the map
  final double distanceMeters;
  final double durationSeconds;
  const RouteResult({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
  });
}

Future<RouteResult> getRoute({
  required double originLat,
  required double originLng,
  required double destLat,
  required double destLng,
});
```

Calls the public OSRM demo server. Throws on network failure or a
non-200 response — callers must catch and show their own fallback UI (the
map still shows pins with no line; Emergency shows distance without a
drawn route). Nothing about the returned route is cached or stored;
callers ask fresh every time.

**REQ-5.2 (directions inside Emergency):** Sanjay builds a self-contained
wrapper around this function — not Santhosh, see `team/sanjay/README.md`
and `team/santhosh/README.md` for why. Santhosh's Emergency screen calls
Sanjay's wrapper, not this function directly.

---

## overpass_service.dart

Owner: Santhosh.

```dart
class OverpassPlace {
  final String? name;   // null or empty if the OSM entry has no name tag
  final String amenityType;  // "hospital" or "police"
  final double latitude;
  final double longitude;
  const OverpassPlace({
    this.name,
    required this.amenityType,
    required this.latitude,
    required this.longitude,
  });
}

Future<List<OverpassPlace>> findNearbyEmergencyServices({
  required double latitude,
  required double longitude,
  double radiusMeters = 5000,
});
```

Queries Overpass for `amenity=hospital` and `amenity=police` within the
radius. Free, keyless. Can be slow, rate-limited, or empty — callers must
handle all three without crashing, and must never depend on this call
succeeding to show default emergency numbers (those come from
`emergency_contacts` via `supabase_service.dart`, independently).

---

## location_service.dart

Owner: Vishwa.

```dart
Future<RoutePoint?> getCurrentPosition();   // null if permission denied or GPS unavailable

Future<LastKnownLocation?> getLastKnownLocation(String userId);  // reads last_known_location via Supabase

Future<void> saveLastKnownLocation({
  required String userId,
  required double latitude,
  required double longitude,
});
```

Wraps `geolocator` for the live position and `supabase_service.dart` for
the stored fallback. Does not decide staleness — the caller compares the
returned `LastKnownLocation.recordedAt` to `DateTime.now()` and decides
whether to flag it, per `lib/models/CONTRACT.md`.
