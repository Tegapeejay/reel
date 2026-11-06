import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reel/core/models/media_item.dart';
import 'package:reel/shared/widgets/empty_state.dart';
import 'package:reel/shared/widgets/poster_card.dart';

void main() {
  testWidgets('PosterCard shows details and toggles the watchlist',
      (tester) async {
    const item = MediaItem(
      id: 1,
      mediaType: MediaType.movie,
      title: 'Dune',
      releaseDate: '2021-10-22',
      voteAverage: 8.0,
    );

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Center(child: PosterCard(item: item, width: 130)),
          ),
        ),
      ),
    );

    expect(find.text('Dune'), findsOneWidget);
    expect(find.text('2021'), findsOneWidget);
    expect(find.text('8.0'), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_border_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.bookmark_border_rounded));
    await tester.pump();

    expect(find.byIcon(Icons.bookmark_rounded), findsOneWidget);
    expect(find.textContaining('Added "Dune"'), findsOneWidget);
  });

  testWidgets('EmptyState renders title, message and action', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmptyState(
            icon: Icons.bookmark_border_rounded,
            title: 'Your watchlist is empty',
            message: 'Save something.',
            actionLabel: 'Discover',
            onAction: () => tapped = true,
          ),
        ),
      ),
    );
    expect(find.text('Your watchlist is empty'), findsOneWidget);
    await tester.tap(find.text('Discover'));
    expect(tapped, isTrue);
  });
}
