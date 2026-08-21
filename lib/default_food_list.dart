import 'food_item.dart';

/// Built-in default foods, available on launch.
final List<FoodItem> defaultFoodList = [
  const FoodItem(id: 'default_rice', name: 'White Rice (cooked)', unit: 'g', caloriesPerUnit: 1.3),
  const FoodItem(id: 'default_chicken_breast', name: 'Chicken Breast (cooked)', unit: 'g', caloriesPerUnit: 1.65),
  const FoodItem(id: 'default_egg', name: 'Egg', unit: 'piece', caloriesPerUnit: 78),
  const FoodItem(id: 'default_banana', name: 'Banana', unit: 'piece', caloriesPerUnit: 105),
  const FoodItem(id: 'default_bread', name: 'White Bread', unit: 'slice', caloriesPerUnit: 79),
  const FoodItem(id: 'default_milk', name: 'Whole Milk', unit: 'ml', caloriesPerUnit: 0.61),
  const FoodItem(id: 'default_apple', name: 'Apple', unit: 'piece', caloriesPerUnit: 95),
  const FoodItem(id: 'default_almonds', name: 'Almonds', unit: 'g', caloriesPerUnit: 5.79),
  const FoodItem(id: 'default_potato', name: 'Potato (baked)', unit: 'g', caloriesPerUnit: 0.93),
  const FoodItem(id: 'default_olive_oil', name: 'Olive Oil', unit: 'tbsp', caloriesPerUnit: 119),
];
