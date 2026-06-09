import 'package:flutter/material.dart';
import '../../../profile/screens/profile_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileScreen(); // ✅ DIRECT CONNECTION
  }
}