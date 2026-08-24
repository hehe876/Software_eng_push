// Maps to the `emergency_contacts` table (db/schema.sql, 4.5 Emergency,
// REQ-5.1-5.4). FROZEN — see lib/models/CONTRACT.md before changing
// anything here.
//
// These come from Supabase, never from Overpass — they must be visible
// even when Overpass is down or rate-limited. See
// PROJECT-UNDERSTANDING.md Part 9.

class EmergencyContact {
  final String id;
  final String? region;
  final String serviceName;
  final String phoneNumber;
  final bool isDefault; // true for national numbers: 112, 100, 108, 101...

  const EmergencyContact({
    required this.id,
    this.region,
    required this.serviceName,
    required this.phoneNumber,
    this.isDefault = false,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'] as String,
      region: json['region'] as String?,
      serviceName: json['service_name'] as String,
      phoneNumber: json['phone_number'] as String,
      isDefault: json['is_default'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'region': region,
      'service_name': serviceName,
      'phone_number': phoneNumber,
      'is_default': isDefault,
    };
  }
}
