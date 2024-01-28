import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class AuthenticationInServer {

  static Future<Map<String, dynamic>> authenticateInServers(String eaccessTokenmail, String name) async {
    final headerOptions = {
      'Content-Type': 'application/json'
    };
     Map<String, String> userLoggedWithGoogle = {
        'accessToken': eaccessTokenmail,
        'name': name,
      };
    final responseSpring = await http.post(
      Uri.parse('https://app-auth-uexc3xgdlq-uc.a.run.app/auth/profile/login-with-google-mobile'),
      headers: headerOptions,
      body: jsonEncode(userLoggedWithGoogle), 
    );

    if (responseSpring.statusCode == 200) {
      Map<String, dynamic> jsonResponseSpring = jsonDecode(responseSpring.body);
      String token = jsonResponseSpring['token'] as String;
      String userEmail = jsonResponseSpring['email'] as String;

      Map<String, String> userLogged = {
        'token': token,
        'email': userEmail,
      };
      final responseQuarkus = await http.post(
        Uri.parse('https://quarkus-uexc3xgdlq-uc.a.run.app/api/auth/authenticate'),
        headers: headerOptions,
        body: jsonEncode(userLogged), 
      );

      if (responseQuarkus.statusCode == 200) {
        String jwt = responseQuarkus.body;

        jsonResponseSpring['jwt'] = jwt;
        Logger().i("jsonResponseSpring: $jsonResponseSpring");
        return jsonResponseSpring;
      }else{
        Logger().e("responseSpring: ${responseSpring.statusCode}");
        return {};
      }
    }else{
      Logger().e("responseSpring: ${responseSpring.statusCode}");
      return {};
    }
  }
}
