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
  Status? _loggedInStatus = Status.Authenticating;
  Status? _registeredInStatus = Status.NotRegistered;

  Status? get loggedInStatus => _loggedInStatus;
  Status? get registeredInStatus => _registeredInStatus;

  User? _user = new User();
  User get getUser => _user!;
  String? _completeAddress;
  String get completeAddress => _completeAddress!;
  SharedPref _sharedPref = SharedPref();

  String? _loginErrorMsg;
  String get loginErrorMsg => _loginErrorMsg!;

  String? _registerErrorMsg;
  String get registerErrorMsg => _registerErrorMsg!;
  String? _host;
  String get host => _host!;

  String? _port;
  String get port => _port!;
  String? deviceid;
  String? get getDeviceid => deviceid;

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
        deviceid = androidInfo.id;
        print('this is device id ${deviceid}');
        // Android 9 (SDK 28), Xiaomi Redmi Note 7
      }

      if (Platform.isIOS) {
        var iosInfo = await DeviceInfoPlugin().iosInfo;
        version = iosInfo.systemName;
        model = iosInfo.model;
        deviceid = iosInfo.identifierForVendor.toString();
        print('this is device id ${deviceid}');
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
      "project_id": project_id
    };

    final response = await callAPI(jsonData, "SignUp", null);
    print("this is response $response");
    if (response['status'] != 200) {
      _registeredInStatus = Status.Failure;
      _registerErrorMsg = response['message'];
      notifyListeners();
      return false;
    } else {
      _completeAddress = response['media_server_map']['complete_address'];

      _host = response["messaging_server_map"]["host"];
      _port = response["messaging_server_map"]["port"];
      SharedPref sharedPref = SharedPref();
      sharedPref.save("authUser", response);
      sharedPref.save('deviceid', deviceid.toString());
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
      "project_id": project_id
    };

    final response = await callAPI(jsonData, "Login", null);
    print("this is response of login api $response");
    if (response['status'] != 200) {
      _loggedInStatus = Status.Failure;
      _loginErrorMsg = response['message'];
      notifyListeners();
    } else {
      _completeAddress = response['media_server_map']['complete_address'];

      _host = response["messaging_server_map"]["host"];
      _port = response["messaging_server_map"]["port"];
      SharedPref sharedPref = SharedPref();
      sharedPref.save("authUser", response);
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
    _loggedInStatus = Status.LoggedOut;
    _user = null;
    notifyListeners();
  }

  isUserLogedIn() async {
    final authUser = await _sharedPref.read("authUser");
    final devid = await _sharedPref.read('deviceid');
    print("this is authUser $authUser");
    if (authUser == null) {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
    } else {
      _completeAddress =
          jsonDecode(authUser)['media_server_map']['complete_address'];
      _host = jsonDecode(authUser)["messaging_server_map"]["host"];
      _port = jsonDecode(authUser)["messaging_server_map"]["port"];
      print('if this is device is ${devid}');
      deviceid = jsonDecode(devid.toString());
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
