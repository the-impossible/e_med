import 'package:e_med/components/delegatedSnackBar.dart';
import 'package:e_med/components/delegatedText.dart';
import 'package:e_med/controller/scheduleController.dart';
import 'package:e_med/models/user_data.dart';
import 'package:e_med/routes/routes.dart';
import 'package:e_med/services/database.dart';
import 'package:e_med/utils/constant.dart';
import 'package:e_med/utils/form_validators.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/getStudentController.dart';

class GetStudent extends StatefulWidget {
  const GetStudent({super.key});

  @override
  State<GetStudent> createState() => _GetStudentState();
}

class _GetStudentState extends State<GetStudent> {
  GetStudentController getStudentController = Get.put(GetStudentController());

  final _formKey = GlobalKey<FormState>();

  DatabaseService databaseService = Get.put(DatabaseService());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: DelegatedText(
            text: "Get Students",
            fontSize: 18,
            color: Constants.darkColor,
            fontName: "InterBold",
          ),
          elevation: 0,
          backgroundColor: Constants.basicColor,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                onPressed: () {
                  Get.toNamed(Routes.createStudent);
                },
                icon: const Icon(
                  Icons.add_circle,
                  size: 35,
                  color: Constants.primaryColor,
                ),
              ),
            )
          ],
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
                          'assets/search.svg',
                          width: 50,
                          height: 130,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Session(),
                      const SizedBox(height: 20),
                      const College(),
                      const SizedBox(height: 20),

                      const SizedBox(height: 30),
                      SizedBox(
                        width: size.width,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (getStudentController
                                      .sessionController.text.isEmpty ||
                                  getStudentController
                                      .collegeController.text.isEmpty) {
                                ScaffoldMessenger.of(Get.context!).showSnackBar(
                                    delegatedSnackBar(
                                        "Kindly reselect session and college!",
                                        false));
                              } else  {

                                Get.toNamed(Routes.studentList, arguments: {
                                  'session': getStudentController
                                      .sessionController.text,
                                  'college': getStudentController
                                      .collegeController.text,
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.primaryColor,
                          ),
                          child: DelegatedText(
                            fontSize: 15,
                            text: 'Get Student',
                            color: Constants.basicColor,
                          ),
                        ),
                      ),
                      // const Department(),
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
  GetStudentController getStudentController = Get.put(GetStudentController());

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
          getStudentController.sessionController.text = newValue;
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
  GetStudentController getStudentController = Get.put(GetStudentController());

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
          getStudentController.collegeController.text = newValue;
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
