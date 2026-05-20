import 'package:cloud_firestore/cloud_firestore.dart';

class PostService {

  /// LIKE / UNLIKE POST
  Future<void> likePost({

    required String postId,

    required String userId,

    required List likes,
  }) async {

    try {

      if (likes.contains(userId)) {

        /// UNLIKE
        await FirebaseFirestore.instance
            .collection("posts")
            .doc(postId)
            .update({

          "likes":
          FieldValue.arrayRemove(
            [userId],
          ),
        });

      } else {

        /// LIKE
        await FirebaseFirestore.instance
            .collection("posts")
            .doc(postId)
            .update({

          "likes":
          FieldValue.arrayUnion(
            [userId],
          ),
        });
      }

    } catch (e) {

      print(e);
    }
  }
}