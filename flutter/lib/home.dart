import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase/src/data_snapshot.dart';
import 'package:tic_tac_toe/name_dialog.dart';
import 'package:tic_tac_toe/spinner.dart';
import 'package:tic_tac_toe/model/user.dart';

class TicTacToeConfiguration {
  User currentUser;
}

class TicTacToeHome extends StatefulWidget {
  TicTacToeConfiguration configuration;
  ValueChanged<TicTacToeConfiguration> updater;

  TicTacToeHome(this.configuration, this.updater, {Key key}) : super(key: key);

  @override
  _TicTacToeHomeState createState() => new _TicTacToeHomeState();
}

class _TicTacToeHomeState extends State<TicTacToeHome> {
  DatabaseReference _usersRef = FirebaseDatabase.instance.reference("users");

  void _onUserLoggedIn(spinner, user) {
    config.updater(config.configuration..currentUser = user);
    spinner.hide();
    _goToLobby();
  }

  void _goToLobby() => Navigator.popAndPushNamed(context, "/lobby");

  void _connect() {
    var spinner = new Spinner();
    showDialog(context: context, child: spinner);

    FirebaseAuth.instance.signInAnonymously().then((user) {
      var userRef = _usersRef.child(user.uid);
      userRef.once("value").then((DataSnapshot snapshot) async {
        var savedUser = snapshot.val();
        if (savedUser != null && savedUser['displayName'] != null) {
          _onUserLoggedIn(spinner, new User.fromMap(savedUser));
        } else {
          var name =
              await showDialog(context: context, child: new NameDialog());
          if (name == null) {
            await userRef.remove();
            await FirebaseAuth.instance.app.proxy.signOut();
            spinner.hide();
          } else {
            await userRef.set(user..displayName = name);
            _onUserLoggedIn(spinner, new User.fromMap(user.toJson()));
          }
        }
      });
    }).catchError((error) async {
      print(error);
      await showDialog(
          context: context,
          child: new Dialog(
              title: new Text('Error logging in'),
              content: new Text(error.toString())));
      spinner.hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text('Tic-Tac-Toe')),
        body: new Center(child: new RaisedButton(
            onPressed: _connect, child: new Text("Login"))));
  }
}
