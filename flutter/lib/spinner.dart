import 'package:flutter/material.dart';
import 'dart:async';

class Spinner extends StatefulWidget {
  Completer _hideCompleter;

  Future hide() async {
    if (_hideCompleter != null) {
      _hideCompleter.complete();
      await _hideCompleter.future;
    }
  }

  @override
  _SpinnerState createState() {
    return new _SpinnerState();
  }
}

class _SpinnerState extends State {
  @override
  void initState() {
    super.initState();

    config._hideCompleter = new Completer()
      ..future.whenComplete(() => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(alignment: FractionalOffset.center, children: [
      new ModalBarrier(dismissable: false),
      new Center(child: new CircularProgressIndicator())
    ]);
  }
}
