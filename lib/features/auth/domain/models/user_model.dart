import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String regNo;
  final String course;
  final String year;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.regNo,
    required this.course,
    required this.year,
    required this.createdAt,
  });

  /// Convert UserModel to Firestore document map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'regNo': regNo,
      'course': course,
      'year': year,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Create UserModel from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    DateTime parseTimestamp(dynamic ts) {
      if (ts == null) return DateTime.now();
      if (ts is Timestamp) return ts.toDate();
      if (ts is DateTime) return ts;
      return DateTime.now();
    }

    return UserModel(
      uid: uid,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      regNo: map['regNo'] as String? ?? '',
      course: map['course'] as String? ?? '',
      year: map['year'] as String? ?? '',
      createdAt: parseTimestamp(map['createdAt']),
    );
  }

  /// Create a copy with modified fields
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? regNo,
    String? course,
    String? year,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      regNo: regNo ?? this.regNo,
      course: course ?? this.course,
      year: year ?? this.year,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, regNo: $regNo, course: $course, year: $year, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          name == other.name &&
          email == other.email &&
          regNo == other.regNo &&
          course == other.course &&
          year == other.year;

  @override
  int get hashCode =>
      uid.hashCode ^
      name.hashCode ^
      email.hashCode ^
      regNo.hashCode ^
      course.hashCode ^
      year.hashCode;
}
