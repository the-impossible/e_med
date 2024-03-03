import 'package:e_med/components/delegatedDropDown.dart';
import 'package:e_med/components/delegatedForm.dart';
import 'package:e_med/components/delegatedText.dart';
import 'package:e_med/controller/uploadResultStudentController.dart';
import 'package:e_med/models/test_rest.dart';
import 'package:e_med/services/database.dart';
import 'package:e_med/utils/constant.dart';
import 'package:e_med/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class UploadTestResult extends StatefulWidget {
  const UploadTestResult({super.key});

  @override
  State<UploadTestResult> createState() => _UploadTestResultState();
}

List<String> sickling = [
  'Negative',
  'Positive',
];

List<String> grouping = [
  'O +ve',
  'B +ve',
];

class _UploadTestResultState extends State<UploadTestResult> {
  DatabaseService databaseService = Get.put(DatabaseService());
  UploadTestResultController uploadTestResultController =
      Get.put(UploadTestResultController());
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    fetchTestResult();
    super.initState();
  }

  void fetchTestResult() async {
    TestResult? testResult =
        await databaseService.getTestResult(Get.arguments['userId']);

    if (testResult != null) {
      uploadTestResultController.hbController.text = testResult!.hb;
      uploadTestResultController.reactionController.text = testResult.reaction!;
      uploadTestResultController.mpController.text = testResult.mp!;
      uploadTestResultController.proteinController.text = testResult.protein;
      uploadTestResultController.diffController.text = testResult.diff!;
      uploadTestResultController.sugarController.text = testResult.sugar;
      uploadTestResultController.skinController.text = testResult.skin!;
      uploadTestResultController.bilController.text = testResult.bil;
      uploadTestResultController.sicklingController.text = testResult.sickling;
      uploadTestResultController.aceController.text = testResult.ace;
      uploadTestResultController.genotypeController.text = testResult.genotype!;
      uploadTestResultController.gravityController.text = testResult.gravity!;
      uploadTestResultController.groupingController.text = testResult.grouping;
      print("object3: ${testResult.grouping}");
      uploadTestResultController.pregnancyController.text =
          testResult.pregnancy!;
      uploadTestResultController.sagController.text = testResult.sag!;
      uploadTestResultController.microController.text = testResult.micro!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: DelegatedText(
            text: "Upload Test Result",
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                    child: SvgPicture.asset(
                      'assets/doctor.svg',
                      width: 50,
                      height: 130,
                    ),
                  ),
                  DelegatedText(
                    text: "Test Result For:",
                    fontSize: 20,
                    color: Constants.darkColor,
                    fontName: "InterBold",
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: DelegatedText(
                          text: "${Get.arguments?['username'] ?? 'Unknown'}",
                          fontSize: 18,
                          color: Constants.darkColor,
                          fontName: "InterBold",
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: DelegatedText(
                          text: "${Get.arguments?['name'] ?? 'Unknown'}",
                          fontSize: 18,
                          color: Constants.darkColor,
                          fontName: "InterBold",
                          truncate: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: DelegatedText(
                          fontSize: 15,
                          text: 'BLOOD',
                          color: Constants.darkColor,
                          fontName: "InterBold",
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        flex: 4,
                        child: DelegatedText(
                          fontSize: 15,
                          text: 'URINE',
                          color: Constants.darkColor,
                          fontName: "InterBold",
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: delegatedForm(
                          fieldName: "HB G/100ML 🔶",
                          icon: Icons.ac_unit,
                          hintText: 'Enter HB',
                          isSecured: false,
                          validator: FormValidator.validateField,
                          formController:
                              uploadTestResultController.hbController,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        flex: 4,
                        child: delegatedForm(
                          fieldName: "REACTION",
                          icon: Icons.account_tree,
                          hintText: 'Enter REACTION',
                          isSecured: false,
                          formController:
                              uploadTestResultController.reactionController,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: delegatedForm(
                          fieldName: "MP",
                          icon: Icons.ac_unit,
                          hintText: 'Enter MP',
                          isSecured: false,
                          formController:
                              uploadTestResultController.mpController,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        flex: 4,
                        child: delegatedForm(
                          fieldName: "PROTEIN 🔶",
                          icon: Icons.account_tree,
                          hintText: 'Enter PROTEIN',
                          isSecured: false,
                          validator: FormValidator.validateField,
                          formController:
                              uploadTestResultController.proteinController,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: delegatedForm(
                          fieldName: "DIFF COUNT",
                          icon: Icons.ac_unit,
                          hintText: 'Enter DIFF COUNT',
                          isSecured: false,
                          formController:
                              uploadTestResultController.diffController,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        flex: 4,
                        child: delegatedForm(
                          fieldName: "SUGAR 🔶",
                          icon: Icons.account_tree,
                          hintText: 'Enter (GLUCOSE)',
                          isSecured: false,
                          validator: FormValidator.validateField,
                          formController:
                              uploadTestResultController.sugarController,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: delegatedForm(
                          fieldName: "SNIP & BLOOD",
                          icon: Icons.ac_unit,
                          hintText: 'SKIN SNIP & BLOOD FILM',
                          isSecured: false,
                          formController:
                              uploadTestResultController.skinController,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        flex: 4,
                        child: delegatedForm(
                          fieldName: "BILIRUBIN 🔶",
                          icon: Icons.account_tree,
                          hintText: 'Enter BILIRUBIN',
                          isSecured: false,
                          validator: FormValidator.validateField,
                          formController:
                              uploadTestResultController.bilController,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: DropDown(
                          dropDownName: sickling,
                          name: "SICKLING 🔶",
                          icon: Icons.ac_unit,
                          controller:
                              uploadTestResultController.sicklingController,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        flex: 4,
                        child: delegatedForm(
                          fieldName: "ACETONE  🔶",
                          icon: Icons.account_tree,
                          hintText: 'Enter ACETONE ',
                          isSecured: false,
                          validator: FormValidator.validateField,
                          formController:
                              uploadTestResultController.aceController,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: delegatedForm(
                          fieldName: "GENOTYPE",
                          icon: Icons.ac_unit,
                          hintText: 'GENOTYPE / SOLUBILITY',
                          isSecured: false,
                          formController:
                              uploadTestResultController.genotypeController,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        flex: 4,
                        child: delegatedForm(
                          fieldName: "SPECIFIC ",
                          icon: Icons.account_tree,
                          hintText: 'Specific Gravity',
                          isSecured: false,
                          formController:
                              uploadTestResultController.gravityController,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: DropDown(
                          dropDownName: grouping,
                          name: "GROUPING 🔶",
                          icon: Icons.ac_unit,
                          controller:
                              uploadTestResultController.groupingController,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        flex: 4,
                        child: delegatedForm(
                          fieldName: "PREGNANCY",
                          icon: Icons.account_tree,
                          hintText: 'Pregnancy Status',
                          isSecured: false,
                          formController:
                              uploadTestResultController.pregnancyController,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: delegatedForm(
                          fieldName: "HB SAG",
                          icon: Icons.ac_unit,
                          hintText: 'HB SAG',
                          isSecured: false,
                          formController:
                              uploadTestResultController.sagController,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        flex: 4,
                        child: delegatedForm(
                          fieldName: "MICROSCOPY",
                          icon: Icons.account_tree,
                          hintText: 'MICROSCOPY/C/S',
                          isSecured: false,
                          formController:
                              uploadTestResultController.microController,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                    child: SizedBox(
                      width: size.width,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            uploadTestResultController.userId =
                                Get.arguments['userId'];
                            uploadTestResultController.uploadResult();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.primaryColor,
                        ),
                        child: DelegatedText(
                          fontSize: 15,
                          text: 'Upload Test Result',
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
