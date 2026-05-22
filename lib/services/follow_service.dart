import 'package:cloud_firestore/cloud_firestore.dart';

class FollowService {

  Future<void> followUser({

    required String currentUserId,

    required String targetUserId,

    required List followers,
  }) async {

    try {

      /// UNFOLLOW
      if (followers.contains(currentUserId)) {

        await FirebaseFirestore.instance
            .collection("users")
            .doc(targetUserId)
            .update({

          "followers":
          FieldValue.arrayRemove(
            [currentUserId],
          ),
        });

        await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUserId)
            .update({

          "following":
          FieldValue.arrayRemove(
            [targetUserId],
          ),
        });

      } else {

        /// FOLLOW
        await FirebaseFirestore.instance
            .collection("users")
            .doc(targetUserId)
            .update({

          "followers":
          FieldValue.arrayUnion(
            [currentUserId],
          ),
        });

        await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUserId)
            .update({

          "following":
          FieldValue.arrayUnion(
            [targetUserId],
          ),
        });
      }

    } catch (e) {

      print(
        "FOLLOW ERROR: $e",
      );
    }
  }
}