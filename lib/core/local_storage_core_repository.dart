import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageDb {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences? prefs;

  Future getLocalStringDb(String key) async {
    prefs = await _prefs;
    return prefs!.getString(key);
  }

  Future setLocalStringDb(String key, value) async {
    prefs = await _prefs;
    prefs!.setString(key, value);
  }

  Future getLocalListDb(String key) async {
    prefs = await _prefs;
    return prefs!.getStringList(key);
  }

  Future setLocalListDb(String key, value) async {
    prefs = await _prefs;
    prefs!.setString(key, value);
  }

  Future removeKey(String key) async {
    prefs = await _prefs;
    prefs!.remove(key);
  }
}
