import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'food_item.dart';
import 'calorie_tracker.dart';

class AddEntryScreen extends StatefulWidget {
  final CalorieTracker tracker;
  const AddEntryScreen({super.key, required this.tracker});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  FoodItem? _selectedItem;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double? get _previewCalories {
    final amount = double.tryParse(_amountController.text);
    if (_selectedItem == null || amount == null) return null;
    return amount * _selectedItem!.caloriesPerUnit;
  }

  void _submit() {
    if (!_formKey.currentState!.validate() || _selectedItem == null) return;
    final amount = double.parse(_amountController.text);
    widget.tracker.addConsumedEntry(
      foodItemId: _selectedItem!.id,
      amount: amount,
    );
    Navigator.pop(context);
  }

  Future<void> _openAddCustomFoodDialog() async {
    final nameController = TextEditingController();
    final unitController = TextEditingController(text: 'g');
    final caloriesController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Add custom food',
          style: TextStyle(color: AppColors.plum, fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: unitController,
              decoration:
                  const InputDecoration(labelText: 'Unit (g, ml, piece, ...)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: caloriesController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Calories per 1 unit'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.goldMuted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Add',
                style: TextStyle(
                    color: AppColors.plum, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (result != true) return;

    final calories = double.tryParse(caloriesController.text);
    if (nameController.text.trim().isEmpty ||
        unitController.text.trim().isEmpty ||
        calories == null) {
      return;
    }

    final newItem = FoodItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: nameController.text.trim(),
      unit: unitController.text.trim(),
      caloriesPerUnit: calories,
    );

    await widget.tracker.addFoodItem(newItem);
    setState(() => _selectedItem = newItem);
  }

  @override
  Widget build(BuildContext context) {
    final foodItems = widget.tracker.foodItems;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('LOG AN ITEM')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<FoodItem>(
                initialValue: _selectedItem,
                decoration: const InputDecoration(labelText: 'Item'),
                dropdownColor: AppColors.cardWhite,
                style: const TextStyle(color: AppColors.plum, fontSize: 14),
                items: foodItems
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text('${item.name} (${item.unit})'),
                        ))
                    .toList(),
                onChanged: (item) => setState(() => _selectedItem = item),
                validator: (value) =>
                    value == null ? 'Please select an item' : null,
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _openAddCustomFoodDialog,
                style: TextButton.styleFrom(foregroundColor: AppColors.plum),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add a new food item'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: AppColors.plum),
                decoration: InputDecoration(
                  labelText: 'Amount consumed'
                      '${_selectedItem != null ? ' (${_selectedItem!.unit})' : ''}',
                ),
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter an amount';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (_previewCalories != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.cardWhite,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('= ',
                          style: TextStyle(color: AppColors.goldMuted)),
                      Text(
                        '${_previewCalories!.toStringAsFixed(0)} calories',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.plum,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('ADD TO LOG'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
