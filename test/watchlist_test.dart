import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reel/core/models/media_item.dart';
import 'package:reel/features/watchlist/application/watchlist_providers.dart';

void main() {
  const movie = MediaItem(id: 1, mediaType: MediaType.movie, title: 'Movie');
  const show = MediaItem(id: 1, mediaType: MediaType.tv, title: 'Show');

  late ProviderContainer container;
  late WatchlistNotifier notifier;

  setUp(() {
    container = ProviderContainer();
    notifier = container.read(watchlistProvider.notifier);
  });
  tearDown(() => container.dispose());

  test('starts empty', () {
    expect(container.read(watchlistProvider), isEmpty);
  });

  test('adds an item and rejects duplicates', () {
    expect(notifier.add(movie), isTrue);
    expect(notifier.add(movie), isFalse);
    expect(container.read(watchlistProvider), [movie]);
  });

  test('movie and TV show with the same id are both allowed', () {
    notifier.add(movie);
    notifier.add(show);
    expect(container.read(watchlistProvider).length, 2);
  });

  test('toggle adds then removes', () {
    expect(notifier.toggle(movie), isTrue);
    expect(container.read(isWatchlistedProvider(movie.key)), isTrue);
    expect(notifier.toggle(movie), isFalse);
    expect(container.read(isWatchlistedProvider(movie.key)), isFalse);
  });

  test('newest item is first', () {
    notifier.add(movie);
    notifier.add(show);
    expect(container.read(watchlistProvider).first, show);
  });
}
