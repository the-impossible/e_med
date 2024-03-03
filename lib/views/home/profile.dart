import 'dart:io';

import 'package:e_med/components/delegatedForm.dart';
import 'package:e_med/components/delegatedSnackBar.dart';
import 'package:e_med/components/delegatedText.dart';
import 'package:e_med/components/error.dart';
import 'package:e_med/controller/profileController.dart';
import 'package:e_med/models/user_data.dart';
import 'package:e_med/routes/routes.dart';
import 'package:e_med/services/database.dart';
import 'package:e_med/utils/constant.dart';
import 'package:e_med/utils/form_validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? image;
  final _formKey = GlobalKey<FormState>();
  DatabaseService databaseService = Get.put(DatabaseService());
  ProfileController profileController = Get.put(ProfileController());
  Future pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile == null) return;

      setState(() {
        image = File(pickedFile.path);
        profileController.image = image;
      });
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
          delegatedSnackBar("Failed to Capture image: $e", false));
    }
  }

  @override
  void initState() {
    profileController.ageController.text = databaseService.userData!.age!;
    profileController.nameController.text = databaseService.userData!.name;
    profileController.genderController.text = databaseService.userData!.gender!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Constants.basicColor,
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
                    child: StreamBuilder<UserData?>(
                        stream: databaseService.getUserProfile(
                            FirebaseAuth.instance.currentUser!.uid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // Return a loading indicator while the future is still loading
                            return const Center(
                              child: CircularProgressIndicator(
                                  color: Constants.primaryColor),
                            );
                          } else if (snapshot.hasError) {
                            return const ErrorScreen();
                          } else if (snapshot.hasData) {
                            return Column(
                              children: [
                                Stack(
                                  children: [
                                    StreamBuilder<String?>(
                                        stream: databaseService.getProfileImage(
                                            FirebaseAuth
                                                .instance.currentUser!.uid),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return Center(
                                              child: CircleAvatar(
                                                maxRadius: 60,
                                                minRadius: 60,
                                                child: ClipOval(
                                                  child: Image.asset(
                                                    "assets/user.png",
                                                    width: 160,
                                                    height: 160,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else if (snapshot.hasData) {
                                            return Center(
                                              child: CircleAvatar(
                                                maxRadius: 60,
                                                minRadius: 60,
                                                child: ClipOval(
                                                  child: (image != null)
                                                      ? Image.file(
                                                          image!,
                                                          width: 160,
                                                          height: 160,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.network(
                                                          snapshot.data!,
                                                          width: 160,
                                                          height: 160,
                                                          fit: BoxFit.cover,
                                                          // colorBlendMode: BlendMode.darken,
                                                        ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        }),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 90,
                                        left: 80,
                                      ),
                                      child: Center(
                                        child: InkWell(
                                          onTap: () => pickImage(),
                                          child: const CircleAvatar(
                                            backgroundColor:
                                                Constants.whiteColor,
                                            child: Icon(
                                              Icons.add_a_photo,
                                              color: Constants.primaryColor,
                                              size: 25,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                DelegatedText(
                                  text: profileController.nameController.text,
                                  fontSize: 20,
                                  fontName: 'InterBold',
                                ),
                                const SizedBox(height: 5),
                                DelegatedText(
                                  text: 'submit form below to update profile',
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
                                      profileController.nameController,
                                ),
                                delegatedForm(
                                  fieldName: 'Age',
                                  icon: Icons.abc_rounded,
                                  hintText: 'Enter age',
                                  validator: FormValidator.validateAge,
                                  isSecured: false,
                                  formController:
                                      profileController.ageController,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Row(
                                    children: [
                                      const Icon(
                                          Icons.airline_seat_legroom_extra),
                                      const SizedBox(width: 15),
                                      DelegatedText(
                                        text: "Gender",
                                        fontSize: 15,
                                        fontName: 'InterMed',
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 12, bottom: 12),
                                  child: SelectGender(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          profileController.updateAccount();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Constants.primaryColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25))),
                                      child: DelegatedText(
                                          text: "Save Changes", fontSize: 18),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      DelegatedText(
                                        text: "reset Password?",
                                        fontSize: 15,
                                        color: Constants.darkColor,
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Get.toNamed(Routes.resetPassword),
                                        child: DelegatedText(
                                          text: "Reset?",
                                          fontSize: 15,
                                          color: Constants.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Confirm Logout'),
                                          content: const Text(
                                              'Are you sure you want to logout? '),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                // logoutController.signOut();
                                              },
                                              child: const Text('Log out'),
                                            ),
                                          ],
                                        );
                                      },
                                    )
                                  },
                                  child: DelegatedText(
                                    text: "Logout ",
                                    fontSize: 20,
                                    fontName: "InterBold",
                                    color: Constants.primaryColor,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}

class SelectGender extends StatefulWidget {
  const SelectGender({super.key});

  @override
  State<SelectGender> createState() => _SelectGenderState();
}

List<String> gender = [
  'Male',
  'Female',
];

class _SelectGenderState extends State<SelectGender> {
  ProfileController profileController = Get.put(ProfileController());
  String? location;

  void initializeSelectedGender() {
    if (profileController.genderController.text.isNotEmpty) {
      location = profileController.genderController.text;
    }
  }

  @override
  void initState() {
    initializeSelectedGender();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // String? location = profileController.genderController.text;

    return DropdownButtonFormField<String>(
      validator: FormValidator.validateGender,
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
      value: location,
      hint: const Text('Select Gender'),
      onChanged: (String? newValue) {
        setState(() {
          location = newValue!;
          profileController.genderController.text = newValue;
        });
      },
      items: gender
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
