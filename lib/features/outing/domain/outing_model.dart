import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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
    DateTime parseTimestamp(dynamic ts) {
      if (ts == null) return DateTime.fromMillisecondsSinceEpoch(0);
      if (ts is Timestamp) return ts.toDate();
      if (ts is DateTime) return ts;
      if (ts is String) {
        final parsed = DateTime.tryParse(ts);
        if (parsed != null) return parsed;
      }
      debugPrint('OutingModel.fromMap: unrecognized timestamp value: $ts');
      return DateTime.fromMillisecondsSinceEpoch(0);
    }

    final startTimeValue = parseTimestamp(map['startTime']);
    final endTimeValue = map['endTime'] == null
        ? null
        : parseTimestamp(map['endTime']);
    final createdAtValue = parseTimestamp(map['createdAt']);

    return OutingModel(
      id: id,
      userId: map['userId'] as String? ?? '',
      startTime: startTimeValue,
      endTime: endTimeValue,
      durationMinutes: map['durationMinutes'] is int
          ? map['durationMinutes'] as int
          : int.tryParse(map['durationMinutes']?.toString() ?? '') ?? 0,
      createdAt: createdAtValue,
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
