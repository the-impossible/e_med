import 'package:cloud_firestore/cloud_firestore.dart';

class TestResult {
  final  String userId;
  final  String hb;
  final  String? reaction;
  final  String? mp;
  final  String protein;
  final  String? diff;
  final  String sugar;
  final  String? skin;
  final  String bil;
  final  String sickling;
  final  String ace;
  final  String? genotype;
  final  String? gravity;
  final  String grouping;
  final  String? pregnancy;
  final  String? sag;
  final  String? micro;
  final DateTime? dateCreated;

  TestResult({
    required this.userId,
    required this.hb,
    this.reaction,
    this.mp,
    required this.protein,
    this.diff,
    required this.sugar,
    this.skin,
    required this.bil,
    required this.sickling,
    required this.ace,
    this.genotype,
    this.gravity,
    required this.grouping,
    this.pregnancy,
    this.sag,
    this.micro,
    required this.dateCreated,
  });

  factory TestResult.fromJson(DocumentSnapshot snapshot) {
    return TestResult(
      userId: snapshot.id,
      hb: snapshot['hb'],
      reaction: snapshot['reaction'],
      mp: snapshot['mp'],
      protein: snapshot['protein'],
      diff: snapshot['diff'],
      sugar: snapshot['sugar'],
      skin: snapshot['skin'],
      bil: snapshot['bil'],
      sickling: snapshot['sickling'],
      ace: snapshot['ace'],
      genotype: snapshot['genotype'],
      gravity: snapshot['gravity'],
      grouping: snapshot['grouping'],
      pregnancy: snapshot['pregnancy'],
      sag: snapshot['sag'],
      micro: snapshot['micro'],
      dateCreated: snapshot['dateCreated'] != null
          ? (snapshot['dateCreated'] as Timestamp).toDate()
          : null,
    );
  }
}
