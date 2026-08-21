import 'package:flutter/material.dart';
import '../app_theme.dart';


class DashedDivider extends StatelessWidget {
  final Color color;
  const DashedDivider({super.key, this.color = AppColors.dashDivider});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const dashWidth = 5.0;
          const dashSpace = 4.0;
          final dashCount =
              (constraints.maxWidth / (dashWidth + dashSpace)).floor();
          return Flex(
            direction: Axis.horizontal,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: 1,
                child: DecoratedBox(decoration: BoxDecoration(color: color)),
              );
            }).expand((w) => [w, const SizedBox(width: dashSpace)]).toList(),
          );
        },
      ),
    );
  }
}
