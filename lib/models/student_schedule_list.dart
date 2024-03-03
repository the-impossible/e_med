import 'package:cloud_firestore/cloud_firestore.dart';

class StudentScheduleListModel {
  final String id;
  bool hasExpired;
  final bool hasUploaded;
  final String user;
  final DateTime? testDate;
  final DateTime? dateCreated;

  StudentScheduleListModel({
    required this.id,
    required this.hasExpired,
    required this.hasUploaded,
    required this.user,
    this.testDate,
    this.dateCreated,
  });

  factory StudentScheduleListModel.fromJson(DocumentSnapshot snapshot) {
    return StudentScheduleListModel(
      id: snapshot.id,
      hasExpired: snapshot['hasExpired'],
      hasUploaded: snapshot['hasUploaded'],
      user: snapshot['user'],
      testDate: snapshot['testDate'] != null
          ? (snapshot['testDate'] as Timestamp).toDate()
          : null,
      dateCreated: snapshot['dateCreated'] != null
          ? (snapshot['dateCreated'] as Timestamp).toDate()
          : null,
    );
  }
}
