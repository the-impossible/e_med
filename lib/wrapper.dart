import 'package:e_med/components/error.dart';
import 'package:e_med/models/user_data.dart';
import 'package:e_med/services/database.dart';
import 'package:e_med/utils/loading.dart';
import 'package:e_med/views/auth/signIn.dart';
import 'package:e_med/views/home/admin/admin_home.dart';
import 'package:e_med/views/home/student/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  DatabaseService databaseService = Get.put(DatabaseService());

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.signOut();

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        } else if (snapshot.hasError) {
          return const ErrorScreen();
        } else if (snapshot.hasData) {
          // check for the userType (userType == std)? stdHomepage : admHomepage
          final userId = FirebaseAuth.instance.currentUser!.uid;
          databaseService.uid = userId;

          return FutureBuilder(
            future: databaseService.getUser(userId),
            builder: (context, AsyncSnapshot<UserData?> userData) {
              if (userData.connectionState == ConnectionState.waiting) {
                return const Loading();
              } else if (userData.hasError) {
                return const ErrorScreen();
              } else {
                if (userData.data!.type == 'std') {
                  return const HomePage();
                }
                return const AdminHomePage();
              }
            },
          );
        } else {
          return const SignIn();
        }
      },
    );
  }
}
