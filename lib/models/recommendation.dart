// Maps to the `recommendations` table (db/schema.sql, 4.6 Recommendations,
// REQ-6.1-6.4). FROZEN — see lib/models/CONTRACT.md before changing
// anything here.
//
// Rows are hand-seeded in db/seed.sql, not fetched from any live API.
// See PROJECT-UNDERSTANDING.md Part 3.

class Recommendation {
  final String id;
  final String destination;
  final String name;
  final String category;
  final String? description;
  final double? rating;
  final int? priceLevel;
  final List<String>? tags;
  final double? latitude;
  final double? longitude;
  final String? imageUrl;

  const Recommendation({
    required this.id,
    required this.destination,
    required this.name,
    required this.category,
    this.description,
    this.rating,
    this.priceLevel,
    this.tags,
    this.latitude,
    this.longitude,
    this.imageUrl,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      id: json['id'] as String,
      destination: json['destination'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      priceLevel: json['price_level'] as int?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'destination': destination,
      'name': name,
      'category': category,
      'description': description,
      'rating': rating,
      'price_level': priceLevel,
      'tags': tags,
      'latitude': latitude,
      'longitude': longitude,
      'image_url': imageUrl,
    };
  }
}
