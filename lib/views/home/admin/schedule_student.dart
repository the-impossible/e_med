import 'package:e_med/components/delegatedForm2.dart';
import 'package:e_med/components/delegatedSnackBar.dart';
import 'package:e_med/components/delegatedText.dart';
import 'package:e_med/controller/scheduleController.dart';
import 'package:e_med/services/database.dart';
import 'package:e_med/utils/constant.dart';
import 'package:e_med/utils/form_validators.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ScheduleStudent extends StatefulWidget {
  const ScheduleStudent({super.key});

  @override
  State<ScheduleStudent> createState() => _ScheduleStudentState();
}

class _ScheduleStudentState extends State<ScheduleStudent> {
  ScheduleController scheduleController = Get.put(ScheduleController());
  final _formKey = GlobalKey<FormState>();

  DatabaseService databaseService = Get.put(DatabaseService());

  TextEditingController _start = TextEditingController();
  TextEditingController _end = TextEditingController();
  var pickedDateTime;

  _pickDateTime(TextEditingController controller) async {
    DateTime dateTime = DateTime.now();

    DateTime? pickedDate = await Constants.pickDate(context, dateTime);
    if (pickedDate == null) return;

    TimeOfDay? pickedTime = await Constants.pickTime(context, dateTime);
    if (pickedTime == null) return;

    dateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
        pickedTime.hour, pickedTime.minute);

    setState(() {
      var date = DateFormat.yMEd().format(dateTime);
      var time = DateFormat.jm().format(dateTime);
      String testDate = "$date, $time";
      controller.text = testDate;
      scheduleController.testDate = testDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: DelegatedText(
            text: "Schedule Test",
            fontSize: 18,
            color: Constants.darkColor,
            fontName: "InterBold",
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
                          'assets/schedule.svg',
                          width: 50,
                          height: 130,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Session(),
                      const SizedBox(height: 20),
                      const College(),
                      const SizedBox(height: 20),
                      DefaultTextFormField(
                        formController: scheduleController.testDateController,
                        obscureText: false,
                        fontSize: 15.0,
                        icon: Icons.date_range,
                        label: "Test Date & Time",
                        onTap: () => _pickDateTime(
                            scheduleController.testDateController),
                        validator: FormValidator.validateField,
                        fillColor: Constants.basicColor,
                        keyboardInputType: TextInputType.none,
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: size.width,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (scheduleController
                                      .sessionController.text.isEmpty ||
                                  scheduleController
                                      .collegeController.text.isEmpty) {
                                ScaffoldMessenger.of(Get.context!).showSnackBar(
                                    delegatedSnackBar(
                                        "Kindly reselect session and college!",
                                        false));
                              } else {
                                scheduleController.scheduleStudent();
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.primaryColor,
                          ),
                          child: DelegatedText(
                            fontSize: 15,
                            text: 'Schedule Test',
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
  ScheduleController scheduleController = Get.put(ScheduleController());

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
          scheduleController.sessionController.text = newValue;
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
  ScheduleController scheduleController = Get.put(ScheduleController());

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
          scheduleController.collegeController.text = newValue;
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
