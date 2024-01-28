
import 'package:draw/forms/loging_with_google.dart';
import 'package:draw/home.dart';
import 'package:draw/login.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class Profile extends StatefulWidget {
  
  final Map<String, dynamic> data;
  final GoogleSignInAccount currentUser;

  static const String routeName = "/profile";
  const Profile({Key? key, required this.data, required this.currentUser}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  Future<void> deleteProfile() async {
    int userId = widget.data['userId'];
    bool spring = await deleteUserFromSpring(userId);
    bool quarkus = await deleteUserFromQuarkus(userId);
    if (spring && quarkus) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
    }
  }

  Future<bool> deleteUserFromSpring(int userId) async {
    String token = widget.data['token'] ?? 'token not found';
    final headerOptions = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final responseSpring = await http.delete(
      Uri.parse('https://app-auth-uexc3xgdlq-uc.a.run.app/auth/profile/$userId'),
      headers: headerOptions,
      );
    if (responseSpring.statusCode == 200) {
      Logger().i("Profile deleted successfully");
      return true;
    } else {
      Logger().e("Request for deleting Profile failed with status: ${responseSpring.statusCode}.");
      return false;
    }
  }

    Future<bool> deleteUserFromQuarkus(int userId) async {
    String jwt = widget.data['jwt'] ?? 'token not found';
    final headerOptions = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwt'
    };
    final responseQuarkus = await http.delete(
      Uri.parse('https://quarkus-uexc3xgdlq-uc.a.run.app/api/games/user/$userId'),
      headers: headerOptions,
      );
    if (responseQuarkus.statusCode == 200) {
      Logger().i("Profile in Quarkus deleted!");
      return true;
    } else {
      Logger().e("Failed to delete profile in quarkus. Error: ${responseQuarkus.statusCode}");
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  widget.currentUser.photoUrl ?? 'https://www.draw.schaedler-almeida.space/assets/uknownPicture.png'
                ),
              ),
              SizedBox(height: 16),
              Text(
                widget.data['name'],
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 16),
              Text(
                widget.data['email'],
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await LoginWithGoogle.disconnect();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Login()), // replace Login() with your first page widget
                    (Route<dynamic> route) => false,
                  );
                },
                child: Text("Logout")
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirm Delete'),
                        content: Text('Are you sure you want to delete your profile?'),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Delete'),
                            onPressed: () {
                              deleteProfile();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Delete Profile'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // background
                  onPrimary: Colors.white, // foreground
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}