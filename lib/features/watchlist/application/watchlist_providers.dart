import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/media_item.dart';
import '../data/watchlist_repository.dart';

final watchlistRepositoryProvider = Provider<WatchlistRepository>(
  (ref) => InMemoryWatchlistRepository(),
);

/// Shared watchlist state (newest first, no duplicates).
final watchlistProvider =
    NotifierProvider<WatchlistNotifier, List<MediaItem>>(WatchlistNotifier.new);

/// Whether the item with the given [MediaItem.key] is saved.
final isWatchlistedProvider = Provider.family<bool, String>((ref, key) {
  return ref.watch(watchlistProvider.select((l) => l.any((m) => m.key == key)));
});

class WatchlistNotifier extends Notifier<List<MediaItem>> {
  @override
  List<MediaItem> build() => const [];

  bool contains(MediaItem item) => state.any((m) => m.key == item.key);

  /// Returns false (and changes nothing) if the item is already saved.
  bool add(MediaItem item) {
    if (contains(item)) return false;
    state = [item, ...state];
    _persist();
    return true;
  }

  void remove(MediaItem item) {
    state = state.where((m) => m.key != item.key).toList();
    _persist();
  }

  /// Adds or removes. Returns true if the item is now in the watchlist.
  bool toggle(MediaItem item) {
    if (contains(item)) {
      remove(item);
      return false;
    }
    return add(item);
  }

  void _persist() {
    ref.read(watchlistRepositoryProvider).saveAll(state);
  }
}
