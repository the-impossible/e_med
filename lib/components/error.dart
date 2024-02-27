import 'package:e_med/components/delegatedText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0, bottom: 30),
            child: SvgPicture.asset(
              'assets/error.svg',
              width: 50,
              height: 200,
            ),
          ),
          DelegatedText(
            text: "Something Went Wrong!",
            fontSize: 20,
          ),
        ],
      ),
    );
  }
}
