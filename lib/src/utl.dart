import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// Date format YYYY/MM
final DateFormat dtFormatMonth = DateFormat('yyyy/MM');

/// Platforms
// ignore: camel_case_types
enum kPlatform {
  ///
  android,

  ///
  fuchsia,

  ///
  ios,

  ///
  linux,

  ///
  macos,

  ///
  windows,
}

/// My utilities
class Utl {
  /// Get a random int value
  static int randomInt({int min = 0, int max = 99}) {
    assert(min < max);
    return min + math.Random().nextInt(max - min);
  }

  /// Get a random bool value
  static bool randomBool() {
    return math.Random().nextBool();
  }

  /// Get the name of the caller method
  static String getMethodName({int? level, StackTrace? stackTrace}) {
    String nameClass = 'unknown';
    String nameMethod = 'unknown';

    final int level1 = level ?? 0;

    StackTrace? st = stackTrace;
    int idxFrame = level1;
    if (st == null) {
      st = StackTrace.current;
      idxFrame = 1 + level1;
    }
    final List<StackFrame> currentFrames = StackFrame.fromStackTrace(st);

    if (currentFrames.length >= idxFrame) {
      final String line1 = currentFrames[idxFrame].toString();

      const String key0 = 'method: ';
      final int idx0 = line1.indexOf(key0) + key0.length;
      if (idx0 > 0) {
        nameMethod = line1.substring(idx0, line1.length - 1);
      }

      const String key1 = 'className: ';
      final int idx1 = line1.indexOf(key1) + key1.length;
      if (idx1 > 0) {
        const String key2 = ',';
        final int idx2 = line1.indexOf(key2, idx1) + key2.length;
        if (idx2 > 0) {
          nameClass = line1.substring(idx1, idx2 - 1);
        }
      }
    }
    return '[$nameClass.$nameMethod]';
  }

  /// Convert integer to hex string
  static String hexString(int val) {
    const int padding = 2;

    int iVal = val;
    if (val < 0) {
      iVal = val.abs();
    }

    final String sVal = iVal.toRadixString(16).toUpperCase().padLeft(padding, '0');
    if (val < 0) {
      return '-0x$sVal';
    }
    return '0x$sVal';
  }

  /// Check what is the current platform
  static bool isPlatform(kPlatform platform) {
    switch (platform) {
      case kPlatform.android:
        return Platform.isAndroid;
      case kPlatform.fuchsia:
        return Platform.isFuchsia;
      case kPlatform.ios:
        return Platform.isIOS;
      case kPlatform.linux:
        return Platform.isLinux;
      case kPlatform.macos:
        return Platform.isMacOS;
      case kPlatform.windows:
        return Platform.isWindows;
    }
  }

  /// Get operating system name
  static String getOperatingSystem() {
    return Platform.operatingSystem;
  }

  /// Get operating system version
  static String getOperatingSystemVersion() {
    return Platform.operatingSystemVersion;
  }

  /// Get the number of processors
  static int getNumOfProcessors() {
    return Platform.numberOfProcessors;
  }

  /// Convert double to string and format the number of digits of decimals
  static String formatDoubleNum(double number, {int numDecimal = 0}) {
    return number.toStringAsFixed(numDecimal);
  }

  /// Returns the number of days between two dates.
  static int daysBetween(DateTime from, DateTime to) {
    return to.difference(from).inDays;
  }

  /// Convert time string to millisecond
  /// time format 00:04:21.58X
  static int getTimeInMilli(String time, {String format = 'HH:mm:ss.SSS'}) {
    const bool utc = true;
    final DateTime dt = DateFormat(format).parse(time, utc);
    final int msec = dt.millisecondsSinceEpoch;
    return msec;
  }

  /// Convert degree to radian
  static double degreeToRadian(double degree) => degree * math.pi / 180;

  /// Convert radian to degree
  static double radianToDegree(double radian) => radian * 180 / math.pi;

  /// Checks if a folder exists at the given path.
  static Future<bool> isFolderExists(String path) => Directory(path).exists();

  /// Truncate a string to a specified length or shorter
  static String truncate(String text, int maxLength) {
    return (text.length <= maxLength) ? text : text.substring(0, maxLength);
  }
}

/// Titled
mixin Titled {
  /// title
  String _title = 'empty';

  /// set title
  set title(String s) {
    _title = s;
  }

  /// get title
  String getTitle() {
    return _title;
  }
}

/// A utility to sequentially calculate a running average.
class AverageCalculator {
  int _count = 0;
  num _sum = 0;

  /// Returns the current average.
  double get average => _count == 0 ? 0 : _sum / _count;

  /// Adds a value and returns the updated average.
  double add(num val) {
    _sum += val;
    _count++;
    return average;
  }

  @override
  String toString() => average.toString();
}
