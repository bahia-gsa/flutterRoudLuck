import 'dart:convert';

import 'package:draw/forms/new_game_from.dart';
import 'package:draw/game.dart';
import 'package:draw/profile.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
final Map<String, dynamic> data;

  static const String routeName = "/home";
  const Home({Key? key, required this.data}) : super(key: key);
  

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
    List<Map<String, dynamic>> gamesByUser = [];

  
  @override
  void initState() {
    super.initState();
    String userId = widget.data['userId'].toString();
    getGamesByUser(userId);
  }

  Future<void> getGamesByUser(String userId) async {
    // prevents unnecessary API calls 
    if(gamesByUser.isNotEmpty) {
      return;
    }
    // Replace with your API endpoint
    String jwt = widget.data['jwt'] ?? 'jwt not found';
    final headerOptions = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwt'
    };
    final response = await http.get(
      Uri.parse('https://quarkus-uexc3xgdlq-uc.a.run.app/api/games/user/$userId'),
      headers: headerOptions,
      );

    if (response.statusCode == 200) {
      print('GAMES---: ${response.body}');
      setState(() {
        gamesByUser = List<Map<String, dynamic>>.from(jsonDecode(response.body));

      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw Exception('Failed to load data');
    }
  }

  Future<void> deleteGame(int gameId) async {
  String jwt = widget.data['jwt'] ?? 'jwt not found';
  final headerOptions = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $jwt'
  };
  final response = await http.delete(
    Uri.parse('https://quarkus-uexc3xgdlq-uc.a.run.app/api/games/$gameId'),
    headers: headerOptions,
  );

  if (response.statusCode == 200) {
    print('Game deleted successfully');
  } else {
    print('Request failed with status: ${response.statusCode}.');
    throw Exception('Failed to delete game');
  }
}

  @override
  Widget build(BuildContext context) {
    String name = widget.data['name'] ?? 'Welcome';
    String jwt = widget.data['jwt'] ?? 'jwt not found';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(name,
        style: TextStyle(
          color: Colors.white,
        ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ListView.builder(
          itemCount: gamesByUser.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                title: ElevatedButton(
                  child: Text(gamesByUser[index]['gameName'], style: TextStyle(fontSize: 20)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Game(
                          game: gamesByUser[index],
                          data: widget.data,
                        ),
                      ),
                    );
                  },
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete,
                  color: Colors.red,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Delete Game'),
                          content: Text('Are you sure you want to delete this game?'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('OK'),
                              onPressed: () async {
                                await deleteGame(gamesByUser[index]['id']);
                                setState(() {
                                  gamesByUser.removeAt(index);
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(data: widget.data),
                  ),
                );
              },
              child: Icon(Icons.person),
              heroTag: 'ProfileButton',
            ),
            const SizedBox(height: 30),
            FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return NewGameForm(
                      data: widget.data,
                      onNewGameAdded: (newGame) {
                        setState(() {
                          gamesByUser.add(newGame);
                        });
                      },
                    );
                  },
                );
              },
              icon: Icon(Icons.add),
              label: Text('Add Game'),
              heroTag: 'AddGameButton',
            ),
          ],
        ),
      ),
    );
  }
}