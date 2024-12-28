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

  /// A 32 bit value representing this color.
  ///
  /// The bits are assigned as follows:
  ///
  /// * Bits 24-31 are the alpha value.
  /// * Bits 16-23 are the red value.
  /// * Bits 8-15 are the green value.
  /// * Bits 0-7 are the blue value.
  // @Deprecated('Use component accessors like .r or .g.')
  int getValue(){
    return _floatToInt8(a) << 24 |
    _floatToInt8(r) << 16 |
    _floatToInt8(g) << 8 |
    _floatToInt8(b) << 0;
  }

  static int _floatToInt8(double x) {
    return (x * 255.0).round() & 0xff;
  }
}
