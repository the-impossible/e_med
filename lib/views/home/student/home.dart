import 'package:e_med/services/database.dart';
import 'package:e_med/utils/constant.dart';
import 'package:e_med/views/home/profile.dart';
import 'package:e_med/views/home/student/schedule_list.dart';
import 'package:fancy_bottom_navigation_2/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  final int page;
  const HomePage(this.page, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey bottomNavigationKey = GlobalKey();
  DatabaseService databaseService = Get.put(DatabaseService());

  late int currentPage;

  @override
  void initState() {
    super.initState();
    currentPage = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Constants.basicColor,
        body: IndexedStack(
          index: currentPage,
          children: const [
            StudentScheduleList(),
            ProfilePage(),
          ],
        ),
        bottomNavigationBar: FancyBottomNavigation(
          circleColor: Constants.primaryColor,
          inactiveIconColor: Constants.primaryColor,
          textColor: Constants.primaryColor,
          tabs: [
            TabData(
              iconData: Icons.how_to_vote_rounded,
              title: "Schedules",
            ),
            TabData(iconData: Icons.person, title: "Profile")
          ],
          initialSelection: currentPage,
          key: bottomNavigationKey,
          onTabChangedListener: (position) {
            setState(() {
              currentPage = position;
            });
          },
        ),
      ),
    );
  }
}
