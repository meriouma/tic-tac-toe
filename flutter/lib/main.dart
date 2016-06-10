import 'package:flutter/material.dart';
import 'package:tic_tac_toe/home.dart';
import 'package:tic_tac_toe/lobby.dart';
import 'package:tic_tac_toe/game_view.dart';

void main() {
  runApp(new TicTacToeApp());
}

class TicTacToeApp extends StatefulWidget {
  @override
  _TicTacToeAppState createState() {
    return new _TicTacToeAppState();
  }
}

class _TicTacToeAppState extends State {
  TicTacToeConfiguration _configuration = new TicTacToeConfiguration();

  void _configurationUpdater(TicTacToeConfiguration value) {
    setState(() {
      _configuration = value;
    });
  }

  Route<Null> _getRoute(RouteSettings settings) {
    List<String> path = settings.name.split('/');
    if (path[0] != '') return null;
    if (path[1] == 'games') {
      if (path.length != 3) return null;
      return new MaterialPageRoute<Null>(
          settings: settings,
          builder: (BuildContext context) =>
              new GameView(_configuration, path[2]));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Tic-Tac-Toe',
        theme: new ThemeData(primarySwatch: Colors.blue),
        onGenerateRoute: _getRoute,
        routes: {
          "/lobby": (context) =>
              new Lobby(_configuration, _configurationUpdater)
        },
        home: new TicTacToeHome(_configuration, _configurationUpdater));
  }
}
