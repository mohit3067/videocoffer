import 'package:flutter/material.dart';
import 'package:videocoffer/screens/profile_screen.dart';
import 'package:videocoffer/screens/search_screen.dart';
import 'package:videocoffer/screens/upload_screen.dart';
import 'package:videocoffer/screens/update_profile_screen.dart';
import 'package:videocoffer/screens/feed_screen.dart';
import 'package:provider/provider.dart';
import 'package:videocoffer/utils/provider.dart';

class homeScreenWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentPage = context.watch<HomeState>().currentPage; 
    if (currentPage == 0) {
      return VideoScreen();
    } else if (currentPage == 1) {
      return SearchScreen();
    } else if (currentPage == 2) {
      return RecordVideoScreen();
    } else if (currentPage == 3) {
      return ProfileScreen();
    } else if (currentPage == 4) {
      return UpdateProfileScreen();
    } else {
      return Container();
    }
  }
}

List<Widget> homescreenitem = [
        homeScreenWrapper(),
];