import 'dart:io';

import 'package:e_med/components/delegatedForm.dart';
import 'package:e_med/components/delegatedText.dart';
import 'package:e_med/controller/createAdminAccountController.dart';
import 'package:e_med/services/database.dart';
import 'package:e_med/utils/constant.dart';
import 'package:e_med/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateAdmin extends StatefulWidget {
  const CreateAdmin({super.key});

  @override
  State<CreateAdmin> createState() => _CreateAdminState();
}

class _CreateAdminState extends State<CreateAdmin> {
  File? image;
  final _formKey = GlobalKey<FormState>();
  DatabaseService databaseService = Get.put(DatabaseService());
  CreateAdminAccountController createAdminAccountController =
      Get.put(CreateAdminAccountController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Constants.basicColor,
          appBar: AppBar(
            centerTitle: true,
            title: DelegatedText(
              text: "Create Administrator",
              fontSize: 18,
              color: Constants.darkColor,
              fontName: "InterBold",
            ),
            elevation: 0,
            backgroundColor: Constants.basicColor,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back),
              color: Constants.darkColor,
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        DelegatedText(
                          text: 'submit form below to create an admin account',
                          fontSize: 15,
                          fontName: 'InterMed',
                        ),
                        const SizedBox(height: 30),
                        delegatedForm(
                          fieldName: 'Name',
                          icon: Icons.person,
                          hintText: 'Enter Full name',
                          validator: FormValidator.validateName,
                          isSecured: false,
                          formController:
                              createAdminAccountController.nameController,
                        ),
                        delegatedForm(
                          fieldName: 'Username',
                          icon: Icons.abc_rounded,
                          hintText: 'Enter Username',
                          validator: FormValidator.validateAge,
                          isSecured: false,
                          formController:
                              createAdminAccountController.usernameController,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  createAdminAccountController.createAccount();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Constants.primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25))),
                              child: DelegatedText(
                                  text: "Create Account", fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
