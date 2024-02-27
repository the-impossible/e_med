import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_med/models/user_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class DatabaseService extends GetxController {
  String? uid;
  DatabaseService({this.uid});

  UserData? userData;

  // collection reference
  var usersCollection = FirebaseFirestore.instance.collection("Users");
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


}


