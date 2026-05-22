import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart'
as http;

class ProfileService {

  /// UPLOAD PROFILE IMAGE
  Future<String?> uploadProfileImage({

    required File imageFile,
  }) async {

    try {

      var url = Uri.parse(

        "https://api.cloudinary.com/v1_1/damza1cx4/image/upload",
      );

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
          imageFile.path,
        ),
      );

      /// PRESET
      request.fields[
      'upload_preset'] =
      'instagram_clone';

      /// SEND
      var response =
      await request.send();

      var responseData =
      await response.stream
          .bytesToString();

      var data =
      jsonDecode(responseData);

      return data['secure_url'];

    } catch (e) {

      print(
        "PROFILE IMAGE ERROR: $e",
      );

      return null;
    }
  }

  /// SAVE PROFILE IMAGE URL
  Future<void> saveProfileImage({

    required String imageUrl,
  }) async {

    try {

      String uid =

          FirebaseAuth.instance
              .currentUser!
              .uid;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .update({

        "profileImage":
        imageUrl,
      });

    } catch (e) {

      print(
        "SAVE PROFILE ERROR: $e",
      );
    }
  }
}