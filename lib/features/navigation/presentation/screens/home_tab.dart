import 'package:flutter/material.dart';

import '../../../home/presentation/screens/home_screen.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Reuse the existing HomeScreen to avoid duplicating logic/UI.
    return const HomeScreen();
  }
}
