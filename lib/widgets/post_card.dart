import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../services/post_service.dart';
import '../views/comments/comments_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';

class PostCard extends StatelessWidget {

  final Map<String, dynamic> post;

  const PostCard({

    super.key,

    required this.post,
  });

  /// SHARE POST
  Future<void> sharePost(

      BuildContext context,

      String imageUrl,

      String caption,

      ) async {

    try {

      final dir =

      await getTemporaryDirectory();

      final filePath =

          "${dir.path}/shared_post.jpg";

      await Dio().download(

        imageUrl,

        filePath,
      );

      await Share.shareXFiles(

        [

          XFile(filePath),
        ],

        text: caption,
      );

    } catch (e) {

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        const SnackBar(

          content:
          Text(
            "Unable to share",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final currentUserId =

        FirebaseAuth.instance
            .currentUser!
            .uid;

    final PostService postService =
    PostService();

    bool isLiked =

    (post['likes'] ?? [])
        .contains(
      currentUserId,
    );

    int commentCount =

        post['commentCount'] ??
            0;

    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        /// HEADER
        Padding(

          padding:
          const EdgeInsets.all(
            12,
          ),

          child: Row(

            children: [

              const CircleAvatar(

                backgroundColor:
                Colors.grey,

                child: Icon(

                  Icons.person,

                  color:
                  Colors.white,
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              Text(

                post['username']
                    ??
                    'User',

                style:
                const TextStyle(

                  color:
                  Colors.white,

                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const Spacer(),

              GestureDetector(

                onTap: () {

                  showModalBottomSheet(

                    context: context,

                    backgroundColor:
                    Colors.black,

                    builder: (_) {

                      return SafeArea(

                        child: Column(

                          mainAxisSize:
                          MainAxisSize.min,

                          children: [

                            ListTile(

                              leading:
                              const Icon(

                                Icons.delete,

                                color:
                                Colors.red,
                              ),

                              title:
                              const Text(

                                "Delete Post",

                                style:
                                TextStyle(

                                  color:
                                  Colors.red,
                                ),
                              ),

                              onTap: () async {

                                Navigator.pop(
                                  context,
                                );

                                try {

                                  await FirebaseFirestore
                                      .instance
                                      .collection(
                                      "posts")
                                      .doc(
                                    post[
                                    'postId'],
                                  )
                                      .delete();

                                  ScaffoldMessenger
                                      .of(
                                      context)
                                      .showSnackBar(

                                    const SnackBar(

                                      content:
                                      Text(
                                        "Post deleted",
                                      ),
                                    ),
                                  );

                                } catch (e) {

                                  ScaffoldMessenger
                                      .of(
                                      context)
                                      .showSnackBar(

                                    const SnackBar(

                                      content:
                                      Text(
                                        "Delete failed",
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },

                child: const Icon(

                  Icons.more_vert,

                  color:
                  Colors.white,
                ),
              )            ],
          ),
        ),

        /// IMAGE
        Image.network(

          post['postImage'],

          width:
          double.infinity,

          height: 350,

          fit:
          BoxFit.cover,
        ),

        /// ACTIONS
        Padding(

          padding:
          const EdgeInsets
              .symmetric(

            horizontal: 10,

            vertical: 8,
          ),

          child: Row(

            children: [

              /// LIKE
              IconButton(

                onPressed: () {

                  postService
                      .likePost(

                    postId:
                    post[
                    'postId'],

                    userId:
                    currentUserId,

                    likes:
                    post[
                    'likes'] ??
                        [],
                  );
                },

                icon: Icon(

                  isLiked

                      ? Icons
                      .favorite

                      : Icons
                      .favorite_border,

                  color:

                  isLiked

                      ? Colors
                      .red

                      : Colors
                      .white,
                ),
              ),

              /// COMMENT
              Column(

                children: [

                  IconButton(

                    onPressed: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder:
                              (

                              context,

                              ) =>

                              CommentsScreen(

                                postId:

                                post[
                                'postId'],
                              ),
                        ),
                      );
                    },

                    icon:
                    const Icon(

                      Icons
                          .comment_outlined,

                      color:
                      Colors
                          .white,
                    ),
                  ),

                  Text(

                    "$commentCount",

                    style:
                    const TextStyle(

                      color:
                      Colors
                          .white,
                    ),
                  ),
                ],
              ),

              /// SHARE
              IconButton(

                onPressed: () {

                  showModalBottomSheet(

                    context:
                    context,

                    backgroundColor:
                    Colors.black,

                    builder:
                        (_) {

                      return SafeArea(

                        child:

                        Column(

                          mainAxisSize:
                          MainAxisSize
                              .min,

                          children: [

                            const SizedBox(
                              height:
                              10,
                            ),

                            const Text(

                              "Share Post",

                              style:
                              TextStyle(

                                color:
                                Colors.white,

                                fontSize:
                                18,
                              ),
                            ),

                            ListTile(

                              leading:
                              const Icon(

                                Icons.share,

                                color:
                                Colors.white,
                              ),

                              title:
                              const Text(

                                "Share",

                                style:
                                TextStyle(

                                  color:
                                  Colors.white,
                                ),
                              ),

                              onTap:
                                  () {

                                Navigator.pop(
                                  context,
                                );

                                sharePost(

                                  context,

                                  post[
                                  'postImage'],

                                  post[
                                  'caption'] ??
                                      '',
                                );
                              },
                            ),

                            ListTile(

                              leading:
                              const Icon(

                                Icons.download,

                                color:
                                Colors.white,
                              ),

                              title:
                              const Text(

                                "Download",

                                style:
                                TextStyle(

                                  color:
                                  Colors.white,
                                ),
                              ),

                              onTap:
                                  () {

                                Navigator.pop(
                                  context,
                                );

                                sharePost(

                                  context,

                                  post[
                                  'postImage'],

                                  "",
                                );
                              },
                            ),

                            const SizedBox(
                              height:
                              20,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },

                icon:
                const Icon(

                  Icons.send,

                  color:
                  Colors.white,
                ),
              ),

              const Spacer(),

              /// SAVE
              IconButton(

                onPressed: () {},

                icon:
                const Icon(

                  Icons
                      .bookmark_border,

                  color:
                  Colors
                      .white,
                ),
              ),
            ],
          ),
        ),

        /// LIKES
        Padding(

          padding:
          const EdgeInsets
              .symmetric(

            horizontal: 15,
          ),

          child: Text(

            "${(post['likes'] ?? []).length} likes",

            style:
            const TextStyle(

              color:
              Colors.white,

              fontWeight:
              FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(
          height: 5,
        ),

        /// CAPTION
        Padding(

          padding:
          const EdgeInsets
              .symmetric(

            horizontal: 15,
          ),

          child: Text.rich(

            TextSpan(

              children: [

                TextSpan(

                  text:
                  "${post['username']} ",

                  style:
                  const TextStyle(

                    fontWeight:
                    FontWeight.bold,

                    color:
                    Colors.white,
                  ),
                ),

                TextSpan(

                  text:
                  post[
                  'caption'] ??
                      '',

                  style:
                  const TextStyle(

                    color:
                    Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}