import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../profile/user_profile_screen.dart';

class UsersScreen extends StatelessWidget {

  const UsersScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        backgroundColor: Colors.black,

        title: const Text(
          "Users",

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: StreamBuilder(

        stream: FirebaseFirestore.instance
            .collection("users")
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {

            return const Center(

              child:
              CircularProgressIndicator(),
            );
          }

          return ListView.builder(

            itemCount:
            snapshot.data!.docs.length,

            itemBuilder: (context, index) {

              var user =
              snapshot.data!.docs[index];

              Map<String, dynamic> data =

              user.data();

              return ListTile(

                leading: const CircleAvatar(

                  backgroundColor:
                  Colors.grey,

                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),

                title: Text(

                  data['username']
                      ?? '',

                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),

                subtitle: Text(

                  data['email']
                      ?? '',

                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

                onTap: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (context) =>

                          UserProfileScreen(
                            userData: data,
                          ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}