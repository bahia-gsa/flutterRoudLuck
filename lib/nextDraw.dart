import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logger/logger.dart';

class NextDraw extends StatefulWidget {

    final Map<String, dynamic> game;
    final Map<String, dynamic> data;


    NextDraw({required this.game, required this.data});

  @override
  State<NextDraw> createState() => _NextDrawState();
}

class _NextDrawState extends State<NextDraw> {
  Future<Map<String, dynamic>>? drawFuture;

  Future<Map<String, dynamic>> drawPlayer(String gameId) async {
    String jwt = widget.data['jwt'] ?? 'jwt not found';
    final headerOptions = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwt'
    };
    final response = await http.get(
      Uri.parse('https://quarkus-uexc3xgdlq-uc.a.run.app/api/draws/draw/$gameId'),
      headers: headerOptions,
    );

    if (response.statusCode == 200) {
      Logger().i("Draw made successfully ------------${response.body}");
      return jsonDecode(response.body);
    } else {
      Logger().e("Request for new Draw failed with status: ${response.statusCode}.");
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
           const Text(
            'Next Round',
            style: TextStyle(fontSize: 28),
          ),
           const SizedBox(height: 20),
          IconButton(
            icon: Icon(Icons.play_circle),
            iconSize: 100.0,
            onPressed: () {
              setState(() {
                drawFuture = drawPlayer(widget.game['id'].toString());
              });
            },
          ),
          const SizedBox(height: 60),
          FutureBuilder<Map<String, dynamic>>(
            future: drawFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    '${snapshot.data?['playerName'] ?? 'No player drawn yet'}',
                    style: TextStyle(fontSize: 24, color: Colors.blue),
                  ),
                );
              } else {
                return const Text(
                  'No player drawn yet',
                  style: TextStyle(fontSize: 24),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}