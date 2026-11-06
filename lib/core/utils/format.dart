const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// "2021-10-22" -> "Oct 22, 2021". Returns null for missing / malformed input.
String? formatDate(String? iso) {
  if (iso == null) return null;
  final parts = iso.split('-');
  if (parts.length != 3) return null;
  final month = int.tryParse(parts[1]);
  final day = int.tryParse(parts[2]);
  if (month == null || day == null || month < 1 || month > 12) return null;
  return '${_months[month - 1]} $day, ${parts[0]}';
}

/// 135 -> "2h 15m".
String? formatRuntime(int? minutes) {
  if (minutes == null || minutes <= 0) return null;
  final h = minutes ~/ 60;
  final m = minutes % 60;
  if (h == 0) return '${m}m';
  return m == 0 ? '${h}h' : '${h}h ${m}m';
}
