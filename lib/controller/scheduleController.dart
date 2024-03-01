import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_med/components/delegatedSnackBar.dart';
import 'package:e_med/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ScheduleController extends GetxController {
  DatabaseService databaseService = Get.put(DatabaseService());

  String? testDate;
  TextEditingController collegeController = TextEditingController();
  TextEditingController sessionController = TextEditingController();
  TextEditingController testDateController = TextEditingController();

  // Function to parse date string and convert to server timestamp
  Timestamp convertToServerTimestamp(String dateString) {
    // Define date format
    DateTime dateTime;
    try {
      final dateFormat = DateFormat('E, M/d/y, h:mm a');

      dateTime = dateFormat.parse(dateString);
    } catch (e) {
      final dateFormat = DateFormat('MMM-dd-yy hh:mm a');
      dateTime = dateFormat.parse(dateString);
    }
    // Convert DateTime object to Firestore server timestamp
    return Timestamp.fromDate(dateTime);
  }

  Future scheduleStudent() async {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    Timestamp serverTimestamp = convertToServerTimestamp(testDate!);

    bool isSuccessful = await DatabaseService().scheduleStudent(
      collegeController.text,
      sessionController.text,
      testDateController.text,
      serverTimestamp,
    );

    if (isSuccessful) {
      collegeController.clear();
      sessionController.clear();
      testDateController.clear();

      navigator!.pop(Get.context!);
      ScaffoldMessenger.of(Get.context!).showSnackBar(
          delegatedSnackBar("Test Scheduled was successful!", true));
    } else {
      navigator!.pop(Get.context!);
    }
  }
}
