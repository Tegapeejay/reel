import 'package:flutter_test/flutter_test.dart';
import 'package:reel/core/config/tmdb_images.dart';
import 'package:reel/core/models/media_item.dart';
import 'package:reel/core/utils/format.dart';
import 'package:reel/features/detail/domain/media_detail.dart';

void main() {
  group('MediaItem.fromJson', () {
    test('parses a movie', () {
      final item = MediaItem.fromJson({
        'id': 438631,
        'media_type': 'movie',
        'title': 'Dune',
        'overview': 'Paul Atreides...',
        'poster_path': '/p.jpg',
        'backdrop_path': '/b.jpg',
        'vote_average': 7.8,
        'release_date': '2021-10-22',
      });
      expect(item.mediaType, MediaType.movie);
      expect(item.title, 'Dune');
      expect(item.year, '2021');
      expect(item.voteAverage, 7.8);
      expect(item.key, 'movie-438631');
    });

    test('parses a TV show using name / first_air_date', () {
      final item = MediaItem.fromJson({
        'id': 1,
        'media_type': 'tv',
        'name': 'Severance',
        'first_air_date': '2022-02-18',
        'vote_average': 8,
      });
      expect(item.mediaType, MediaType.tv);
      expect(item.title, 'Severance');
      expect(item.year, '2022');
      expect(item.voteAverage, 8.0);
    });

    test('uses fallbackType when media_type is absent', () {
      final item = MediaItem.fromJson({'id': 5, 'name': 'X'},
          fallbackType: MediaType.tv);
      expect(item.mediaType, MediaType.tv);
    });

    test('treats empty release date as missing', () {
      final item =
          MediaItem.fromJson({'id': 2, 'title': 'T', 'release_date': ''});
      expect(item.releaseDate, isNull);
      expect(item.year, isNull);
    });

    test('same TMDB id with different types are different items', () {
      const a = MediaItem(id: 1, mediaType: MediaType.movie, title: 'A');
      const b = MediaItem(id: 1, mediaType: MediaType.tv, title: 'B');
      expect(a == b, isFalse);
    });
  });

  test('listFromResponse can exclude people', () {
    final items = MediaItem.listFromResponse({
      'results': [
        {'id': 1, 'media_type': 'movie', 'title': 'A'},
        {'id': 2, 'media_type': 'person', 'name': 'B'},
      ],
    }, includePeople: false);
    expect(items.map((e) => e.id), [1]);
  });

  test('TmdbImages builds URLs and handles null', () {
    expect(TmdbImages.poster('/a.jpg'), 'https://image.tmdb.org/t/p/w342/a.jpg');
    expect(TmdbImages.backdrop('/b.jpg', size: 'w1280'),
        'https://image.tmdb.org/t/p/w1280/b.jpg');
    expect(TmdbImages.poster(null), isNull);
    expect(TmdbImages.poster(''), isNull);
  });

  test('formatDate and formatRuntime', () {
    expect(formatDate('2021-10-22'), 'Oct 22, 2021');
    expect(formatDate(null), isNull);
    expect(formatDate('garbage'), isNull);
    expect(formatRuntime(155), '2h 35m');
    expect(formatRuntime(60), '1h');
    expect(formatRuntime(45), '45m');
    expect(formatRuntime(0), isNull);
  });

  group('MediaDetail.fromJson', () {
    test('parses genres, runtime and picks the YouTube trailer', () {
      final d = MediaDetail.fromJson({
        'id': 1,
        'title': 'Dune',
        'overview': 'o',
        'tagline': '',
        'runtime': 155,
        'genres': [
          {'id': 1, 'name': 'Sci-Fi'},
          {'id': 2, 'name': 'Adventure'},
        ],
        'videos': {
          'results': [
            {'site': 'YouTube', 'type': 'Teaser', 'key': 'tease'},
            {'site': 'Vimeo', 'type': 'Trailer', 'key': 'vimeo'},
            {'site': 'YouTube', 'type': 'Trailer', 'key': 'trail'},
          ],
        },
      }, MediaType.movie);
      expect(d.genres, ['Sci-Fi', 'Adventure']);
      expect(d.runtime, 155);
      expect(d.tagline, isNull);
      expect(d.trailerKey, 'trail');
    });

    test('has no trailer when none is available', () {
      final d = MediaDetail.fromJson(
          {'id': 1, 'name': 'Show', 'videos': {'results': []}}, MediaType.tv);
      expect(d.trailerKey, isNull);
      expect(d.title, 'Show');
    });
  });
}
