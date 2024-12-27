import 'dart:ui';

/// Color extensions
extension ColorExtension on Color {
  /// Convert Color RGB to string
  String toHex({bool hashSign = false, bool withAlpha = false}) {
    final String alpha = (a * 255).toInt().toRadixString(16).padLeft(2, '0');
    final String red = (r * 255).toInt().toRadixString(16).padLeft(2, '0');
    final String green = (g * 255).toInt().toRadixString(16).padLeft(2, '0');
    final String blue = (b * 255).toInt().toRadixString(16).padLeft(2, '0');

    return '${hashSign ? '#' : ''}'
            '${withAlpha ? alpha : ''}'
            '$red$green$blue'
        .toUpperCase();
  }

  /// Invert it
  Color invert() {
    final int base = 0xff;
    return Color.fromARGB(
      (base * a).toInt(),
      (base * (1 - r)).toInt(),
      (base * (1 - g)).toInt(),
      (base * (1 - b)).toInt(),
    );
  }
}
