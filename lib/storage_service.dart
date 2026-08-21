import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'food_item.dart';
import 'consumed_entry.dart';
import 'default_food_list.dart';

/// Handles reading and writing app data to the device using SharedPreferences.
class StorageService {
  static const _kFoodListKey = 'food_list';
  static const _kConsumedEntriesKey = 'consumed_entries';
  static const _kCalorieLimitKey = 'calorie_limit';
  static const _kInitializedKey = 'initialized';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<List<FoodItem>> loadFoodList() async {
    final prefs = await _prefs;
    final initialized = prefs.getBool(_kInitializedKey) ?? false;

    if (!initialized) {
      await saveFoodList(defaultFoodList);
      await prefs.setBool(_kInitializedKey, true);
      return List.of(defaultFoodList);
    }

    final raw = prefs.getString(_kFoodListKey);
    if (raw == null) return List.of(defaultFoodList);

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveFoodList(List<FoodItem> items) async {
    final prefs = await _prefs;
    final encoded = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_kFoodListKey, encoded);
  }

  Future<List<ConsumedEntry>> loadConsumedEntries() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_kConsumedEntriesKey);
    if (raw == null) return [];

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => ConsumedEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveConsumedEntries(List<ConsumedEntry> entries) async {
    final prefs = await _prefs;
    final encoded = jsonEncode(entries.map((e) => e.toJson()).toList());
    await prefs.setString(_kConsumedEntriesKey, encoded);
  }

  Future<int?> loadCalorieLimit() async {
    final prefs = await _prefs;
    return prefs.getInt(_kCalorieLimitKey);
  }

  Future<void> saveCalorieLimit(int limit) async {
    final prefs = await _prefs;
    await prefs.setInt(_kCalorieLimitKey, limit);
  }
}
