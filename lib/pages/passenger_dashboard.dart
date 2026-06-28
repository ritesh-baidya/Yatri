import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/passenger_bottom_nav_bar.dart';
import '../pages/notification_page.dart';
import '../pages/passenger_booking_page.dart';
import '../pages/passenger_profile.dart';
import '../pages/passenger_search_results.dart';

class PassengerDashboard extends StatefulWidget {
  const PassengerDashboard({super.key});

  @override
  State<PassengerDashboard> createState() => _PassengerDashboardState();
}

class _PassengerDashboardState extends State<PassengerDashboard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentTabIndex = 0;

  // Swap icon state
  bool _isSwapped = false;
  String _fromCity = 'Kathmandu';
  String _toCity = 'Pokhara';
  DateTime _selectedDate = DateTime(2025, 5, 25);
  int _seatCount = 1;

  void _selectFromCity() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Departure City'),
        children: [
          'Kathmandu',
          'Pokhara',
          'Chitwan',
          'Butwal',
          'Biratnagar',
          'Lalitpur',
          'Bhaktapur'
        ].map((city) {
          return SimpleDialogOption(
            onPressed: () {
              setState(() {
                _fromCity = city;
              });
              Navigator.pop(context);
            },
            child: Text(city, style: const TextStyle(fontSize: 16)),
          );
        }).toList(),
      ),
    );
  }

  void _selectToCity() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Destination City'),
        children: [
          'Kathmandu',
          'Pokhara',
          'Chitwan',
          'Butwal',
          'Biratnagar',
          'Lalitpur',
          'Bhaktapur'
        ].map((city) {
          return SimpleDialogOption(
            onPressed: () {
              setState(() {
                _toCity = city;
              });
              Navigator.pop(context);
            },
            child: Text(city, style: const TextStyle(fontSize: 16)),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _selectSeats() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Seats'),
        children: List.generate(6, (index) => index + 1).map((seats) {
          return SimpleDialogOption(
            onPressed: () {
              setState(() {
                _seatCount = seats;
              });
              Navigator.pop(context);
            },
            child: Text('$seats ${seats == 1 ? 'Seat' : 'Seats'}',
                style: const TextStyle(fontSize: 16)),
          );
        }).toList(),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final wd = weekdays[date.weekday - 1];
    final m = months[date.month - 1];
    return '$wd, ${date.day} $m ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 480;

    Widget body;
    if (_currentTabIndex == 0) {
      body = _buildDashboardHome();
    } else {
      body = _buildOtherTab(_currentTabIndex);
    }

    Widget scaffold = Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFFAF7F4),
      body: Stack(
        children: [
          Positioned.fill(child: body),
          // Bottom nav bar pinned
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: PassengerBottomNavBar(
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
    );

    if (isDesktop) {
      final height = MediaQuery.of(context).size.height;
      final clampedHeight = height > 940 ? 900.0 : height - 40.0;
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1A0A0A),
                        Color(0xFF2D1515),
                      ],
                    ),
                  ),
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
                  border: Border.all(color: const Color(0xFF1A0A0A), width: 10),
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
                  child: scaffold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return scaffold;
  }

  Widget _buildOtherTab(int index) {
    if (index == 1) return const PassengerBookingPage();
    if (index == 2) {
      return const Center(
        child: Text('Messages', style: TextStyle(fontSize: 18)),
      );
    }
    if (index == 3) return const PassengerProfilePage();
    return const SizedBox.shrink();
  }

  Widget _buildDashboardHome() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Hero Section with background image ───
          _buildHeroWithMap(),

          // ─── Search Card (overlapping the map) ───
          Transform.translate(
            offset: const Offset(0, -60),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSearchCard(),
            ),
          ),

          // ─── Popular Routes Section ───
          Transform.translate(
            offset: const Offset(0, -40),
            child: _buildPopularRoutes(),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════
  // HERO SECTION — Background image + greeting + map
  // ════════════════════════════════════════════════════
  Widget _buildHeroWithMap() {
    return SizedBox(
      height: 520,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background image at the top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 230,
            child: Image.asset(
              'assets/images/passenger_top_bg.png.png',
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),

          // Safe area top spacing + top bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting text and notification bell
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, Sushma 👋',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF4A4A4A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Where are you\n',
                                  style: GoogleFonts.inter(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF1A1A1A),
                                    height: 1.2,
                                  ),
                                ),
                                TextSpan(
                                  text: 'going today?',
                                  style: GoogleFonts.inter(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFFE52020),
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Notification bell
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationPage(),
                            ),
                          );
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFE8E0DA),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(
                                Icons.notifications_none_rounded,
                                color: Color(0xFF4A4A4A),
                                size: 24,
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  width: 9,
                                  height: 9,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE52020),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 1.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Map area (white rounded card with map content)
          Positioned(
            top: 185,
            left: 12,
            right: 12,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    // Map image
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/passenger_map_route.png',
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Menu button (top-left on map)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.menu,
                          color: Color(0xFF333333),
                          size: 20,
                        ),
                      ),
                    ),

                    // Map controls (top-right)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Column(
                        children: [
                          // GPS/Location button
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.my_location,
                              color: Color(0xFF333333),
                              size: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Zoom in
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              border: Border.all(
                                  color: const Color(0xFFE8E8E8), width: 0.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Color(0xFF333333),
                              size: 20,
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(12)),
                              border: const Border(
                                top: BorderSide(
                                    color: Color(0xFFE8E8E8), width: 0.5),
                                left: BorderSide(
                                    color: Color(0xFFE8E8E8), width: 0.5),
                                right: BorderSide(
                                    color: Color(0xFFE8E8E8), width: 0.5),
                                bottom: BorderSide(
                                    color: Color(0xFFE8E8E8), width: 0.5),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.remove,
                              color: Color(0xFF333333),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════
  // SEARCH CARD — From/To + Date + Passengers + Search
  // ════════════════════════════════════════════════════
  Widget _buildSearchCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // From field
          Row(
            children: [
              // Blue dot
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFBFDBFE), width: 2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: _selectFromCity,
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _fromCity,
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Swap button
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isSwapped = !_isSwapped;
                    final temp = _fromCity;
                    _fromCity = _toCity;
                    _toCity = temp;
                  });
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFE8E8E8),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.swap_vert_rounded,
                    color: Color(0xFF666666),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          // Divider line
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 12, bottom: 12),
            child: Container(
              height: 1,
              color: const Color(0xFFF0F0F0),
            ),
          ),

          // To field
          Row(
            children: [
              // Red dot
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFFE52020),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFECACA), width: 2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: _selectToCity,
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'To',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _toCity,
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Date and Passengers row
          Row(
            children: [
              // Date
              Expanded(
                child: GestureDetector(
                  onTap: _selectDate,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF5F5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.calendar_today_outlined,
                          color: Color(0xFFE52020),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF9CA3AF),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatDate(_selectedDate),
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1A1A),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Vertical divider
              Container(
                width: 1,
                height: 40,
                color: const Color(0xFFF0F0F0),
              ),

              const SizedBox(width: 16),

              // Passengers
              Expanded(
                child: GestureDetector(
                  onTap: _selectSeats,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF5F5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.person_outline_rounded,
                          color: Color(0xFFE52020),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Passengers',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF9CA3AF),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$_seatCount ${_seatCount == 1 ? 'Seat' : 'Seats'}',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1A1A),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Search Buses button
          Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE52020), Color(0xFFCC1B1B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE52020).withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PassengerSearchResultsPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.directions_bus_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Search Buses',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════
  // POPULAR ROUTES SECTION
  // ════════════════════════════════════════════════════
  Widget _buildPopularRoutes() {
    return Column(
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Routes',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              Text(
                'View all',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFE52020),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Route items with temple illustration
        Stack(
          children: [
            // Temple illustration (bottom-right background)
            Positioned(
              right: -10,
              bottom: 0,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'assets/images/passenger_bottom_bg.png',
                  width: 180,
                  height: 160,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Route list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildRouteItem(
                    fromCity: 'Kathmandu',
                    toCity: 'Pokhara',
                    duration: '6h 30m',
                    distance: '200 km',
                    color: const Color(0xFFE52020),
                    icon: Icons.directions_bus_rounded,
                  ),
                  const SizedBox(height: 8),
                  _buildRouteItem(
                    fromCity: 'Kathmandu',
                    toCity: 'Chitwan',
                    duration: '5h 30m',
                    distance: '160 km',
                    color: const Color(0xFF059669),
                    icon: Icons.directions_bus_rounded,
                  ),
                  const SizedBox(height: 8),
                  _buildRouteItem(
                    fromCity: 'Kathmandu',
                    toCity: 'Butwal',
                    duration: '7h',
                    distance: '275 km',
                    color: const Color(0xFFF59E0B),
                    icon: Icons.directions_bus_rounded,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRouteItem({
    required String fromCity,
    required String toCity,
    required String duration,
    required String distance,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF0F0F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PassengerSearchResultsPage(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Bus icon with colored background
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),

                // Route details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              fromCity,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1A1A),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Color(0xFF9CA3AF),
                              size: 16,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              toCity,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1A1A),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$duration  •  $distance',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),

                // Chevron
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFD1D5DB),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
