import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

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
    Logger().i("Game added successfully ------------${response.body}");
    return jsonDecode(response.body);
  } else {
    Logger().e("Failed to add game. Response status code: ${response.statusCode}");
    throw Exception('Failed to add game');
  }
}


 @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 1, 
        height: MediaQuery.of(context).size.height * 0.40,
        child: AlertDialog(
          title: Text('New Game'),
          content: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  style: TextStyle(fontFamily: 'Unbounded'),
                  validator: (value) {
                    if (value == null || value.length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
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

