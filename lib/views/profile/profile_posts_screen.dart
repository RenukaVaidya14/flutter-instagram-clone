import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/post_card.dart';

class ProfilePostsScreen
    extends StatelessWidget {

  final int initialIndex;

  final List<QueryDocumentSnapshot>
  posts;

  const ProfilePostsScreen({

    super.key,

    required this.posts,

    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      Colors.black,

      body: PageView.builder(

        controller:
        PageController(

          initialPage:
          initialIndex,
        ),

        scrollDirection:
        Axis.vertical,

        itemCount:
        posts.length,

        itemBuilder:
            (context, index) {

          String postId =

          posts[index]
          ['postId'];

          /// FETCH SAME POST AGAIN
          return StreamBuilder(

            stream:
            FirebaseFirestore
                .instance
                .collection(
                "posts")
                .doc(postId)
                .snapshots(),

            builder:
                (
                context,
                snapshot,
                ) {

              if (!snapshot
                  .hasData) {

                return const Center(

                  child:
                  CircularProgressIndicator(),
                );
              }

              if (!snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data!.data() == null) {

                WidgetsBinding.instance
                    .addPostFrameCallback((_) {

                  if (context.mounted) {

                    Navigator.pop(
                      context,
                    );
                  }
                });

                return const SizedBox();
              }

              Map<String, dynamic> post =

              snapshot.data!.data()

              as Map<String, dynamic>;

              /// SAME WIDGET AS HOME
              return SingleChildScrollView(

                child:
                PostCard(

                  post:
                  post,
                ),
              );
            },
          );
        },
      ),
    );
  }
}