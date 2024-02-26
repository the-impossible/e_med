import 'package:e_med/utils/constant.dart';
import 'package:fancy_bottom_navigation_2/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DelegatedBottomNavigation extends StatefulWidget {
  const DelegatedBottomNavigation({super.key});

  @override
  State<DelegatedBottomNavigation> createState() =>
      _DelegatedBottomNavigationState();
}

class _DelegatedBottomNavigationState extends State<DelegatedBottomNavigation> {
  int currentPage = 0;

  GlobalKey bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return FancyBottomNavigation(
      circleColor: Constants.primaryColor,
      inactiveIconColor: Constants.primaryColor,
      textColor: Constants.primaryColor,
      tabs: [
        TabData(
          iconData: Icons.how_to_vote_rounded,
          title: "Vote",
          onclick: () {},
        ),
        TabData(
          iconData: Icons.dashboard,
          title: "Result",
          onclick: () {
            print("object");
            // Get.toNamed(Routes.signIn);
          },
        ),
        TabData(iconData: Icons.person, title: "Profile")
      ],
      initialSelection: 0,
      key: bottomNavigationKey,
      onTabChangedListener: (position) {
        setState(() {
          currentPage = position;
        });
      },
    );
  }
}

_getPage(int page) {
  switch (page) {
    // case 0:
    //   return Get.toNamed(Routes.studHome);
    // case 1:
    //   return Get.toNamed(Routes.studHome);
    // default:
    //   return Get.toNamed(Routes.studHome);
  }
}
