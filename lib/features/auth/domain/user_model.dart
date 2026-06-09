import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String regNo;
  final String course;
  final String year;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.regNo,
    required this.course,
    required this.year,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'regNo': regNo,
      'course': course,
      'year': year,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      regNo: map['regNo'] as String? ?? '',
      course: map['course'] as String? ?? '',
      year: map['year'] as String? ?? '',
    );
  }
}
