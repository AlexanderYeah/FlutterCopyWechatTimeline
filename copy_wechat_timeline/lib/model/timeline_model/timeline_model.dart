import 'comment.dart';
import 'like.dart';
import 'user.dart';
import 'video.dart';

class TimelineModel {
  String? id;
  List<String>? images;
  Video? video;
  String? content;
  String? postType;
  User? user;
  String? publishDate;
  String? location;
  bool? isLike;
  List<Like>? likes;
  List<Comment>? comments;

  TimelineModel({
    this.id,
    this.images,
    this.video,
    this.content,
    this.postType,
    this.user,
    this.publishDate,
    this.location,
    this.isLike,
    this.likes,
    this.comments,
  });

  @override
  String toString() {
    return 'TimelineModel(id: $id, images: $images, video: $video, content: $content, postType: $postType, user: $user, publishDate: $publishDate, location: $location, isLike: $isLike, likes: $likes, comments: $comments)';
  }

  factory TimelineModel.fromJson(Map<String, dynamic> json) {
    return TimelineModel(
      id: json['id'] as String?,
      images: json['images'] as List<String>?,
      video: json['video'] == null
          ? null
          : Video.fromJson(json['video'] as Map<String, dynamic>),
      content: json['content'] as String?,
      postType: json['post_type'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      publishDate: json['publishDate'] as String?,
      location: json['location'] as String?,
      isLike: json['is_like'] as bool?,
      likes: (json['likes'] as List<dynamic>?)
          ?.map((e) => Like.fromJson(e as Map<String, dynamic>))
          .toList(),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'images': images,
      'video': video?.toJson(),
      'content': content,
      'post_type': postType,
      'user': user?.toJson(),
      'publishDate': publishDate,
      'location': location,
      'is_like': isLike,
      'likes': likes?.map((e) => e.toJson()).toList(),
      'comments': comments?.map((e) => e.toJson()).toList(),
    };
  }
}
