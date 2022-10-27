import 'dart:math' as math;

/// Integer extension
extension IntegerExtension on int {
  /// Round integer value at a certain place
  int roundInt(int place) {
    final num mod = math.pow(10.0, place);
    return ((this / mod).round() * mod).toInt();
  }
}

/// Double extension
extension DoubleExtension on double {
  /// Round double value at a certain place
  double roundDouble(int place) {
    final num mod = math.pow(10.0, place);
    return (this * mod).round().toDouble() / mod;
  }
}
