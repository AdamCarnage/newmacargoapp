import 'package:shared_preferences/shared_preferences.dart';

class Pref {
  static setPref(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getPref(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(key);

    return data;
  }

  Future<dynamic> removePref(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }
}
