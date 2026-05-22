import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';

class ReelPlayer
    extends StatefulWidget {

  final String videoUrl;

  const ReelPlayer({

    super.key,

    required this.videoUrl,
  });

  @override
  State<ReelPlayer> createState() =>
      _ReelPlayerState();
}

class _ReelPlayerState
    extends State<ReelPlayer> {

  late CachedVideoPlayerPlusController
  controller;

  @override
  void initState() {

    super.initState();

    controller =
    CachedVideoPlayerPlusController
        .networkUrl(

      Uri.parse(widget.videoUrl),
    )

      ..initialize().then((_) {

        setState(() {});
      });

    controller.play();

    controller.setLooping(true);
  }

  @override
  void dispose() {

    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (!controller
        .value
        .isInitialized) {

      return const Center(

        child:
        CircularProgressIndicator(),
      );
    }

    return SizedBox.expand(

      child: FittedBox(

        fit: BoxFit.cover,

        child: SizedBox(

          width:
          controller
              .value
              .size
              .width,

          height:
          controller
              .value
              .size
              .height,

          child:
          CachedVideoPlayerPlus(
            controller,
          ),
        ),
      ),
    );
  }
}