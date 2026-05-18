import 'package:flutter/material.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return const Scaffold(

      backgroundColor: Colors.black,

      body: Center(
        child: Text(
          "Upload Screen",

          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}