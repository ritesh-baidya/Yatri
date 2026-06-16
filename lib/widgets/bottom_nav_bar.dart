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
    _NavItem(icon: Icons.directions_car_rounded, label: 'My Rides'),
    _NavItem(icon: Icons.edit_square, label: 'Post'),
    _NavItem(icon: Icons.qr_code_rounded, label: 'QR Pay'),
    _NavItem(icon: Icons.notifications_rounded, label: 'Booking'),
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
          // 1. Custom Painted Background with Notch, Rounded Corners and Shadow
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

          // 3. Floating Circular QR Pay Button (sunken into the notch)
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
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFF02462a),
                    width: 3.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.qr_code_rounded, // QR Code icon
                  color: Color(0xFF02462a),
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
        const SizedBox(height: 26),
        Text(
          item.label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 6),
        const SizedBox(height: 3),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildRegularItem(_NavItem item, bool isSelected) {
    return Column(
      key: ValueKey(item.label),
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(
          item.icon,
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.6),
          size: 22,
        ),
        const SizedBox(height: 4),
        Text(
          item.label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 6),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: isSelected ? 1.0 : 0.0,
          child: Container(
            width: 16,
            height: 3,
            decoration: BoxDecoration(
              color: const Color(0xFF00CC76), // bright green selection indicator
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

class BottomNavBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFF02462a)
      ..style = PaintingStyle.fill;

    double centerX = size.width / 2;
    double notchWidth = 84.0;
    double notchDepth = 26.0;
    double cornerRadius = 24.0;

    Path path = Path();
    // Start at bottom-left
    path.moveTo(0, size.height);
    
    // Draw left vertical line up to the top curve
    path.lineTo(0, cornerRadius);
    
    // Top-left corner curve
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

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

    // Draw top edge line to the top-right curve
    path.lineTo(size.width - cornerRadius, 0);

    // Top-right corner curve
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);

    // Draw right vertical line to bottom-right
    path.lineTo(size.width, size.height);
    
    // Draw bottom horizontal line back to bottom-left
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
