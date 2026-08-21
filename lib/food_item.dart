class FoodItem {
  final String id;
  final String name;
  final String unit; // e.g. "g", "ml", "piece", "cup"
  final double caloriesPerUnit; // calories for 1 unit of `unit`

  const FoodItem({
    required this.id,
    required this.name,
    required this.unit,
    required this.caloriesPerUnit,
  });

  FoodItem copyWith({
    String? id,
    String? name,
    String? unit,
    double? caloriesPerUnit,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      caloriesPerUnit: caloriesPerUnit ?? this.caloriesPerUnit,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'unit': unit,
        'caloriesPerUnit': caloriesPerUnit,
      };

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
        id: json['id'] as String,
        name: json['name'] as String,
        unit: json['unit'] as String,
        caloriesPerUnit: (json['caloriesPerUnit'] as num).toDouble(),
      );
}
