import 'package:flutter/material.dart';

class NameDialog extends StatefulWidget {
  @override
  _NameDialogState createState() {
    return new _NameDialogState();
  }
}

class _NameDialogState extends State {
  String _name;

  void _handleCancel() {
    Navigator.pop(context);
  }

  void _handleOk() {
    Navigator.pop(context, _name);
  }

  String _validateName(String s) {
    return s.isEmpty ? "You must enter a name" : null;
  }

  @override
  Widget build(BuildContext context) {
    return new Dialog(
        title: new Text("Enter name"),
        content: new Form(
            child: new Input(
                autofocus: true,
                formField: new FormField<String>(
                    setter: (val) => _name = val, validator: _validateName),
                labelText: "Name",
                onSubmitted: (val) {}),
            onSubmitted: () {}),
        actions: [
          new FlatButton(child: new Text('CANCEL'), onPressed: _handleCancel),
          new FlatButton(child: new Text('OK'), onPressed: _handleOk),
        ]);
  }
}
