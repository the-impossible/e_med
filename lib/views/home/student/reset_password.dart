import 'package:e_med/components/delegatedForm.dart';
import 'package:e_med/components/delegatedSnackBar.dart';
import 'package:e_med/components/delegatedText.dart';
import 'package:e_med/controller/resetPasswordController.dart';
import 'package:e_med/utils/constant.dart';
import 'package:e_med/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  ResetPasswordController resetPasswordController =
      Get.put(ResetPasswordController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: DelegatedText(
            text: "Change Password",
            fontSize: 20,
            color: Constants.darkColor,
            fontName: "InterBold",
          ),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back),
            color: Constants.darkColor,
          ),
          elevation: 0,
          backgroundColor: Constants.basicColor,
        ),
        backgroundColor: Constants.basicColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                    child: SvgPicture.asset(
                      'assets/password.svg',
                      width: 50,
                      height: 130,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: DelegatedText(
                      text:
                          "Your new password must be the same as your Confirm password.",
                      fontSize: 15,
                      align: TextAlign.justify,
                      color: Constants.darkColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: delegatedForm(
                      fieldName: 'Current Password',
                      icon: Icons.person,
                      hintText: 'Enter your current password',
                      validator: FormValidator.validatePassword,
                      formController: resetPasswordController.oldPass,
                      isSecured: true,
                    ),
                  ),
                  delegatedForm(
                    fieldName: 'New Password',
                    icon: Icons.lock,
                    hintText: 'Enter your New password',
                    isSecured: true,
                    validator: FormValidator.validatePassword,
                    formController: resetPasswordController.newPass,
                    // formController: loginController.passwordController,
                  ),
                  delegatedForm(
                    fieldName: 'Confirm Password',
                    icon: Icons.lock,
                    hintText: 'Confirm the new password',
                    isSecured: true,
                    validator: FormValidator.validatePassword,
                    formController: resetPasswordController.newPass2,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (resetPasswordController.newPass.text ==
                              resetPasswordController.newPass2.text) {
                            resetPasswordController.updatePassword();
                          } else {
                            ScaffoldMessenger.of(Get.context!).showSnackBar(
                              delegatedSnackBar(
                                  "FAILED: New and Confirm password don't match",
                                  false),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.primaryColor,
                      ),
                      child: DelegatedText(
                        fontSize: 15,
                        text: 'Reset Password',
                        color: Constants.basicColor,
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
