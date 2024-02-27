import 'dart:io';
import 'package:e_med/components/delegatedSnackBar.dart';
import 'package:e_med/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  DatabaseService databaseService = Get.put(DatabaseService());
  File? image;

  String? userType;

  Future<void> updateAccount() async {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      String? deviceToken = await FirebaseMessaging.instance.getToken();

      await databaseService.updateProfile(
        FirebaseAuth.instance.currentUser!.uid,
        nameController.text.trim(),
        ageController.text.trim(),
        genderController.text.trim(),
        deviceToken!,
      );

      if (image != null) {
        await databaseService.updateImage(
          image,
          FirebaseAuth.instance.currentUser!.uid,
        );
      }

      ScaffoldMessenger.of(Get.context!).showSnackBar(
          delegatedSnackBar("Account Updated Successfully", true));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(delegatedSnackBar(e.message.toString(), false));
    } finally {
      navigator!.pop(Get.context!);
    }
  }
}
