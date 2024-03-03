import 'package:e_med/components/delegatedText.dart';
import 'package:e_med/controller/searchStudentController.dart';
import 'package:e_med/models/scheduled_list.dart';
import 'package:e_med/routes/routes.dart';
import 'package:e_med/services/database.dart';
import 'package:e_med/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ScheduleList extends StatefulWidget {
  const ScheduleList({super.key});

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  SearchStudentController searchStudentController =
      Get.put(SearchStudentController());
  DatabaseService databaseService = Get.put(DatabaseService());

  List<ScheduledListModel>? filteredScheduledList;

  void filterScheduledList(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredScheduledList = searchStudentController
            .scheduledList; // Reset to original list if query is empty
      } else {
        filteredScheduledList =
            searchStudentController.scheduledList!.where((schedule) {
          final scheduleUsername = schedule.username.toLowerCase();
          final input = query.toLowerCase();
          return scheduleUsername.contains(input);
        }).toList();
      }
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
            text: "Search & Upload",
            fontSize: 20,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                TextField(
                  controller: searchStudentController.usernameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Reg Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Constants.primaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Constants.primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: filterScheduledList,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: size.height * .7,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        FutureBuilder<List<ScheduledListModel>?>(
                          future: databaseService.getScheduledList(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 50.0, bottom: 30),
                                      child: SvgPicture.asset(
                                        'assets/error.svg',
                                        width: 50,
                                        height: 200,
                                      ),
                                    ),
                                    DelegatedText(
                                      text: "Something went wrong",
                                      fontSize: 20,
                                    ),
                                  ],
                                ),
                              );
                            } else if (snapshot.hasData) {
                              var scheduledList = snapshot.data!;
                              filteredScheduledList ??= scheduledList;
                              if (filteredScheduledList!.isNotEmpty) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: filteredScheduledList!.length,
                                  itemBuilder: (context, index) {
                                    final scheduleData =
                                        filteredScheduledList![index];
                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () => Get.toNamed(
                                              Routes.uploadTestResult,
                                              arguments: {
                                                'username': scheduleData
                                                    .username
                                                    .toUpperCase(),
                                                'name': scheduleData.name
                                                    .toUpperCase(),
                                                'userId': scheduleData.id,
                                              }),
                                          child: Container(
                                            height: size.height * 0.15,
                                            margin: const EdgeInsets.only(
                                                bottom: 20),
                                            decoration: const BoxDecoration(
                                              color: Constants.primaryColor,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  DelegatedText(
                                                    text: scheduleData.name
                                                        .toUpperCase(),
                                                    fontSize: 17,
                                                    color: Constants.basicColor,
                                                    truncate: true,
                                                    fontName: "InterMed",
                                                  ),
                                                  const SizedBox(height: 5),
                                                  DelegatedText(
                                                    text: scheduleData.username
                                                        .toUpperCase(),
                                                    fontSize: 17,
                                                    color: Constants.basicColor,
                                                    truncate: false,
                                                    fontName: "InterMed",
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      DelegatedText(
                                                        text: "Upload",
                                                        fontSize: 17,
                                                        color: Constants
                                                            .basicColor,
                                                        truncate: false,
                                                        fontName: "InterMed",
                                                      ),
                                                      IconButton(
                                                        onPressed: () {},
                                                        icon: const Icon(Icons
                                                            .file_upload_sharp),
                                                        color: Constants
                                                            .basicColor,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                return Center(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 50.0, bottom: 30),
                                        child: SvgPicture.asset(
                                          'assets/noFound.svg',
                                          width: 50,
                                          height: 200,
                                        ),
                                      ),
                                      DelegatedText(
                                        text: "No Schedule Found",
                                        fontSize: 20,
                                      ),
                                    ],
                                  ),
                                );
                              }
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
