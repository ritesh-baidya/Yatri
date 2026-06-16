import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class YatriBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const YatriBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.directions_car_outlined, label: 'My Rides'),
    _NavItem(icon: Icons.edit_square, label: 'Post'),
    _NavItem(icon: Icons.qr_code_outlined, label: 'QR Pay'),
    _NavItem(icon: Icons.calendar_today_outlined, label: 'Booking'),
    _NavItem(icon: Icons.person_outline_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: Container(
          height: 76,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 235, 234, 234),
            borderRadius: BorderRadius.circular(38),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isSelected = index == selectedIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: _buildItem(item, isSelected),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(_NavItem item, bool isSelected) {
    final activeColor = const Color(0xFF007A48);
    final inactiveColor = const Color(0xFF64748B);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        Icon(
          item.icon,
          color: isSelected ? activeColor : inactiveColor,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          item.label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? activeColor : inactiveColor,
          ),
        ),
        const SizedBox(height: 8),
        // Active indicator line at the bottom
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isSelected ? 32 : 0,
          height: 3,
          decoration: BoxDecoration(
            color: activeColor,
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
