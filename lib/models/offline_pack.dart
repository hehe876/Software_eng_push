// Maps to the `offline_packs` table (db/schema.sql, 4.4 Maps & Offline,
// REQ-4.1-4.3). FROZEN — see lib/models/CONTRACT.md before changing
// anything here.
//
// This row only records THAT a trip was downloaded and where the static
// assets are. The actual offline payload (itinerary copy, guide text)
// lives in Hive on the phone, not here. See
// PROJECT-UNDERSTANDING.md Part 8.

class OfflinePack {
  final String id;
  final String userId;
  final String tripId;
  final String? guideText;
  final String? staticMapUrl;
  final DateTime downloadedAt;

  const OfflinePack({
    required this.id,
    required this.userId,
    required this.tripId,
    this.guideText,
    this.staticMapUrl,
    required this.downloadedAt,
  });

  factory OfflinePack.fromJson(Map<String, dynamic> json) {
    return OfflinePack(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      tripId: json['trip_id'] as String,
      guideText: json['guide_text'] as String?,
      staticMapUrl: json['static_map_url'] as String?,
      downloadedAt: DateTime.parse(json['downloaded_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'trip_id': tripId,
      'guide_text': guideText,
      'static_map_url': staticMapUrl,
      'downloaded_at': downloadedAt.toIso8601String(),
    };
  }
}
