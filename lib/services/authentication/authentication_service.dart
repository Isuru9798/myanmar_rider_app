import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';
import '../../models/login_model/login_model.dart';

import '../../models/user_model/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../util/error_handler.dart';
import '../../util/util.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
//  signup user
  Future<void> signUpUser({
    required BuildContext context,
    required UserModel user,
    required LoginModel login,
  }) async {
    try {
      final _data = <String, dynamic>{};
      _data["user"] = user;
      _data["login"] = login;

      http.Response res = await http.post(
          Uri.parse('${Config.BACKEND_URL}/authentication/register'),
          body: jsonEncode(_data),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      ErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, jsonDecode(res.body)['message']);
          // Navigator.of(context).pushNamed(OtpScreen.routeName);
        },
      );
      if (jsonDecode(res.body)['status']) {
        Navigator.of(context).pushNamed(LoginScreen.routeName);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('${Config.BACKEND_URL}/authentication/login'),
        body: jsonEncode({
          "login_email": email,
          "login_password": password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      ErrorHandler(
        response: res,
        context: context,
        onSuccess: () async {
          if (jsonDecode(res.body)["status"]) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            //set token and user ids
            String user_token = jsonDecode(res.body)["token"];
            String user_id = jsonDecode(res.body)["data"]["_id"];
            await prefs.setString("token", user_token);
            await prefs.setString("user_id", user_id);

            Provider.of<AuthProvider>(context, listen: true).token;

            Navigator.of(context).pushNamedAndRemoveUntil(
              HomeScreen.routeName,
              (Route<dynamic> route) => false,
            );
          }
          showSnackBar(context, jsonDecode(res.body)['message']);
          // Navigator.of(context).pushNamed(LoginScreen.routeName);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void getTokenVerify(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      if (token == null) {
        prefs.setString("token", "");
      }
      var res = await http.post(
        Uri.parse('${Config.BACKEND_URL}/authentication/token-verify'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token!
        },
      );
      if (jsonDecode(res.body)["status"]) {
        String _token = jsonDecode(res.body)["token"];
        String _uid = jsonDecode(res.body)["user_id"];
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
