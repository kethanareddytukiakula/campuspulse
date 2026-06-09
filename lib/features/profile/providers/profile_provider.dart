import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  final Map<String, dynamic> user = {
    "name": "Charit",
    "email": "charit@gmail.com",
    "department": "CSE",
    "regNo": "22BCE1234"
  };

  final List<Map<String, dynamic>> outings = [
    {"place": "Cafe XYZ", "duration": 120, "date": "2026-06-08"},
    {"place": "City Mall", "duration": 90, "date": "2026-06-07"},
    {"place": "Park", "duration": 60, "date": "2026-06-06"},
  ];

  int get totalOutings => outings.length;

  int get totalTime =>
      outings.fold(0, (sum, item) => sum + (item["duration"] as int));

  double get avgTime =>
      totalOutings == 0 ? 0 : totalTime / totalOutings;
}