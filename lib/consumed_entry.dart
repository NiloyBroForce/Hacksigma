class ConsumedEntry {
  final String id;
  final String foodItemId;
  final double amount; 
  final DateTime timestamp;

  const ConsumedEntry({
    required this.id,
    required this.foodItemId,
    required this.amount,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'foodItemId': foodItemId,
        'amount': amount,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ConsumedEntry.fromJson(Map<String, dynamic> json) => ConsumedEntry(
        id: json['id'] as String,
        foodItemId: json['foodItemId'] as String,
        amount: (json['amount'] as num).toDouble(),
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}
