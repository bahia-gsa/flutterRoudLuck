import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewGameForm extends StatelessWidget {

  final TextEditingController nameController = TextEditingController();
  final Map<String, dynamic> data;
  final Function(Map<String, dynamic>) onNewGameAdded;

  NewGameForm({super.key, required this.data, required this.onNewGameAdded});

  Future<Map<String, dynamic>> addNewPlayer() async {
  String gameName = nameController.text;
  String userId = data['userId'].toString();

  Map<String, String> newGame = {
    'gameName': gameName,
    'userId': userId,
  };

  String jwt = data['jwt'] ?? 'jwt not found';
  final headerOptions = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $jwt'
  };

  final response = await http.post(
    Uri.parse('https://quarkus-uexc3xgdlq-uc.a.run.app/api/games'),
    headers: headerOptions,
    body: jsonEncode(newGame),
  );

  if (response.statusCode == 200) {
    print('Game added successfully ------------${response.body}');
    return jsonDecode(response.body);
  } else {
    print('Request failed with status: ${response.statusCode}.');
    throw Exception('Failed to add game');
  }
}


 @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 1, // 100% of screen width
        height: MediaQuery.of(context).size.height * 0.45, // 45% of screen height
        child: AlertDialog(
          title: Text('New Game'),
          content: Form(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
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
              onPressed: () async {
                Map<String, dynamic> newGame = await addNewPlayer();
                onNewGameAdded(newGame);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

