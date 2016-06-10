import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:tic_tac_toe/model/game.dart';

class Cell extends StatelessWidget {
  static TextStyle _textStyle = new TextStyle(
      textBaseline: TextBaseline.ideographic,
      fontSize: 100.0,
      color: new Color.fromARGB(255, 0, 0, 0));

  int index;
  ValueChanged<int> onTap;
  String value;

  Cell({this.index, this.onTap, this.value: BoardValue.EMPTY});

  TextSpan _createTextSpan(String text) {
    return new TextSpan(
        text: text,
        style: _textStyle,
        recognizer: new TapGestureRecognizer()
          ..onTap = onTap == null ? () {} : () => onTap(index));
  }

  @override
  Widget build(BuildContext context) {
    return new Container(child: new RichText(
        textAlign: TextAlign.center,
        text: _createTextSpan(value),
        overflow: TextOverflow.fade));
  }
}
