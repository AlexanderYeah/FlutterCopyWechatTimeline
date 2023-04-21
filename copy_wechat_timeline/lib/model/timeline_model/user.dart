class User {
  String? uid;
  String? nickname;
  String? avator;

  User({this.uid, this.nickname, this.avator});

  @override
  String toString() {
    return 'User(uid: $uid, nickname: $nickname, avator: $avator)';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] as String?,
      nickname: json['nickname'] as String?,
      avator: json['avator'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'nickname': nickname,
      'avator': avator,
    };
  }
}
