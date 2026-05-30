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

      String reelId =

      DateTime.now()
          .millisecondsSinceEpoch
          .toString();

      var url = Uri.parse(

        "https://api.cloudinary.com/v1_1/damza1cx4/video/upload",
      );

      var request =
      http.MultipartRequest(

        "POST",

        url,
      );

      request.files.add(

        await http.MultipartFile
            .fromPath(

          "file",

          videoFile.path,
        ),
      );

      request.fields[
      'upload_preset'
      ] =

      'instagram_clone';

      var response =
      await request.send();

      var responseData =

      await response.stream
          .bytesToString();

      var data =

      jsonDecode(
        responseData,
      );

      String videoUrl =

      data[
      'secure_url'
      ];

      /// SAVE REEL
      await FirebaseFirestore
          .instance
          .collection(
        "reels",
      )
          .doc(
        reelId,
      )
          .set({

        "reelId":
        reelId,

        "videoUrl":
        videoUrl,

        "caption":
        caption,

        "username":
        "renu",

        "likes":
        [],

        "commentCount":
        0,

        "timestamp":
        FieldValue
            .serverTimestamp(),
      });

    }

    catch (e) {

      print(

        "UPLOAD ERROR: $e",
      );
    }
  }

  /// LIKE REEL
  Future<void> likeReel({

    required String reelId,

    required String userId,

    required List likes,

  }) async {

    try {

      if (

      likes.contains(
        userId,
      )

      ) {

        await FirebaseFirestore
            .instance
            .collection(
          "reels",
        )
            .doc(
          reelId,
        )
            .update({

          "likes":

          FieldValue
              .arrayRemove(

            [
              userId,
            ],
          ),
        });

      }

      else {

        await FirebaseFirestore
            .instance
            .collection(
          "reels",
        )
            .doc(
          reelId,
        )
            .update({

          "likes":

          FieldValue
              .arrayUnion(

            [
              userId,
            ],
          ),
        });
      }

    }

    catch (e) {

      print(

        "LIKE ERROR: $e",
      );
    }
  }

  /// UPDATE COMMENT COUNT
  Future<void>
  updateCommentCount({

    required String reelId,

  }) async {

    try {

      await FirebaseFirestore
          .instance
          .collection(
        "reels",
      )
          .doc(
        reelId,
      )
          .update({

        "commentCount":

        FieldValue
            .increment(
          1,
        ),
      });

    }

    catch (e) {

      print(

        "COMMENT ERROR: $e",
      );
    }
  }
}