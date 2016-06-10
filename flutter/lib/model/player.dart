import 'package:tic_tac_toe/model/user.dart';

class Player {
  String uid;
  String displayName;
  String boardValue;
  bool wins;

  Player();

  factory Player.fromUser(User user) {
    return new Player()
      ..uid = user.uid
      ..displayName = user.displayName;
  }

  factory Player.fromMap(Map map) {
    if (map == null) {
      return null;
    }

    return new Player()
      ..uid = map['uid']
      ..displayName = map['displayName']
      ..boardValue = map['boardValue']
      ..wins = map['wins'] ?? false;
  }

  Map toJson() {
    return new Map()
      ..["uid"] = uid
      ..["displayName"] = displayName
      ..["boardValue"] = boardValue
      ..["wins"] = wins;
  }
}
