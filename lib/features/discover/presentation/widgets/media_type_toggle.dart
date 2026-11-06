import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/media_item.dart';
import '../../../../core/theme/app_colors.dart';
import '../../application/discover_providers.dart';

class MediaTypeToggle extends ConsumerWidget {
  const MediaTypeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(mediaModeProvider);
    void select(MediaType type) =>
        ref.read(mediaModeProvider.notifier).state = type;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Segment(
            label: 'Movies',
            selected: mode == MediaType.movie,
            onTap: () => select(MediaType.movie),
          ),
          _Segment(
            label: 'TV Shows',
            selected: mode == MediaType.tv,
            onTap: () => select(MediaType.tv),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: selected ? Colors.white : AppColors.textSecondary,
              ),
        ),
      ),
    );
  }
}
