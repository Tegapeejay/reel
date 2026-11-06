import '../../../core/api/tmdb_api_service.dart';
import '../../../core/models/media_item.dart';

class SearchRepository {
  SearchRepository(this._api);

  final TmdbApiService _api;

  /// GET /search/multi?query={query} — movies, TV shows and people.
  Future<List<MediaItem>> search(String query) async {
    final json = await _api.get(
      '/search/multi',
      query: {'query': query, 'include_adult': false},
    );
    return MediaItem.listFromResponse(json);
  }
}
