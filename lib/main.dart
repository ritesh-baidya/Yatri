import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/yatri_theme.dart';
import 'widgets/bottom_nav_bar.dart';
import 'util/responsive.dart';
import 'widgets/earnings_card.dart';
import 'widgets/upcoming_ride_card.dart';
import 'package:google_fonts/google_fonts.dart';



void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yatri Driver Dashboard',
      debugShowCheckedModeBanner: false,
      theme: YatriTheme.lightTheme,
      home: const DriverDashboard(),
    );
  }
}

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    final isDesktop = width > 480;
    final r = Responsive(context);

    Widget dashboardContent = Scaffold(
      backgroundColor: YatriTheme.scaffoldBg,
      body: Stack(
        children: [
          // Dashboard Content (non-scrollable)
          Positioned.fill(
            child: Column(
              children: [
                _buildHeaderSection(),
                // Today's Earnings Card positioned directly below header, overlapping the seam
                Transform.translate(
                  offset: const Offset(0, -120),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: r.widthPct(0.05)),
                    child: const EarningsCard(),
                  ),
                ),
                // Main Content Section shifted up accordingly to sit below EarningsCard
                Expanded(
                  child: Transform.translate(
                    offset: const Offset(0, -70),
                    child: _buildMainContentSection(),
                  ),
                ),
              ],
            ),
          ),
          


          // Pinned Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: YatriBottomNavBar(
              selectedIndex: _currentTabIndex,
              onTap: (index) {
                setState(() {
                  _currentTabIndex = index;
                });
              },
            ),
          ),

          // Simulated iOS Home Indicator at the very bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 8,
            child: Center(
              child: Container(
                width: 140,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (isDesktop) {
      final clampedHeight = height > 940 ? 900.0 : height - 40.0;
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: Image.asset(
                  'assets/images/background.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF0F172A),
                            Color(0xFF1E293B),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Center(
              child: Container(
                width: 380,
                height: clampedHeight,
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(44),
                  border: Border.all(color: const Color(0xFF09140E), width: 10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.65),
                      blurRadius: 36,
                      offset: const Offset(0, 18),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(34),
                  child: dashboardContent,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return dashboardContent;
  }

  // Simulated status bar to match the iOS 9:41 UI in the mockup
  Widget _buildSimulatedStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      color: Colors.transparent,
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Time
            const Text(
              "9:41",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            
            // Icons (Signal, Wifi, Battery)
            Row(
              children: [
                const Icon(
                  Icons.signal_cellular_alt_rounded,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 5),
                const Icon(
                  Icons.wifi,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 5),
                // Custom battery icon
                Container(
                  width: 20,
                  height: 10,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  padding: const EdgeInsets.all(1),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 12,
                      height: double.infinity,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Custom painted background for header section (gradient + mountains + car + user stats)
  Widget _buildHeaderSection() {
    final r = Responsive(context);
    return Container(
      width: double.infinity,
      height: r.heightPct(0.43), // increased height for a taller hero background

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF042111),
            const Color(0xFF0C4125),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Mountain silhouettes and pagoda temples
          Positioned.fill(
            child: CustomPaint(
              painter: MountainPainter(),
            ),
          ),
          // Car illustration on the right (responsive width, blended with background)
          Positioned(
            right: -r.widthPct(0.1), // Move further left
            
            top: r.heightPct(0.10), // moved further down
            width: r.widthPct(0.85), // Increased width to scale and position the car correctly
            height: r.heightPct(0.21), // Further reduced height
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                // Horizontal fade to hide the left edge of the image, keep right side solid
                return const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.transparent,
                    Colors.white,
                    Colors.white,
                    Colors.white,
                    Colors.white,
                  ],
                  stops: [0.0, 0.5, 0.75, 0.9, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  // Vertical fade to hide the bottom edge of the image
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.transparent,
                    ],
                    stops: [0.6, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: Image.asset(
                  'assets/images/car_top.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.centerRight,
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(
              r.widthPct(0.05),
              r.heightPct(0.045), // Reduced from 0.07 to prevent overflow
              r.widthPct(0.05),
              r.heightPct(0.015), // Reduced from 0.03 to prevent overflow
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                // Spacer for status bar
                const SizedBox(height: 60), // Increased spacing for greeting text
                
                // Greeting and Notification Row
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Hello, Ram Kumar",
                                style: GoogleFonts.inter(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                "👋",
                                style: TextStyle(fontSize: 24),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Ready to drive today?",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Notification bell with red dot
                    Transform.translate(
                      offset: const Offset(0, -32),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Stack(
                          children: [
                            const Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                              size: 28,
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // The bottom section containing upcoming ride and safety banner
  Widget _buildMainContentSection() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Upcoming Ride" Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Upcoming Ride",
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              
              // "Next Up" Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F6EE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Next Up",
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0A5C36),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_outward,
                      color: Color(0xFF0A5C36),
                      size: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Upcoming Ride Card Widget
          const UpcomingRideCard(),
          const Spacer(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

// Custom Painter to draw soft mountain silhouettes in the header
class MountainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = const Color(0xFF053E23).withOpacity(0.4)
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = const Color(0xFF03311A).withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final paintTree = Paint()
      ..color = const Color(0xFF022B16).withOpacity(0.55)
      ..style = PaintingStyle.fill;

    final paintPagoda = Paint()
      ..color = const Color(0xFF012010).withOpacity(0.65)
      ..style = PaintingStyle.fill;

    // Background mountains
    final path1 = Path();
    path1.moveTo(0, size.height);
    path1.lineTo(0, size.height * 0.5);
    path1.quadraticBezierTo(
      size.width * 0.2, size.height * 0.25,
      size.width * 0.4, size.height * 0.45,
    );
    path1.quadraticBezierTo(
      size.width * 0.65, size.height * 0.65,
      size.width * 0.9, size.height * 0.35,
    );
    path1.lineTo(size.width, size.height * 0.45);
    path1.lineTo(size.width, size.height);
    path1.close();
    canvas.drawPath(path1, paint1);

    // Foreground mountains/hills
    final path2 = Path();
    path2.moveTo(0, size.height);
    path2.lineTo(0, size.height * 0.75);
    path2.quadraticBezierTo(
      size.width * 0.25, size.height * 0.45,
      size.width * 0.5, size.height * 0.65,
    );
    path2.quadraticBezierTo(
      size.width * 0.75, size.height * 0.8,
      size.width, size.height * 0.55,
    );
    path2.lineTo(size.width, size.height);
    path2.close();
    canvas.drawPath(path2, paint2);

    // Pine trees and Pagodas sitting along the hill line
    _drawPineTree(canvas, Offset(size.width * 0.38, size.height * 0.64), 18, 42, paintTree);
    _drawPineTree(canvas, Offset(size.width * 0.44, size.height * 0.63), 14, 32, paintTree);
    
    // Pagoda 1 (Small)
    _drawPagoda(canvas, Offset(size.width * 0.49, size.height * 0.64), 22, 45, paintPagoda);
    
    // Pagoda 2 (Large, main)
    _drawPagoda(canvas, Offset(size.width * 0.56, size.height * 0.67), 28, 60, paintPagoda);
    
    // Pine trees on the right side
    _drawPineTree(canvas, Offset(size.width * 0.63, size.height * 0.68), 16, 38, paintTree);
    _drawPineTree(canvas, Offset(size.width * 0.68, size.height * 0.69), 12, 28, paintTree);
  }

  void _drawPagoda(Canvas canvas, Offset bottomCenter, double width, double height, Paint paint) {
    final double tierHeight = height / 3.5;
    
    // Base platform
    final Rect baseRect = Rect.fromLTWH(bottomCenter.dx - width * 0.4, bottomCenter.dy - 3, width * 0.8, 3);
    canvas.drawRect(baseRect, paint);
    
    double currentY = bottomCenter.dy - 3;
    
    for (int i = 0; i < 3; i++) {
      final double roofWidth = width * (1.0 - i * 0.22);
      final double bodyWidth = roofWidth * 0.55;
      final double nextY = currentY - tierHeight;
      
      // Body walls
      final Rect bodyRect = Rect.fromLTWH(bottomCenter.dx - bodyWidth / 2, nextY, bodyWidth, tierHeight);
      canvas.drawRect(bodyRect, paint);
      
      // Roof (trapezoid)
      final Path roofPath = Path();
      roofPath.moveTo(bottomCenter.dx - roofWidth / 2, nextY + tierHeight * 0.15);
      roofPath.lineTo(bottomCenter.dx + roofWidth / 2, nextY + tierHeight * 0.15);
      roofPath.lineTo(bottomCenter.dx + roofWidth * 0.25 / 2, nextY);
      roofPath.lineTo(bottomCenter.dx - roofWidth * 0.25 / 2, nextY);
      roofPath.close();
      canvas.drawPath(roofPath, paint);
      
      currentY = nextY;
    }
    
    // Spire
    final Path spirePath = Path();
    spirePath.moveTo(bottomCenter.dx - width * 0.08, currentY);
    spirePath.lineTo(bottomCenter.dx + width * 0.08, currentY);
    spirePath.lineTo(bottomCenter.dx, currentY - height * 0.12);
    spirePath.close();
    canvas.drawPath(spirePath, paint);
  }

  void _drawPineTree(Canvas canvas, Offset bottomCenter, double width, double height, Paint paint) {
    // Trunk
    final Rect trunk = Rect.fromLTWH(bottomCenter.dx - width * 0.12, bottomCenter.dy - height * 0.12, width * 0.24, height * 0.12);
    canvas.drawRect(trunk, paint);
    
    // 3 layers of leaves
    double currentY = bottomCenter.dy - height * 0.1;
    double currentWidth = width;
    final double stepY = height * 0.32;
    
    for (int i = 0; i < 3; i++) {
      final Path leaves = Path();
      leaves.moveTo(bottomCenter.dx - currentWidth / 2, currentY);
      leaves.lineTo(bottomCenter.dx + currentWidth / 2, currentY);
      leaves.lineTo(bottomCenter.dx, currentY - stepY);
      leaves.close();
      canvas.drawPath(leaves, paint);
      
      currentY -= stepY * 0.6;
      currentWidth *= 0.72;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
