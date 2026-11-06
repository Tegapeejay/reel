import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class RatingBadge extends StatelessWidget {
  const RatingBadge({super.key, required this.rating, this.compact = false});

  final double rating;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (rating <= 0) return const SizedBox.shrink();
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: compact ? 6 : 8, vertical: compact ? 3 : 5),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(165),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded,
              size: compact ? 13 : 16, color: AppColors.star),
          const SizedBox(width: 3),
          Text(
            rating.toStringAsFixed(1),
            style: textTheme.labelLarge?.copyWith(fontSize: compact ? 11 : 13),
          ),
        ],
      ),
    );
  }
}
