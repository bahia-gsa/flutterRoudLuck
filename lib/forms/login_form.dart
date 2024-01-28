import 'dart:convert';
import 'dart:math';
import 'package:draw/forms/loging_with_google.dart';
import 'package:draw/login.dart';
import 'package:draw/pages/home_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:draw/forms/new_user_register_form.dart';
import 'package:draw/home.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginForm extends StatefulWidget  {

  final String initialEmail;

  const LoginForm({this.initialEmail = ''});

   @override
  _LoginFormState createState() => _LoginFormState();
}

Future<bool> fetchData(BuildContext context, String email, String password) async {

    final basicAuthEncoded = 'Basic ${base64Encode(utf8.encode('$email:$password'))}';
    final headerOptions = {
      'Content-Type': 'application/json',
      'Authorization': basicAuthEncoded,
    };

    final responseSpring = await http.post(
      Uri.parse('https://app-auth-uexc3xgdlq-uc.a.run.app/auth/profile/login'),
      headers: headerOptions,
      body: jsonEncode({}), 
    );

    if (responseSpring.statusCode == 200) {
      Logger().i("responseSpring: ${responseSpring.body}");
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
       /* Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(data: jsonResponseSpring),
          ),
        );*/
        return true;
      } else {
        Logger().e("Second request failed. Response status code: ${responseQuarkus.statusCode}");
        return false;
      }
    } else {
      Logger().e("First request failed. Response status code: ${responseSpring.statusCode}");
      if (responseSpring.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Center(
              child: Text('Invalid credentials. Please try again.',
                style: TextStyle(color: Colors.white, fontFamily: "Unbounded", fontSize: 12),),
            ),
          ),
        );
      }
      return false;
    }
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Future<bool>? loginFuture;

@override
void initState() {
  super.initState();
  emailController = TextEditingController(text: widget.initialEmail);
  _loginWithGoogle();
}

void _loginWithGoogle() {
  LoginWithGoogle.login().then((account) {
    if (account != null) {
      account.authentication.then((googleKey) {
        Logger().i("User is already signed in: $account");
        Logger().i("Google Key: ${googleKey.accessToken}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(currentUser: account, accessToken: googleKey.accessToken),
          ),
        );
      });
    } else {
      Logger().i("No user is currently signed in.");
    }
  }).catchError((error) {
    Logger().e("Error signing in: $error");
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Form'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<bool>(
          future: loginFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    style: TextStyle(fontFamily: 'Unbounded'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    style: TextStyle(fontFamily: 'Unbounded'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      String email = emailController.text;
                      String password = passwordController.text;

                      setState(() {
                        loginFuture = fetchData(context, email, password) as Future<bool>?;
                      });
                    },
                    child: Text('Login'),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('I am sorry!'),
                              content: const Text('This feature is not implemented yet, please try connection with Google.',
                                style: TextStyle(fontFamily: "Unbounded", fontSize: 13)
                                ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                     /* Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewUserRegisterForm(),
                        ),
                      );*/
                    },
                    child: const Text('New User'),
                  ),
                  const SizedBox(height: 20),
                  IconButton(
                    onPressed: () async {
                      LoginWithGoogle.signIn().then((value) => _loginWithGoogle());
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/sign_in_google.svg',
                      height: 50.0,
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}