import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_med/models/user_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../components/delegatedSnackBar.dart';

class DatabaseService extends GetxController {
  String? uid;
  DatabaseService({this.uid});

  UserData? userData;

  // collection reference
  var usersCollection = FirebaseFirestore.instance.collection("Users");
  var scheduleCollection = FirebaseFirestore.instance.collection("Schedule");
  var amountCollection = FirebaseFirestore.instance.collection("Amount");
  var filesCollection = FirebaseStorage.instance.ref();

  //get user and populate the userData model
  Future<UserData?> getUser(String uid) async {
    // Query database to get user type
    final snapshot = await usersCollection.doc(uid).get();
    // Return user type as string
    if (snapshot.exists) {
      userData = UserData.fromJson(snapshot);
      return UserData.fromJson(snapshot);
    }
    return null;
  }

  // Update user profile
  Future<bool> updateProfile(
    String uid,
    String name,
    String age,
    String gender,
    String token,
  ) async {
    usersCollection.doc(uid).update({
      "age": age,
      "gender": gender,
      "name": name,
      "token": token,
    });
    return true;
  }

  // update user profile image
  Future<bool> updateImage(File? image, String path) async {
    filesCollection.child(path).putFile(image!);
    return true;
  }

  // Get profile image
  Stream<String?> getProfileImage(String path) {
    try {
      Future.delayed(const Duration(milliseconds: 3600));
      return filesCollection.child(path).getDownloadURL().asStream();
    } catch (e) {
      return Stream.value(null);
    }
  }

  // Get a user profile
  Stream<UserData?> getUserProfile(String uid) {
    return usersCollection.doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return UserData.fromJson(snapshot);
      }
      return null;
    });
  }

  // Set Image
  Future<bool> setImage(String? uid) async {
    final ByteData byteData = await rootBundle.load("assets/user.png");
    final Uint8List imageData = byteData.buffer.asUint8List();
    filesCollection.child("$uid").putData(imageData);
    return true;
  }

  //Create user
  Future createStudentData(
    String uid,
    String username,
    String name,
    String college,
    String department,
    String session,
    String type,
  ) async {
    await setImage(uid);
    return await usersCollection.doc(uid).set(
      {
        'username': username,
        'name': name,
        'college': college,
        'department': department,
        'session': session,
        'type': type,
        'isCompleted': false,
        'gender': "",
        'age': "",
        'token': "",
        'dateCreated': FieldValue.serverTimestamp(),
      },
    );
  }

  // Get student accounts
  Stream<List<UserData>> getAccounts(String type) {
    return usersCollection
        .where('type', isEqualTo: type)
        .orderBy('dateCreated', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => UserData.fromJson(doc)).toList(),
        );
  }

  // Get image
  Future<String?> getImage(String uid) async {
    try {
      final url = await filesCollection.child(uid).getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }

  // Schedule Student

  Future<bool> scheduleStudent(
    String college,
    String session,
    String rawDate,
    Timestamp date,
  ) async {
    try {
      // 1. Get the amount to schedule
      QuerySnapshot amountSnapshot = await amountCollection.limit(1).get();

      if (amountSnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(delegatedSnackBar("Amount collection empty!", false));
        throw Exception('No amount found in amountCollection');
      }

      dynamic amount = amountSnapshot.docs.first['amount'];

      // 2. Fetch users where isCompleted is false and orderBy dateCreated in ascending order
      QuerySnapshot userSnapshot = await usersCollection
          .where('isCompleted', isEqualTo: false)
          .where('college', isEqualTo: college)
          .where('session', isEqualTo: session)
          .where('type', isEqualTo: "std")
          .orderBy('dateCreated', descending: false)
          // .limit(int.parse(amount))
          .get();

      print("OBJECT: ${userSnapshot.docs.length}");
      if (userSnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(delegatedSnackBar(
            "No student found with the supplied data", false));
        throw Exception('No student found with the supplied data');
      }
      // Loop through the user record and perform actions
      for (DocumentSnapshot userDoc
          in userSnapshot.docs.take(int.parse(amount))) {
        String userId = userDoc.id;
        // Schedule student for test
        DocumentReference scheduleRef = await scheduleCollection.add({
          'user': userId,
          'testDate': date,
          'hasExpired': false,
          'hasUploaded': false,
          'dateCreated': Timestamp.now(),
        });
        // Change the student createdDate
        await usersCollection.doc(userId).update({
          "dateCreated": FieldValue.serverTimestamp(),
        });
        // Ensure token availability before sending push notification
        if (userDoc['token'] != null && userDoc['token'].isNotEmpty) {
          // Send push notification
          String truncateString(String input, int maxLength) {
            if (input.length <= maxLength) {
              return input;
            } else {
              return "${input.substring(0, maxLength)}...";
            }
          }

          var headers = {
            'Authorization':
                'key=AAAAKvQ--G4:APA91bH3ZzYn9ORvW-qTtP8tBH3rQbJFz-vUC7xa56nblvBkH3rFv_bZ1CI4N_AEWNRgxcJZBrWSKztBG4DQmWtmZJ7TxWSZ9BE6HidfBqdQCFWbowVTbE2Vodr47v9os7zfGmfSuu5c',
            'Content-Type': 'application/json',
          };

          var request = http.Request(
              'POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));

          request.body = json.encode({
            "registration_ids": ["${userDoc['token']}"],
            "notification": {
              "title": "New Test Schedule",
              "body": truncateString(
                  "Medical Test: $rawDate. prompt has been schedule for you",
                  40),
              "click_action": "FLUTTER_NOTIFICATION_CLICK"
            },
            "data": {"event_id": scheduleRef.id}
          });

          request.headers.addAll(headers);
          http.StreamedResponse response = await request.send();
          if (response.statusCode == 200) {
            print("Notification has been sent!!");
          } else {
            print(response.reasonPhrase);
            ScaffoldMessenger.of(Get.context!).showSnackBar(
                delegatedSnackBar("Push notification failed!", false));
            throw Exception('Push notification failed!');
          }
        }
      }
      // Return true if scheduling is successful for any user
      return true;
    } catch (error) {
      print('Error scheduling student: $error');
      return false; // Return false if scheduling encounters an error
    }
  }
}
