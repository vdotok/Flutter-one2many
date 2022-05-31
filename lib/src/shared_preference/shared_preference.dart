import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPref {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);

    return data;
  }

  Future<bool> save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, json.encode(value));
  }

  readInteger(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getInt(key) ?? 0;
    print("this is data in shared $data");
    return data;
  }

  Future<bool> saveInteger(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(key, value);
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  readbool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getBool(key);

    return data;
  }
   Future<bool> savebool(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(key,value);
  }

}
