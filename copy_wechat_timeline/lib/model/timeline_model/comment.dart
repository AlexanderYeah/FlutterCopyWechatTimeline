import 'user.dart';

class Comment {
  User? user;
  String? content;
  String? publishDate;

  Comment({this.user, this.content, this.publishDate});

  @override
  String toString() {
    return 'Comment(user: $user, content: $content, publishDate: $publishDate)';
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      content: json['content'] as String?,
      publishDate: json['publishDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'content': content,
      'publishDate': publishDate,
    };
  }
}
