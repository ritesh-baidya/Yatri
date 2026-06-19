import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';

/// A wrapper widget for the passenger dashboard that reuses the existing
/// [YatriBottomNavBar] implementation. This keeps the original
/// `PassengerDashboard` code unchanged while providing the expected
/// `PassengerBottomNavBar` class.
class PassengerBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const PassengerBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return YatriBottomNavBar(
      selectedIndex: selectedIndex,
      onTap: onTap,
    );
  }
}
