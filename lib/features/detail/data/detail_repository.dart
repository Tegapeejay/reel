import '../../../core/api/tmdb_api_service.dart';
import '../../../core/models/media_item.dart';
import '../domain/media_detail.dart';

class DetailRepository {
  DetailRepository(this._api);

  final TmdbApiService _api;

  /// GET /movie/{id} or /tv/{id}, with trailers in the same request.
  Future<MediaDetail> fetchDetail(MediaType type, int id) async {
    final segment = type == MediaType.tv ? 'tv' : 'movie';
    final json = await _api.get(
      '/$segment/$id',
      query: {'append_to_response': 'videos'},
    );
    return MediaDetail.fromJson(
        json, type == MediaType.tv ? MediaType.tv : MediaType.movie);
  }
}
