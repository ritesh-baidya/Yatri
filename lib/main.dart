import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/yatri_theme.dart';
import 'widgets/bottom_nav_bar.dart';
import 'util/responsive.dart';
import 'widgets/earnings_card.dart';
import 'widgets/upcoming_ride_card.dart';

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
    final titles = ['My Rides', 'Post', 'Requests', 'Profile'];
    return Scaffold(
      backgroundColor: YatriTheme.scaffoldBg,
      appBar: AppBar(
        title: Text(
          titles[index],
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
          '${titles[index]} Screen',
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
      dashboardBody = SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderSection(),
            // White Content Section
            Container(
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
                  children: _buildMainContentSection(),
                ),
              ),
            ),
            const SizedBox(height: 100), // Space for bottom nav bar
          ],
        ),
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
            // Dashboard Content (scrollable)
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
      const SizedBox(height: 130),
    ];
  }
}
