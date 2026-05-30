import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileScreen
    extends StatefulWidget {

  final Map<String, dynamic> userData;

  const EditProfileScreen({

    super.key,

    required this.userData,
  });

  @override
  State<EditProfileScreen>
  createState() =>

      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {

  late TextEditingController
  usernameController;

  late TextEditingController
  bioController;

  @override
  void initState() {

    super.initState();

    usernameController =
        TextEditingController(

          text:
          widget.userData[
          'username'] ??
              '',
        );

    bioController =
        TextEditingController(

          text:
          widget.userData[
          'bio'] ??
              '',
        );
  }

  Future<void>
  updateProfile() async {

    String uid =
        FirebaseAuth.instance
            .currentUser!
            .uid;

    await FirebaseFirestore
        .instance
        .collection("users")
        .doc(uid)
        .update({

      "username":
      usernameController
          .text
          .trim(),

      "bio":
      bioController
          .text
          .trim(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      backgroundColor:
      Colors.black,

      appBar: AppBar(

        backgroundColor:
        Colors.black,

        title:
        const Text(
          "Edit Profile",
        ),

        actions: [

          TextButton(

            onPressed:
            updateProfile,

            child:
            const Text(
              "Save",
            ),
          ),
        ],
      ),

      body: Padding(

        padding:
        const EdgeInsets
            .all(20),

        child: Column(

          children: [

            TextField(

              controller:
              usernameController,

              decoration:
              const InputDecoration(

                labelText:
                "Username",
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            TextField(

              controller:
              bioController,

              decoration:
              const InputDecoration(

                labelText:
                "Bio",
              ),
            ),
          ],
        ),
      ),
    );
  }
}