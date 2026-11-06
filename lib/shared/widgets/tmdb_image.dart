import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Cached network image with a neutral placeholder and a graceful fallback.
class TmdbImage extends StatelessWidget {
  const TmdbImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.radius = 0,
    this.fallbackIcon = Icons.movie_outlined,
  });

  final String? url;
  final BoxFit fit;
  final double radius;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final fallback = ColoredBox(
      color: AppColors.surface,
      child: Center(
        child: Icon(fallbackIcon, color: AppColors.textSecondary, size: 28),
      ),
    );
    final image = url == null
        ? fallback
        : CachedNetworkImage(
            imageUrl: url!,
            fit: fit,
            fadeInDuration: const Duration(milliseconds: 200),
            placeholder: (context, _) =>
                const ColoredBox(color: AppColors.surface),
            errorWidget: (context, _, __) => fallback,
          );
    if (radius == 0) return image;
    return ClipRRect(borderRadius: BorderRadius.circular(radius), child: image);
  }
}
