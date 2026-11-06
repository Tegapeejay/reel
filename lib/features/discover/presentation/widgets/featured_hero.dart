import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/api_exception.dart';
import '../../../../core/config/tmdb_images.dart';
import '../../../../core/models/media_item.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/rating_badge.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../../shared/widgets/tmdb_image.dart';
import '../../../../shared/widgets/watchlist_button.dart';
import '../../application/discover_providers.dart';

double _heroHeight(BuildContext context) =>
    (MediaQuery.sizeOf(context).height * 0.5).clamp(380.0, 520.0).toDouble();

class FeaturedHero extends ConsumerWidget {
  const FeaturedHero({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featured = ref.watch(featuredProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      child: featured.when(
        loading: () => Skeleton(
            height: _heroHeight(context), radius: AppSpacing.radiusXl),
        error: (e, _) => SizedBox(
          height: 200,
          child: ErrorView(
            message: describeError(e),
            onRetry: () => ref.invalidate(discoverSectionProvider),
          ),
        ),
        data: (item) =>
            item == null ? const SizedBox.shrink() : _HeroCard(item: item),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.item});

  final MediaItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      child: SizedBox(
        height: _heroHeight(context),
        child: Stack(
          fit: StackFit.expand,
          children: [
            TmdbImage(url: TmdbImages.backdrop(item.backdropPath, size: 'w1280')),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.25, 0.7, 1],
                  colors: [
                    Colors.transparent,
                    Color(0xCC090B10),
                    AppColors.background,
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withAlpha(40),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'FEATURED · ${item.mediaType.label.toUpperCase()}',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      RatingBadge(rating: item.voteAverage),
                      if (item.voteAverage > 0) const SizedBox(width: 10),
                      Text(item.year ?? 'TBA', style: textTheme.bodyMedium),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(item.overview,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'View Details',
                          icon: Icons.play_arrow_rounded,
                          onPressed: () =>
                              context.push(AppRoutes.detailsFor(item)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: WatchlistButton(item: item, compact: true)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
