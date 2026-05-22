import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart'
as http;

class ReelService {

  /// UPLOAD REEL
  Future<void> uploadReel({

    required File videoFile,

    required String caption,
  }) async {

    try {

      /// UNIQUE ID
      String reelId =

      DateTime.now()
          .millisecondsSinceEpoch
          .toString();

      /// CLOUDINARY URL
      var url = Uri.parse(

        "https://api.cloudinary.com/v1_1/damza1cx4/video/upload",
      );

      /// REQUEST
      var request =
      http.MultipartRequest(
        "POST",
        url,
      );

      /// VIDEO FILE
      request.files.add(

        await http.MultipartFile
            .fromPath(
          "file",
          videoFile.path,
        ),
      );

      /// PRESET
      request.fields[
      'upload_preset'] =
      'instagram_clone';

      /// SEND
      var response =
      await request.send();

      /// RESPONSE
      var responseData =
      await response.stream
          .bytesToString();

      var data =
      jsonDecode(responseData);

      String videoUrl =
      data['secure_url'];

      /// SAVE FIRESTORE
      await FirebaseFirestore.instance
          .collection("reels")
          .doc(reelId)
          .set({

        "reelId": reelId,

        "videoUrl": videoUrl,

        "caption": caption,

        "username": "renu",

        "timestamp":
        FieldValue.serverTimestamp(),
      });

    } catch (e) {

      print(
        "REEL ERROR: $e",
      );
    }
  }
}