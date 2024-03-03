import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_med/models/scheduled_list.dart';
import 'package:e_med/models/student_schedule_list.dart';
import 'package:e_med/models/test_rest.dart';
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
  var testCollection = FirebaseFirestore.instance.collection("Test");
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
          .get();

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

  Future<List<ScheduledListModel>?> getScheduledList() async {
    try {
      List<ScheduledListModel> scheduleList = [];

      // 1. Get all records from scheduleCollection
      QuerySnapshot scheduleSnapshot = await scheduleCollection.get();

      // 2. Create a map to store the most recent schedule for each user
      Map<String, Map<String, dynamic>> userMap = {};

      // Iterate through each document in the scheduleCollection
      for (var scheduleDoc in scheduleSnapshot.docs) {
        String userId = scheduleDoc['user'];

        // If user already exists in the map, compare dateCreated and pick the most recent one
        if (userMap.containsKey(userId)) {
          DateTime existingDate = userMap[userId]!['dateCreated'];
          DateTime newDate = (scheduleDoc['dateCreated'] as Timestamp).toDate();

          // Update if the new date is more recent
          if (newDate.isAfter(existingDate)) {
            userMap[userId] = {
              'id': scheduleDoc.id,
              'userId': scheduleDoc['user'],
              'dateCreated': newDate,
            };
          }
        } else {
          // If user doesn't exist in the map, add the schedule
          userMap[userId] = {
            'id': scheduleDoc.id,
            'userId': scheduleDoc['user'],
            'dateCreated': (scheduleDoc['dateCreated'] as Timestamp).toDate(),
          };
        }
      }

      // 3. Query userCollection to get name and username for each user
      await Future.forEach(userMap.entries, (entry) async {
        Map<String, dynamic> userData = entry.value;

        DocumentSnapshot userDoc =
            await usersCollection.doc(userData['userId']).get();

        // Check if the user exists in userCollection
        if (userDoc.exists) {
          String name = userDoc['name'];
          String username = userDoc['username'];

          // Create a ScheduleList object and add it to the scheduleList
          scheduleList.add(ScheduledListModel(
            id: userData['userId'],
            name: name,
            username: username,
            dateCreated: userData['dateCreated'],
          ));
        }
      });

      return scheduleList;
    } catch (error) {
      print('Error getting scheduled list: $error');
      return null; // Return null if an error occurs
    }
  }

  //Upload Result
  Future uploadStudentTestResult(
    String userId,
    String hb,
    String reaction,
    String mp,
    String protein,
    String diff,
    String sugar,
    String skin,
    String bil,
    String sickling,
    String ace,
    String genotype,
    String gravity,
    String grouping,
    String pregnancy,
    String sag,
    String micro,
  ) async {
    try {
      // Check if the document exists
      final docSnapshot = await testCollection.doc(userId).get();
      if (docSnapshot.exists) {
        // Document exists, update it
        await testCollection.doc(userId).update(
          {
            'hb': hb,
            'reaction': reaction,
            'mp': mp,
            'protein': protein,
            'diff': diff,
            'sugar': sugar,
            'skin': skin,
            'bil': bil,
            'sickling': sickling,
            'ace': ace,
            'genotype': genotype,
            'gravity': gravity,
            'grouping': grouping,
            'pregnancy': pregnancy,
            'sag': sag,
            'micro': micro,
            'dateUpdated': FieldValue.serverTimestamp(),
          },
        );
      } else {
        // Document does not exist, create it
        await testCollection.doc(userId).set(
          {
            'userId': userId,
            'hb': hb,
            'reaction': reaction,
            'mp': mp,
            'protein': protein,
            'diff': diff,
            'sugar': sugar,
            'skin': skin,
            'bil': bil,
            'sickling': sickling,
            'ace': ace,
            'genotype': genotype,
            'gravity': gravity,
            'grouping': grouping,
            'pregnancy': pregnancy,
            'sag': sag,
            'micro': micro,
            'dateCreated': FieldValue.serverTimestamp(),
          },
        );
      }
      await usersCollection.doc(userId).update({'isCompleted': true});
      await scheduleCollection.doc(userId).update({'hasUploaded': true});
      return true; // Return true if the operation is successful
    } catch (error) {
      print('Error uploading test result: $error');
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(delegatedSnackBar("$error", true));
      return false; // Return false if an error occurs
    }
  }

  //get Test Result
  Future<TestResult?> getTestResult(String uid) async {
    // Query database to get user type
    final snapshot = await testCollection.doc(uid).get();
    // Return user type as string
    if (snapshot.exists) {
      return TestResult.fromJson(snapshot);
    }
    return null;
  }

  // get student specific schedule
  // Stream<List<StudentScheduleListModel>>? getListOfSchedule(String user) {
  //   return scheduleCollection
  //       .where('user', isEqualTo: user)
  //       .orderBy('dateCreated', descending: true)
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs
  //           .map((doc) => StudentScheduleListModel.fromJson(doc))
  //           .toList());
  // }

  Stream<List<StudentScheduleListModel>> getListOfSchedule(String user) {
  return scheduleCollection
      .where('user', isEqualTo: user)
      .orderBy('dateCreated', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
        var schedule = StudentScheduleListModel.fromJson(doc); // Pass the DocumentSnapshot directly

        // Update the hasExpired field based on the testDate
        if (schedule.testDate != null && schedule.testDate!.isBefore(DateTime.now())) {
          schedule.hasExpired = true;
        } else {
          schedule.hasExpired = false;
        }

        // Update the document in Firestore with the modified schedule
        scheduleCollection.doc(doc.id).update({'hasExpired': schedule.hasExpired});

        return schedule;
      }).toList());
}

}
