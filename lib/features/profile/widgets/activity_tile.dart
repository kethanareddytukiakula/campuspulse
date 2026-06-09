import 'package:flutter/material.dart';

class ActivityTile extends StatelessWidget {
  final String place;
  final int duration;
  final String date;

  const ActivityTile({
    super.key,
    required this.place,
    required this.duration,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(place),
        subtitle: Text("Duration: $duration min"),
        trailing: Text(date),
      ),
    );
  }
}