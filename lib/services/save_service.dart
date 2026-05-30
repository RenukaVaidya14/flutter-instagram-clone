import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SaveService {

  final uid =
      FirebaseAuth.instance.currentUser!.uid;

  Future<void> toggleSavePost({
    required String postId,
  }) async {

    DocumentReference ref =
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("savedPosts")
        .doc(postId);

    var doc = await ref.get();

    if (doc.exists) {

      await ref.delete();

    } else {

      await ref.set({
        "postId": postId,
        "savedAt":
        FieldValue.serverTimestamp(),
      });
    }
  }

  Future<bool> isPostSaved(
      String postId) async {

    var doc =
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("savedPosts")
        .doc(postId)
        .get();

    return doc.exists;
  }
}