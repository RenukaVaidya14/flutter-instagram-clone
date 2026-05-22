import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/comment_service.dart';

class CommentTile extends StatelessWidget {

  final Map<String, dynamic> comment;

  final String postId;

  const CommentTile({

    super.key,

    required this.comment,

    required this.postId,
  });

  @override
  Widget build(BuildContext context) {

    /// CURRENT USER
    final String currentUserId =

        FirebaseAuth.instance
            .currentUser!
            .uid;

    /// COMMENT OWNER CHECK
    bool isCommentOwner =

        comment['uid'] ==
            currentUserId;

    /// COMMENT SERVICE
    final CommentService commentService =
    CommentService();

    return GestureDetector(

      onLongPress: () {

        /// ONLY OWNER CAN DELETE
        if (isCommentOwner) {

          showDialog(

            context: context,

            builder: (context) {

              return AlertDialog(

                backgroundColor:
                Colors.grey.shade900,

                title: const Text(

                  "Delete Comment?",

                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),

                actions: [

                  TextButton(

                    onPressed: () {

                      Navigator.pop(context);
                    },

                    child: const Text(
                      "Cancel",
                    ),
                  ),

                  TextButton(

                    onPressed: () async {

                      Navigator.pop(context);

                      await commentService
                          .deleteComment(

                        postId: postId,

                        commentId:
                        comment['commentId'],
                      );
                    },

                    child: const Text(

                      "Delete",

                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
      },

      child: Padding(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),

        child: Row(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const CircleAvatar(

              radius: 18,

              backgroundColor:
              Colors.grey,

              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(

              child: RichText(

                text: TextSpan(

                  children: [

                    TextSpan(

                      text:
                      "${comment['username'] ?? 'User'} ",

                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    TextSpan(

                      text:
                      comment['comment']
                          ?? '',

                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}