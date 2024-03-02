import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduledListModel {
  final String id;
  final String name;
  final String username;
  final DateTime? dateCreated;

  ScheduledListModel({
    required this.id,
    required this.name,
    required this.username,
    required this.dateCreated,
  });

  factory ScheduledListModel.fromJson(DocumentSnapshot snapshot) {
    return ScheduledListModel(
      id: snapshot.id,
      name: snapshot['name'],
      username: snapshot['username'],
      dateCreated: snapshot['dateCreated'] != null
          ? (snapshot['dateCreated'] as Timestamp).toDate()
          : null,
    );
  }
}
