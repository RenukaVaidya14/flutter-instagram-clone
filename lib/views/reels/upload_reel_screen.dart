import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/reel_service.dart';

class UploadReelScreen
    extends StatefulWidget {

  const UploadReelScreen({
    super.key,
  });

  @override
  State<UploadReelScreen> createState() =>
      _UploadReelScreenState();
}

class _UploadReelScreenState
    extends State<UploadReelScreen> {

  File? videoFile;

  final captionController =
  TextEditingController();

  bool isLoading = false;

  /// PICK VIDEO
  Future<void> pickVideo() async {

    final pickedVideo =

    await ImagePicker()
        .pickVideo(

      source: ImageSource.gallery,
    );

    if (pickedVideo != null) {

      setState(() {

        videoFile =
            File(pickedVideo.path);
      });
    }
  }

  /// UPLOAD REEL
  Future<void> uploadReel() async {

    if (videoFile == null) return;

    setState(() {
      isLoading = true;
    });

    await ReelService().uploadReel(

      videoFile: videoFile!,

      caption:
      captionController.text.trim(),
    );

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(
        content:
        Text("Reel Uploaded"),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        backgroundColor: Colors.black,

        title: const Text(
          "Upload Reel",

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: Padding(
        padding:
        const EdgeInsets.all(20),

        child: Column(

          children: [

            /// VIDEO PREVIEW
            GestureDetector(

              onTap: pickVideo,

              child: Container(

                height: 300,

                width: double.infinity,

                decoration: BoxDecoration(

                  color:
                  Colors.grey.shade900,

                  borderRadius:
                  BorderRadius.circular(
                      15),
                ),

                child: videoFile == null

                    ? const Column(

                  mainAxisAlignment:
                  MainAxisAlignment
                      .center,

                  children: [

                    Icon(
                      Icons.video_library,
                      color:
                      Colors.white,
                      size: 60,
                    ),

                    SizedBox(height: 10),

                    Text(

                      "Select Reel Video",

                      style: TextStyle(
                        color:
                        Colors.white,
                      ),
                    ),
                  ],
                )

                    : const Center(

                  child: Text(

                    "Video Selected ✅",

                    style: TextStyle(
                      color:
                      Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// CAPTION
            TextField(

              controller:
              captionController,

              style: const TextStyle(
                color: Colors.white,
              ),

              decoration: InputDecoration(

                hintText:
                "Write caption...",

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

            const SizedBox(height: 30),

            /// UPLOAD BUTTON
            SizedBox(

              width: double.infinity,

              height: 50,

              child: ElevatedButton(

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  Colors.blue,
                ),

                onPressed:

                isLoading

                    ? null

                    : uploadReel,

                child:

                isLoading

                    ? const CircularProgressIndicator(
                  color:
                  Colors.white,
                )

                    : const Text(

                  "Upload Reel",

                  style: TextStyle(
                    color:
                    Colors.white,
                    fontSize: 18,
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