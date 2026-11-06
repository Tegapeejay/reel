import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/tmdb_images.dart';
import '../../core/models/media_item.dart';
import '../../core/router/routes.dart';
import '../../core/theme/app_spacing.dart';
import 'rating_badge.dart';
import 'tmdb_image.dart';
import 'watchlist_icon_button.dart';

/// Poster + title + year, with a rating badge and watchlist toggle overlaid.
/// Pass [width] for horizontal rows; leave null to fill a grid cell.
class PosterCard extends ConsumerWidget {
  const PosterCard({super.key, required this.item, this.width});

  final MediaItem item;
  final double? width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final card = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push(AppRoutes.detailsFor(item)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2 / 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                TmdbImage(
                  url: TmdbImages.poster(item.posterPath),
                  radius: AppSpacing.radiusMd,
                ),
                Positioned(
                  left: 6,
                  bottom: 6,
                  child: RatingBadge(rating: item.voteAverage, compact: true),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: WatchlistIconButton(item: item),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleSmall),
          const SizedBox(height: 2),
          Text(item.year ?? 'TBA', style: textTheme.bodySmall),
        ],
      ),
    );
    return width == null ? card : SizedBox(width: width, child: card);
  }
}
