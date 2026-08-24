// Maps to the `last_known_location` table (db/schema.sql, 4.5 Emergency,
// REQ-5.4). FROZEN — see lib/models/CONTRACT.md before changing anything
// here.
//
// One row per user, overwritten on every update — no history. Used as
// the fallback when live GPS is unavailable. The caller (not this class)
// is responsible for comparing recordedAt to now() and flagging the
// position as possibly stale — see PROJECT-UNDERSTANDING.md Part 9.

class LastKnownLocation {
  final String userId; // primary key
  final double latitude;
  final double longitude;
  final DateTime recordedAt;

  const LastKnownLocation({
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.recordedAt,
  });

  factory LastKnownLocation.fromJson(Map<String, dynamic> json) {
    return LastKnownLocation(
      userId: json['user_id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      recordedAt: DateTime.parse(json['recorded_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'latitude': latitude,
      'longitude': longitude,
      'recorded_at': recordedAt.toIso8601String(),
    };
  }
}
