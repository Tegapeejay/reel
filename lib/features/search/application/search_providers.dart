import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/tmdb_api_service.dart';
import '../../../core/models/media_item.dart';
import '../data/search_repository.dart';

const Duration searchDebounce = Duration(milliseconds: 500);

final searchRepositoryProvider = Provider<SearchRepository>(
  (ref) => SearchRepository(ref.watch(tmdbApiProvider)),
);

/// Holds the *debounced* query. Call [onChanged] on every keystroke; the state
/// only updates once typing has paused for [searchDebounce].
class SearchQueryNotifier extends Notifier<String> {
  Timer? _timer;

  @override
  String build() {
    ref.onDispose(() => _timer?.cancel());
    return '';
  }

  void onChanged(String input) {
    _timer?.cancel();
    final query = input.trim();
    if (query.isEmpty) {
      state = '';
      return;
    }
    _timer = Timer(searchDebounce, () => state = query);
  }

  /// Skips the debounce (keyboard "search" action, tapping a recent search).
  void submit(String input) {
    _timer?.cancel();
    state = input.trim();
  }

  void clear() {
    _timer?.cancel();
    state = '';
  }
}

final searchQueryProvider =
    NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

final searchResultsProvider =
    FutureProvider.autoDispose<List<MediaItem>>((ref) {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return Future.value(const <MediaItem>[]);
  return ref.watch(searchRepositoryProvider).search(query);
});

class RecentSearchesNotifier extends Notifier<List<String>> {
  static const int maxItems = 8;

  @override
  List<String> build() => const [];

  void add(String query) {
    final q = query.trim();
    if (q.isEmpty) return;
    final rest = state.where((s) => s.toLowerCase() != q.toLowerCase());
    state = [q, ...rest].take(maxItems).toList();
  }

  void clear() => state = const [];
}

final recentSearchesProvider =
    NotifierProvider<RecentSearchesNotifier, List<String>>(
        RecentSearchesNotifier.new);
