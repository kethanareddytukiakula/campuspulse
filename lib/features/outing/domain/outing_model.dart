import 'package:cloud_firestore/cloud_firestore.dart';

class OutingModel {
  final String id;
  final String userId;
  final DateTime startTime;
  final DateTime? endTime;
  final int durationMinutes;
  final DateTime createdAt;

  OutingModel({
    required this.id,
    required this.userId,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.createdAt,
  });

  factory OutingModel.fromMap(Map<String, dynamic> map, String id) {
    final dynamic startTimeValue = map['startTime'];
    final dynamic endTimeValue = map['endTime'];
    final dynamic createdAtValue = map['createdAt'];

    return OutingModel(
      id: id,
      userId: map['userId'] as String? ?? '',
      startTime: startTimeValue is Timestamp
          ? startTimeValue.toDate()
          : (startTimeValue as DateTime),
      endTime: endTimeValue == null
          ? null
          : endTimeValue is Timestamp
          ? endTimeValue.toDate()
          : (endTimeValue as DateTime),
      durationMinutes: map['durationMinutes'] as int? ?? 0,
      createdAt: createdAtValue is Timestamp
          ? createdAtValue.toDate()
          : (createdAtValue as DateTime),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': endTime == null ? null : Timestamp.fromDate(endTime!),
      'durationMinutes': durationMinutes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
