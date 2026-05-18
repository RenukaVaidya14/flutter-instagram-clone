class UserModel {

  final String uid;
  final String username;
  final String email;
  final String bio;
  final String profileImage;

  UserModel({

    required this.uid,
    required this.username,
    required this.email,
    required this.bio,
    required this.profileImage,
  });

  Map<String, dynamic> toMap() {

    return {

      "uid": uid,

      "username": username,

      "email": email,

      "bio": bio,

      "profileImage": profileImage,
    };
  }

  factory UserModel.fromMap(
      Map<String, dynamic> map) {

    return UserModel(

      uid: map['uid'] ?? '',

      username:
      map['username'] ?? '',

      email: map['email'] ?? '',

      bio: map['bio'] ?? '',

      profileImage:
      map['profileImage'] ?? '',
    );
  }
}