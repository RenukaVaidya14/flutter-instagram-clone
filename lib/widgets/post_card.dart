import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/post_service.dart';

class PostCard extends StatelessWidget {

  final Map<String, dynamic> post;

  const PostCard({

    super.key,

    required this.post,
  });

  @override
  Widget build(BuildContext context) {

    /// CURRENT USER ID
    final String currentUserId =

        FirebaseAuth.instance
            .currentUser!
            .uid;

    /// POST SERVICE
    final PostService postService =
    PostService();

    /// CHECK LIKE STATUS
    bool isLiked =

    (post['likes'] ?? [])
        .contains(currentUserId);

    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        /// TOP USER INFO
        Padding(
          padding:
          const EdgeInsets.all(12),

          child: Row(

            children: [

              const CircleAvatar(

                backgroundColor:
                Colors.grey,

                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 10),

              Text(

                post['username']
                    ?? 'User',

                style: const TextStyle(
                  color: Colors.white,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const Spacer(),

              const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ],
          ),
        ),

        /// POST IMAGE
        Image.network(

          post['postImage']
              ?? '',

          width: double.infinity,

          height: 350,

          fit: BoxFit.cover,

          loadingBuilder:
              (
              context,
              child,
              loadingProgress,
              ) {

            if (loadingProgress ==
                null) {

              return child;
            }

            return Container(

              height: 350,

              color:
              Colors.grey.shade900,

              child: const Center(

                child:
                CircularProgressIndicator(),
              ),
            );
          },

          errorBuilder:
              (
              context,
              error,
              stackTrace,
              ) {

            return Container(

              height: 350,

              color:
              Colors.grey.shade900,

              child: const Center(

                child: Icon(
                  Icons.error,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),

        /// ACTION BUTTONS
        Padding(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),

          child: Row(

            children: [

              /// LIKE BUTTON
              IconButton(

                onPressed: () {

                  postService.likePost(

                    postId:
                    post['postId'],

                    userId:
                    currentUserId,

                    likes:
                    post['likes']
                        ?? [],
                  );
                },

                icon: Icon(

                  isLiked

                      ? Icons.favorite

                      : Icons.favorite_border,

                  color:

                  isLiked

                      ? Colors.red

                      : Colors.white,

                  size: 28,
                ),
              ),

              /// COMMENT BUTTON
              IconButton(

                onPressed: () {},

                icon: const Icon(
                  Icons.comment_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),

              /// SHARE BUTTON
              IconButton(

                onPressed: () {},

                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 26,
                ),
              ),

              const Spacer(),

              /// SAVE BUTTON
              IconButton(

                onPressed: () {},

                icon: const Icon(
                  Icons.bookmark_border,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
        ),

        /// LIKES COUNT
        Padding(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 15,
          ),

          child: Text(

            "${(post['likes'] ?? []).length} likes",

            style: const TextStyle(
              color: Colors.white,
              fontWeight:
              FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 5),

        /// CAPTION
        Padding(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 15,
          ),

          child: RichText(

            text: TextSpan(

              children: [

                TextSpan(

                  text:
                  "${post['username'] ?? 'User'} ",

                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                TextSpan(

                  text:
                  post['caption']
                      ?? '',

                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}