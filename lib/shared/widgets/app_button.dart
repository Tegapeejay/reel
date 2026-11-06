import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

enum AppButtonVariant { primary, secondary, tonal }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
    );
    const padding = EdgeInsets.symmetric(horizontal: 14, vertical: 14);
    final textStyle = Theme.of(context).textTheme.labelLarge;
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );

    return switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: padding,
            shape: shape,
            textStyle: textStyle,
          ),
          child: content,
        ),
      AppButtonVariant.tonal => FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary.withAlpha(70),
            foregroundColor: Colors.white,
            padding: padding,
            shape: shape,
            textStyle: textStyle,
          ),
          child: content,
        ),
      AppButtonVariant.secondary => OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: BorderSide(color: Colors.white.withAlpha(80)),
            padding: padding,
            shape: shape,
            textStyle: textStyle,
          ),
          child: content,
        ),
    };
  }
}
