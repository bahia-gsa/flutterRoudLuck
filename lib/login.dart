import 'dart:async';
import 'dart:convert';
import 'package:draw/forms/new_user_register_form.dart';
import 'package:draw/home.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class Login extends StatefulWidget {
  const Login({Key? key});

  @override
  State<Login> createState() => _MyAppState();
}

class _MyAppState extends State<Login> {

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginForm(),
                  ),
                );
              },
              child: SvgPicture.asset(
                'assets/icons/logo.svg',
                height: 250,
                width: 250,
                color: Colors.purple[300],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Let\'s get started !',
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}

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
      print('Login successful! Response data: ${responseSpring.body}');
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
        print("jsonResponseSpring: $jsonResponseSpring");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(data: jsonResponseSpring),
          ),
        );
        return true;
      } else {
        // unsuccessful second response here
        print('Second request failed. Response status code: ${responseQuarkus.statusCode}');
        return false;
      }
    } else {
      // Unsuccessful response handling here
      print('Login failed. Response status code: ${responseSpring.statusCode}');
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
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
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
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewUserRegisterForm(),
                        ),
                      );
                    },
                    child: Text('New User'),
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