import 'package:e_med/components/delegatedText.dart';
import 'package:e_med/controller/createAccountController.dart';
import 'package:e_med/models/user_data.dart';
import 'package:e_med/routes/routes.dart';
import 'package:e_med/services/database.dart';
import 'package:e_med/utils/constant.dart';
import 'package:e_med/utils/title_case.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  CreateAccountController createAccountController =
      Get.put(CreateAccountController());

  DatabaseService databaseService = Get.put(DatabaseService());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: DelegatedText(
            text: "Student List",
            fontSize: 20,
            color: Constants.darkColor,
            fontName: "InterBold",
          ),
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
          elevation: 0,
          backgroundColor: Constants.basicColor,
        ),
        backgroundColor: Constants.basicColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * .7,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          StreamBuilder<List<UserData>>(
                            stream: databaseService.getAccounts('std'),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                    "Something went wrong! ${snapshot.error}");
                              } else if (snapshot.hasData) {
                                final accountList = snapshot.data!;
                                if (accountList.isNotEmpty) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: accountList.length,
                                    itemBuilder: (context, index) {
                                      final accountData = accountList[index];
                                      return InkWell(
                                        onTap: () =>
                                            Get.toNamed(Routes.studentDetails),
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          height: size.height * .13,
                                          decoration: BoxDecoration(
                                            color: Constants.basicColor,
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color.fromARGB(
                                                    221, 207, 203, 203),
                                                blurRadius: 2,
                                                offset: Offset(2, 2),
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    DelegatedText(
                                                      text: accountData.name
                                                          .titleCase(),
                                                      fontSize: 18,
                                                      truncate: true,
                                                      fontName: "InterBold",
                                                      color:
                                                          Constants.darkColor,
                                                    ),
                                                    const Spacer(),
                                                    FutureBuilder<String?>(
                                                      future: databaseService
                                                          .getImage(
                                                              accountData.id),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        } else if (snapshot
                                                            .hasData) {
                                                          return ClipOval(
                                                            child:
                                                                Image.network(
                                                              snapshot.data!,
                                                              height: 50,
                                                              width: 50,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          );
                                                        } else {
                                                          return Image.asset(
                                                            "assets/user.png",
                                                            width: 50,
                                                            height: 40,
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    DelegatedText(
                                                      text: accountData.username
                                                          .toUpperCase(),
                                                      fontSize: 18,
                                                      truncate: true,
                                                      fontName: "InterBold",
                                                      color:
                                                          Constants.darkColor,
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
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
                                          text: "No Student Record Found",
                                          fontSize: 20,
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
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
          ],
        ),
      ),
    );
  }
}
