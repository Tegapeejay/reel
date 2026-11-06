import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/media_item.dart';
import '../../../core/theme/app_colors.dart';
import '../application/discover_providers.dart';
import '../domain/discover_section.dart';
import 'widgets/discover_header.dart';
import 'widgets/featured_hero.dart';
import 'widgets/media_section.dart';

class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        onRefresh: () async {
          ref.invalidate(discoverSectionProvider);
          await ref
              .read(discoverSectionProvider(DiscoverSection.trending).future)
              .catchError((_) => <MediaItem>[]);
        },
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            const DiscoverHeader(),
            const FeaturedHero(),
            const SizedBox(height: 28),
            for (final section in DiscoverSection.values)
              MediaSection(section: section),
          ],
        ),
      ),
    );
  }
}
