import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

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
    addPlayer(jsonDecode(response.body));
    Logger().i("Player added successfully ------------${response.body}");
  } else {
    Logger().e("Failed to add player. Response status code: ${response.statusCode}");
    throw Exception('Failed to add player');
  }
}

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 0.60,
        child: AlertDialog(
          title: Center(child: Text('Add a player')),
          content: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  style: const TextStyle(fontFamily: 'Unbounded'),
                  validator: (value) {
                    if (value == null || value.length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  style: const TextStyle(fontFamily: 'Unbounded'),
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
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