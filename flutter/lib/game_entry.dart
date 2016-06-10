import 'package:flutter/material.dart';
import 'package:tic_tac_toe/model/game.dart';
import 'package:firebase/firebase.dart';
import 'package:tic_tac_toe/home.dart';
import 'package:tic_tac_toe/model/player.dart';

class GameEntry extends StatelessWidget {
  Game game;
  TicTacToeConfiguration configuration;
  var onTap;

  GameEntry(this.configuration, this.game, this.onTap) {}

  @override
  Widget build(BuildContext context) {
    return new InkWell(
        onTap: () async {
          // TODO : openTransaction

          BoardValue boardValue = new BoardValue.create();
          Player joiner = new Player.fromUser(configuration.currentUser)
            ..boardValue = boardValue.joiner;
          game.owner.boardValue = boardValue.owner;

          DatabaseReference gameRef =
              FirebaseDatabase.instance.reference("/games/${game.id}");
          await gameRef
              .set(game
                ..joiner = joiner
                ..state = GameState.JOINED
                ..toJson())
              .whenComplete(() {
            gameRef.set(game..state = GameState.TURN_X);

            onTap(game);
          });
        },
        child: new Container(
            padding: const EdgeInsets.all(16.0),
            decoration: new BoxDecoration(border: new Border(
                bottom: new BorderSide(color: Theme.of(context).dividerColor))),
            child: new Row(children: <Widget>[
              new Container(
                  margin: const EdgeInsets.only(right: 5.0),
                  child: new Text(game.owner.displayName))
            ])));
  }
}
