import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'calorie_tracker.dart';

class SettingsScreen extends StatefulWidget {
  final CalorieTracker tracker;
  const SettingsScreen({super.key, required this.tracker});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _limitController;

  @override
  void initState() {
    super.initState();
    _limitController = TextEditingController(
      text: widget.tracker.calorieLimit?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final limit = int.parse(_limitController.text);
    widget.tracker.setCalorieLimit(limit);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('SETTINGS')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _limitController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppColors.plum),
                decoration: const InputDecoration(
                  labelText: 'Daily calorie limit',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter a limit';
                  final parsed = int.tryParse(value);
                  if (parsed == null || parsed <= 0) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                child: const Text('SAVE'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
