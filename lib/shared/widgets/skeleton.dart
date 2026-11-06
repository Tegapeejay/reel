import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Pulsing placeholder block used while content loads.
class Skeleton extends StatefulWidget {
  const Skeleton({
    super.key,
    this.width,
    this.height,
    this.radius = AppSpacing.radiusMd,
  });

  final double? width;
  final double? height;
  final double radius;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  late final Animation<double> _opacity =
      Tween<double>(begin: 0.4, end: 1).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}

class PosterCardSkeleton extends StatelessWidget {
  const PosterCardSkeleton({super.key, this.width = AppSpacing.posterWidth});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeleton(width: width, height: width * 1.5),
          const SizedBox(height: 10),
          Skeleton(width: width * 0.8, height: 12, radius: 6),
          const SizedBox(height: 6),
          Skeleton(width: width * 0.4, height: 10, radius: 5),
        ],
      ),
    );
  }
}
