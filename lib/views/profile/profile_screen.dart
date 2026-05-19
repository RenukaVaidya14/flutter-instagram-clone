import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  File? profileImage;

  /// PICK IMAGE
  Future<void> pickImage() async {

    final pickedImage =
    await ImagePicker().pickImage(

      source: ImageSource.gallery,
    );

    if (pickedImage != null) {

      setState(() {

        profileImage =
            File(pickedImage.path);
      });
    }
  }

  /// DELETE IMAGE
  void deleteImage() {

    setState(() {

      profileImage = null;
    });
  }

  /// SHOW OPTIONS
  void showProfileOptions() {

    showModalBottomSheet(

      context: context,

      backgroundColor:
      Colors.grey.shade900,

      builder: (context) {

        return SafeArea(

          child: Wrap(
            children: [

              /// CHANGE PHOTO
              ListTile(

                leading: const Icon(
                  Icons.photo,

                  color: Colors.white,
                ),

                title: const Text(
                  "Change Profile Photo",

                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),

                onTap: () {

                  Navigator.pop(context);

                  pickImage();
                },
              ),

              /// REMOVE PHOTO
              if (profileImage != null)

                ListTile(

                  leading: const Icon(
                    Icons.delete,

                    color: Colors.red,
                  ),

                  title: const Text(
                    "Remove Photo",

                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),

                  onTap: () {

                    Navigator.pop(context);

                    deleteImage();
                  },
                ),

              /// CANCEL
              ListTile(

                leading: const Icon(
                  Icons.close,

                  color: Colors.white,
                ),

                title: const Text(
                  "Cancel",

                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),

                onTap: () {

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        backgroundColor: Colors.black,

        elevation: 0,

        title: const Text(
          "renu",

          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [

          IconButton(
            onPressed: () {},

            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.all(15),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              /// TOP PROFILE SECTION
              Row(
                children: [

                  /// PROFILE IMAGE
                  GestureDetector(

                    onLongPress:
                    showProfileOptions,

                    child: CircleAvatar(

                      radius: 45,

                      backgroundColor:
                      Colors.grey.shade800,

                      backgroundImage:
                      profileImage != null

                          ? FileImage(
                        profileImage!,
                      )

                          : null,

                      child:
                      profileImage == null

                          ? const Icon(
                        Icons.person,

                        size: 45,

                        color:
                        Colors.white,
                      )

                          : null,
                    ),
                  ),

                  const Spacer(),

                  /// POSTS
                  const Column(
                    children: [

                      Text(
                        "0",

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        "Posts",

                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 25),

                  /// FOLLOWERS
                  const Column(
                    children: [

                      Text(
                        "0",

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        "Followers",

                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 25),

                  /// FOLLOWING
                  const Column(
                    children: [

                      Text(
                        "0",

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        "Following",

                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// USERNAME
              const Text(
                "renu",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              /// BIO
              const Text(
                "Flutter Developer 🚀",

                style: TextStyle(
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              /// EDIT PROFILE BUTTON
              SizedBox(
                width: double.infinity,

                child: OutlinedButton(

                  style:
                  OutlinedButton.styleFrom(

                    side: BorderSide(
                      color:
                      Colors.grey.shade700,
                    ),
                  ),

                  onPressed: () {},

                  child: const Text(
                    "Edit Profile",

                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// DIVIDER
              Divider(
                color: Colors.grey.shade800,
              ),

              const SizedBox(height: 15),

              /// POSTS GRID PLACEHOLDER
              GridView.builder(

                shrinkWrap: true,

                physics:
                const NeverScrollableScrollPhysics(),

                itemCount: 9,

                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(

                  crossAxisCount: 3,

                  crossAxisSpacing: 5,

                  mainAxisSpacing: 5,
                ),

                itemBuilder: (context, index) {

                  return Container(

                    color: Colors.grey.shade900,

                    child: const Icon(
                      Icons.image,

                      color: Colors.white54,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}