/// String extension
extension StringExtension on String {
  /// capitalize
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

// https://zenn.dev/clay/articles/39208e1f8d442c
// The only relationship between full-width and half-width is to add or subtract 65248
const int _diffHanZen = 65248;

/// handling Japanese characters
extension JapaneseString on String {
  /// Convert alphanumeric to full length characters
  String alphanumericToFullWidth() {
    final RegExp regex = RegExp(r'^[a-zA-Z0-9]+$');
    final Iterable<String> string = runes.map<String>((int rune) {
      final String char = String.fromCharCode(rune);
      return regex.hasMatch(char) ? String.fromCharCode(rune + _diffHanZen) : char;
    });
    return string.join();
  }

  /// Convert numbers and alphabets to half-width characters
  String alphanumericToHalfWidth() {
    final RegExp regex = RegExp(r'^[Ａ-Ｚａ-ｚ０-９]+$');
    final Iterable<String> string = runes.map<String>((int rune) {
      final String char = String.fromCharCode(rune);
      return regex.hasMatch(char) ? String.fromCharCode(rune - _diffHanZen) : char;
    });
    return string.join();
  }
}
