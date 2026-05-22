import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentService {

  /// ADD COMMENT
  Future<void> addComment({

    required String postId,

    required String comment,
  }) async {

    try {

      if (comment.trim().isEmpty) {
        return;
      }

      String commentId =

      DateTime.now()
          .millisecondsSinceEpoch
          .toString();

      User? currentUser =

          FirebaseAuth.instance
              .currentUser;

      if (currentUser == null) {
        return;
      }

      /// SAVE COMMENT
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(postId)
          .collection("comments")
          .doc(commentId)
          .set({

        "commentId": commentId,

        "uid": currentUser.uid,

        "username": "renu",

        "comment": comment.trim(),

        "timestamp":
        FieldValue.serverTimestamp(),
      });

      /// UPDATE COMMENT COUNT
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(postId)
          .update({

        "commentCount":
        FieldValue.increment(1),
      });

    } catch (e) {

      print(
        "COMMENT ERROR: $e",
      );
    }
  }

  /// DELETE COMMENT
  Future<void> deleteComment({

    required String postId,

    required String commentId,
  }) async {

    try {

      /// DELETE COMMENT
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(postId)
          .collection("comments")
          .doc(commentId)
          .delete();

      /// DECREASE COMMENT COUNT
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(postId)
          .update({

        "commentCount":
        FieldValue.increment(-1),
      });

    } catch (e) {

      print(
        "DELETE COMMENT ERROR: $e",
      );
    }
  }
}