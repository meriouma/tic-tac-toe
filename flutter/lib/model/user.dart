class User {
  String providerId = null;
  String uid = null;
  String displayName = null;
  String photoUrl = null;
  String email = null;

  User();

  factory User.fromMap(Map map) {
    return new User()
      ..providerId = map['providerId']
      ..uid = map['uid']
      ..displayName = map['displayName']
      ..photoUrl = map['photoUrl']
      ..email = map['email'];
  }

  String toString() {
    return "User("
        "providerId: $providerId,"
        "uid: $uid,"
        "displayName: $displayName,"
        "photoUrl: $photoUrl,"
        "email: $email"
        ")";
  }

  Map toJson() {
    Map map = new Map();
    map["providerId"] = providerId;
    map["uid"] = uid;
    map["displayName"] = displayName;
    map["photoUrl"] = photoUrl;
    map["email"] = email;
    return map;
  }
}
