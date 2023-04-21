class Video {
  String? cover;
  String? url;

  Video({this.cover, this.url});

  @override
  String toString() => 'Video(cover: $cover, url: $url)';

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      cover: json['cover'] as String?,
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cover': cover,
      'url': url,
    };
  }
}
