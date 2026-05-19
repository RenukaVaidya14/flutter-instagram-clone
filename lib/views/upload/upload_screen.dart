import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'
as http;
import 'package:image_picker/image_picker.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() =>
      _UploadScreenState();
}

class _UploadScreenState
    extends State<UploadScreen> {

  File? selectedImage;

  final captionController =
  TextEditingController();

  bool isLoading = false;

  /// PICK IMAGE
  Future<void> pickImage() async {

    final pickedFile =
    await ImagePicker().pickImage(

      source: ImageSource.gallery,
    );

    if (pickedFile != null) {

      setState(() {

        selectedImage =
            File(pickedFile.path);
      });
    }
  }

  /// REMOVE IMAGE
  void removeImage() {

    setState(() {

      selectedImage = null;
    });
  }

  /// UPLOAD POST
  Future<void> uploadPost() async {

    if (selectedImage == null) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
          Text("Please select image"),
        ),
      );

      return;
    }

    try {

      setState(() {
        isLoading = true;
      });

      /// CURRENT USER
      User? currentUser =
          FirebaseAuth.instance.currentUser;

      if (currentUser == null) {

        throw Exception(
            "User not logged in");
      }

      /// UNIQUE POST ID
      String postId =
      DateTime.now()
          .millisecondsSinceEpoch
          .toString();

      /// CLOUDINARY URL
      var url = Uri.parse(
        "https://api.cloudinary.com/v1_1/damza1cx4/image/upload",
      );

      /// REQUEST
      var request =
      http.MultipartRequest(
        "POST",
        url,
      );

      /// IMAGE FILE
      request.files.add(

        await http.MultipartFile
            .fromPath(
          "file",
          selectedImage!.path,
        ),
      );

      /// UPLOAD PRESET
      request.fields['upload_preset'] =
      'instagram_clone';

      /// SEND REQUEST
      var response =
      await request.send();

      /// RESPONSE
      var responseData =
      await response.stream.bytesToString();

      var data =
      jsonDecode(responseData);

      /// IMAGE URL
      String imageUrl =
      data['secure_url'];

      /// SAVE TO FIRESTORE
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(postId)
          .set({

        "postId": postId,

        "uid": currentUser.uid,

        "username": "renu",

        "caption":
        captionController.text.trim(),

        "postImage": imageUrl,

        "timestamp":
        DateTime.now().toString(),

        "likes": [],
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
          Text("Post Uploaded Successfully"),
        ),
      );

      /// CLEAR DATA
      captionController.clear();

      removeImage();

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content:
          Text(e.toString()),
        ),
      );

      debugPrint(
          "UPLOAD ERROR: $e");

    } finally {

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        backgroundColor: Colors.black,

        elevation: 0,

        title: const Text(
          "New Post",

          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [

          TextButton(

            onPressed:
            isLoading
                ? null
                : uploadPost,

            child: isLoading

                ? const SizedBox(

              height: 20,
              width: 20,

              child:
              CircularProgressIndicator(
                color: Colors.blue,
                strokeWidth: 2,
              ),
            )

                : const Text(
              "Share",

              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight:
                FontWeight.bold,
              ),
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

              /// IMAGE SECTION
              GestureDetector(

                onTap: pickImage,

                child: Container(

                  height: 300,
                  width: double.infinity,

                  decoration: BoxDecoration(

                    color:
                    Colors.grey.shade900,

                    borderRadius:
                    BorderRadius.circular(
                        10),
                  ),

                  child:
                  selectedImage != null

                      ? ClipRRect(

                    borderRadius:
                    BorderRadius.circular(
                        10),

                    child: Image.file(

                      selectedImage!,

                      fit: BoxFit.cover,
                    ),
                  )

                      : Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: const [

                      Icon(
                        Icons.add_photo_alternate,

                        color:
                        Colors.white54,

                        size: 70,
                      ),

                      SizedBox(height: 10),

                      Text(
                        "Tap to select image",

                        style: TextStyle(
                          color:
                          Colors.white54,

                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// CAPTION
              TextField(

                controller:
                captionController,

                maxLines: 4,

                style: const TextStyle(
                  color: Colors.white,
                ),

                decoration: InputDecoration(

                  hintText:
                  "Write a caption...",

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

              const SizedBox(height: 20),

              /// REMOVE IMAGE BUTTON
              if (selectedImage != null)

                SizedBox(
                  width: double.infinity,

                  child: OutlinedButton(

                    style:
                    OutlinedButton.styleFrom(

                      side: const BorderSide(
                        color: Colors.red,
                      ),
                    ),

                    onPressed: removeImage,

                    child: const Text(
                      "Remove Image",

                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}