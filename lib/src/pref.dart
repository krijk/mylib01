import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Preference control
class Pref {
  /// Get preference bool
  static Future<bool> getBool(String key, {bool defaultVal = true}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool v = prefs.getBool(key) ?? defaultVal;
    return v;
  }

  /// Set preference bool
  static Future<void> setBool(String key, {bool value = false}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  /// Get preference int
  static Future<int> getInt(String key, int defaultVal) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int v = prefs.getInt(key) ?? defaultVal;
    return v;
  }

  /// Set preference int
  static Future<void> setInt(String key, int val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, val);
  }

  /// Get preference double
  static Future<double> getDouble(String key, double defaultVal) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final double v = prefs.getDouble(key) ?? defaultVal;
    return v;
  }

  /// Set preference double
  static Future<void> setDouble(String key, double val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, val);
  }

  /// Get preference string
  static Future<String> getString(String key, String defaultString) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String v = prefs.getString(key) ?? defaultString;
    return v;
  }

  /// Set preference string
  static Future<void> setString(String key, String val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, val);
    // await prefs.setString(key, val); // Need to be checked
  }

  /// Reads a set of string values from persistent storage.
  static Future<List<String?>> getStringList(String key, List<String>? defaultStrings) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String?> stringList = prefs.getStringList(key) ?? defaultStrings ?? <String>[];
    return stringList;
  }

  /// Saves a list of strings value to persistent storage in the background.
  static Future<void> setStringList(String key, List<String>? defaultStrings) async {
    if (defaultStrings == null) {
      return;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, defaultStrings);
  }

  /// Get preference json map
  static Future<Map<String, dynamic>> getJson(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? str = prefs.getString(key);
    if (str == null) {
      return <String, dynamic>{};
    }
    final Map<String, dynamic> ret = json.decode(str) as Map<String, dynamic>;
    return ret;
  }

  /// Save preference json
  static Future<void> setJson(String key, Map<String, dynamic> value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  /// Delete preference of specified key
  static Future<void> deletePref(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  /// Reload and fetches the latest values from the host platform.
  static Future<void> reload() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
  }
}
