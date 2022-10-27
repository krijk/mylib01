import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';

import 'package:mylib01/lib.dart';

void main() {
  test('round int at the place', () {
    final int ret1 = 44221.roundInt(2);
    expect(ret1, 44200);
    final int ret2 = 44251.roundInt(2);
    expect(ret2, 44300);
  });

  /// const double pi = 3.1415926535897932;
  test('round double at the place', () {
    const double value = math.pi;
    final double ret0 = value.roundDouble(0);
    expect(ret0, 3);
    final double ret1 = value.roundDouble(1);
    expect(ret1, 3.1);
    final double ret2 = value.roundDouble(2);
    expect(ret2, 3.14);
    final double ret3 = value.roundDouble(3);
    expect(ret3, 3.142);
  });

  test('Capitalize String', () {
    final String str1 = 'test'.capitalize();
    expect(str1, 'Test');
  });
}
