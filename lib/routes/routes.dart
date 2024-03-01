import 'package:e_med/splashScreen.dart';
import 'package:e_med/views/home/admin/admin_home.dart';
import 'package:e_med/views/home/admin/create_student.dart';
import 'package:e_med/views/home/admin/schedule_student.dart';
import 'package:e_med/views/home/student/home.dart';
import 'package:e_med/views/home/student/reset_password.dart';
import 'package:get/get.dart';

class Routes {
  static String splash = '/';
  static String signIn = '/signIn';
  static String signUp = '/signUp';
  static String studHome = '/studHome';
  static String createStudent = '/createStudent';
  static String scheduleStudent = '/scheduleStudent';
  static String profilePage = '/profilePage';
  static String resetPassword = '/resetPassword';
  static String allCandidate = '/allCandidate';

  // Admin Pages
  static String adminHome = '/adminHome';
}

bool isLogin = true;

final getPages = [
  GetPage(
    name: Routes.splash,
    page: () => const Splash(),
  ),
  GetPage(
    name: Routes.studHome,
    page: () => const HomePage(0),
  ),
  GetPage(
    name: Routes.scheduleStudent,
    page: () => const ScheduleStudent(),
  ),
  GetPage(
    name: Routes.createStudent,
    page: () => const CreateStudent(),
  ),
  // GetPage(
  //   name: Routes.profilePage,
  //   page: () => const ProfilePage(),
  // ),
  GetPage(
    name: Routes.resetPassword,
    page: () => const ResetPassword(),
  ),
  GetPage(
    name: Routes.adminHome,
    page: () => const AdminHomePage(),
  ),
  // GetPage(
  //   name: Routes.allCandidate,
  //   page: () => const AllCandidate(),
  // ),
];
