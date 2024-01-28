
import 'package:draw/authentication/authentication_in_server.dart';
import 'package:draw/home.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class HomePage extends StatefulWidget {

  final GoogleSignInAccount currentUser;
  final String? accessToken;

  const HomePage({Key? key, required this.currentUser, required this.accessToken}): super(key: key);


  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  Future<Map<String, dynamic>>? _authenticationFuture;


@override
  void initState() {
     _authenticationFuture = AuthenticationInServer.authenticateInServers(widget.accessToken ?? '', widget.currentUser?.displayName ?? '');
    super.initState();
  }


 @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _authenticationFuture,
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home(data: snapshot.data!, currentUser: widget.currentUser)),
              );
            });
            return Scaffold();
          }
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }


}

