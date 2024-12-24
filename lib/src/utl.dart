import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';

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
    return min + Random().nextInt(max - min);
  }

  /// Get a random bool value
  static bool randomBool() {
    final int val = randomInt();
    if (val % 2 == 0) {
      return true;
    }
    return false;
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
