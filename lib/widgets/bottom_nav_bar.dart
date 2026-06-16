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
    _NavItem(icon: Icons.qr_code_rounded, label: 'QR Pay'),
    _NavItem(icon: Icons.near_me_rounded, label: 'Requests'),
    _NavItem(icon: Icons.person_outline_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    const double barHeight = 72.0;
    const double buttonSize = 58.0;

    return SafeArea(
      top: false,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. Custom Painted Background with Notch and Shadow
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, barHeight),
            painter: BottomNavBarPainter(),
          ),

          // 2. Navigation Items Row
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: barHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_items.length, (index) {
                final item = _items[index];
                final isSelected = index == selectedIndex;
                final isCenter = index == 2;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(index),
                    behavior: HitTestBehavior.opaque,
                    child: isCenter
                        ? _buildCenterTextPlaceholder(item, isSelected)
                        : _buildRegularItem(item, isSelected),
                  ),
                );
              }),
            ),
          ),

          // 3. Floating Circular Blue Scan Button (sunken into the notch)
          Positioned(
            top: -20, // Positioned sticking out above the nav bar
            left: MediaQuery.of(context).size.width / 2 - (buttonSize / 2),
            width: buttonSize,
            height: buttonSize,
            child: GestureDetector(
              onTap: () => onTap(2),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: YatriTheme.primary, // green theme
                  boxShadow: [
                    BoxShadow(
                      color: YatriTheme.primary.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.qr_code_rounded, // QR Code icon
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterTextPlaceholder(_NavItem item, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(height: 42),
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
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
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

class BottomNavBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromARGB(255, 236, 234, 234)
      ..style = PaintingStyle.fill;

    double centerX = size.width / 2;
    double notchWidth = 84.0;
    double notchDepth = 26.0;

    Path path = Path();
    path.moveTo(0, 0);

    // Draw top edge line up to the notch
    path.lineTo(centerX - notchWidth / 2 - 12, 0);

    // Left curve leading into the notch
    path.cubicTo(
      centerX - notchWidth / 2 + 5,
      0,
      centerX - notchWidth / 2 + 10,
      notchDepth,
      centerX,
      notchDepth,
    );

    // Right curve leading out of the notch
    path.cubicTo(
      centerX + notchWidth / 2 - 10,
      notchDepth,
      centerX + notchWidth / 2 - 5,
      0,
      centerX + notchWidth / 2 + 12,
      0,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Draw shadow under the bottom navigation bar path
    canvas.drawShadow(
      path,
      Colors.black.withValues(alpha: 0.12),
      12.0,
      false,
    );

    // Paint the navigation bar background path
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
