import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {

  static String userLoggedInKey = "USERLOGGEDINKEY";

  static saveUserLoggedIn({@required bool isLoggedIn}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(userLoggedInKey, isLoggedIn);
  }

  static Future<bool> getUserLoggedIn() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(userLoggedInKey);
  }

}