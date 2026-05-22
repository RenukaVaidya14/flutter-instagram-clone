import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import '../bottom_nav/bottom_nav_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() =>
      _SignupScreenState();
}

class _SignupScreenState
    extends State<SignupScreen> {

  final usernameController =
  TextEditingController();

  final emailController =
  TextEditingController();

  final passwordController =
  TextEditingController();

  final confirmPasswordController =
  TextEditingController();

  String errorMessage = "";

  bool isLoading = false;

  /// SIGNUP USER
  Future<void> signupUser() async {

    if (usernameController.text
        .trim()
        .isEmpty ||
        emailController.text
            .trim()
            .isEmpty ||
        passwordController.text
            .trim()
            .isEmpty ||
        confirmPasswordController
            .text
            .trim()
            .isEmpty) {

      setState(() {
        errorMessage =
        "Please fill all fields";
      });

      return;
    }

    if (passwordController.text
        .trim() !=
        confirmPasswordController
            .text
            .trim()) {

      setState(() {
        errorMessage =
        "Passwords do not match";
      });

      return;
    }

    try {

      setState(() {
        isLoading = true;
        errorMessage = "";
      });

      UserCredential userCredential =

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(

        email:
        emailController.text.trim(),

        password:
        passwordController.text.trim(),
      );


      /// SAVE USER DATA IN FIRESTORE
      /// SAVE USER DATA IN FIRESTORE
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({

        "uid":
        userCredential.user!.uid,

        "username":
        usernameController.text.trim(),

        "email":
        emailController.text.trim(),

        "bio": "",

        "profileImage": "",

        "followers": [],

        "following": [],

        "posts": 0,
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
          Text("Signup Successful"),
        ),
      );

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(
          builder: (context) =>
          const BottomNavScreen(),
        ),
      );

    } on FirebaseAuthException catch (e) {

      if (e.code ==
          'email-already-in-use') {

        errorMessage =
        "Email already registered";

      } else if (e.code ==
          'weak-password') {

        errorMessage =
        "Password too weak";

      } else if (e.code ==
          'invalid-email') {

        errorMessage =
        "Invalid email";

      } else {

        errorMessage =
            e.message.toString();
      }

      setState(() {});

    } finally {

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      resizeToAvoidBottomInset: true,

      backgroundColor: Colors.black,

      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 30,
            ),

            child: Column(
              children: [

                const SizedBox(height: 80),

                const Text(
                  "Instagram",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight:
                    FontWeight.bold,
                    fontFamily: 'cursive',
                  ),
                ),

                const SizedBox(height: 50),

                /// Username
                TextField(

                  controller:
                  usernameController,

                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  decoration: InputDecoration(

                    hintText: "Username",

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
                          8),

                      borderSide:
                      BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                /// Email
                TextField(

                  controller:
                  emailController,

                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  decoration: InputDecoration(

                    hintText: "Email",

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
                          8),

                      borderSide:
                      BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                /// Password
                TextField(

                  controller:
                  passwordController,

                  obscureText: true,

                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  decoration: InputDecoration(

                    hintText: "Password",

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
                          8),

                      borderSide:
                      BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                /// Confirm Password
                TextField(

                  controller:
                  confirmPasswordController,

                  obscureText: true,

                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  decoration: InputDecoration(

                    hintText:
                    "Confirm Password",

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
                          8),

                      borderSide:
                      BorderSide.none,
                    ),
                  ),
                ),

                /// ERROR MESSAGE
                if (errorMessage.isNotEmpty)

                  Padding(
                    padding:
                    const EdgeInsets.only(
                      top: 10,
                    ),

                    child: Text(

                      errorMessage,

                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ),

                const SizedBox(height: 30),

                /// SIGNUP BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(

                    style:
                    ElevatedButton.styleFrom(

                      backgroundColor:
                      Colors.blue,

                      shape:
                      RoundedRectangleBorder(

                        borderRadius:
                        BorderRadius.circular(
                            8),
                      ),
                    ),

                    onPressed:
                    isLoading
                        ? null
                        : signupUser,

                    child: isLoading

                        ? const CircularProgressIndicator(
                      color:
                      Colors.white,
                    )

                        : const Text(
                      "Sign up",

                      style: TextStyle(
                        color:
                        Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                /// LOGIN
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: [

                    const Text(
                      "Already have an account?",

                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    TextButton(

                      onPressed: () {

                        Navigator.pop(
                            context);
                      },

                      child: const Text(
                        "Log in.",

                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}