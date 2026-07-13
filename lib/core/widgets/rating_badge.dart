import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// White pill showing a 0–10 score, colored by score band.
class RatingBadge extends StatelessWidget {
  const RatingBadge({super.key, required this.value, this.large = false});

  final double value;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final color = Z.rating(value);
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: large ? 14 : 10, vertical: large ? 7 : 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(color: Color(0x22000000), blurRadius: 4, offset: Offset(0, 1)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: large ? 18 : 14, color: color),
          const SizedBox(width: 3),
          Text(
            value.toStringAsFixed(1),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: large ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
