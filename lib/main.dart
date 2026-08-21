import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'calorie_tracker.dart';
import 'home_screen.dart';

void main() {
  runApp(const CalorieTrackerApp());
}

class CalorieTrackerApp extends StatefulWidget {
  const CalorieTrackerApp({super.key});

  @override
  State<CalorieTrackerApp> createState() => _CalorieTrackerAppState();
}

class _CalorieTrackerAppState extends State<CalorieTrackerApp> {
  final CalorieTracker _tracker = CalorieTracker();

  @override
  void initState() {
    super.initState();
    _tracker.load();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calorie Tracker',
      theme: buildAppTheme(),
      home: HomeScreen(tracker: _tracker),
    );
  }
}
