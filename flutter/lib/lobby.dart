import 'package:flutter/material.dart';
import 'package:tic_tac_toe/home.dart';
import 'package:firebase/firebase.dart';
import 'dart:async';
import 'package:firebase/src/data_snapshot.dart';
import 'package:tic_tac_toe/game_entry.dart';
import 'package:tic_tac_toe/model/game.dart';
import 'package:tic_tac_toe/model/player.dart';

class Lobby extends StatefulWidget {
  TicTacToeConfiguration configuration;
  ValueChanged<TicTacToeConfiguration> updater;

  Lobby(this.configuration, this.updater);

  @override
  _LobbyState createState() {
    return new _LobbyState();
  }
}

class _LobbyState extends State<Lobby> {
  List<GameEntry> _games = [];
  DatabaseReference _gamesRef = FirebaseDatabase.instance.reference("/games");
  StreamSubscription _subscription;

  Future _onBackPressed() async {
    await FirebaseAuth.instance.app.proxy.signOut();
    Navigator.pop(context);
  }

  void _createGame() {
    DatabaseReference newRef = _gamesRef.push();

    newRef.set(new Game()
      ..owner = new Player.fromUser(config.configuration.currentUser)
      ..toJson());

    newRef.onValue
        .firstWhere((Event event) => event.snapshot.val() != null)
        .then((Event event) {
      Game game = new Game.fromMap(event.snapshot.key, event.snapshot.val());

      Navigator.pushNamed(context, "/games/${game.id}");
    });
  }

  void _onGameTapped(Game game) {
    Navigator.pushNamed(context, "/games/${game.id}");
  }

  @override
  void initState() {
    super.initState();

    _subscription = _gamesRef.onValue.listen((Event event) {
      DataSnapshot snapshot = event.snapshot;
      Map<String, Map> games = snapshot.val();
      setState(() {
        _games = games == null
            ? []
            : games.keys
                .map((key) => new Game.fromMap(key, games[key]))
                .where((Game game) => game.isOpen)
                .map((Game game) =>
                    new GameEntry(config.configuration, game, _onGameTapped))
                .toList(growable: false);
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: new Text("Available games"),
            leading: new IconButton(
                icon: Icons.arrow_back, onPressed: _onBackPressed)),
        body: new Container(
            child: new ScrollableList(itemExtent: 60.0, children: _games)),
        floatingActionButton: new FloatingActionButton(
            onPressed: _createGame,
            tooltip: "Create Game",
            child: new Icon(icon: Icons.add)));
  }
}
