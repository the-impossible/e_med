import 'package:e_med/splashScreen.dart';
import 'package:get/get.dart';

class Routes {
  static String splash = '/';
  static String signIn = '/signIn';
  static String signUp = '/signUp';
  static String studHome = '/studHome';
  static String castVote = '/castVote';
  static String resultStats = '/resultStats';
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
  // GetPage(
  //   name: Routes.studHome,
  //   page: () => const HomePage(),
  // ),
  // GetPage(
  //   name: Routes.castVote,
  //   page: () => const CastVote(),
  // ),
  // GetPage(
  //   name: Routes.resultStats,
  //   page: () => const ResultStats(),
  // ),
  // GetPage(
  //   name: Routes.profilePage,
  //   page: () => const ProfilePage(),
  // ),
  // GetPage(
  //   name: Routes.resetPassword,
  //   page: () => const ResetPassword(),
  // ),
  // GetPage(
  //   name: Routes.adminHome,
  //   page: () => const AdminHomePage(),
  // ),
  // GetPage(
  //   name: Routes.allCandidate,
  //   page: () => const AllCandidate(),
  // ),
];
