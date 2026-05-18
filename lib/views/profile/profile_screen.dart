import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        backgroundColor: Colors.black,

        title: const Text(
          "renu",

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            /// TOP PROFILE SECTION
            Row(
              children: [

                /// PROFILE IMAGE
                const CircleAvatar(
                  radius: 40,

                  backgroundColor:
                  Colors.grey,

                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(width: 30),

                /// POSTS
                const Column(
                  children: [

                    Text(
                      "0",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      "Posts",

                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 25),

                /// FOLLOWERS
                const Column(
                  children: [

                    Text(
                      "0",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      "Followers",

                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 25),

                /// FOLLOWING
                const Column(
                  children: [

                    Text(
                      "0",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      "Following",

                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// USERNAME
            const Text(
              "renu",

              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            /// BIO
            const Text(
              "Flutter Developer 🚀",

              style: TextStyle(
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            /// EDIT PROFILE BUTTON
            SizedBox(
              width: double.infinity,

              child: OutlinedButton(

                style:
                OutlinedButton.styleFrom(

                  side: BorderSide(
                    color:
                    Colors.grey.shade700,
                  ),
                ),

                onPressed: () {},

                child: const Text(
                  "Edit Profile",

                  style: TextStyle(
                    color: Colors.white,
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
