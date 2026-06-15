import 'package:flutter/material.dart';
import '../theme/yatri_theme.dart';
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
    _NavItem(icon: Icons.directions_car_rounded, label: 'My Rides'),
    _NavItem(icon: Icons.edit_square, label: 'Post'),
    _NavItem(icon: Icons.near_me_rounded, label: 'Requests'),
    _NavItem(icon: Icons.person_outline_rounded, label: 'Profile'),
  ];

  // Index of the center/highlighted item
  static const int _centerIndex = 2;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isSelected = index == selectedIndex;
              final isCenter = index == _centerIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: isCenter
                        ? _buildCenterItem(item, isSelected)
                        : _buildRegularItem(item, isSelected),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildCenterItem(_NavItem item, bool isSelected) {
    return Column(
      key: const ValueKey('center'),
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? YatriTheme.primary
                : const Color(0xFFE8F5EE),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: YatriTheme.primary.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Icon(
            item.icon,
            color: isSelected ? Colors.white : YatriTheme.primary,
            size: 26,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          item.label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isSelected ? YatriTheme.primary : const Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }

  Widget _buildRegularItem(_NavItem item, bool isSelected) {
    return Column(
      key: ValueKey(item.label),
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected
                ? YatriTheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            item.icon,
            color: isSelected ? YatriTheme.primary : const Color(0xFF94A3B8),
            size: 22,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          item.label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? YatriTheme.primary : const Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
