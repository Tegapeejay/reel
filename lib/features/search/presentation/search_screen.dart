import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/models/media_item.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/section_heading.dart';
import '../../../shared/widgets/skeleton.dart';
import '../../discover/domain/discover_section.dart';
import '../../discover/presentation/widgets/media_section.dart';
import '../application/search_providers.dart';
import 'widgets/search_result_tile.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _applyRecent(String query) {
    _controller.text = query;
    _controller.selection = TextSelection.collapsed(offset: query.length);
    ref.read(searchQueryProvider.notifier).submit(query);
  }

  void _open(MediaItem item) {
    ref.read(recentSearchesProvider.notifier).add(ref.read(searchQueryProvider));
    if (item.mediaType == MediaType.person) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(
            content: Text('Person profiles are coming in a later milestone.')));
      return;
    }
    context.push(AppRoutes.detailsFor(item));
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pagePadding, 16, AppSpacing.pagePadding, 12),
              child: Text('Search',
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pagePadding),
              child: _SearchField(
                controller: _controller,
                onChanged: ref.read(searchQueryProvider.notifier).onChanged,
                onSubmitted: (value) {
                  ref.read(searchQueryProvider.notifier).submit(value);
                  ref.read(recentSearchesProvider.notifier).add(value);
                },
                onClear: () {
                  _controller.clear();
                  ref.read(searchQueryProvider.notifier).clear();
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: query.isEmpty
                  ? _IdleContent(onRecentTap: _applyRecent)
                  : _Results(onTap: _open),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        hintText: 'Search movies, TV shows, actors...',
        prefixIcon:
            const Icon(Icons.search_rounded, color: AppColors.textSecondary),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) => value.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  tooltip: 'Clear',
                  onPressed: onClear,
                  icon: const Icon(Icons.close_rounded),
                ),
        ),
      ),
    );
  }
}

class _IdleContent extends ConsumerWidget {
  const _IdleContent({required this.onRecentTap});

  final ValueChanged<String> onRecentTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recent = ref.watch(recentSearchesProvider);
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        SectionHeading(
          title: 'Recent searches',
          actionLabel: recent.isEmpty ? null : 'Clear',
          onAction: () => ref.read(recentSearchesProvider.notifier).clear(),
        ),
        const SizedBox(height: 12),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
          child: recent.isEmpty
              ? Text('Your recent searches will appear here.',
                  style: Theme.of(context).textTheme.bodyMedium)
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final q in recent)
                      ActionChip(
                        avatar: const Icon(Icons.history_rounded, size: 18),
                        label: Text(q),
                        onPressed: () => onRecentTap(q),
                        backgroundColor: AppColors.surface,
                        side: BorderSide.none,
                      ),
                  ],
                ),
        ),
        const SizedBox(height: 28),
        const MediaSection(section: DiscoverSection.trending),
        const MediaSection(section: DiscoverSection.popular),
      ],
    );
  }
}

class _Results extends ConsumerWidget {
  const _Results({required this.onTap});

  final ValueChanged<MediaItem> onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(searchResultsProvider);
    return results.when(
      loading: () => ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
        itemCount: 5,
        separatorBuilder: (context, _) => const SizedBox(height: 12),
        itemBuilder: (context, _) =>
            const Skeleton(height: 104, radius: AppSpacing.radiusMd),
      ),
      error: (e, _) => ErrorView(
        message: describeError(e),
        onRetry: () => ref.invalidate(searchResultsProvider),
      ),
      data: (items) => items.isEmpty
          ? const EmptyState(
              icon: Icons.search_off_rounded,
              title: 'No results',
              message: 'Try a different title, show or actor name.',
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pagePadding, 0, AppSpacing.pagePadding, 24),
              itemCount: items.length,
              separatorBuilder: (context, _) => const SizedBox(height: 12),
              itemBuilder: (context, i) => SearchResultTile(
                item: items[i],
                onTap: () => onTap(items[i]),
              ),
            ),
    );
  }
}
