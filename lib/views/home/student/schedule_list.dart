import 'package:e_med/components/delegatedText.dart';
import 'package:e_med/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleList extends StatefulWidget {
  const ScheduleList({super.key});

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
            child: Column(
              children: [
                Container(
                  height: size.height * 0.08,
                  decoration: const BoxDecoration(
                    color: Constants.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: DelegatedText(
                      text: "Medical Test Feb. 27, 2024, from 9:00 am. prompt",
                      fontSize: 17,
                      color: Constants.basicColor,
                      truncate: false,
                      fontName: "InterMed",
                    ),
                  ),
                ),
                Container(
                  height: size.height * 0.255,
                  decoration: const BoxDecoration(
                    color: Constants.whiteColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(221, 207, 203, 203),
                        blurRadius: 1,
                        spreadRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                    "Shehy Moh'd Kangiwa Medical Centre Kaduna Polytechnic on Feb. 27, 2024. by 6:53 a.m.",
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
                        SizedBox(
                          width: 100,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Constants.primaryColor,
                            ),
                            child: DelegatedText(text: "Result", fontSize: 15),
                          ),
                        )
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
