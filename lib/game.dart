import 'dart:convert';
import 'package:draw/hisotryDraws.dart';
import 'package:draw/home.dart';
import 'package:draw/nextDraw.dart';
import 'package:draw/players_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  final Map<String, dynamic> game;
  final Map<String, dynamic> data;

 
  //Game({required Key key, required this.game, required this.data}) : super(key: key);
  Game({Key? key, required this.game, required this.data}) : super(key: key);


  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  List<Map<String, dynamic>> playersByGame = [];
  int currentPageIndex = 0;

  @override
    void initState() {
      super.initState();
      String gameId = widget.game['id'].toString();
      getPlayerByGame(gameId);
    }

    Future<void> getPlayerByGame(String gameId) async {
    // Replace with your API endpoint
    String jwt = widget.data['jwt'] ?? 'jwt not found';
    final headerOptions = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwt'
    };
    final response = await http.get(
      Uri.parse('https://quarkus-uexc3xgdlq-uc.a.run.app/api/players/$gameId'),
      headers: headerOptions,
      );

    if (response.statusCode == 200) {
      print('PLAYERS---: ${response.body}');
      setState(() {
        playersByGame = List<Map<String, dynamic>>.from(jsonDecode(response.body));

      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Game: ${widget.game}');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.game['gameName'] ?? 'Game Name not found',
        style: TextStyle(
          color: Colors.white,
        ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.people_alt_outlined),
            label: 'Players',
          ),
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.view_list_outlined),
            label: 'Round',
          ),
        ],
      ),
      //body: currentPageIndex == 2 ? PlayersPage() : GameBody(game: widget.game, data: widget.data),
      body: currentPageIndex > 0 ? getBodyForIndex(currentPageIndex) : PlayersPage(playersByGame: playersByGame, data: widget.data, game: widget.game),
    );
  }
   Widget getBodyForIndex(int index) {
    switch (index) {
      case 0:
        return PlayersPage(playersByGame: playersByGame, data: widget.data, game: widget.game);
      case 1:
        return HistoryDraws(game: widget.game, data: widget.data);
      case 2:
        return NextDraw(game: widget.game, data: widget.data);
      default:
        return NextDraw(game: widget.game, data: widget.data);
    }
  }
}

class GameBody extends StatelessWidget {
  final Map<String, dynamic> game;
  final Map<String, dynamic> data;

  const GameBody({Key? key, required this.game, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(game['gameName'] ?? 'Game Name not found'),
    );
  }
}

