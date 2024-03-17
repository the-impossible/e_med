import 'package:e_med/components/delegatedSnackBar.dart';
import 'package:e_med/services/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAdminAccountController extends GetxController {
  DatabaseService databaseService = Get.put(DatabaseService());
  final password = '12345678';
  List<List<dynamic>> fields = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  Future createAccount() async {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      FirebaseApp secondaryApp = await Firebase.initializeApp(
        name: 'SecondaryApp',
        options: Firebase.app().options,
      );

      FirebaseAuth createAuth = FirebaseAuth.instanceFor(app: secondaryApp);

      var user = await createAuth.createUserWithEmailAndPassword(
        email: "${usernameController.text}@gmail.com",
        password: password,
      );

      // Create a new user
      await DatabaseService().createAdminData(
          user.user!.uid, usernameController.text, nameController.text, "adm");

      // after creating the account, delete the secondary app
      await secondaryApp.delete();
      usernameController.clear();
      nameController.clear();
      ScaffoldMessenger.of(Get.context!).showSnackBar(
          delegatedSnackBar("Account created successfully!", true));
    } on FirebaseAuthException catch (e) {
      navigator!.pop(Get.context!);
      print("ERROR: $e");
      ScaffoldMessenger.of(Get.context!).showSnackBar(
          delegatedSnackBar("Error creating, check your input", false));
    } finally {
      navigator!.pop(Get.context!);
    }
  }
}
