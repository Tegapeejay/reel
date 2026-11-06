import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/models/media_item.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/format.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/rating_badge.dart';
import '../../../shared/widgets/skeleton.dart';
import '../../../shared/widgets/watchlist_button.dart';
import '../application/detail_providers.dart';
import '../domain/media_detail.dart';
import 'widgets/detail_header.dart';
import 'widgets/trailer_section.dart';

class DetailScreen extends ConsumerWidget {
  const DetailScreen({super.key, required this.mediaType, required this.id});

  final MediaType mediaType;
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = (mediaType, id);
    final detail = ref.watch(mediaDetailProvider(args));
    return Scaffold(
      body: Stack(
        children: [
          detail.when(
            loading: () => const _DetailSkeleton(),
            error: (e, _) => ErrorView(
              message: describeError(e),
              onRetry: () => ref.invalidate(mediaDetailProvider(args)),
            ),
            data: (d) => _DetailBody(detail: d),
          ),
          const Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: Padding(padding: EdgeInsets.all(8), child: _BackButton()),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      style: IconButton.styleFrom(backgroundColor: Colors.black.withAlpha(120)),
      icon: const Icon(Icons.arrow_back_rounded),
      onPressed: () =>
          context.canPop() ? context.pop() : context.go(AppRoutes.home),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.detail});

  final MediaDetail detail;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final date = formatDate(detail.releaseDate);
    final runtime = formatRuntime(detail.runtime);
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailHeader(detail: detail),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    RatingBadge(rating: detail.voteAverage),
                    if (date != null) Text(date, style: textTheme.bodyMedium),
                    if (runtime != null)
                      Text(runtime, style: textTheme.bodyMedium),
                    Text(detail.mediaType.label,
                        style: textTheme.bodyMedium
                            ?.copyWith(color: AppColors.secondary)),
                  ],
                ),
                if (detail.genres.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final g in detail.genres) _GenreChip(label: g),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: WatchlistButton(item: detail.toMediaItem()),
                ),
                const SizedBox(height: 24),
                Text('Overview', style: textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  detail.overview.isEmpty
                      ? 'No overview available yet.'
                      : detail.overview,
                  style: textTheme.bodyLarge
                      ?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 28),
                TrailerSection(trailerKey: detail.trailerKey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GenreChip extends StatelessWidget {
  const _GenreChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Skeleton(height: 380, radius: 0),
        Padding(
          padding: EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Skeleton(width: 180, height: 18, radius: 6),
              SizedBox(height: 16),
              Skeleton(height: 52),
              SizedBox(height: 24),
              Skeleton(height: 14, radius: 6),
              SizedBox(height: 8),
              Skeleton(height: 14, radius: 6),
              SizedBox(height: 8),
              Skeleton(width: 240, height: 14, radius: 6),
            ],
          ),
        ),
      ],
    );
  }
}
