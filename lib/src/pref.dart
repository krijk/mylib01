import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Preference control
class Pref {
  static SharedPreferences? _prefs;

  // For testing purposes
  @visibleForTesting
  static void setMockInstance(SharedPreferences mock) {
    _prefs = mock;
  }

  /// Initialize SharedPreferences instance.
  /// Call this method once at app startup.
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Helper to ensure _prefs is initialized
  static SharedPreferences get _instance {
    if (_prefs == null) {
      throw Exception("SharedPreferences not initialized. Call Pref.init() first.");
    }
    return _prefs!;
  }

  /// Is pref initialized?
  static Future<void> _initCheck() async {
    if (_prefs != null) {
      return;
    }
    await init();
  }

  /// Get preference bool
  static Future<bool> getBool(String key, {bool defaultVal = true}) async {
    await _initCheck();
    return _instance.getBool(key) ?? defaultVal;
  }

  /// Set preference bool
  static Future<void> setBool(String key, {bool value = false}) async {
    await _initCheck();
    await _instance.setBool(key, value);
  }

  /// Get preference int
  static Future<int> getInt(String key, int defaultVal) async {
    await _initCheck();
    return _instance.getInt(key) ?? defaultVal;
  }

  /// Set preference int
  static Future<void> setInt(String key, int val) async {
    await _initCheck();
    await _instance.setInt(key, val);
  }

  /// Get preference double
  static Future<double> getDouble(String key, double defaultVal) async {
    await _initCheck();
    return _instance.getDouble(key) ?? defaultVal;
  }

  /// Set preference double
  static Future<void> setDouble(String key, double val) async {
    await _initCheck();
    await _instance.setDouble(key, val);
  }

  /// Get preference string
  static Future<String> getString(String key, String defaultString) async {
    await _initCheck();
    return _instance.getString(key) ?? defaultString;
  }

  /// Set preference string
  static Future<void> setString(String key, String val) async {
    await _initCheck();
    await _instance.setString(key, val);
  }

  /// Reads a set of string values from persistent storage.
  static Future<List<String>> getStringList(String key, List<String>? defaultStrings) async {
    await _initCheck();
    return _instance.getStringList(key) ?? defaultStrings ?? <String>[];
  }

  /// Saves a list of strings value to persistent storage in the background.
  static Future<void> setStringList(String key, List<String>? defaultStrings) async {
    if (defaultStrings == null) {
      return;
    }
    await _initCheck();
    await _instance.setStringList(key, defaultStrings);
  }

  /// Get preference json map
  static Future<Map<String, dynamic>> getJson(String key, {Map<String, dynamic>? defaultVal}) async {
    await _initCheck();

    final String? str = _instance.getString(key);
    if (str == null) {
      return defaultVal ?? <String, dynamic>{};
    }
    try {
      final dynamic decoded = json.decode(str);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return defaultVal ?? <String, dynamic>{}; // Or log an error
    } catch (e) {
      // Log the error e.g., print('Error decoding JSON for key $key: $e');
      return defaultVal ?? <String, dynamic>{};
    }
  }

  /// Save preference json
  static Future<void> setJson(String key, Map<String, dynamic> value) async {
    await _initCheck();
    try {
      await _instance.setString(key, json.encode(value));
    } catch (e) {
      // Log the error e.g., print('Error encoding JSON for key $key: $e');
      // Optionally rethrow or handle as needed
    }
  }

  /// Delete preference of specified key
  static Future<void> deletePref(String key) async {
    await _initCheck();
    _instance.remove(key);
  }

  /// Reload and fetches the latest values from the host platform.
  static Future<void> reload() async {
    await _initCheck();
    await _instance.reload();
  }

  /// Clears all preferences.
  static Future<void> clearAll() async {
    await _initCheck();
    await _instance.clear();
  }
}
