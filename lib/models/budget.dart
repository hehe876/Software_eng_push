// Maps to the `budgets` table (db/schema.sql, 4.3 Budget, REQ-3.1-3.5).
// FROZEN — see lib/models/CONTRACT.md before changing anything here.
//
// This is what was ALLOCATED. What was actually SPENT is never stored —
// see Expense and PROJECT-UNDERSTANDING.md Part 2, Scene 5. Compute spent
// totals with SUM(amount) GROUP BY category on Expense rows, every time.

class Budget {
  final String id;
  final String tripId;
  final String category;
  final double allocatedAmount;

  const Budget({
    required this.id,
    required this.tripId,
    required this.category,
    required this.allocatedAmount,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'] as String,
      tripId: json['trip_id'] as String,
      category: json['category'] as String,
      allocatedAmount: (json['allocated_amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trip_id': tripId,
      'category': category,
      'allocated_amount': allocatedAmount,
    };
  }
}
