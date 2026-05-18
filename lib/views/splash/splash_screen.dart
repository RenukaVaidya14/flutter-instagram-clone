import 'dart:async';

import 'package:flutter/material.dart';

import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    /// Navigate after 3 seconds
    Timer(
      const Duration(seconds: 3),

          () {

            Navigator.pushReplacement(
              context,

              MaterialPageRoute(
                builder: (context) =>
                const LoginScreen(),
              ),
            );
        /// Navigate to next screen
        /// Example:
        /// LoginScreen()

      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      body: Center(

        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            /// Instagram Logo
            Image.asset(
              "assets/images/instagram_logo.png",

              height: 100,
            ),

            const SizedBox(height: 20),

            /// Instagram Text
            const Text(
              "Instagram",

              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: 'cursive',
              ),
            ),
          ],
        ),
      ),
    );
  }
}