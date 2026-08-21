import 'package:flutter/foundation.dart';
import 'food_item.dart';
import 'consumed_entry.dart';
import 'storage_service.dart';


class CalculatedEntry {
  final ConsumedEntry entry;
  final FoodItem foodItem;
  double get calories => entry.amount * foodItem.caloriesPerUnit;

  CalculatedEntry({required this.entry, required this.foodItem});
}


class CalorieTracker extends ChangeNotifier {
  final StorageService _storage = StorageService();

  List<FoodItem> _foodItems = [];
  List<ConsumedEntry> _consumedEntries = [];
  int? _calorieLimit;
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  List<FoodItem> get foodItems => List.unmodifiable(_foodItems);
  int? get calorieLimit => _calorieLimit;

  Future<void> load() async {
    _foodItems = await _storage.loadFoodList();
    _consumedEntries = await _storage.loadConsumedEntries();
    _calorieLimit = await _storage.loadCalorieLimit();
    _isLoading = false;
    notifyListeners();
  }

  List<CalculatedEntry> get todaysEntries {
    final now = DateTime.now();
    return _consumedEntries
        .where((e) =>
            e.timestamp.year == now.year &&
            e.timestamp.month == now.month &&
            e.timestamp.day == now.day)
        .map((e) => CalculatedEntry(
              entry: e,
              foodItem: _foodItems.firstWhere(
                (f) => f.id == e.foodItemId,
                orElse: () => FoodItem(
                  id: e.foodItemId,
                  name: 'Unknown item',
                  unit: '',
                  caloriesPerUnit: 0,
                ),
              ),
            ))
        .toList()
      ..sort((a, b) => a.entry.timestamp.compareTo(b.entry.timestamp));
  }

  double get totalCalories =>
      todaysEntries.fold(0.0, (sum, e) => sum + e.calories);

  bool get hasLimit => _calorieLimit != null;

  bool get isOverLimit =>
      hasLimit && totalCalories > (_calorieLimit as int);

  double get remainingCalories =>
      hasLimit ? (_calorieLimit as int) - totalCalories : 0;

  Future<void> setCalorieLimit(int limit) async {
    _calorieLimit = limit;
    await _storage.saveCalorieLimit(limit);
    notifyListeners();
  }

  Future<void> addConsumedEntry({
    required String foodItemId,
    required double amount,
  }) async {
    final entry = ConsumedEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      foodItemId: foodItemId,
      amount: amount,
      timestamp: DateTime.now(),
    );
    _consumedEntries.add(entry);
    await _storage.saveConsumedEntries(_consumedEntries);
    notifyListeners();
  }

  Future<void> removeConsumedEntry(String entryId) async {
    _consumedEntries.removeWhere((e) => e.id == entryId);
    await _storage.saveConsumedEntries(_consumedEntries);
    notifyListeners();
  }

  Future<void> addFoodItem(FoodItem item) async {
    _foodItems.add(item);
    await _storage.saveFoodList(_foodItems);
    notifyListeners();
  }
}
