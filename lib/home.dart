import 'dart:convert';

import 'package:draw/authentication/token_service.dart';
import 'package:draw/forms/new_game_from.dart';
import 'package:draw/game.dart';
import 'package:draw/login.dart';
import 'package:draw/profile.dart';
import "package:flutter/material.dart";
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class Home extends StatefulWidget {
final Map<String, dynamic> data;
final GoogleSignInAccount currentUser;

  static const String routeName = "/home";
  const Home({Key? key, required this.data, required this.currentUser}) : super(key: key);
  

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
    List<Map<String, dynamic>> gamesByUser = [];

  
@override
void initState() {
  super.initState();
  if(TokenService().isTokenValidity(widget.data['expiresIn'].toString())){
    getGamesByUser(widget.data['userId'].toString());
  } else {
    TokenService().returnToInitialPage(context);
  }
}

  Future<void> getGamesByUser(String userId) async {
    if(gamesByUser.isNotEmpty) {
      return;
    }
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
      Logger().i("GamesByUser: ${response.body}");
      setState(() {
        gamesByUser = List<Map<String, dynamic>>.from(jsonDecode(response.body));

      });
    } else {
      Logger().e("Request for Games failed with status: ${response.statusCode}.");
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
    Logger().i("Game deleted successfully");
  } else {
    Logger().e("Request for delete Game failed with status: ${response.statusCode}.");
    throw Exception('Failed to delete game');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.currentUser.displayName ?? ''),
        actions: <Widget>[
          IconButton(
            icon: GoogleUserCircleAvatar(
              identity: widget.currentUser,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Profile(data: widget.data, currentUser: widget.currentUser),
                ),
              );
            },
          ),
        ],
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
                    if(TokenService().isTokenValidity(widget.data['expiresIn'].toString())){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Game(
                            game: gamesByUser[index],
                            data: widget.data,
                          ),
                        ),
                      );
                    }else{
                      TokenService().returnToInitialPage(context);
                    }
                  },
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete,
                  color: Colors.red,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Delete Game'),
                          content: const Text('Are you sure you want to delete this game?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('OK'),
                              onPressed: () async {
                                if(TokenService().isTokenValidity(widget.data['expiresIn'].toString())){
                                  await deleteGame(gamesByUser[index]['id']);
                                  setState(() {
                                    gamesByUser.removeAt(index);
                                  });
                                  Navigator.of(context).pop();
                                }else{
                                  TokenService().returnToInitialPage(context);
                                }
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
            const SizedBox(height: 30),
            FloatingActionButton.extended(
              onPressed: () {
                if(TokenService().isTokenValidity(widget.data['expiresIn'].toString())){
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
                }else{
                  TokenService().returnToInitialPage(context);
                }
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