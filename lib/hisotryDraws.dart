import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';


class HistoryDraws extends StatefulWidget {
  final Map<String, dynamic> game;
  final Map<String, dynamic> data;


  HistoryDraws({required this.game, required this.data});

  @override
  State<HistoryDraws> createState() => _HistoryDrawsState();
}

class _HistoryDrawsState extends State<HistoryDraws> {

  List<Map<String, dynamic>> DrawsByGame= [];

    @override
    void initState() {
      super.initState();
      String gameId = widget.game['id'].toString();
      getDrawsByGame(gameId);
    }

   Future<void> getDrawsByGame(String gameId) async {
    // Replace with your API endpoint
    String jwt = widget.data['jwt'] ?? 'jwt not found';
    final headerOptions = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwt'
    };
    final response = await http.get(
      Uri.parse('https://quarkus-uexc3xgdlq-uc.a.run.app/api/draws/$gameId'),
      headers: headerOptions,
      );

    if (response.statusCode == 200) {
      setState(() {
        DrawsByGame = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
      print('DrawsByGame: ${DrawsByGame}');
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DrawsTable(DrawsByGame),
      ),
    );
  }
}

class DrawsTable extends StatefulWidget {

  final List<Map<String, dynamic>> draws;

  DrawsTable(this.draws);

  @override
  State<DrawsTable> createState() => _MyTableState();
}

class _MyTableState extends State<DrawsTable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: widget.draws.map((player) {
          return Column(
            children: <Widget>[
              ListTile(
                title: Text(player['playerName']),
                trailing: Text(DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(player['createdAt'])),
                  style: TextStyle(fontSize: 12, color: Colors.red)),
              ),
              Divider(height: 0),
            ],
          );
        }).toList(),
      ),
    );
  }
}