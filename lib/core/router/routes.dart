import '../models/media_item.dart';

abstract final class AppRoutes {
  static const String home = '/';
  static const String search = '/search';
  static const String watchlist = '/watchlist';
  static const String profile = '/profile';
  static const String detailsPattern = '/details/:type/:id';

  static String details(MediaType type, int id) => '/details/${type.name}/$id';
  static String detailsFor(MediaItem item) => details(item.mediaType, item.id);
}
