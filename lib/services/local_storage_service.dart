import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class LocalStorageService {
  static LocalStorageService? _instance;
  static SharedPreferences? _preferences;

  static Future<LocalStorageService> getInstance() async {
    _instance ??= LocalStorageService();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  Future<T?> getData<T>(String key) async {
    try {
      final value = _preferences?.getString(key);
      if (value == null) return null;
      return jsonDecode(value) as T;
    } catch (e) {
      debugPrint('Error getting data for key $key: $e');
      return null;
    }
  }

  Future<bool> setData(String key, dynamic value) async {
    try {
      final jsonString = jsonEncode(value);
      return await _preferences?.setString(key, jsonString) ?? false;
    } catch (e) {
      debugPrint('Error setting data for key $key: $e');
      return false;
    }
  }

  Future<bool> removeData(String key) async {
    try {
      return await _preferences?.remove(key) ?? false;
    } catch (e) {
      debugPrint('Error removing data for key $key: $e');
      return false;
    }
  }

  Future<bool> clearAll() async {
    try {
      return await _preferences?.clear() ?? false;
    } catch (e) {
      debugPrint('Error clearing storage: $e');
      return false;
    }
  }
}
