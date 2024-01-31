import 'package:draw/login.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class TokenService {
    bool isTokenValidity(String expiresIn){
    if (DateTime.parse(expiresIn).isBefore(DateTime.now())) {
      Logger().i("Token is expired");
      return false;
    }
    Logger().i("Token is valid");
    return true; 
  }

void returnToInitialPage(BuildContext context){
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    duration: Duration(seconds: 4),
    content: Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: const Text(
        'Session expired. Please log in again.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.red,
          fontFamily: "Unbounded",
          fontSize: 13,
          fontWeight: FontWeight.normal,
        ),
      ),
    ),
  ),
);
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const Login()),
    (Route<dynamic> route) => false,
  );
  }
}