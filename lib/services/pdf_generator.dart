import 'dart:io';
import 'dart:typed_data';
import 'package:e_med/components/delegatedSnackBar.dart';
import 'package:e_med/models/test_rest.dart';
import 'package:e_med/models/user_data.dart';
import 'package:e_med/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class PdfGenerator {
  DatabaseService databaseService = Get.put(DatabaseService());
  Future<Uint8List> generatePDF(String userId) async {
    TestResult? testResult = await databaseService.getTestResult(userId);

    final DateFormat formatter = DateFormat('MMMM d, yyyy, h:mm a');

    // Get the current date and time
    final String formattedDate = formatter.format(DateTime.now());

    final pdf = pw.Document();

    List<pw.Widget> widgets = [];

    final headerArea = pw.Column(children: [
      pw.Text(
        "SHEHU MOH'D KANGIWA MEDICAL CENTRE",
        style: pw.TextStyle(
          fontSize: 20,
          letterSpacing: 1,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
      pw.Text(
        "KADUNA POLYTECHNIC",
        style: pw.TextStyle(
          fontSize: 20,
          letterSpacing: 1,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
      pw.Text(
        "Labouratory Form",
        style: pw.TextStyle(
          fontSize: 18,
          letterSpacing: 1,
          fontWeight: pw.FontWeight.bold,
          decoration: pw.TextDecoration.underline,
        ),
      ),
    ]);

    pw.Widget _buildUnderlinedText(String label, String text) {
      return pw.Container(
        padding:
            pw.EdgeInsets.symmetric(vertical: 4.0), // Adjust vertical padding
        child: pw.Row(
          children: [
            pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 16,
                letterSpacing: 1,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(width: 4.0), // Add some spacing between label and text
            pw.Container(
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(
                    color: PdfColors.black,
                    width: 1.0, // Adjust the width of the underline
                  ),
                ),
              ),
              child: pw.Text(
                text,
                style: pw.TextStyle(
                  fontSize: 16,
                  letterSpacing: 1,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    pw.Widget _buildSchData(String label, String text) {
      return pw.Container(
        padding:
            pw.EdgeInsets.symmetric(vertical: 4.0), // Adjust vertical padding
        child: pw.Row(
          children: [
            pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 14,
                letterSpacing: 1,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(width: 10), // Add some spacing between label and text
            pw.Container(
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(
                    color: PdfColors.black,
                    width: 1.0, // Adjust the width of the underline
                  ),
                ),
              ),
              child: pw.Text(
                text,
                style: pw.TextStyle(
                  fontSize: 13,
                  letterSpacing: 1,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    pw.Widget _buildLabData1(String label, String text) {
      return pw.Container(
        padding:
            pw.EdgeInsets.symmetric(vertical: 4.0), // Adjust vertical padding
        child: pw.Row(
          children: [
            (text.isEmpty) ? pw.Spacer() : pw.SizedBox(width: 142),
            pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 14,
                letterSpacing: 1,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(width: 4.0),
            (text.isEmpty)
                ? pw.Text(
                    "__________",
                    style: pw.TextStyle(
                      fontSize: 13,
                      letterSpacing: 1,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  )
                : pw.Container(
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(
                        bottom: pw.BorderSide(
                          color: PdfColors.black,
                          width: 1.0, // Adjust the width of the underline
                        ),
                      ),
                    ),
                    child: pw.Text(
                      text,
                      style: pw.TextStyle(
                        fontSize: 13,
                        letterSpacing: 1,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
          ],
        ),
      );
    }

    pw.Widget _buildDocData(String label, String text) {
      return pw.Container(
        padding:
            pw.EdgeInsets.symmetric(vertical: 4.0), // Adjust vertical padding
        child: pw.Row(
          children: [
            pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 14,
                letterSpacing: 1,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(width: 4.0),
            (text.isEmpty)
                ? pw.Text(
                    "__________",
                    style: pw.TextStyle(
                      fontSize: 13,
                      letterSpacing: 1,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  )
                : pw.Container(
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(
                        bottom: pw.BorderSide(
                          color: PdfColors.black,
                          width: 1.0, // Adjust the width of the underline
                        ),
                      ),
                    ),
                    child: pw.Text(
                      text,
                      style: pw.TextStyle(
                        fontSize: 13,
                        letterSpacing: 1,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
          ],
        ),
      );
    }

    UserData? userData =
        await databaseService.getUser(FirebaseAuth.instance.currentUser!.uid);

    final bioDataArea = pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _buildUnderlinedText("NAME: ", userData!.name.toUpperCase()),
        _buildUnderlinedText("SEX: ", userData.gender!.toUpperCase()),
        _buildUnderlinedText("AGE: ", userData.age!.toUpperCase()),
      ],
    );

    final schDataArea = pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _buildSchData("DEPT: ", databaseService.userData!.department!),
        _buildSchData("CLINIC NOTES : ", "MEDICAL EXAMINATION"),
      ],
    );

    final testHeaderDataArea = pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          "BLOOD",
          style: pw.TextStyle(
            fontSize: 16,
            letterSpacing: 1,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(width: 20),
        pw.Text(
          "URINE",
          style: pw.TextStyle(
            fontSize: 16,
            letterSpacing: 1,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(width: 20),
      ],
    );

    pw.Widget _resultData(
        String label1, String text1, String label2, String text2) {
      return pw.Container(
        padding: const pw.EdgeInsets.symmetric(
            vertical: 4.0), // Adjust vertical padding
        child: pw.Row(
          children: [
            pw.SizedBox(width: 30),
            pw.Text(
              label1,
              style: const pw.TextStyle(
                fontSize: 16,
                letterSpacing: 1,
              ),
            ),
            (text1.isEmpty)
                ? pw.SizedBox()
                : pw.Text(
                    text1,
                    style: const pw.TextStyle(
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
            pw.Spacer(),
            pw.Text(
              label2,
              style: const pw.TextStyle(
                fontSize: 16,
                letterSpacing: 1,
              ),
            ),
            pw.Text(
              text2,
              style: const pw.TextStyle(
                fontSize: 16,
                letterSpacing: 1,
              ),
            ),
            pw.SizedBox(width: 20),
          ],
        ),
      );
    }

    final testDataArea = pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _resultData(
            "HB G/100ML: ", testResult!.hb, "REACTION: ", testResult.reaction!),
        _resultData("MP: ", testResult.mp!, "PROTEIN: ", testResult.protein),
        _resultData("DIFF.COUNT: ", testResult.diff!, "SUGAR(GLUCOSE): ",
            testResult.sugar),
        _resultData("SKIN SNIP & BLOOD FILM: ", testResult.skin!, "BILIRUBIN: ",
            testResult.bil),
        _resultData(
            "SICKLING: ", testResult.skin!, "ACETONE: ", testResult.ace),
        _resultData("GENOTYPE/SOLUBILITY: ", testResult.genotype!,
            "SPECIFIC GRAVITY: ", testResult.gravity!),
        _resultData("GROUPING: ", testResult.grouping, "PREGNANCY: ",
            testResult.pregnancy!),
        _resultData(
            "HB SAG: ", testResult.sag!, "MICROSCOPY/C/S: ", testResult.micro!),
        _resultData("HCV: ", "", "", ""),
        _resultData("FBS: ", "", "", ""),
      ],
    );

    final labDataArea = pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _buildLabData1("MED.LAB SCIENTIST SIGNATURE", ""),
        _buildLabData1("DATE : ", formattedDate),
      ],
    );

    final doctorDataArea = pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _buildDocData("DOCTOR'S SIGNATURE", ""),
        _buildDocData("DATE : ", formattedDate),
      ],
    );

    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            headerArea,
            pw.SizedBox(height: 20),
            bioDataArea,
            schDataArea,
            pw.SizedBox(height: 20),
            testHeaderDataArea,
            pw.SizedBox(height: 10),
            testDataArea,
            pw.SizedBox(height: 20),
            labDataArea,
            pw.SizedBox(height: 50),
            doctorDataArea,
          ];
          // return widgets;
        }));

    return pdf.save();
  }

  Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final output = await getTemporaryDirectory();
    var filePath = "${output.path}/$fileName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    UserData? userData =
        await databaseService.getUser(FirebaseAuth.instance.currentUser!.uid);

    if (userData!.age!.isNotEmpty && userData.gender != null) {
      await OpenFile.open(filePath);
    } else {
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(delegatedSnackBar("Update your profile first", false));
    }
  }
}
