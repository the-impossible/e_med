import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_med/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetStudentController extends GetxController {
  DatabaseService databaseService = Get.put(DatabaseService());

  TextEditingController collegeController = TextEditingController();
  TextEditingController sessionController = TextEditingController();

}
