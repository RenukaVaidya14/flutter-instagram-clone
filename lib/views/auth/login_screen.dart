import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../bottom_nav/bottom_nav_screen.dart';
import '../home/home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final emailController =
  TextEditingController();

  final passwordController =
  TextEditingController();

  String errorMessage = "";

  bool isLoading = false;

  /// LOGIN USER
  Future<void> loginUser() async {

    if (emailController.text
        .trim()
        .isEmpty ||
        passwordController.text
            .trim()
            .isEmpty) {

      setState(() {
        errorMessage =
        "Please enter all fields";
      });

      return;
    }

    try {

      setState(() {
        isLoading = true;
        errorMessage = "";
      });

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(

        email:
        emailController.text.trim(),

        password: passwordController
            .text
            .trim(),
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
          Text("Login Successful"),
        ),
      );

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(
          builder: (context) =>
          const BottomNavScreen()
        ),
      );

    } on FirebaseAuthException catch (e) {

      if (e.code == 'user-not-found') {

        errorMessage =
        "No user found";

      } else if (e.code ==
          'wrong-password') {

        errorMessage =
        "Incorrect password";

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
              mainAxisAlignment:
              MainAxisAlignment.center,

              children: [

                const SizedBox(height: 100),

                /// Instagram Logo
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

                const SizedBox(height: 20),

                /// LOGIN BUTTON
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
                        : loginUser,

                    child: isLoading

                        ? const CircularProgressIndicator(
                      color:
                      Colors.white,
                    )

                        : const Text(
                      "Log in",

                      style: TextStyle(
                        color:
                        Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                /// SIGNUP
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: [

                    const Text(
                      "Don't have an account?",

                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    TextButton(

                      onPressed: () {

                        Navigator.push(

                          context,

                          MaterialPageRoute(
                            builder: (context) =>
                            const SignupScreen(),
                          ),
                        );
                      },

                      child: const Text(
                        "Sign up.",

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