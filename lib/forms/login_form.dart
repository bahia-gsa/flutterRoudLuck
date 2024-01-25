import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:draw/forms/new_user_register_form.dart';
import 'package:draw/home.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(data: jsonResponseSpring),
          ),
        );
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewUserRegisterForm(),
                        ),
                      );
                    },
                    child: const Text('New User'),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}