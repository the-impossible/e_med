import 'package:e_med/components/delegatedSnackBar.dart';
import 'package:e_med/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadTestResultController extends GetxController {
  DatabaseService databaseService = Get.put(DatabaseService());
  String? userId;
  TextEditingController hbController = TextEditingController();
  TextEditingController reactionController = TextEditingController();
  TextEditingController mpController = TextEditingController();
  TextEditingController proteinController = TextEditingController();
  TextEditingController diffController = TextEditingController();
  TextEditingController sugarController = TextEditingController();
  TextEditingController skinController = TextEditingController();
  TextEditingController bilController = TextEditingController();
  TextEditingController sicklingController = TextEditingController();
  TextEditingController aceController = TextEditingController();
  TextEditingController genotypeController = TextEditingController();
  TextEditingController gravityController = TextEditingController();
  TextEditingController groupingController = TextEditingController();
  TextEditingController pregnancyController = TextEditingController();
  TextEditingController sagController = TextEditingController();
  TextEditingController microController = TextEditingController();

  Future uploadResult() async {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    bool isSuccessful = await DatabaseService().uploadStudentTestResult(
      userId!,
      hbController.text,
      reactionController.text,
      mpController.text,
      proteinController.text,
      diffController.text,
      sugarController.text,
      skinController.text,
      bilController.text,
      sicklingController.text,
      aceController.text,
      genotypeController.text,
      gravityController.text,
      groupingController.text,
      pregnancyController.text,
      sagController.text,
      microController.text,
    );

    if (isSuccessful) {
      navigator!.pop(Get.context!);
      ScaffoldMessenger.of(Get.context!).showSnackBar(
          delegatedSnackBar("Test Uploaded successfully!", true));
      Get.back();
    } else {
      navigator!.pop(Get.context!);
    }
  }
}
