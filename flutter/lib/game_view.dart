import 'package:flutter/material.dart';
import 'package:tic_tac_toe/cell.dart';
import 'package:tic_tac_toe/home.dart';
import 'package:firebase/firebase.dart';
import 'package:tic_tac_toe/model/game.dart';
import 'dart:async';

class GameView extends StatefulWidget {
  final String gameId;
  TicTacToeConfiguration configuration;

  GameView(this.configuration, this.gameId) {}

  @override
  _GameViewState createState() {
    return new _GameViewState();
  }
}

class _GameViewState extends State<GameView> {
  List<Cell> _cells = [];
  DatabaseReference _gameRef;
  Game _game;
  StreamSubscription _subscription;
  String _status;

  Future _updateCell(int index) async {
    String uid = config.configuration.currentUser.uid;
    if (_game.isTurn(uid)) {
      _game.markBoard(index, uid);
      await _gameRef.set(_game.toJson());

      setState(() {
        _cells[index] = new Cell(index: index, value: _game.board[index]);
      });
    }
  }

  void _onGameChanged(Event event) {
    _game = new Game.fromMap(config.gameId, event.snapshot.val());

    setState(() {
      if (_game.isPlaying) {
        _status = _game.isTurn(config.configuration.currentUser.uid)
            ? "It's your turn!"
            : "Waiting for player to play";
      } else if (_game.isDone) {
        _status = _game.isWinner(config.configuration.currentUser.uid)
            ? "You won!"
            : "You lost..";
      }

      var board = _game.board;
      _cells = board.asMap().keys.map((int index) {
        String value = board[index];
        return new Cell(
            index: index,
            value: value,
            onTap: value == BoardValue.EMPTY ? _updateCell : null);
      }).toList(growable: false);
    });
  }

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 9; i++) {
      _cells.add(new Cell(index: i, onTap: _updateCell));
    }

    _status = "Waiting for player to join";
    _gameRef = FirebaseDatabase.instance.reference("/games/${config.gameId}");
    _subscription = _gameRef.onValue.listen(_onGameChanged);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BorderSide border = new BorderSide(
        width: 2.0,
        color: _game == null || !_game.isPlaying && !_game.isDone
            ? const Color(0x000000FF)
            : const Color.fromARGB(255, 0, 0, 0));
    BorderSide noBorder = new BorderSide(width: 2.0, style: BorderStyle.none);

    return new Scaffold(body: new Center(child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          new Text(_status),
          new FixedColumnCountGrid(
              columnCount: 3,
              columnSpacing: 0.0,
              rowSpacing: 0.0,
              children: _cells
                  .map((cell) => new Container(
                      margin: new EdgeInsets.all(0.0),
                      padding: new EdgeInsets.all(0.0),
                      child: cell,
                      decoration: new BoxDecoration(border: new Border(
                          top: (cell.index > 2) ? border : noBorder,
                          bottom: (cell.index < 6) ? border : noBorder,
                          right: (cell.index % 3 != 2) ? border : noBorder,
                          left: (cell.index % 3 > 0) ? border : noBorder))))
                  .toList(growable: false))
        ])));
  }
}
