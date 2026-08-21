import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'calorie_tracker.dart';
import 'add_entry_screen.dart';
import 'settings_screen.dart';
import 'dashed_divider.dart';

class HomeScreen extends StatefulWidget {
  final CalorieTracker tracker;
  const HomeScreen({super.key, required this.tracker});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.tracker.addListener(_onChange);
  }

  @override
  void dispose() {
    widget.tracker.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final tracker = widget.tracker;

    if (tracker.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.plum),
        ),
      );
    }

    final entries = tracker.todaysEntries;
    final total = tracker.totalCalories;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("TODAY'S LOG"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.plum),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(tracker: tracker),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(0, 4, 0, 100),
            children: [
              _SummaryHeader(tracker: tracker, total: total),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _ReceiptCard(
                  entries: entries,
                  total: total,
                  onDismiss: tracker.removeConsumedEntry,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEntryScreen(tracker: tracker),
            ),
          );
        },
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}


class _SummaryHeader extends StatelessWidget {
  final CalorieTracker tracker;
  final double total;
  const _SummaryHeader({required this.tracker, required this.total});

  @override
  Widget build(BuildContext context) {
    final hasLimit = tracker.hasLimit;
    final isOver = tracker.isOverLimit;

    String stampText;
    Color stampColor;
    String subText;

    if (!hasLimit) {
      stampText = 'No limit';
      stampColor = AppColors.goldMuted;
      subText = 'Set a daily calorie limit in settings';
    } else if (isOver) {
      stampText = 'Over budget';
      stampColor = AppColors.orange;
      subText =
          '${(total - tracker.calorieLimit!).toStringAsFixed(0)} cal over ${tracker.calorieLimit} cal limit';
    } else {
      stampText = 'On track';
      stampColor = AppColors.orange;
      subText =
          '${tracker.remainingCalories.toStringAsFixed(0)} of ${tracker.calorieLimit} cal remaining';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                total.toStringAsFixed(0),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: AppColors.plum,
                  height: 1,
                ),
              ),
              Transform.rotate(
                angle: -0.07, // ~ -4deg, matches the mockup's tilted stamp
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: stampColor, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    stampText.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: stampColor,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subText,
            style: const TextStyle(fontSize: 12, color: AppColors.goldMuted),
          ),
        ],
      ),
    );
  }
}


class _ReceiptCard extends StatelessWidget {
  final List<CalculatedEntry> entries;
  final double total;
  final void Function(String entryId) onDismiss;

  const _ReceiptCard({
    required this.entries,
    required this.total,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          if (entries.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'No items logged today.',
                style: TextStyle(color: AppColors.goldMuted, fontSize: 13),
              ),
            )
          else
            ...entries.map((e) => _ReceiptRow(
                  entry: e,
                  onDismiss: () => onDismiss(e.entry.id),
                )),
          if (entries.isNotEmpty) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.only(top: 12),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.plum, width: 2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.plum,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    total.toStringAsFixed(0),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.plum,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  final CalculatedEntry entry;
  final VoidCallback onDismiss;

  const _ReceiptRow({required this.entry, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(entry.entry.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 8),
        child: const Icon(Icons.delete_outline, color: AppColors.orange),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.foodItem.name,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.plum,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${entry.entry.amount} ${entry.foodItem.unit}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.gold,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  entry.calories.toStringAsFixed(0),
                  style: const TextStyle(fontSize: 13, color: AppColors.plum),
                ),
              ],
            ),
            const SizedBox(height: 9),
            const DashedDivider(),
          ],
        ),
      ),
    );
  }
}
