import 'package:flutter_test/flutter_test.dart';
import 'package:mylib01/lib.dart';

void main() {
  group('ElecUtl.getNearestE', () {
    test('E3 series rounding', () {
      expect(ElecUtl.getNearestE(1.0, ESeries.e3), 1.0);
      expect(ElecUtl.getNearestE(1.5, ESeries.e3), 1.0); // 1.0 is closer than 2.2
      expect(ElecUtl.getNearestE(2.0, ESeries.e3), 2.2);
      expect(ElecUtl.getNearestE(3.3, ESeries.e3), 2.2); // 2.2 is closer than 4.7
      expect(ElecUtl.getNearestE(4.0, ESeries.e3), 4.7);
    });

    test('E24 series rounding across decades', () {
      expect(ElecUtl.getNearestE(9.5, ESeries.e24), 9.1);
      expect(ElecUtl.getNearestE(9.8, ESeries.e24), 10.0);
      expect(ElecUtl.getNearestE(910, ESeries.e24), 910.0);
    });

    test('Handling zero or negative', () {
      expect(ElecUtl.getNearestE(0, ESeries.e12), 0);
      expect(ElecUtl.getNearestE(-10, ESeries.e12), 0);
    });
  });

  group('Resistor/Capacitor Codes', () {
    test('Resistor codes (3-digit notation)', () {
      expect(ElecUtl.getResistorCode(10), '100'); // 10 * 10^0
      expect(ElecUtl.getResistorCode(100), '101'); // 10 * 10^1
      expect(ElecUtl.getResistorCode(1000), '102'); // 10 * 10^2
      expect(ElecUtl.getResistorCode(47000), '473'); // 47 * 10^3
      expect(ElecUtl.getResistorCode(4.7), '4R7');
      expect(ElecUtl.getResistorCode(1.0), '1');
      expect(0.22.resistorCode, '0R2');
    });

    test('Capacitor codes (Base unit: Farads, Output: pF-based notation)', () {
      expect(ElecUtl.getCapacitorCode(100e-12), '101'); // 100 pF -> 10 * 10^1
      expect(ElecUtl.getCapacitorCode(1e-6), '105'); // 1 uF = 1,000,000 pF -> 10 * 10^5
      expect(ElecUtl.getCapacitorCode(0.1e-6), '104'); // 0.1 uF = 100,000 pF -> 10 * 10^4
      expect((47e-12).capacitorCode, '470'); // 47 pF -> 47 * 10^0
    });
  });

  group('ElecUtl.formatWithUnit', () {
    test('SI Prefix formatting', () {
      expect(ElecUtl.formatWithUnit(1000, 'Ω'), '1 kΩ');
      expect(ElecUtl.formatWithUnit(0.001, 'V'), '1 mV');
      expect(ElecUtl.formatWithUnit(0.000001, 'F'), '1 μF');
      expect(1234567.0.formatWithUnit('Hz'), '1.23 MHz');
      expect(0.000000000001.formatWithUnit('F'), '1 pF');
    });

    test('Edge cases', () {
      expect(ElecUtl.formatWithUnit(0, 'A'), '0 A');
      expect(ElecUtl.formatWithUnit(-4700, 'Ω'), '-4.7 kΩ');
    });
  });

  group('ElecUtl.valueFrom', () {
    test('Calculating base values from prefixed units', () {
      expect(ElecUtl.valueFrom(10, 'kΩ'), 10000);
      expect(ElecUtl.valueFrom(0.1, 'uF'), 1e-7);
      expect(ElecUtl.valueFrom(470, 'pF'), 470e-12);
      expect(ElecUtl.valueFrom(5, 'V'), 5);
    });
  });
}
