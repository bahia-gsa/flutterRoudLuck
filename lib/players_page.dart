import 'package:draw/forms/add_player_form.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PlayersPage extends StatefulWidget {
  
  final List<Map<String, dynamic>> playersByGame;
  final Map<String, dynamic> data;
  final Map<String, dynamic> game;

  PlayersPage({required this.playersByGame, required this.data, required this.game});


  @override
  State<PlayersPage> createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {

  void addPlayer(Map<String, dynamic> player) {
    setState(() {
      widget.playersByGame.add(player);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PlayersTable(widget.playersByGame, widget.data),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddPlayerForm(game: widget.game, addPlayer: addPlayer);
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class PlayersTable extends StatefulWidget {

  final List<Map<String, dynamic>> playersByGame;
  final Map<String, dynamic> data;

  PlayersTable(this.playersByGame, this.data);

  @override
  State<PlayersTable> createState() => _MyTableState();
}

class _MyTableState extends State<PlayersTable> {


    Future<void> deletePlayer(Map<String, dynamic> player) async {
    String jwt = widget.data['jwt'] ?? 'jwt not found';
    final headerOptions = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwt'
    };
    final response = await http.delete(
      Uri.parse('https://quarkus-uexc3xgdlq-uc.a.run.app/api/players/${player['id']}'),
      headers: headerOptions,
      );

    if (response.statusCode == 200) {
        print('PLAYERS DELETED');
        setState(() {
          widget.playersByGame.remove(player);
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw Exception('Failed to load data');
    }
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: widget.playersByGame.map((player) {
          return Column(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(child: Text(player['playerName'][0])),
                title: Text(player['playerName']),
                subtitle: Text(player['playerEmail'],
                style: TextStyle(color: Colors.red),),
                trailing: IconButton(
  icon: Icon(Icons.delete_forever),
  onPressed: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this player?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                deletePlayer(player);
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
              Divider(height: 0),
            ],
          );
        }).toList(),
      ),
    );
  }
}