import 'package:flutter/material.dart';

import '../../../../core/config/tmdb_images.dart';
import '../../../../core/models/media_item.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/rating_badge.dart';
import '../../../../shared/widgets/tmdb_image.dart';

class SearchResultTile extends StatelessWidget {
  const SearchResultTile({super.key, required this.item, required this.onTap});

  final MediaItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isPerson = item.mediaType == MediaType.person;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 56,
              height: 84,
              child: TmdbImage(
                url: isPerson
                    ? TmdbImages.profile(item.profilePath)
                    : TmdbImages.poster(item.posterPath, size: 'w185'),
                radius: AppSpacing.radiusSm,
                fallbackIcon:
                    isPerson ? Icons.person_outline_rounded : Icons.movie_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _TypeBadge(type: item.mediaType),
                      if (item.year != null)
                        Text(item.year!, style: textTheme.bodySmall),
                      if (item.voteAverage > 0)
                        RatingBadge(rating: item.voteAverage, compact: true),
                    ],
                  ),
                  if (!isPerson && item.overview.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(item.overview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final MediaType type;

  @override
  Widget build(BuildContext context) {
    final color = switch (type) {
      MediaType.movie => AppColors.primary,
      MediaType.tv => AppColors.secondary,
      MediaType.person => AppColors.star,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(40),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        type.label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}
