import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/comment_service.dart';
import '../../widgets/comment_tile.dart';

class CommentsScreen extends StatefulWidget {

  final String postId;

  const CommentsScreen({

    super.key,

    required this.postId,
  });

  @override
  State<CommentsScreen> createState() =>
      _CommentsScreenState();
}

class _CommentsScreenState
    extends State<CommentsScreen> {

  final commentController =
  TextEditingController();

  final CommentService commentService =
  CommentService();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        backgroundColor: Colors.black,

        title: const Text(
          "Comments",

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: Column(

        children: [

          /// COMMENTS LIST
          Expanded(

            child: StreamBuilder(

              stream: FirebaseFirestore.instance
                  .collection("posts")
                  .doc(widget.postId)
                  .collection("comments")
                  .orderBy(
                "timestamp",
                descending: true,
              )
                  .snapshots(),

              builder: (context, snapshot) {

                if (!snapshot.hasData) {

                  return const Center(

                    child:
                    CircularProgressIndicator(),
                  );
                }

                return ListView.builder(

                  itemCount:
                  snapshot.data!.docs.length,

                  itemBuilder: (context, index) {

                    var comment =
                    snapshot.data!.docs[index];

                    Map<String, dynamic> data =

                    comment.data();

                    return CommentTile(

                      comment: data,

                      postId:
                      widget.postId,
                    );                  },
                );
              },
            ),
          ),

          /// COMMENT INPUT
          Padding(
            padding:
            const EdgeInsets.all(10),

            child: Row(

              children: [

                Expanded(

                  child: TextField(

                    controller:
                    commentController,

                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    decoration: InputDecoration(

                      hintText:
                      "Add a comment...",

                      hintStyle:
                      const TextStyle(
                        color: Colors.grey,
                      ),

                      filled: true,

                      fillColor:
                      Colors.grey.shade900,

                      border:
                      OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(
                            10),

                        borderSide:
                        BorderSide.none,
                      ),
                    ),
                  ),
                ),

                /// SEND BUTTON
                IconButton(

                  onPressed: () async {

                    await commentService
                        .addComment(

                      postId:
                      widget.postId,

                      comment:
                      commentController.text
                          .trim(),
                    );

                    commentController.clear();
                  },

                  icon: const Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}