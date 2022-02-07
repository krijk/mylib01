/// String extension
extension StringExtension on String {
  /// capitalize
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
