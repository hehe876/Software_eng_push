// Maps to the `trips` table (db/schema.sql, 4.2 Itinerary, REQ-2.1-2.4).
// FROZEN — see lib/models/CONTRACT.md before changing anything here.

import 'package:intl/intl.dart';

final DateFormat _dateOnly = DateFormat('yyyy-MM-dd');

class Trip {
  final String id;
  final String userId;
  final String destination;
  final DateTime startDate; // date only, no time component
  final DateTime endDate; // date only, no time component
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;

  const Trip({
    required this.id,
    required this.userId,
    required this.destination,
    required this.startDate,
    required this.endDate,
    this.latitude,
    this.longitude,
    required this.createdAt,
  });

  // Day headings are NOT stored anywhere — calculate them from these two
  // dates every time the screen opens. See PROJECT-UNDERSTANDING.md Part 7.
  int get numberOfDays => endDate.difference(startDate).inDays + 1;

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      destination: json['destination'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'destination': destination,
      'start_date': _dateOnly.format(startDate),
      'end_date': _dateOnly.format(endDate),
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
