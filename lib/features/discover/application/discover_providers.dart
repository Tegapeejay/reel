import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/tmdb_api_service.dart';
import '../../../core/models/media_item.dart';
import '../data/discover_repository.dart';
import '../domain/discover_section.dart';

/// Movies / TV Shows toggle on the Discover screen.
final mediaModeProvider = StateProvider<MediaType>((ref) => MediaType.movie);

final discoverRepositoryProvider = Provider<DiscoverRepository>(
  (ref) => DiscoverRepository(ref.watch(tmdbApiProvider)),
);

final discoverSectionProvider =
    FutureProvider.family<List<MediaItem>, DiscoverSection>((ref, section) {
  final mode = ref.watch(mediaModeProvider);
  return ref.watch(discoverRepositoryProvider).fetchSection(section, mode);
});

/// First trending title that has a backdrop and an overview.
final featuredProvider = FutureProvider<MediaItem?>((ref) async {
  final items =
      await ref.watch(discoverSectionProvider(DiscoverSection.trending).future);
  for (final item in items) {
    if (item.backdropPath != null && item.overview.isNotEmpty) return item;
  }
  return null;
});
