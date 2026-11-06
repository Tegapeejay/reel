import 'api_constants.dart';

/// Builds full TMDB image URLs from the relative paths the API returns.
abstract final class TmdbImages {
  static String? poster(String? path, {String size = 'w342'}) => _build(path, size);
  static String? backdrop(String? path, {String size = 'w780'}) => _build(path, size);
  static String? profile(String? path, {String size = 'w185'}) => _build(path, size);

  static String? _build(String? path, String size) {
    if (path == null || path.isEmpty) return null;
    return '${ApiConstants.imageBaseUrl}/$size$path';
  }
}
