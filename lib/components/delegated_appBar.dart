import 'package:e_med/components/delegatedText.dart';
import 'package:e_med/services/database.dart';
import 'package:e_med/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DelegatedAppBar extends StatelessWidget {
  final String title;
  const DelegatedAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseService databaseService = Get.put(DatabaseService());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            "assets/logo.png",
            width: 50,
            height: 40,
          ),
          const SizedBox(width: 5),
          DelegatedText(
            text: this.title,
            fontSize: 28,
            fontName: "InterBold",
            color: Constants.primaryColor,
          ),
        ],
      ),
    );
  }
}
