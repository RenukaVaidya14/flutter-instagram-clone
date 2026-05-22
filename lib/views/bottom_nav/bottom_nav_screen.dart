import 'package:flutter/material.dart';

import '../feed/feed_screen.dart';
import '../profile/profile_screen.dart';
import '../reels/reels_screen.dart';
import '../upload/upload_screen.dart';

class BottomNavScreen
    extends StatefulWidget {

  const BottomNavScreen({
    super.key,
  });

  @override
  State<BottomNavScreen> createState() =>
      _BottomNavScreenState();
}

class _BottomNavScreenState
    extends State<BottomNavScreen> {

  int currentIndex = 0;

  final List screens = [

    const FeedScreen(),

    const ReelsScreen(),

    const UploadScreen(),

    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: screens[currentIndex],

      bottomNavigationBar:
      BottomNavigationBar(

        currentIndex: currentIndex,

        backgroundColor:
        Colors.black,

        type:
        BottomNavigationBarType.fixed,

        selectedItemColor:
        Colors.white,

        unselectedItemColor:
        Colors.grey,

        onTap: (index) {

          setState(() {

            currentIndex = index;
          });
        },

        items: const [

          BottomNavigationBarItem(

            icon: Icon(Icons.home),

            label: "Home",
          ),

          BottomNavigationBarItem(

            icon: Icon(Icons.video_collection),

            label: "Reels",
          ),

          BottomNavigationBarItem(

            icon: Icon(Icons.add_box_outlined),

            label: "Upload",
          ),

          BottomNavigationBarItem(

            icon: Icon(Icons.person),

            label: "Profile",
          ),
        ],
      ),
    );
  }
}