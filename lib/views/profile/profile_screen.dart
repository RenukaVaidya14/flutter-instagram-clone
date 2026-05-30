import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/profile_service.dart';
import '../auth/login_screen.dart';
import '../saved/saved_screen.dart';
import 'profile_posts_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  File? profileImage;

  final currentUser =

      FirebaseAuth.instance
          .currentUser;

  /// PICK IMAGE
  Future<void> pickImage() async {

    try {

      final pickedImage =

      await ImagePicker()
          .pickImage(

        source: ImageSource.gallery,
      );

      if (pickedImage == null) return;

      File imageFile =
      File(pickedImage.path);

      /// LOCAL UI UPDATE
      setState(() {

        profileImage =
            imageFile;
      });

      print(
        "IMAGE PICKED",
      );

      /// UPLOAD CLOUDINARY
      String? imageUrl =

      await ProfileService()
          .uploadProfileImage(

        imageFile: imageFile,
      );

      print(
        "IMAGE URL: $imageUrl",
      );

      /// SAVE FIRESTORE
      if (imageUrl != null &&
          imageUrl.isNotEmpty) {

        await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser!.uid)
            .set({

          "profileImage":
          imageUrl,

        }, SetOptions(
          merge: true,
        ));

        print(
          "PROFILE IMAGE SAVED",
        );

        setState(() {});
      }

    } catch (e) {

      print(
        "PROFILE IMAGE ERROR: $e",
      );
    }
  }

  /// REMOVE IMAGE
  Future<void> deleteImage() async {

    setState(() {

      profileImage = null;
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.uid)
        .update({

      "profileImage": "",
    });
  }

  /// MENU OPTIONS
  void showProfileOptions() {

    showGeneralDialog(

      context: context,

      barrierDismissible: true,

      barrierLabel: "Menu",

      transitionDuration:
      const Duration(
        milliseconds: 300,
      ),

      pageBuilder:
          (
          context,
          animation,
          secondaryAnimation,
          ) {

        return Align(

          alignment:
          Alignment.centerRight,

          child: Material(

            color:
            Colors.grey.shade900,

            child: Container(

              width:
              MediaQuery.of(
                context,
              ).size.width *
                  0.7,

              padding:
              const EdgeInsets.only(
                top: 60,
              ),

              child: Column(

                children: [

                  ListTile(

                    leading:
                    const Icon(

                      Icons.bookmark,

                      color:
                      Colors.white,
                    ),

                    title:
                    const Text(

                      "Saved",

                      style:
                      TextStyle(
                        color:
                        Colors.white,
                      ),
                    ),

                    onTap: () {

                      Navigator.pop(
                        context,
                      );

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder:
                              (_) =>

                          const SavedScreen(),
                        ),
                      );
                    },
                  ),

                  ListTile(

                    leading:
                    const Icon(

                      Icons.logout,

                      color:
                      Colors.red,
                    ),

                    title:
                    const Text(

                      "Logout",

                      style:
                      TextStyle(
                        color:
                        Colors.red,
                      ),
                    ),

                    onTap:
                        () async {

                      await FirebaseAuth
                          .instance
                          .signOut();

                      Navigator
                          .pushAndRemoveUntil(

                        context,

                        MaterialPageRoute(

                          builder:
                              (

                              context,

                              ) =>

                          const LoginScreen(),
                        ),

                            (route) =>
                        false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },

      transitionBuilder:

          (
          context,
          animation,
          secondaryAnimation,
          child,
          ) {

        return SlideTransition(

          position:
          Tween<Offset>(

            begin:
            const Offset(
              1,
              0,
            ),

            end:
            Offset.zero,
          ).animate(
            animation,
          ),

          child: child,
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {

    return StreamBuilder(

      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser!.uid)
          .snapshots(),

      builder: (context, userSnapshot) {

        if (!userSnapshot.hasData) {

          return const Scaffold(

            backgroundColor:
            Colors.black,

            body: Center(

              child:
              CircularProgressIndicator(),
            ),
          );
        }

        /// FIRESTORE USER DATA
        Map<String, dynamic> userData =

            userSnapshot.data?.data()

            as Map<String, dynamic>? ??

                {};

        return Scaffold(

          backgroundColor: Colors.black,

          appBar: AppBar(

            backgroundColor:
            Colors.black,

            elevation: 0,

            title: Text(

              userData['username']
                  ?? 'User',

              style: const TextStyle(

                color: Colors.white,

                fontWeight:
                FontWeight.bold,
              ),
            ),

            actions: [

              IconButton(

                onPressed:
                showProfileOptions,

                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          body: StreamBuilder(

            stream: FirebaseFirestore.instance
                .collection("posts")
                .where(
              "uid",
              isEqualTo:
              currentUser!.uid,
            )
                .snapshots(),

            builder: (context, postSnapshot) {

              if (!postSnapshot.hasData) {

                return const Center(

                  child:
                  CircularProgressIndicator(),
                );
              }

              var posts =
                  postSnapshot.data!.docs;

              return SingleChildScrollView(

                child: Padding(
                  padding:
                  const EdgeInsets.all(
                      15),

                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                    children: [

                      /// TOP PROFILE SECTION
                      Row(

                        children: [

                          /// PROFILE IMAGE
                          GestureDetector(

                            onLongPress: pickImage,

                            child:
                            CircleAvatar(

                              radius: 45,

                              backgroundColor:
                              Colors.grey
                                  .shade800,

                              backgroundImage:

                              userData[
                              'profileImage'] !=
                                  null &&
                                  userData[
                                  'profileImage'] !=
                                      ""

                                  ? NetworkImage(
                                userData[
                                'profileImage'],
                              )

                                  : null,

                              child:

                              userData[
                              'profileImage'] ==
                                  null ||
                                  userData[
                                  'profileImage'] ==
                                      ""

                                  ? const Icon(
                                Icons.person,

                                size: 45,

                                color:
                                Colors
                                    .white,
                              )

                                  : null,
                            ),
                          ),

                          const Spacer(),

                          /// POSTS
                          Column(

                            children: [

                              Text(

                                posts.length
                                    .toString(),

                                style:
                                const TextStyle(

                                  color:
                                  Colors.white,

                                  fontSize: 20,

                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                  height: 5),

                              const Text(

                                "Posts",

                                style:
                                TextStyle(
                                  color:
                                  Colors.white,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                              width: 25),

                          /// FOLLOWERS
                          Column(

                            children: [

                              Text(

                                "${(userData['followers'] ?? []).length}",

                                style:
                                const TextStyle(

                                  color:
                                  Colors.white,

                                  fontSize: 20,

                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                  height: 5),

                              const Text(

                                "Followers",

                                style:
                                TextStyle(
                                  color:
                                  Colors.white,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                              width: 25),

                          /// FOLLOWING
                          Column(

                            children: [

                              Text(

                                "${(userData['following'] ?? []).length}",

                                style:
                                const TextStyle(

                                  color:
                                  Colors.white,

                                  fontSize: 20,

                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                  height: 5),

                              const Text(

                                "Following",

                                style:
                                TextStyle(
                                  color:
                                  Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// USERNAME
                      Text(

                        userData['username']
                            ?? '',

                        style:
                        const TextStyle(

                          color: Colors.white,

                          fontSize: 16,

                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      /// BIO
                      Text(

                        userData['bio']
                            ?? '',

                        style:
                        const TextStyle(
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// EDIT PROFILE
                      SizedBox(

                        width:
                        double.infinity,

                        child:
                        OutlinedButton(

                          style:
                          OutlinedButton
                              .styleFrom(

                            side: BorderSide(
                              color:
                              Colors.grey
                                  .shade700,
                            ),
                          ),

                          onPressed: () {

                            Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder: (context) =>

                                    EditProfileScreen(

                                      userData: userData,
                                    ),
                              ),
                            );
                          },
                          child: const Text(

                            "Edit Profile",

                            style: TextStyle(
                              color:
                              Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Divider(
                        color:
                        Colors.grey
                            .shade800,
                      ),

                      const SizedBox(height: 5),

                      /// POSTS GRID
                      GridView.builder(

                        shrinkWrap: true,

                        physics:
                        const NeverScrollableScrollPhysics(),

                        itemCount:
                        posts.length,

                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(

                          crossAxisCount: 3,

                          crossAxisSpacing:
                          5,

                          mainAxisSpacing:
                          5,
                        ),

                        itemBuilder:
                            (context, index) {

                          var post =
                          posts[index];

                          return GestureDetector(

                            onTap: () {

                              Navigator.push(

                                context,

                                MaterialPageRoute(

                                  builder: (_) =>

                                      ProfilePostsScreen(

                                        posts: posts,

                                        initialIndex: index,
                                      ),
                                ),
                              );
                            },

                            child: ClipRRect(

                              borderRadius:
                              BorderRadius.circular(
                                2,
                              ),

                              child: Image.network(

                                post['postImage'],

                                fit: BoxFit.cover,

                                loadingBuilder:

                                    (

                                    context,

                                    child,

                                    progress,

                                    ) {

                                  if (progress == null) {

                                    return child;
                                  }

                                  return Container(

                                    color:
                                    Colors.grey
                                        .shade900,

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

                                    color:
                                    Colors.grey
                                        .shade900,

                                    child:
                                    const Icon(

                                      Icons.image,

                                      color:
                                      Colors.white54,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                          },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}