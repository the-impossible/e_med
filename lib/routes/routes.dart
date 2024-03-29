import 'package:e_med/splashScreen.dart';
import 'package:e_med/views/home/admin/admin_home.dart';
import 'package:e_med/views/home/admin/createAdmin.dart';
import 'package:e_med/views/home/admin/create_student.dart';
import 'package:e_med/views/home/admin/schedule_student.dart';
import 'package:e_med/views/home/admin/studentList.dart';
import 'package:e_med/views/home/admin/student_details.dart';
import 'package:e_med/views/home/admin/upload_test.dart';
import 'package:e_med/views/home/student/home.dart';
import 'package:e_med/views/home/student/reset_password.dart';
import 'package:e_med/views/home/admin/search_student.dart';
import 'package:get/get.dart';

class Routes {
  static String splash = '/';
  static String signIn = '/signIn';
  static String signUp = '/signUp';
  static String studHome = '/studHome';
  static String profilePage = '/profilePage';
  static String resetPassword = '/resetPassword';

  // Admin Pages
  static String adminHome = '/adminHome';
  static String createStudent = '/createStudent';
  static String scheduleStudent = '/scheduleStudent';
  static String studentList = '/studentList';
  static String scheduleList = '/scheduleList';
  static String uploadTestResult = '/uploadTestResult';
  static String studentDetails = '/studentDetails';
  static String createAdmin = '/createAdmin';
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
  GetPage(
    name: Routes.studentList,
    page: () => const StudentList(),
  ),
  GetPage(
    name: Routes.scheduleList,
    page: () => const ScheduleList(),
  ),
  GetPage(
    name: Routes.resetPassword,
    page: () => const ResetPassword(),
  ),
  GetPage(
    name: Routes.adminHome,
    page: () => const AdminHomePage(),
  ),
  GetPage(
    name: Routes.uploadTestResult,
    page: () => const UploadTestResult(),
  ),
  GetPage(
    name: Routes.studentDetails,
    page: () => const StudentDetailsPage(),
  ),
  GetPage(
    name: Routes.createAdmin,
    page: () => const CreateAdmin(),
  ),
];
