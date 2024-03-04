import 'dart:io';
import 'dart:typed_data';

import 'package:e_med/components/delegatedText.dart';
import 'package:e_med/models/scheduled_list.dart';
import 'package:e_med/models/student_schedule_list.dart';
import 'package:e_med/services/database.dart';
import 'package:e_med/services/pdf_generator.dart';
import 'package:e_med/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';

class StudentScheduleList extends StatefulWidget {
  const StudentScheduleList({super.key});

  @override
  State<StudentScheduleList> createState() => _StudentScheduleListState();
}

class _StudentScheduleListState extends State<StudentScheduleList> {
  DatabaseService databaseService = Get.put(DatabaseService());
  final PdfGenerator pdfGenerator = PdfGenerator();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: DelegatedText(
            text: "My Schedule",
            fontSize: 20,
            color: Constants.darkColor,
            fontName: "InterBold",
          ),
          elevation: 0,
          backgroundColor: Constants.basicColor,
        ),
        backgroundColor: Constants.basicColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: StreamBuilder<List<StudentScheduleListModel>>(
                stream: databaseService.getListOfSchedule(userId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong! ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    final scheduleList = snapshot.data!;
                    if (scheduleList.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: scheduleList.length,
                        itemBuilder: (context, index) {
                          final scheduleData = scheduleList[index];
                          String dateTimeToString(DateTime date) {
                            DateFormat outputFormat =
                                DateFormat("MMM d y, hh:mma");
                            return outputFormat.format(date);
                          }

                          String date =
                              dateTimeToString(scheduleData.testDate!);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              children: [
                                Container(
                                  height: size.height * 0.08,
                                  decoration: BoxDecoration(
                                    color: (scheduleData.hasExpired)
                                        ? Constants.secondaryColor
                                        : Constants.primaryColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: DelegatedText(
                                      text: "Medical Test $date. prompt",
                                      fontSize: 17,
                                      color: Constants.basicColor,
                                      truncate: false,
                                      fontName: "InterMed",
                                    ),
                                  ),
                                ),
                                Container(
                                  height: size.height * 0.27,
                                  decoration: const BoxDecoration(
                                    color: Constants.whiteColor,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color.fromARGB(221, 207, 203, 203),
                                        blurRadius: 1,
                                        spreadRadius: 2,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: Image.asset(
                                                "assets/logo.png",
                                                width: 100,
                                                height: 80,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 8,
                                              child: DelegatedText(
                                                text:
                                                    "Shehy Moh'd Kangiwa Medical Centre Kaduna Polytechnic on $date prompt",
                                                fontSize: 15,
                                                color: Constants.darkColor,
                                                truncate: false,
                                                fontName: "InterMed",
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        DelegatedText(
                                          text:
                                              "You are expected to be at the stated venue at the stated time",
                                          fontSize: 15,
                                          color: Constants.darkColor,
                                          truncate: false,
                                          fontName: "InterMed",
                                        ),
                                        const SizedBox(height: 10),
                                        (scheduleData.hasUploaded)
                                            ? SizedBox(
                                                width: 100,
                                                height: 50,
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    final data =
                                                        await pdfGenerator
                                                            .generatePDF();
                                                    pdfGenerator.savePdfFile(
                                                        "MedPro", data);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Constants.primaryColor,
                                                  ),
                                                  child: DelegatedText(
                                                      text: "Result",
                                                      fontSize: 15),
                                                ),
                                              )
                                            : const SizedBox()
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 50.0, bottom: 30),
                              child: SvgPicture.asset(
                                'assets/schedule.svg',
                                width: 50,
                                height: 200,
                              ),
                            ),
                            DelegatedText(
                              text:
                                  "You have not been scheduled yet... ensure you've updated your profile",
                              fontSize: 20,
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ),
      ),
    );
  }
}
