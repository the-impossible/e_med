import 'dart:convert';
import 'dart:io';
import 'package:e_med/components/delegatedSnackBar.dart';
import 'package:e_med/components/delegatedText.dart';
import 'package:e_med/controller/createAccountController.dart';
import 'package:e_med/services/database.dart';
import 'package:e_med/utils/constant.dart';
import 'package:e_med/utils/form_validators.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateStudent extends StatefulWidget {
  const CreateStudent({super.key});

  @override
  State<CreateStudent> createState() => _CreateStudentState();
}

class _CreateStudentState extends State<CreateStudent> {
  CreateAccountController createAccountController =
      Get.put(CreateAccountController());
  final _formKey = GlobalKey<FormState>();

  DatabaseService databaseService = Get.put(DatabaseService());

  String? filePath;
  String selected = "No selected file";
  String preSelected = "";

  Future _pickCSV() async {
    setState(() {
      selected = "No selected file";
    });
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );

    // if no file is found
    if (result == null) return;

    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    filePath = result.files.first.path!;

    final String extension = path.extension(filePath!);

    if (extension.toLowerCase() == '.csv') {
      final input = File(filePath!).openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();

      createAccountController.fields = fields;

      for (var element in fields) {
        final regNo = element[0].toString().toLowerCase();

        QuerySnapshot snaps = await FirebaseFirestore.instance
            .collection('Users')
            .where("username", isEqualTo: regNo)
            .get();
        if (snaps.docs.length != 1) {
          preSelected = "File Selected!";
          setState(() {
            isDisabled = false;
          });
        } else {
          preSelected = "No selected file";
          ScaffoldMessenger.of(Get.context!).showSnackBar(delegatedSnackBar(
              "Invalid CSV! contains existing account", false));
          break;
        }
      }
      setState(() {
        selected = preSelected;
      });
    } else {
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(delegatedSnackBar("Invalid file!", false));
    }

    navigator!.pop(Get.context!);
  }

  void uploadFile() {
    createAccountController.createAccount();
    setState(() {
      isDisabled = true;
      selected = "No selected file";
    });
  }

  bool isDisabled = true;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: DelegatedText(
            text: "Create Student",
            fontSize: 18,
            color: Constants.darkColor,
            fontName: "InterBold",
          ),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back,
              color: Constants.darkColor,
            ),
          ),
          elevation: 0,
          backgroundColor: Constants.basicColor,
        ),
        backgroundColor: Constants.basicColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                        child: SvgPicture.asset(
                          'assets/create.svg',
                          width: 50,
                          height: 130,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: size.width * .4,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  _pickCSV();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Constants.primaryColor,
                                ),
                                child: DelegatedText(
                                  fontSize: 15,
                                  text: 'Select File',
                                  color: Constants.whiteColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DelegatedText(
                              text: selected,
                              fontSize: 15,
                              fontName: "InterBold",
                              color: Constants.darkColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Session(),
                      const SizedBox(height: 20),
                      const College(),
                      const SizedBox(height: 20),
                      const Department(),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: size.width,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              (isDisabled)
                                  ? ScaffoldMessenger.of(Get.context!)
                                      .showSnackBar(delegatedSnackBar(
                                          "Select upload file", false))
                                  : uploadFile();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.primaryColor,
                          ),
                          child: DelegatedText(
                            fontSize: 15,
                            text: 'Create Students',
                            color: Constants.basicColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Session Dropdown
class Session extends StatefulWidget {
  const Session({super.key});

  @override
  State<Session> createState() => _SessionState();
}

List<String> sessions = [
  '2022/2023',
  '2021/2022',
];

class _SessionState extends State<Session> {
  CreateAccountController createAccountController =
      Get.put(CreateAccountController());

  @override
  Widget build(BuildContext context) {
    String? sessionValue;

    return DropdownButtonFormField<String>(
      validator: FormValidator.validateField,
      decoration: const InputDecoration(
        fillColor: Constants.basicColor,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Constants.darkColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.0,
            color: Constants.darkColor,
          ),
        ),
      ),
      value: sessionValue,
      hint: const Text('Select Session'),
      onChanged: (String? newValue) {
        setState(() {
          sessionValue = newValue!;
          createAccountController.sessionController.text = newValue;
        });
      },
      items: sessions
          .map(
            (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
    );
  }
}

// College Dropdown
class College extends StatefulWidget {
  const College({super.key});

  @override
  State<College> createState() => _CollegeState();
}

List<String> colleges = [
  'CST',
  'COE',
];

class _CollegeState extends State<College> {
  CreateAccountController createAccountController =
      Get.put(CreateAccountController());

  @override
  Widget build(BuildContext context) {
    String? collegeValue;

    return DropdownButtonFormField<String>(
      validator: FormValidator.validateField,
      decoration: const InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Constants.darkColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.0,
            color: Constants.darkColor,
          ),
        ),
      ),
      value: collegeValue,
      hint: const Text('Select College'),
      onChanged: (String? newValue) {
        setState(() {
          collegeValue = newValue!;
          createAccountController.collegeController.text = newValue;
        });
      },
      items: colleges
          .map(
            (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
    );
  }
}

// Department Dropdown
class Department extends StatefulWidget {
  const Department({super.key});

  @override
  State<Department> createState() => _DepartmentState();
}

List<String> departments = [
  'Computer Science',
  'Agriculture',
  'Science Laboratory',
  'Printing Technology',
];

class _DepartmentState extends State<Department> {
  CreateAccountController createAccountController =
      Get.put(CreateAccountController());

  @override
  Widget build(BuildContext context) {
    String? departmentValue;

    return DropdownButtonFormField<String>(
      validator: FormValidator.validateField,
      decoration: const InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Constants.darkColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.0,
            color: Constants.darkColor,
          ),
        ),
      ),
      value: departmentValue,
      hint: const Text('Select Department'),
      onChanged: (String? newValue) {
        setState(() {
          departmentValue = newValue!;
          createAccountController.departmentController.text = newValue;
        });
      },
      items: departments
          .map(
            (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
    );
  }
}
