import '../../../core/api/tmdb_api_service.dart';
import '../../../core/models/media_item.dart';
import '../domain/discover_section.dart';

class DiscoverRepository {
  DiscoverRepository(this._api);

  final TmdbApiService _api;

  Future<List<MediaItem>> fetchSection(
      DiscoverSection section, MediaType mode) async {
    final json = await _api.get(section.pathFor(mode));
    return MediaItem.listFromResponse(
      json,
      fallbackType: mode,
      includePeople: false,
    );
  }
}
