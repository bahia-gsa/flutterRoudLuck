
import 'package:draw/forms/loging_with_google.dart';
import 'package:draw/login.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class Profile extends StatefulWidget {
  
  final Map<String, dynamic> data;
  final GoogleSignInAccount? currentUser;

  static const String routeName = "/profile";
  const Profile({Key? key, required this.data, this.currentUser}) : super(key: key);

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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  widget.currentUser?.photoUrl ?? 'https://www.draw.schaedler-almeida.space/assets/uknownPicture.png'
                ),
              ),
              const SizedBox(height: 50),
              Text(
                widget.data['name'],
                style: const TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 16),
              Text(
                widget.data['email'],
                style: const TextStyle(fontSize: 18, fontFamily: "Unbounded", color: Colors.white54),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  if (widget.currentUser != null) {
                    await LoginWithGoogle.disconnect();
                  }
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Icon(
                  Icons.power_settings_new,
                  color: Colors.pink,
                  size: 80,
                  ),
              ),
              Expanded(child: Container()), // Add this line to fill the available space
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Delete'),
                        content: const Text('Are you sure you want to delete your profile?'),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Delete'),
                            onPressed: () {
                              deleteProfile();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.person_off_outlined,
                      color: Colors.red,
                      size: 50.0,
                    ),
                    SizedBox(width: 10),
                    Text('Delete Profile',
                      style: TextStyle(fontFamily: "Unbounded", color: Colors.white),
                    ), 
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}