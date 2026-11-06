import '../../../core/models/media_item.dart';

/// Storage contract for the watchlist. Phase 1 uses memory only; a SQLite
/// implementation can replace [InMemoryWatchlistRepository] without touching
/// the notifier or any UI.
abstract interface class WatchlistRepository {
  Future<List<MediaItem>> loadAll();
  Future<void> saveAll(List<MediaItem> items);
}

class InMemoryWatchlistRepository implements WatchlistRepository {
  List<MediaItem> _items = const [];

  @override
  Future<List<MediaItem>> loadAll() async => _items;

  @override
  Future<void> saveAll(List<MediaItem> items) async {
    _items = List.unmodifiable(items);
  }
}
