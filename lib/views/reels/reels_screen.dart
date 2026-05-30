import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/reel_player.dart';
import '../comments/comments_screen.dart';
import 'upload_reel_screen.dart';
import 'package:share_plus/share_plus.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../../services/reel_service.dart';

class ReelsScreen extends StatelessWidget {

  const ReelsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      /// UPLOAD REEL BUTTON
      floatingActionButton:
      FloatingActionButton(

        backgroundColor: Colors.white,

        onPressed: () {

          Navigator.push(

            context,

            MaterialPageRoute(

              builder: (context) =>

              const UploadReelScreen(),
            ),
          );
        },

        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),

      body: StreamBuilder(

        stream: FirebaseFirestore.instance
            .collection("reels")
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

          /// NO DATA
          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {

            return const Center(

              child: Text(

                "No Reels Yet",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            );
          }

          return PageView.builder(

            scrollDirection:
            Axis.vertical,

            itemCount:
            snapshot.data!.docs.length,

            itemBuilder: (context, index) {

              var reel =
              snapshot.data!.docs[index];

              Map<String, dynamic> data =

              reel.data();

              return Stack(

                fit: StackFit.expand,

                children: [

                  /// VIDEO PLAYER
                  ReelPlayer(

                    videoUrl:
                    data['videoUrl']
                        ?? '',
                  ),

                  /// DARK OVERLAY
                  Container(

                    decoration: BoxDecoration(

                      gradient:
                      LinearGradient(

                        begin:
                        Alignment.topCenter,

                        end:
                        Alignment.bottomCenter,

                        colors: [

                          Colors.black
                              .withOpacity(0.2),

                          Colors.black
                              .withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),

                  /// REEL INFO
                  Positioned(

                    left: 15,
                    bottom: 40,

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        /// USERNAME
                        Text(

                          data['username']
                              ?? '',

                          style: const TextStyle(

                            color:
                            Colors.white,

                            fontSize: 18,

                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// CAPTION
                        SizedBox(

                          width:
                          MediaQuery.of(context)
                              .size
                              .width *
                              0.7,

                          child: Text(

                            data['caption']
                                ?? '',

                            style:
                            const TextStyle(
                              color:
                              Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// RIGHT SIDE ACTIONS
              Positioned(

              right: 10,

              bottom: 80,

              child: Column(

              children: [

              /// LIKE
              Column(

              children: [

              IconButton(

              onPressed: () {

              ReelService().likeReel(

              reelId:
              data['reelId'],

              userId:
              FirebaseAuth
                  .instance
                  .currentUser!
                  .uid,

              likes:
              data['likes']
              ?? [],
              );
              },

              icon: Icon(

              (data['likes'] ?? [])

                  .contains(

              FirebaseAuth
                  .instance
                  .currentUser!
                  .uid,
              )

              ? Icons.favorite

                  : Icons.favorite_border,

              color:

              (data['likes'] ?? [])

                  .contains(

              FirebaseAuth
                  .instance
                  .currentUser!
                  .uid,
              )

              ? Colors.red

                  : Colors.white,

              size: 32,
              ),
              ),

              Text(

              "${(data['likes'] ?? []).length}",

              style:
              const TextStyle(

              color:
              Colors.white,
              ),
              ),
              ],
              ),

              const SizedBox(
              height: 20,
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
              (context) =>

                  CommentsScreen(

                    postId:
                    data['reelId'],

                    isReel:true,
                  )              ),
              );
              },

              icon:
              const Icon(

              Icons.comment,

              color:
              Colors.white,

              size: 30,
              ),
              ),

              Text(

              "${data['commentCount'] ?? 0}",

              style:
              const TextStyle(

              color:
              Colors.white,
              ),
              ),
              ],
              ),

              const SizedBox(
              height: 20,
              ),

              /// SHARE
              IconButton(

              onPressed: () {

              Share.share(

              data[
              'videoUrl'],
              );
              },

              icon:
              const Icon(

              Icons.send,

              color:
              Colors.white,

              size: 28,
              ),
              ),
              ],
              ),
              ),
              ],
              );
            },
          );
        },
      ),
    );
  }
}