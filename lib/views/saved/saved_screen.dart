import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SavedScreen
    extends StatelessWidget {

  const SavedScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    String uid =
        FirebaseAuth.instance
            .currentUser!
            .uid;

    return Scaffold(

      backgroundColor:
      Colors.black,

      appBar: AppBar(

        backgroundColor:
        Colors.black,

        title: const Text(
          "Saved",
        ),
      ),

      body: StreamBuilder(

        stream:
        FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection(
            "savedPosts")
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {

            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          if (snapshot.data!
              .docs
              .isEmpty) {

            return const Center(

              child: Text(

                "No Saved Posts",

                style: TextStyle(
                  color:
                  Colors.white,
                ),
              ),
            );
          }

          return ListView.builder(

            itemCount:
            snapshot.data!
                .docs
                .length,

            itemBuilder:
                (context, index) {

              String postId =

              snapshot
                  .data!
                  .docs[index]
              ['postId'];

              return FutureBuilder(

                future:
                FirebaseFirestore
                    .instance
                    .collection(
                    "posts")
                    .doc(postId)
                    .get(),

                builder:
                    (context, postSnap) {

                  if (!postSnap
                      .hasData) {

                    return const SizedBox();
                  }

                  var post =
                  postSnap
                      .data!;

                  return Image.network(
                    post[
                    'postImage'],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}