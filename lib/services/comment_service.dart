import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentService {

  /// ADD COMMENT
  Future<void> addComment({

    required String postId,

    required String comment,

    bool isReel = false,

  }) async {

    try {

      if (
      comment
          .trim()
          .isEmpty
      ) return;

      String commentId =

      DateTime.now()
          .millisecondsSinceEpoch
          .toString();

      User? currentUser =

          FirebaseAuth
              .instance
              .currentUser;

      if (
      currentUser ==
          null
      ) return;

      String collection =

      isReel

          ? "reels"

          : "posts";

      /// SAVE COMMENT
      await FirebaseFirestore
          .instance
          .collection(
        collection,
      )
          .doc(
        postId,
      )
          .collection(
        "comments",
      )
          .doc(
        commentId,
      )
          .set({

        "commentId":
        commentId,

        "uid":
        currentUser.uid,

        "username":
        "renu",

        "comment":
        comment.trim(),

        "timestamp":

        FieldValue
            .serverTimestamp(),
      });

      /// UPDATE COUNT
      await FirebaseFirestore
          .instance
          .collection(
        collection,
      )
          .doc(
        postId,
      )
          .update({

        "commentCount":

        FieldValue
            .increment(
          1,
        ),
      });

    }

    catch (e) {

      print(
        "COMMENT ERROR: $e",
      );
    }
  }

  /// DELETE COMMENT
  Future<void>
  deleteComment({

    required String postId,

    required String commentId,

    bool isReel = false,

  }) async {

    try {

      String collection =

      isReel

          ? "reels"

          : "posts";

      await FirebaseFirestore
          .instance
          .collection(
        collection,
      )
          .doc(
        postId,
      )
          .collection(
        "comments",
      )
          .doc(
        commentId,
      )
          .delete();

      await FirebaseFirestore
          .instance
          .collection(
        collection,
      )
          .doc(
        postId,
      )
          .update({

        "commentCount":

        FieldValue
            .increment(
          -1,
        ),
      });

    }

    catch (e) {

      print(
        "DELETE ERROR: $e",
      );
    }
  }
}