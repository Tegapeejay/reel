import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_exception.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/poster_card.dart';
import '../../../../shared/widgets/section_heading.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../application/discover_providers.dart';
import '../../domain/discover_section.dart';

/// A titled horizontal row of poster cards backed by one TMDB endpoint.
class MediaSection extends ConsumerWidget {
  const MediaSection({super.key, required this.section});

  final DiscoverSection section;

  static const double _rowHeight = 270;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(mediaModeProvider);
    final items = ref.watch(discoverSectionProvider(section));
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeading(title: section.titleFor(mode)),
          const SizedBox(height: 12),
          SizedBox(
            height: _rowHeight,
            child: items.when(
              loading: () => ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.pagePadding),
                itemCount: 6,
                separatorBuilder: (context, _) => const SizedBox(width: 12),
                itemBuilder: (context, _) => const PosterCardSkeleton(),
              ),
              error: (e, _) => ErrorView(
                compact: true,
                message: describeError(e),
                onRetry: () => ref.invalidate(discoverSectionProvider(section)),
              ),
              data: (list) => list.isEmpty
                  ? Center(
                      child: Text('Nothing to show right now.',
                          style: Theme.of(context).textTheme.bodyMedium),
                    )
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.pagePadding),
                      itemCount: list.length,
                      separatorBuilder: (context, _) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, i) => PosterCard(
                        item: list[i],
                        width: AppSpacing.posterWidth,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
