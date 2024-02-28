import 'package:e_med/services/database.dart';
import 'package:e_med/utils/constant.dart';
import 'package:e_med/views/home/admin/create_student.dart';
import 'package:e_med/views/home/admin/studentList.dart';
import 'package:e_med/views/home/profile.dart';
import 'package:e_med/views/home/student/schedule_list.dart';
import 'package:fancy_bottom_navigation_2/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey bottomNavigationKey = GlobalKey();
  DatabaseService databaseService = Get.put(DatabaseService());
  int currentPage = 0;

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
            StudentList(),
            CreateStudent(),
            ScheduleList(),
            ProfilePage(),
          ],
        ),
        bottomNavigationBar: FancyBottomNavigation(
          circleColor: Constants.primaryColor,
          inactiveIconColor: Constants.primaryColor,
          textColor: Constants.primaryColor,
          tabs: [
            TabData(
              iconData: Icons.people,
              title: "Students",
            ),
            TabData(
              iconData: Icons.add_box_sharp,
              title: "Create",
            ),
            TabData(
              iconData: Icons.how_to_vote_rounded,
              title: "Schedule",
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
        ),
      ),
    );
  }
}
