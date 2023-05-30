import 'dart:async';
import 'dart:convert';
import 'dart:io';
// import 'package:device_info/device_info.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_one2many/src/core/config/config.dart';
import '../models/user.dart';
import '../services/server.dart';
import '../../shared_preference/shared_preference.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  LoggedOut,
  Failure,
  Loading
}

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.Authenticating;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;

  User? _user = new User();
  User? get getUser => _user;
  String? _completeAddress;
  String? get completeAddress => _completeAddress;
  String? _deviceId;
  String? get deviceId => _deviceId;
  SharedPref _sharedPref = SharedPref();

  String? _loginErrorMsg;
  String? get loginErrorMsg => _loginErrorMsg;

  String? _registerErrorMsg;
  String? get registerErrorMsg => _registerErrorMsg;
  String? _host;
  String? get host => _host;

  String? _port;
  String? get port => _port;

  Future<bool> register(String username, password, email) async {
    _registeredInStatus = Status.Loading;
    notifyListeners();

    var version;
    var model;

    if (kIsWeb) {
      version = "web";
      model = "web";
    } else {
      if (Platform.isAndroid) {
        var androidInfo = await DeviceInfoPlugin().androidInfo;
        version = androidInfo.version.release;
        model = androidInfo.model;
        // Android 9 (SDK 28), Xiaomi Redmi Note 7
      }

      if (Platform.isIOS) {
        var iosInfo = await DeviceInfoPlugin().iosInfo;
        version = iosInfo.systemName;
        model = iosInfo.model;
        // iOS 13.1, iPhone 11 Pro Max iPhone
      }
    }
    Map<String, dynamic> jsonData = {
      "full_name": username,
      "password": password,
      "email": email,
      "device_type": kIsWeb
          ? "web"
          : Platform.isAndroid
              ? "android"
              : "ios",
      "device_model": model,
      "device_os_ver": version,
      "app_version": "1.1.5",
      "project_id": projectId
    };

    final response = await callAPI(jsonData, "SignUp", null);
    print("this is response $response");
    if (response['status'] != 200) {
      _registeredInStatus = Status.Failure;
      _registerErrorMsg = response['message'];
      notifyListeners();
      return false;
    } else {
      final now = DateTime.now();
      _deviceId = now.microsecondsSinceEpoch.toString();
      _completeAddress = response['media_server_map']['complete_address'];

      _host = response["messaging_server_map"]["host"];
      _port = response["messaging_server_map"]["port"];
      SharedPref sharedPref = SharedPref();
      sharedPref.save("authUser", response);
      sharedPref.save("deviceId", _deviceId);
      _registeredInStatus = Status.Registered;
      _loggedInStatus = Status.LoggedIn;
      _user = User.fromJson(response);
      notifyListeners();
      return true;
    }
  }

  login(String email, password) async {
    _loggedInStatus = Status.Loading;
    notifyListeners();

    Map<String, dynamic> jsonData = {
      "email": email,
      "password": password,
      "project_id": projectId
    };

    final response = await callAPI(jsonData, "Login", null);
    print("this is response of login api $response");
    if (response['status'] != 200) {
      _loggedInStatus = Status.Failure;
      _loginErrorMsg = response['message'];
      notifyListeners();
    } else {
      final now = DateTime.now();
      _deviceId = now.microsecondsSinceEpoch.toString();

      _completeAddress = response['media_server_map']['complete_address'];
      print("this is iddddddd $_deviceId");
      _host = response["messaging_server_map"]["host"];
      _port = response["messaging_server_map"]["port"];
      SharedPref sharedPref = SharedPref();
      sharedPref.save("authUser", response);
      sharedPref.save("deviceId", _deviceId);
      _loggedInStatus = Status.LoggedIn;

      print("THIS IS COMPLETE ADRESS $_completeAddress");
      _user = User.fromJson(response);
      notifyListeners();
    }
  }

  logout() {
    SharedPref sharedPref = SharedPref();
    sharedPref.remove("authUser");
    sharedPref.remove("URL");
    sharedPref.remove("deviceId");
    _loggedInStatus = Status.LoggedOut;
    _user = null;
    notifyListeners();
  }

  isUserLogedIn() async {
    final authUser = await _sharedPref.read("authUser");
    final deviceId = await _sharedPref.read("deviceId");
    print("this is authUser $authUser");
    if (authUser == null) {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
    } else {
      _completeAddress =
          jsonDecode(authUser)['media_server_map']['complete_address'];
      _host = jsonDecode(authUser)["messaging_server_map"]["host"];
      _port = jsonDecode(authUser)["messaging_server_map"]["port"];
      _deviceId = deviceId;
      _loggedInStatus = Status.LoggedIn;
      _user = User.fromJson(jsonDecode(authUser));
      notifyListeners();
    }
  }

  static onError(error) {
    print("the error is $error.detail");
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }
}
