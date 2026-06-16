import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/yatri_theme.dart';
import 'widgets/bottom_nav_bar.dart';
import 'util/responsive.dart';
import 'widgets/earnings_card.dart';
import 'widgets/upcoming_ride_card.dart';
import 'pages/post_ride_page.dart';
import 'pages/profile_page.dart';
import 'pages/booking_page.dart';

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

  Widget _buildOtherTabContent(int index) {
    if (index == 1) {
      return const PostRidePage();
    }
    if (index == 2) {
      return const YatriFonepayQR();
    }
    if (index == 3) {
      return const BookingPage();
    }
    if (index == 4) {
      return const ProfilePage();
    }

    final titles = {
      1: 'Post',
      3: 'Requests',
      4: 'Profile',
    };
    final title = titles[index] ?? 'Screen';

    return Scaffold(
      backgroundColor: YatriTheme.scaffoldBg,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          '$title Screen',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    final isDesktop = width > 480;

    Widget dashboardBody;
    if (_currentTabIndex == 0) {
      dashboardBody = Column(
        children: [
          _buildHeaderSection(),
          // White Content Section
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._buildMainContentSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      dashboardBody = _buildOtherTabContent(_currentTabIndex);
    }

    Widget dashboardContent = Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F3D22),
              Color(0xFF1A5C35),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Dashboard Content
            Positioned.fill(
              child: dashboardBody,
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
          ],
        ),
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
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(44),
                  border: Border.all(color: const Color(0xFF09140E), width: 10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.65),
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

  // Custom painted background for header section (gradient + car + user stats + earnings card)
  Widget _buildHeaderSection() {
    final r = Responsive(context);
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          // Car illustration on the right (responsive width, blended with background)
          Positioned(
            right: -r.widthPct(0.1), // Move further left
            top: r.heightPct(0.08), // moved further down
            width: r.widthPct(
                0.85), // Increased width to scale and position the car correctly
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
              r.heightPct(0.04),
              r.widthPct(0.05),
              0.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting and Notification Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Transform.translate(
                      offset:
                          const Offset(0, 45), // Move only greeting text down
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Hello, Ram Kumar 👋",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Ready to drive today?",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Notification bell with red dot
                    Stack(
                      children: [
                        const Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                          size: 30,
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEF4444),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                    height: 106), // Adjusted to move EarningsCard 5px down
                const EarningsCard(),
                const SizedBox(
                    height: 18), // More space before the white section
              ],
            ),
          ),
        ],
      ),
    );
  }

  // The bottom section containing upcoming ride with curved white background
  List<Widget> _buildMainContentSection() {
    return [
      // "Upcoming Ride" Row
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Text(
              "Upcoming Ride",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
          ),

          // "Next Up" Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Next Up",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF059669),
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.trending_up,
                  color: Color(0xFF059669),
                  size: 14,
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),

      // Upcoming Ride Card Widget
      const UpcomingRideCard(),
      const SizedBox(height: 24),
    ];
  }
}

class YatriFonepayQR extends StatefulWidget {
  const YatriFonepayQR({super.key});

  @override
  State<YatriFonepayQR> createState() => _YatriFonepayQRState();
}

class _YatriFonepayQRState extends State<YatriFonepayQR> {
  bool _isPaid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              // Payment QR Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Fonepay Logo
                      Image.asset(
                        'assets/images/fonepay_logo.png',
                        height: 40,
                      ),
                      const SizedBox(height: 24),

                      // QR Code Container (Green theme frame)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F6EE), // light green bg
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: YatriTheme.primary.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Mock QR Code layout
                            _buildMockQRCode(180),

                            // Center icon decoration (Yatri car or checkmark if paid)
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _isPaid
                                      ? const Color(0xFF10B981)
                                      : YatriTheme.primary,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Icon(
                                _isPaid
                                    ? Icons.check_circle
                                    : Icons.directions_car_rounded,
                                color: _isPaid
                                    ? const Color(0xFF10B981)
                                    : YatriTheme.primary,
                                size: 22,
                              ),
                            ),

                            // Green Overlay if paid
                            if (_isPaid)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.95),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_circle_rounded,
                                        color: Color(0xFF10B981),
                                        size: 60,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Payment Success",
                                        style: TextStyle(
                                          color: Color(0xFF0F172A),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Payment details
                      _buildDetailRow("Driver Name", "Ram Kumar"),
                      const SizedBox(height: 10),
                      _buildDetailRow("Vehicle No.", "BA 2 PA 9842"),
                      const SizedBox(height: 10),
                      _buildDetailRow("Total Fare", "Rs. 2,100", isPrice: true),

                      const Divider(
                          height: 32, color: Color(0xFFF1F5F9), thickness: 1.5),

                      // Status Widget
                      const SizedBox.shrink(),
                      // Status indicators removed per user request
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              if (_isPaid)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _isPaid = false;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Reset Payment Status",
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isPrice = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isPrice ? const Color(0xFF0F172A) : const Color(0xFF334155),
            fontSize: isPrice ? 16 : 14,
            fontWeight: isPrice ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMockQRCode(double size) {
    return Container(
      width: size,
      height: size,
      color: Colors.transparent,
      child: CustomPaint(
        painter: QRCodePainter(color: YatriTheme.primary),
      ),
    );
  }
}

class QRCodePainter extends CustomPainter {
  final Color color;
  QRCodePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    double finderSize = size.width * 0.28;

    _drawFinderPattern(canvas, const Offset(0, 0), finderSize);
    _drawFinderPattern(canvas, Offset(size.width - finderSize, 0), finderSize);
    _drawFinderPattern(canvas, Offset(0, size.height - finderSize), finderSize);

    final pixelSize = size.width / 21;

    for (int r = 0; r < 21; r++) {
      for (int c = 0; c < 21; c++) {
        if ((r < 7 && c < 7) || (r < 7 && c >= 14) || (r >= 14 && c < 7)) {
          continue;
        }
        if (r >= 9 && r <= 11 && c >= 9 && c <= 11) {
          continue;
        }

        final hash = (r * 37 + c * 17) % 5;
        if (hash == 1 || hash == 3) {
          canvas.drawRect(
            Rect.fromLTWH(
                c * pixelSize, r * pixelSize, pixelSize - 0.5, pixelSize - 0.5),
            paint,
          );
        }
      }
    }
  }

  void _drawFinderPattern(Canvas canvas, Offset offset, double size) {
    final paintOuter = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final paintInner = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final pixel = size / 7;

    canvas.drawRect(
        Rect.fromLTWH(offset.dx, offset.dy, size, size), paintOuter);
    canvas.drawRect(
        Rect.fromLTWH(offset.dx + pixel, offset.dy + pixel, size - pixel * 2,
            size - pixel * 2),
        paintInner);
    canvas.drawRect(
        Rect.fromLTWH(offset.dx + pixel * 2, offset.dy + pixel * 2,
            size - pixel * 4, size - pixel * 4),
        paintOuter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
