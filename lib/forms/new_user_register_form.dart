import 'dart:async';
import 'dart:convert';
import 'package:draw/login.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class NewUserRegisterForm extends StatefulWidget {

  @override
  _NewUserRegisterFormState createState() => _NewUserRegisterFormState();
}

class _NewUserRegisterFormState extends State<NewUserRegisterForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Future<bool>? registerFuture;

    Future<Map<String, dynamic>?> registerUser(String name, String email, String password) async {
    final Uri registerUrl = Uri.parse('https://app-auth-uexc3xgdlq-uc.a.run.app/auth/profile/register');

    final response = await http.post(
      registerUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      print('Registration successful! Response data: ${response.body}');
      return jsonDecode(response.body);
    } else {
      print('Registration failed. Response status code: ${response.statusCode}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Form'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<bool>(
          future: registerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.length < 2) {
                          return 'Name must be at least 2 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.length < 8 || !value.contains(RegExp(r'\d')) || !value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                          return 'at least 8 characters, include a special and a number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        String name = nameController.text;
                        String email = emailController.text;
                        String password = passwordController.text;

                        if (Form.of(context)!.validate()) {
                          Map<String, dynamic>? userData = await registerUser(name, email, password);
                          if (userData != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginForm(initialEmail: userData['email']),
                              ),
                            );
                          }
                        }
                      },
                      child: Text('Register'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}