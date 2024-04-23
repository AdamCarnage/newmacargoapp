// ignore_for_file: unused_local_variable, avoid_print

import 'dart:convert';
import 'dart:core';
// import 'package:abooderp/models/company_data_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/company_model.dart';
import '../models/user_model.dart';
import 'package:enquiry/app_const.dart';

class UserAuth {
  static Future<dynamic> userLogin(loginKey, password) async {
    // print("===================\n username: $loginKey \n password: $password");
    String endpoint = "login";
    Uri uri = Uri.parse(AppConsts.baseUrl + endpoint);

    http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'App-Type': 'mobile',
      },
      body: jsonEncode(<String, String>{
        "username": loginKey.toString(),
        "password": password.toString(),
      }),
    );

    print(response.body);
    var error = json.encode({
      "status_code": response.statusCode.toString(),
      "error": "fail to login"
    });

    return response.statusCode != 200
        ? response.statusCode == 401
            ? jsonDecode(response.body)
            : jsonDecode(error.toString())
        : jsonDecode(response.body);
  }

  static Future<void> saveToken(token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  static Future<void> saveUserModel(UserModel userModel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(userModel.toJson());
    await prefs.setString("user", jsonString);
  }

  static Future<UserModel?> getUserModel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString("user");
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return UserModel.fromJson(jsonMap);
    }
    return null;
  }

  static Future<void> saveCompanyModel(CompanyModel company) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(company.toJson());
    await prefs.setString("company", jsonString);
  }

  static Future<CompanyModel?> getCompanyModel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString("company");
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return CompanyModel.fromJson(jsonMap);
    }
    return null;
  }

  // static Future<void> userLogOut(context) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   try {
  //     prefs.remove('token');
  //     prefs.remove('user');
  //     Navigator.of(context).popUntil(ModalRoute.withName('/login'));
  //   } catch (e) {
  //     print("===== Something Went wrong while logout User =====");
  //   }
  // }

  static authenticateUser(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('token') == null || prefs.getString('user') == null) {
      prefs.remove('token');
      prefs.remove('user');
      Navigator.of(context).popUntil(ModalRoute.withName('/login'));
    }
  }

  static Future<bool> isAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('token') != null && prefs.getString('userID') != null) {
      return true;
    } else {
      return false;
    }
  }

  static Future<Map<String, dynamic>> getAuthUser(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('token') != null && prefs.getString('userAuth') != null) {
      return {
        "token": prefs.getString("token"),
        "id": prefs.getString("guid"),
      };
    } else {
      prefs.remove('guid');
      prefs.remove('userAuth');
      prefs.remove('token');
      prefs.remove('tempPass');
      Navigator.of(context).popUntil(ModalRoute.withName('/login'));
      return {
        "token": null,
        "id": null,
      };
    }
  }

  static Future<String?> getDeviceToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission();
    String? deviceToken = await messaging.getToken();
    print("=================TOKEN RESULT======================");
    print(deviceToken);
    return deviceToken;
  }

  static Future<void> saveDefaultFontSize(int size) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('defaultFontSize', size);
  }

  static Future<int?> getDefaultFontSize() async {
    final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    final SharedPreferences pref = await prefs;
    return pref.getInt('defaultFontSize');
  }

  static double useFontSize(double textPercent, int storedFontSize) {
    // return 20;
    return storedFontSize * (textPercent / 100);
  }

  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_token', userData['api_token']);
    await prefs.setString('id', userData['id']);
    await prefs.setString('username', userData['username']);
    await prefs.setString('email', userData['email']);
  }

  static Future<String?> getApiToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('api_token');
  }

  static Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('id');
  }

  static Future<void> userLogOut(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      prefs.remove('api_token');
      prefs.remove('id');
      Navigator.of(context).popUntil(ModalRoute.withName('/login'));
    } catch (e) {
      print("===== Something Went wrong while logout User =====");
    }
  }
}
