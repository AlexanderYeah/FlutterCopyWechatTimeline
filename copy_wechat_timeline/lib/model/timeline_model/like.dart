class Like {
  String? uid;
  String? nickname;
  String? avator;

  Like({this.uid, this.nickname, this.avator});

  @override
  String toString() {
    return 'Like(uid: $uid, nickname: $nickname, avator: $avator)';
  }

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
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
