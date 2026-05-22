import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/follow_service.dart';

class UserProfileScreen
    extends StatelessWidget {

  final Map<String, dynamic> userData;

  const UserProfileScreen({

    super.key,

    required this.userData,
  });

  @override
  Widget build(BuildContext context) {

    /// CURRENT USER
    final String currentUserId =

        FirebaseAuth.instance
            .currentUser!
            .uid;

    /// FOLLOW CHECK
    bool isFollowing =

    (userData['followers'] ?? [])
        .contains(currentUserId);

    /// FOLLOW SERVICE
    final FollowService followService =
    FollowService();

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        backgroundColor: Colors.black,

        title: Text(

          userData['username']
              ?? '',

          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: Padding(
        padding:
        const EdgeInsets.all(20),

        child: Column(

          children: [

            const CircleAvatar(

              radius: 50,

              backgroundColor:
              Colors.grey,

              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            Text(

              userData['username']
                  ?? '',

              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(

              userData['email']
                  ?? '',

              style: const TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 20),

            /// FOLLOWERS / FOLLOWING
            Row(

              mainAxisAlignment:
              MainAxisAlignment.center,

              children: [

                Column(

                  children: [

                    Text(

                      "${(userData['followers'] ?? []).length}",

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const Text(

                      "Followers",

                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 40),

                Column(

                  children: [

                    Text(

                      "${(userData['following'] ?? []).length}",

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const Text(

                      "Following",

                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// FOLLOW BUTTON
            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:

                  isFollowing

                      ? Colors.grey.shade800

                      : Colors.blue,
                ),

                onPressed: () {

                  followService.followUser(

                    currentUserId:
                    currentUserId,

                    targetUserId:
                    userData['uid'],

                    followers:
                    userData['followers']
                        ?? [],
                  );
                },

                child: Text(

                  isFollowing

                      ? "Following"

                      : "Follow",

                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}