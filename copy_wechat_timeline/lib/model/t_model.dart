// class TModel {
//   TModel(
//       {this.id,
//       this.images,
//       this.video,
//       this.content,
//       this.postType,
//       this.user,
//       this.isLike});

//   TModel.fromJson(dynamic json) {
//     id = json['id'];
//     images = json['images'] != null ? json['images'].cast<String>() : [];
//     video = json['video'] != null ? Video.fromJson(json['video']) : null;
//     content = json['content'];
//     postType = json['post_type'];
//     user = json['user'] != null ? User.fromJson(json['user']) : null;
//     isLike = json['isLike'];
//   }
//   String? id;
//   List<String>? images;
//   Video? video;
//   String? content;
//   String? postType;
//   User? user;
//   bool? isLike;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['images'] = images;
//     map['isLike'] = isLike;
//     if (video != null) {
//       map['video'] = video?.toJson();
//     }
//     map['content'] = content;
//     map['post_type'] = postType;
//     if (user != null) {
//       map['user'] = user?.toJson();
//     }
//     return map;
//   }
// }

// class User {
//   User({
//     this.uid,
//     this.nickname,
//     this.avator,
//     this.publishdate,
//     this.location,
//     this.isLike,
//   });

//   User.fromJson(dynamic json) {
//     uid = json['uid'];
//     nickname = json['nickname'];
//     avator = json['avator'];
//     publishdate = json['publishdate'];
//     location = json['location'];
//     isLike = json['is_like'];
//   }
//   String? uid;
//   String? nickname;
//   String? avator;
//   String? publishdate;
//   String? location;
//   bool? isLike;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['uid'] = uid;
//     map['nickname'] = nickname;
//     map['avator'] = avator;
//     map['publishdate'] = publishdate;
//     map['location'] = location;
//     map['is_like'] = isLike;
//     return map;
//   }
// }

// class Video {
//   Video({
//     this.cover,
//     this.url,
//   });

//   Video.fromJson(dynamic json) {
//     cover = json['cover'];
//     url = json['url'];
//   }
//   String? cover;
//   String? url;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['cover'] = cover;
//     map['url'] = url;
//     return map;
//   }
// }
