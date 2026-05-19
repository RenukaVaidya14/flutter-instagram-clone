class PostModel {

  final String postId;

  final String uid;

  final String username;

  final String caption;

  final String postImage;

  final String timestamp;

  final List likes;

  PostModel({

    required this.postId,

    required this.uid,

    required this.username,

    required this.caption,

    required this.postImage,

    required this.timestamp,

    required this.likes,
  });

  /// CONVERT TO MAP
  Map<String, dynamic> toMap() {

    return {

      "postId": postId,

      "uid": uid,

      "username": username,

      "caption": caption,

      "postImage": postImage,

      "timestamp": timestamp,

      "likes": likes,
    };
  }

  /// CONVERT FROM MAP
  factory PostModel.fromMap(
      Map<String, dynamic> map) {

    return PostModel(

      postId:
      map['postId'] ?? '',

      uid:
      map['uid'] ?? '',

      username:
      map['username'] ?? '',

      caption:
      map['caption'] ?? '',

      postImage:
      map['postImage'] ?? '',

      timestamp:
      map['timestamp'] ?? '',

      likes:
      map['likes'] ?? [],
    );
  }
}