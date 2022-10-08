/// String extension
extension StringExtension on String {
  /// capitalize
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

const int _japaneseFullLengthCode = 65248;

/// handling Japanese characters
extension JapaneseString on String {
  /// Convert alphanumeric to full length characters
  String alphanumericToFullLength() {
    final RegExp regex = RegExp(r'^[a-zA-Z0-9]+$');
    final Iterable<String> string = runes.map<String>((int rune) {
      final String char = String.fromCharCode(rune);
      return regex.hasMatch(char) ? String.fromCharCode(rune + _japaneseFullLengthCode) : char;
    });
    return string.join();
  }

  /// Convert full length to alphanumeric characters
  String alphanumericToHalfLength() {
    final RegExp regex = RegExp(r'^[Ａ-Ｚａ-ｚ０-９]+$');
    final Iterable<String> string = runes.map<String>((int rune) {
      final String char = String.fromCharCode(rune);
      return regex.hasMatch(char) ? String.fromCharCode(rune - _japaneseFullLengthCode) : char;
    });
    return string.join();
  }
}
