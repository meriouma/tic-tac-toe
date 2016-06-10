import 'package:tic_tac_toe/model/player.dart';

enum _GameState { OPEN, JOINED, TURN_X, TURN_O, DONE }

class GameState {
  final _GameState _state;

  const GameState(this._state);

  static const GameState OPEN = const GameState(_GameState.OPEN);
  static const GameState JOINED = const GameState(_GameState.JOINED);
  static const GameState TURN_X = const GameState(_GameState.TURN_X);
  static const GameState TURN_O = const GameState(_GameState.TURN_O);
  static const GameState DONE = const GameState(_GameState.DONE);

  int toJson() {
    return _state.index;
  }

  bool get isPlaying =>
      _state == _GameState.TURN_X || _state == _GameState.TURN_O;

  @override
  bool operator ==(o) => o is GameState && _state == o._state;

  @override
  int get hashCode => _state.hashCode;

  factory GameState.fromJson(json) {
    return new GameState(_GameState.values[json]);
  }
}

class BoardValue {
  static const String EMPTY = " ";
  static const String X = "X";
  static const String O = "O";

  final String owner;
  final String joiner;

  BoardValue(this.owner, this.joiner);

  factory BoardValue.create() {
    List<String> values = [X, O]..shuffle();
    return new BoardValue(values[0], values[1]);
  }
}

class Game {
  GameState state;
  Player owner;
  Player joiner;
  String id;
  List<String> board = new List.generate(9, (i) => BoardValue.EMPTY);

  Game({this.state: GameState.OPEN});

  bool get isOpen => state == GameState.OPEN;
  bool get isPlaying => state.isPlaying;
  bool get isDone => state == GameState.DONE;

  bool isTurn(String uid) {
    Player player = _getPlayerById(uid);

    return player.boardValue == BoardValue.X && state == GameState.TURN_X ||
        player.boardValue == BoardValue.O && state == GameState.TURN_O;
  }

  bool isWinner(String uid) {
    return _getPlayerById(uid).wins;
  }

  void markBoard(int index, String uid) {
    String value = _getBoardValue(uid);
    board[index] = value;

    _updateState(value);
  }

  bool _checkBoardLine(List<int> i, String value) {
    return [board[i[0]], board[i[1]], board[i[2]]].every((v) => v == value);
  }

  bool _checkBoardValues(String value) {
    return _checkBoardLine([0, 1, 2], value) ||
        _checkBoardLine([0, 3, 6], value) ||
        _checkBoardLine([0, 4, 8], value) ||
        _checkBoardLine([1, 4, 7], value) ||
        _checkBoardLine([2, 5, 8], value) ||
        _checkBoardLine([2, 4, 6], value) ||
        _checkBoardLine([3, 4, 5], value) ||
        _checkBoardLine([6, 7, 8], value);
  }

  String _getWinner() {
    if (_checkBoardValues(BoardValue.X)) {
      return BoardValue.X;
    } else if (_checkBoardValues(BoardValue.O)) {
      return BoardValue.O;
    }
    return null;
  }

  void _updateState(String lastAddedValue) {
    String value = _getWinner();
    if (value != null) {
      _setWinner(value);
    } else {
      state =
          lastAddedValue == BoardValue.X ? GameState.TURN_O : GameState.TURN_X;
    }
  }

  void _setWinner(String boardValue) {
    Player winner = _getPlayerByBoardValue(boardValue);
    winner.wins = true;
    state = GameState.DONE;
  }

  String _getBoardValue(String uid) {
    return _getPlayerById(uid).boardValue;
  }

  Player _getPlayerByBoardValue(String boardValue) {
    return owner.boardValue == boardValue ? owner : joiner;
  }

  Player _getPlayerById(String uid) {
    return owner.uid == uid ? owner : joiner;
  }

  factory Game.fromMap(String id, Map map) {
    return new Game()
      ..id = id
      ..board = map['board']
      ..joiner = new Player.fromMap(map['joiner'])
      ..state = new GameState.fromJson(map['state'])
      ..owner = new Player.fromMap(map['owner']);
  }

  Map toJson() {
    return new Map()
      ..["board"] = board
      ..["state"] = state.toJson()
      ..["owner"] = owner.toJson()
      ..["joiner"] = joiner?.toJson();
  }
}
