import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/comment_service.dart';
import '../../widgets/comment_tile.dart';

class CommentsScreen
    extends StatefulWidget {

  final String postId;

  final bool isReel;

  const CommentsScreen({

    super.key,

    required this.postId,

    this.isReel = false,
  });

  @override
  State<CommentsScreen> createState() =>
      _CommentsScreenState();
}

class _CommentsScreenState
    extends State<CommentsScreen> {

  final commentController =
  TextEditingController();

  final CommentService
  commentService =
  CommentService();

  @override
  void dispose() {

    commentController.dispose();

    super.dispose();
  }

  @override
  Widget build(
      BuildContext context) {

    String collection =

    widget.isReel

        ? "reels"

        : "posts";

    return Scaffold(

      backgroundColor:
      Colors.black,

      appBar: AppBar(

        backgroundColor:
        Colors.black,

        title: const Text(

          "Comments",

          style: TextStyle(
            color:
            Colors.white,
          ),
        ),
      ),

      body: Column(

        children: [

          /// COMMENTS
          Expanded(

            child:
            StreamBuilder(

              stream:
              FirebaseFirestore
                  .instance
                  .collection(
                  collection)
                  .doc(
                widget
                    .postId,
              )
                  .collection(
                  "comments")
                  .orderBy(

                "timestamp",

                descending:
                true,
              )
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

                if (snapshot
                    .data!
                    .docs
                    .isEmpty) {

                  return const Center(

                    child:
                    Text(

                      "No comments",

                      style:
                      TextStyle(

                        color:
                        Colors.white,
                      ),
                    ),
                  );
                }

                return ListView
                    .builder(

                  reverse:
                  true,

                  itemCount:

                  snapshot
                      .data!
                      .docs
                      .length,

                  itemBuilder:

                      (

                      context,

                      index,

                      ) {

                    Map<
                        String,

                        dynamic>

                    data =

                    snapshot
                        .data!
                        .docs[
                    index]
                        .data()

                    as Map<
                        String,

                        dynamic>;

                    return CommentTile(

                      comment:
                      data,

                      postId:
                      widget
                          .postId,
                    );
                  },
                );
              },
            ),
          ),

          /// INPUT
          Container(

            padding:
            const EdgeInsets
                .all(
              12,
            ),

            color:
            Colors.black,

            child: Row(

              children: [

                Expanded(

                  child:
                  TextField(

                    controller:
                    commentController,

                    style:
                    const TextStyle(

                      color:
                      Colors.white,
                    ),

                    decoration:
                    InputDecoration(

                      hintText:
                      "Add comment",

                      hintStyle:
                      const TextStyle(

                        color:
                        Colors.grey,
                      ),

                      filled:
                      true,

                      fillColor:
                      Colors.grey
                          .shade900,

                      border:
                      OutlineInputBorder(

                        borderRadius:
                        BorderRadius
                            .circular(
                          10,
                        ),

                        borderSide:
                        BorderSide
                            .none,
                      ),
                    ),
                  ),
                ),

                IconButton(

                  onPressed:
                      () async {

                    if (commentController
                        .text
                        .trim()
                        .isEmpty) {

                      return;
                    }

                    await commentService
                        .addComment(

                      postId:
                      widget
                          .postId,

                      comment:
                      commentController
                          .text,

                      isReel:
                      widget
                          .isReel,
                    );

                    commentController
                        .clear();
                  },

                  icon:
                  const Icon(

                    Icons.send,

                    color:
                    Colors.blue,
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