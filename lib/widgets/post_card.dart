import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../services/post_service.dart';
import '../views/comments/comments_screen.dart';
import '../services/save_service.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final PostService postService = PostService();

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
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
          Text("Unable to share"),
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

    bool isLiked =
    (widget.post['likes'] ?? [])
        .contains(
      currentUserId,
    );

    int commentCount =
        widget.post[
        'commentCount'] ??
            0;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        /// HEADER
        Padding(
          padding:
          const EdgeInsets.all(
              12),

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
                  width: 10),

              Text(
                widget.post[
                'username'] ??
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

              const Icon(
                Icons.more_vert,
                color:
                Colors.white,
              ),
            ],
          ),
        ),

        /// IMAGE
        Image.network(
          widget.post[
          'postImage'],

          width:
          double.infinity,

          height: 350,

          fit:
          BoxFit.cover,
        ),

        /// ACTIONS
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),

          child: StatefulBuilder(

            builder: (
                context,
                setLocalState,
                ) {

              bool isLiked =
              (widget.post['likes'] ?? [])
                  .contains(
                currentUserId,
              );

              return Row(

                children: [

                  /// LIKE
                  IconButton(

                    onPressed: () async {

                      try {

                        List likes =
                        List.from(
                            widget.post[
                            'likes'] ??
                                []);

                        if (
                        likes.contains(
                            currentUserId
                        )
                        ) {

                          likes.remove(
                              currentUserId);

                        } else {

                          likes.add(
                              currentUserId);

                        }

                        setLocalState(() {

                          widget.post[
                          'likes'] =
                              likes;

                        });

                        await postService
                            .likePost(

                          postId:
                          widget.post[
                          'postId'],

                          userId:
                          currentUserId,

                          likes:
                          likes,
                        );

                      } catch (e) {

                        ScaffoldMessenger
                            .of(context)
                            .showSnackBar(

                          SnackBar(
                            content:
                            Text(
                                e.toString()),
                          ),
                        );
                      }
                    },

                    icon: Icon(

                      isLiked
                          ? Icons.favorite
                          : Icons
                          .favorite_border,

                      color:

                      isLiked
                          ? Colors.red
                          : Colors.white,
                    ),
                  ),

                  /// COMMENT
                  Column(

                    children: [

                      IconButton(

                        onPressed: () {

                          print(
                              widget.post);

                          if (

                          widget.post[
                          'postId']

                              ==

                              null

                          ) {

                            ScaffoldMessenger
                                .of(
                                context)

                                .showSnackBar(

                              const SnackBar(

                                content:
                                Text(
                                  "postId missing",
                                ),
                              ),
                            );

                            return;
                          }

                          Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder:
                                  (

                                  _,

                                  ) =>

                                  CommentsScreen(

                                    postId:

                                    widget.post[
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
                          Colors.white,
                        ),
                      ),

                      Text(

                        "${widget.post['commentCount'] ?? 0}",

                        style:
                        const TextStyle(

                          color:
                          Colors.white,
                        ),
                      ),
                    ],
                  ),

                  /// SHARE
                  IconButton(

                    onPressed:
                        () {

                      sharePost(

                        context,

                        widget.post[
                        'postImage'],

                        widget.post[
                        'caption'] ??
                            '',
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

                  FutureBuilder(

                    future: SaveService()
                        .isPostSaved(
                      widget.post['postId'],
                    ),

                    builder: (context, snapshot) {

                      bool isSaved =
                          (snapshot.data as bool?) ?? false;

                      return IconButton(

                        onPressed: () async {

                          await SaveService()
                              .toggleSavePost(

                            postId:
                            widget.post['postId'],
                          );

                          setState(() {});
                        },

                        icon: Icon(

                          isSaved

                              ? Icons.bookmark

                              : Icons.bookmark_border,

                          color: Colors.white,
                        ),
                      );
                    },
                  )
                ],
              );
            },
          ),
        ),
        /// LIKE COUNT
        Padding(
          padding:
          const EdgeInsets
              .symmetric(
            horizontal: 15,
          ),

          child: Text(

            "${(widget.post['likes'] ?? []).length} likes",

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
            height: 5),

        /// CAPTION
        Padding(

          padding:
          const EdgeInsets
              .symmetric(
            horizontal: 15,
          ),

          child:
          Text.rich(

            TextSpan(

              children: [

                TextSpan(

                  text:
                  "${widget.post['username']} ",

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
                  widget.post[
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
            height: 20),
      ],
    );
  }
}