import 'package:draw/animation/subtitle_animation.dart';
import 'package:draw/animation/title_animation.dart';
import 'package:draw/forms/login_form.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 60.0),
                    child: const titleAnimation(title: "Round Luck"),
                  ),
                  const SizedBox(height: 50),
                  const subtitleAnimation(),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginForm(),
                          //builder: (context) => const SignInDemo(),
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
                      color: Colors.white54,
                      fontSize: 20,
                      fontFamily: 'Unbounded',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(1.0),
                child: Text(
                  '© SCHAEDLER-ALMEIDA',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontFamily: 'Unbounded',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
