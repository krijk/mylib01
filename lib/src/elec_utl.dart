import 'dart:math' as math;

/// E series: International Standard: IEC 60063
enum ESeries {
  /// E3 series (20% tolerance)
  e3(<double>[1.0, 2.2, 4.7]),

  /// E6 series (10% tolerance)
  e6(<double>[1.0, 1.5, 2.2, 3.3, 4.7, 6.8]),

  /// E12 series (5% tolerance)
  e12(<double>[1.0, 1.2, 1.5, 1.8, 2.2, 2.7, 3.3, 3.9, 4.7, 5.6, 6.8, 8.2]),

  /// E24 series (2% tolerance)
  e24(<double>[
    1.0, 1.1, 1.2, 1.3, 1.5, 1.6, 1.8, 2.0, 2.2, 2.4, 2.7, 3.0,
    3.3, 3.6, 3.9, 4.3, 4.7, 5.1, 5.6, 6.2, 6.8, 7.5, 8.2, 9.1,
  ]);

  /// The values associated with this E series.
  final List<double> seriesValues;
  const ESeries(this.seriesValues);
}

/// Electrical Circuit Utilities
abstract class ElecUtl {
  ElecUtl._();

  /// Returns the value in the E series that is closest to the specified value.
  static double getNearestE(double val, ESeries series) {
    if (val <= 0) return 0;

    final double exponent = (math.log(val) / math.ln10).floorToDouble();
    final double mantissa = val / math.pow(10, exponent);

    final List<double> targets = series.seriesValues;
    double minDiff = double.infinity;
    double closestMantissa = targets[0];

    for (final double e in targets) {
      final double diff = (e - mantissa).abs();
      if (diff < minDiff) {
        minDiff = diff;
        closestMantissa = e;
      }
    }

    // Check if wrap-around to the next decade (10.0) is closer
    if ((10.0 - mantissa).abs() < minDiff) {
      return math.pow(10, exponent + 1).toDouble();
    }

    return closestMantissa * math.pow(10, exponent);
  }

  /// Converts resistance values to the 3-digit notation used for chip resistors
  /// (e.g., 103 = 10 kΩ) The base unit is Ω.
  static String getResistorCode(double ohms) => _toThreeDigitCode(ohms);

  /// Converts capacitor values to three-digit notation (e.g., 104 = 0.1 μF)
  /// The base unit is pF (10^-12)
  static String getCapacitorCode(double farads) => _toThreeDigitCode(farads * 1e12);

  /// An internal function that converts a number into a 3-digit code consisting of the “top two digits + a multiplier”
  /// (e.g., 103 = 10 kΩ 104 = 0.1 μF)
  static String _toThreeDigitCode(double baseValue) {
    if (baseValue <= 0) return '0';

    // For values less than 10, use 'R' as decimal point (e.g., 4.7 -> 4R7, 1.0 -> 1)
    if (baseValue < 10) {
      return baseValue
          .toStringAsFixed(1)
          .replaceFirst('.', 'R')
          .replaceFirst(RegExp(r'R0$'), '');
    }

    int exponent = (math.log(baseValue) / math.ln10).floor() - 1;
    int digits = (baseValue / math.pow(10, exponent)).round();

    // Handle rounding up to 100 (e.g., 99.6 -> 100 -> 10^1)
    if (digits >= 100) {
      digits = digits ~/ 10;
      exponent += 1;
    }

    if (exponent < 0) {
      return baseValue
          .toStringAsFixed(1)
          .replaceFirst('.', 'R')
          .replaceFirst(RegExp(r'R0$'), '');
    }
    return '$digits$exponent';
  }

  static const Map<String, double> _prefixMultipliers = <String, double>{
    'T': 1e12,
    'G': 1e9,
    'M': 1e6,
    'k': 1e3,
    'm': 1e-3,
    'u': 1e-6,
    'μ': 1e-6,
    'n': 1e-9,
    'p': 1e-12,
  };

  static const List<(String, double)> _prefixes = <(String, double)>[
    ('T', 1e12),
    ('G', 1e9),
    ('M', 1e6),
    ('k', 1e3),
    ('', 1.0),
    ('m', 1e-3),
    ('μ', 1e-6),
    ('n', 1e-9),
    ('p', 1e-12),
  ];

  /// Converts numbers into easy-to-read strings using SI prefixes (k, M, m, u, n, p).
  static String formatWithUnit(double value, String unitSymbol) {
    if (value == 0) return '0 $unitSymbol';

    final double absValue = value.abs();

    String selectedPrefix = '';
    double multiplier = 1.0;

    for (final (String, double) p in _prefixes) {
      if (absValue >= p.$2) {
        selectedPrefix = p.$1;
        multiplier = p.$2;
        break;
      }
    }

    // Fallback for extremely small values (still use 'p' if below 1p)
    if (selectedPrefix.isEmpty && multiplier == 1.0 && absValue < 1e-12) {
      selectedPrefix = 'p';
      multiplier = 1e-12;
    }

    final double displayVal = value / multiplier;
    // Format to max 2 decimal places and remove trailing zeros/dot
    final String s = displayVal
        .toStringAsFixed(2)
        .replaceFirst(RegExp(r'\.?0+$'), '');

    return '$s $selectedPrefix$unitSymbol'.trim();
  }

  /// Determines the multiplier from units with prefixes (such as kΩ, uF) and converts the value to the base unit.
  static double valueFrom(double value, String unitWithPrefix) {
    if (unitWithPrefix.isEmpty) return value;

    final String firstChar = unitWithPrefix.substring(0, 1);
    final double? multiplier = _prefixMultipliers[firstChar];

    return value * (multiplier ?? 1.0);
  }
}

/// Extensions for easier access to [ElecUtl] methods.
extension ElecUtlExtension on double {
  /// Formats the number with SI prefixes and the given [unitSymbol].
  String formatWithUnit(String unitSymbol) =>
      ElecUtl.formatWithUnit(this, unitSymbol);

  /// Returns the value in the E series that is closest to this value.
  double toNearestE(ESeries series) => ElecUtl.getNearestE(this, series);

  /// Converts the value to a 3-digit resistor code.
  String get resistorCode => ElecUtl.getResistorCode(this);

  /// Converts the value to a 3-digit capacitor code (base unit: Farads).
  String get capacitorCode => ElecUtl.getCapacitorCode(this);
}
