import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String id;
  final String name;
  final String username;
  final String type;
  final String? gender;
  final String? age;
  final String? department;
  final String? session;
  final String? college;
  final bool isCompleted;
  final DateTime? dateCreated;

  UserData({
    required this.id,
    required this.name,
    required this.username,
    required this.type,
    this.gender,
    this.age,
    this.department,
    this.session,
    this.college,
    required this.isCompleted,
    required this.dateCreated,
  });

  factory UserData.fromJson(DocumentSnapshot snapshot) {
    return UserData(
      id: snapshot.id,
      name: snapshot['name'],
      username: snapshot['username'],
      type: snapshot['type'],
      gender: snapshot['gender'],
      age: snapshot['age'],
      department: snapshot['department'],
      session: snapshot['session'],
      college: snapshot['college'],
      isCompleted: snapshot['isCompleted'],
      dateCreated: snapshot['dateCreated'] != null
          ? (snapshot['dateCreated'] as Timestamp).toDate()
          : null,
    );
  }
}
