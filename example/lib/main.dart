import 'package:flutter/material.dart';
import 'dart:async';

import 'package:level_db/level_db.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<LevelDb> db = getLevelDB();
  String? key;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LevelDb>(
      future: db,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: key != null
                      ? Text(snapshot.data!.getItem(key!) ?? 'not set')
                      : SizedBox(),
                ),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Key'),
                onSubmitted: (v) {
                  setState(() {
                    key = v;
                  });
                },
              ),
              Divider(),
              TextField(
                decoration: InputDecoration(labelText: 'Value'),
                onSubmitted: (v) {
                  setState(() {
                    snapshot.data!.setItem(key!, v);
                  });
                },
              )
            ],
          ),
        );
      },
    );
  }
}
