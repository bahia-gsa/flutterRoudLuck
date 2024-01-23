import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddPlayerForm extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final Map<String, dynamic> game;
  final Function addPlayer;

  AddPlayerForm({required this.game, required this.addPlayer});

Future<void> addNewPlayer(String playerName, String playerEmail, int gameId) async {
  final newPlayer = {
    'playerName': playerName,
    'playerEmail': playerEmail,
    'game': {'id': gameId},
  };

  final response = await http.post(
    Uri.parse('https://quarkus-uexc3xgdlq-uc.a.run.app/api/players'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(newPlayer),
  );

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON.
    addPlayer(jsonDecode(response.body));
    print('Player added successfully ------------${response.body}');
  } else {
    // If the server returns an unexpected response, throw an error.
    throw Exception('Failed to add player');
  }
}

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 1, // 100% of screen width
        height: MediaQuery.of(context).size.height * 0.45, // 45% of screen height
        child: AlertDialog(
          title: Text('Add a new player'),
          content: Form(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  // Add validation and save logic
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  // Add validation and save logic
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                addNewPlayer(nameController.text, emailController.text, game['id']);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}