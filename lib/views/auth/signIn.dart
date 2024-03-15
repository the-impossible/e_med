import 'package:e_med/components/delegatedForm.dart';
import 'package:e_med/components/delegatedText.dart';
import 'package:e_med/controller/loginController.dart';
import 'package:e_med/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.basicColor,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Image.asset(
                      "assets/logo.png",
                      width: 200,
                      height: 130,
                    ),
                  ),
                  DelegatedText(
                    text: 'MedTest',
                    fontSize: 28,
                    fontName: 'InterBold',
                    color: Constants.primaryColor,
                  ),
                  const SizedBox(height: 20),
                  delegatedForm(
                    fieldName: 'Username',
                    icon: Icons.person,
                    hintText: 'Reg. number or username',
                    formController: loginController.regNoController,
                    isSecured: false,
                  ),
                  delegatedForm(
                    fieldName: 'Password',
                    icon: Icons.lock,
                    hintText: 'Enter your password',
                    isSecured: true,
                    formController: loginController.passwordController,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          loginController.signIn();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.primaryColor,
                        ),
                        child: DelegatedText(
                          fontSize: 15,
                          text: 'Sign In',
                          color: Constants.basicColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
