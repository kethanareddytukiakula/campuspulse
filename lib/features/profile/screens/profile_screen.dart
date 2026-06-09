import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// ===============================
/// PROFILE PROVIDER (DUMMY DATA)
/// ===============================
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

/// ===============================
/// MAIN SCREEN
/// ===============================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          centerTitle: true,
        ),
        body: const _ProfileBody(),
      ),
    );
  }
}

/// ===============================
/// BODY
/// ===============================
class _ProfileBody extends StatelessWidget {
  const _ProfileBody();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          _ProfileHeader(user: provider.user),

          const SizedBox(height: 20),

          /// STATS
          _StatsSection(
            totalOutings: provider.totalOutings,
            totalTime: provider.totalTime,
            avgTime: provider.avgTime,
          ),

          const SizedBox(height: 20),

          /// RECENT ACTIVITY
          const Text(
            "Recent Activity",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          ...provider.outings.map((outing) {
            return _ActivityTile(
              place: outing["place"],
              duration: outing["duration"],
              date: outing["date"],
            );
          }).toList(),
        ],
      ),
    );
  }
}

/// ===============================
/// PROFILE HEADER
/// ===============================
class _ProfileHeader extends StatelessWidget {
  final Map<String, dynamic> user;

  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 30,
          child: Icon(Icons.person, size: 30),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user["name"],
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(user["email"]),
            Text("${user["department"]} | ${user["regNo"]}"),
          ],
        ),
      ],
    );
  }
}

/// ===============================
/// STATS SECTION
/// ===============================
class _StatsSection extends StatelessWidget {
  final int totalOutings;
  final int totalTime;
  final double avgTime;

  const _StatsSection({
    required this.totalOutings,
    required this.totalTime,
    required this.avgTime,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _StatCard(title: "Outings", value: totalOutings.toString()),
        _StatCard(title: "Total Time", value: "$totalTime min"),
        _StatCard(title: "Avg Time", value: avgTime.toStringAsFixed(1)),
      ],
    );
  }
}

/// ===============================
/// STAT CARD
/// ===============================
class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Text(title, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ===============================
/// ACTIVITY TILE
/// ===============================
class _ActivityTile extends StatelessWidget {
  final String place;
  final int duration;
  final String date;

  const _ActivityTile({
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