import 'package:shared_preferences/shared_preferences.dart';

/// Platform-specific persistent storage for simple data
class StorageHelper {
  static final StorageHelper _instance = StorageHelper._internal();
  static late SharedPreferencesAsync _asyncPrefs;

  factory StorageHelper() {
    return _instance;
  }

  StorageHelper._internal();

  Future<void> init() async {
    _asyncPrefs = SharedPreferencesAsync();
  }

  Future<void> setInt(String key, int value) async {
    await _asyncPrefs.setInt(key, value);
  }

  Future<void> setDouble(String key, double value) async {
    await _asyncPrefs.setDouble(key, value);
  }

  Future<void> setBool(String key, bool value) async {
    await _asyncPrefs.setBool(key, value);
  }

  Future<void> setString(String key, String value) async {
    await _asyncPrefs.setString(key, value);
  }

  Future<void> setStringList(String key, List<String> value) async {
    await _asyncPrefs.setStringList(key, value);
  }

  Future<int?> getInt(String key) async => await _asyncPrefs.getInt(key);
  Future<double?> getDouble(String key) async => await _asyncPrefs.getDouble(key);
  Future<bool?> getBool(String key) async => await _asyncPrefs.getBool(key);
  Future<String?> getString(String key) async => await _asyncPrefs.getString(key);
  Future<List<String>?> getStringList(String key) async => await _asyncPrefs.getStringList(key);

  Future<void> remove(String key) async {
    return await _asyncPrefs.remove(key);
  }

  Future<void> clear(Set<String> allowList) async {
    await _asyncPrefs.clear(allowList: allowList);
  }

}