import 'package:e_med/components/delegatedSnackBar.dart';
import 'package:e_med/services/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAccountController extends GetxController {
  DatabaseService databaseService = Get.put(DatabaseService());
  final password = '12345678';
  List<List<dynamic>> fields = [];

  TextEditingController collegeController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController sessionController = TextEditingController();

  Future createAccount() async {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      if (fields.isNotEmpty) {
        for (var element in fields) {
          final username = element[0].toString().toLowerCase().trim();
          final name = element[1].toString().toLowerCase().trim();

          FirebaseApp secondaryApp = await Firebase.initializeApp(
            name: 'SecondaryApp',
            options: Firebase.app().options,
          );

          FirebaseAuth createAuth = FirebaseAuth.instanceFor(app: secondaryApp);

          var user = await createAuth.createUserWithEmailAndPassword(
            email: "$username@gmail.com",
            password: password,
          );

          // Create a new user
          await DatabaseService().createStudentData(
              user.user!.uid,
              username,
              name,
              collegeController.text,
              departmentController.text,
              sessionController.text,
              "std");

          // after creating the account, delete the secondary app
          await secondaryApp.delete();
        }
        ScaffoldMessenger.of(Get.context!).showSnackBar(
            delegatedSnackBar("Accounts created successfully!", true));
      } else {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(delegatedSnackBar("No file selected!", false));
      }
    } on FirebaseAuthException catch (e) {
      navigator!.pop(Get.context!);
      print("ERROR: $e");
      ScaffoldMessenger.of(Get.context!).showSnackBar(delegatedSnackBar(
          "Error creating, check your internet connection", false));
    } finally {
      navigator!.pop(Get.context!);
    }
  }
}
