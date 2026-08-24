// Maps to the `profiles` table (db/schema.sql, 4.1 Accounts, REQ-1.1-1.4).
// FROZEN — see lib/models/CONTRACT.md before changing anything here.

class UserProfile {
  final String id; // == auth.users.id
  final String? fullName;
  final String defaultCurrency;
  final Map<String, dynamic>? preferences;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    this.fullName,
    this.defaultCurrency = 'INR',
    this.preferences,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      fullName: json['full_name'] as String?,
      defaultCurrency: json['default_currency'] as String? ?? 'INR',
      preferences: json['preferences'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'default_currency': defaultCurrency,
      'preferences': preferences,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
