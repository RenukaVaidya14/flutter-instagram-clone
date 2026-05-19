import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets/post_card.dart';


class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        backgroundColor: Colors.black,

        elevation: 0,

        title: const Text(

          "Instagram",

          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),

        actions: [

          IconButton(

            onPressed: () {},

            icon: const Icon(
              Icons.favorite_border,
              color: Colors.white,
            ),
          ),

          IconButton(

            onPressed: () {},

            icon: const Icon(
              Icons.chat_bubble_outline,
              color: Colors.white,
            ),
          ),
        ],
      ),

      body: StreamBuilder(

        stream: FirebaseFirestore.instance
            .collection("posts")
            .orderBy(
          "timestamp",
          descending: true,
        )
            .snapshots(),

        builder: (context, snapshot) {

          /// LOADING
          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(

              child:
              CircularProgressIndicator(),
            );
          }

          /// NO POSTS
          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {

            return const Center(

              child: Text(
                "No Posts Yet",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            );
          }

          /// POSTS
          /// POSTS
          return ListView.builder(

            itemCount:
            snapshot.data!.docs.length,

            itemBuilder: (context, index) {

              var post =
              snapshot.data!.docs[index];

              /// CONVERT TO MAP
              Map<String, dynamic> data =

              post.data()
              as Map<String, dynamic>;

              /// REUSABLE POST CARD
              return PostCard(
                post: data,
              );
            },
          );
        },
      ),
    );
  }
}