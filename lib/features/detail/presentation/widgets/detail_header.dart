import 'package:flutter/material.dart';

import '../../../../core/config/tmdb_images.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/tmdb_image.dart';
import '../../domain/media_detail.dart';

/// Backdrop with the poster and title overlaid on its lower edge.
class DetailHeader extends StatelessWidget {
  const DetailHeader({super.key, required this.detail});

  final MediaDetail detail;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 380,
      child: Stack(
        children: [
          Positioned.fill(
            child: TmdbImage(
              url: TmdbImages.backdrop(detail.backdropPath, size: 'w1280'),
            ),
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.2, 0.75, 1],
                  colors: [
                    Colors.transparent,
                    Color(0xE6090B10),
                    AppColors.background,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.pagePadding,
            right: AppSpacing.pagePadding,
            bottom: 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 110,
                  height: 165,
                  child: TmdbImage(
                    url: TmdbImages.poster(detail.posterPath, size: 'w500'),
                    radius: AppSpacing.radiusMd,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(detail.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.headlineMedium),
                      if (detail.tagline != null) ...[
                        const SizedBox(height: 6),
                        Text(detail.tagline!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium
                                ?.copyWith(fontStyle: FontStyle.italic)),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
