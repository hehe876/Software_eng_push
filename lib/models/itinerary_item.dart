// Maps to the `itinerary_items` table (db/schema.sql, 4.2 Itinerary,
// REQ-2.1-2.4). FROZEN — see lib/models/CONTRACT.md before changing
// anything here.

class ItineraryItem {
  final String id;
  final String tripId;
  final int dayNumber;
  final String title;
  final String? locationName;
  final double? latitude;
  final double? longitude;
  final String? startTime; // "HH:mm:ss", nullable. Postgres `time` has no
  // direct Dart equivalent worth adding a package for — store/parse as
  // plain text and format for display where needed.
  final int orderIndex; // position within the day; REQ-2.3 reordering
  final String? notes;
  final DateTime createdAt;

  const ItineraryItem({
    required this.id,
    required this.tripId,
    required this.dayNumber,
    required this.title,
    this.locationName,
    this.latitude,
    this.longitude,
    this.startTime,
    required this.orderIndex,
    this.notes,
    required this.createdAt,
  });

  factory ItineraryItem.fromJson(Map<String, dynamic> json) {
    return ItineraryItem(
      id: json['id'] as String,
      tripId: json['trip_id'] as String,
      dayNumber: json['day_number'] as int,
      title: json['title'] as String,
      locationName: json['location_name'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      startTime: json['start_time'] as String?,
      orderIndex: json['order_index'] as int,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trip_id': tripId,
      'day_number': dayNumber,
      'title': title,
      'location_name': locationName,
      'latitude': latitude,
      'longitude': longitude,
      'start_time': startTime,
      'order_index': orderIndex,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
