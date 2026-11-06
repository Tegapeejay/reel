import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reel/features/search/application/search_providers.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    container.listen(searchQueryProvider, (_, __) {});
  });
  tearDown(() => container.dispose());

  test('rapid typing only produces one debounced query', () async {
    final notifier = container.read(searchQueryProvider.notifier);
    notifier.onChanged('d');
    notifier.onChanged('du');
    notifier.onChanged('dune');
    expect(container.read(searchQueryProvider), '');

    await Future<void>.delayed(searchDebounce + const Duration(milliseconds: 150));
    expect(container.read(searchQueryProvider), 'dune');
  });

  test('clearing the input resets immediately', () async {
    final notifier = container.read(searchQueryProvider.notifier);
    notifier.submit('dune');
    expect(container.read(searchQueryProvider), 'dune');
    notifier.onChanged('');
    expect(container.read(searchQueryProvider), '');
  });

  test('recent searches are de-duplicated, newest first, capped', () {
    final recents = container.read(recentSearchesProvider.notifier);
    recents.add('dune');
    recents.add('Severance');
    recents.add('DUNE');
    expect(container.read(recentSearchesProvider), ['DUNE', 'Severance']);
    for (var i = 0; i < 12; i++) {
      recents.add('q$i');
    }
    expect(container.read(recentSearchesProvider).length,
        RecentSearchesNotifier.maxItems);
  });
}
