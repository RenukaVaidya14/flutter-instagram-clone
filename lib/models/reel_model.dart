class ReelModel {

  final String reelId;

  final String videoUrl;

  final String caption;

  final String username;

  ReelModel({

    required this.reelId,

    required this.videoUrl,

    required this.caption,

    required this.username,
  });

  factory ReelModel.fromMap(

      Map<String, dynamic> map) {

    return ReelModel(

      reelId:
      map['reelId'] ?? '',

      videoUrl:
      map['videoUrl'] ?? '',

      caption:
      map['caption'] ?? '',

      username:
      map['username'] ?? '',
    );
  }
}