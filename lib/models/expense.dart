// Maps to the `expenses` table (db/schema.sql, 4.3 Budget, REQ-3.1-3.5).
// FROZEN — see lib/models/CONTRACT.md before changing anything here.

import 'package:intl/intl.dart';

final DateFormat _dateOnly = DateFormat('yyyy-MM-dd');

class Expense {
  final String id;
  final String tripId;
  final String category;
  final double amount;
  final DateTime spentOn; // date only, no time component
  final String? description;

  const Expense({
    required this.id,
    required this.tripId,
    required this.category,
    required this.amount,
    required this.spentOn,
    this.description,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      tripId: json['trip_id'] as String,
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      spentOn: DateTime.parse(json['spent_on'] as String),
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trip_id': tripId,
      'category': category,
      'amount': amount,
      'spent_on': _dateOnly.format(spentOn),
      'description': description,
    };
  }
}
