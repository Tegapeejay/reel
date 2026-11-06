import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/poster_card.dart';
import '../application/watchlist_providers.dart';

class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(watchlistProvider);
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pagePadding, 16, AppSpacing.pagePadding, 4),
              child: Text('Watchlist', style: textTheme.headlineMedium),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pagePadding),
              child: Text(
                items.isEmpty
                    ? 'Nothing saved yet'
                    : '${items.length} saved ${items.length == 1 ? 'title' : 'titles'}',
                style: textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: items.isEmpty
                  ? EmptyState(
                      icon: Icons.bookmark_border_rounded,
                      title: 'Your watchlist is empty',
                      message:
                          'Tap the bookmark on any title to save it here for later.',
                      actionLabel: 'Discover titles',
                      onAction: () => context.go(AppRoutes.home),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(
                          AppSpacing.pagePadding, 0, AppSpacing.pagePadding, 24),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 170,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.5,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, i) => PosterCard(item: items[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
