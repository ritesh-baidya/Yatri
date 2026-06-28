import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'passenger_dashboard.dart';
import 'passenger_ride_details_page.dart';

class PassengerBookingPage extends StatefulWidget {
  const PassengerBookingPage({super.key});

  @override
  State<PassengerBookingPage> createState() => _PassengerBookingPageState();
}

class _PassengerBookingPageState extends State<PassengerBookingPage> {
  int _selectedTab = 0; // 0 for Upcoming, 1 for Completed

  // Mock data for upcoming rides to allow state changes (e.g. Cancel)
  final List<Map<String, dynamic>> _upcomingRides = [
    {
      'id': 'up1',
      'from': 'Kathmandu',
      'to': 'Pokhara',
      'status': 'Confirmed',
      'date': 'Sun, 25 May',
      'time': '7:00 AM',
      'driverName': 'Ram Kumar',
      'driverPhone': '+977 980xxxxxxxxx',
      'driverRating': 4.8,
      'seats': '1 Seat',
      'price': 'Rs. 700',
    },
    {
      'id': 'up2',
      'from': 'Kathmandu',
      'to': 'Chitwan',
      'status': 'Pending',
      'date': 'Sun, 8 Jun',
      'time': '9:00 AM',
      'driverName': 'Bibash Tamang',
      'driverPhone': '+977 981xxxxxxxxx',
      'driverRating': 4.7,
      'seats': '1 Seat',
      'price': 'Rs. 1500',
    }
  ];

  // Mock data for completed rides to allow interactive rating updates
  final List<Map<String, dynamic>> _completedRides = [
    {
      'id': 'comp1',
      'from': 'Kathmandu',
      'to': 'Pokhara',
      'status': 'Completed',
      'date': '10 May 2025',
      'time': '7:00 AM',
      'driverName': 'Ram Kumar',
      'driverPhone': '+977 980xxxxxxxxx',
      'rating': 0, // user selected rating
      'badgeColor': const Color(0xFFECFDF5),
      'textColor': const Color(0xFF007A48),
    },
    {
      'id': 'comp2',
      'from': 'Kathmandu',
      'to': 'Butwal',
      'status': 'Completed',
      'date': '02 May 2025',
      'time': '8:00 AM',
      'driverName': 'Sujan Thapa',
      'driverPhone': '+977 981xxxxxxxxx',
      'rating': 0,
      'badgeColor': const Color(0xFFECFDF5),
      'textColor': const Color(0xFF007A48),
    },
    {
      'id': 'comp3',
      'from': 'Kathmandu',
      'to': 'Chitwan',
      'status': 'Completed', // Rendered in orange matching the reference image
      'date': 'Sun, 8 Jun',
      'time': '9:00 AM',
      'driverName': 'Bibash Tamang',
      'driverPhone': '+977 981xxxxxxxxx',
      'rating': 0,
      'badgeColor': const Color(0xFFFFF7ED),
      'textColor': const Color(0xFFEA580C),
    }
  ];

  void _showCancelDialog(Map<String, dynamic> ride) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF1F2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFE52020),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Cancel Booking?',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Are you sure you want to cancel your ride from ${ride['from']} to ${ride['to']}?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'No, Keep',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            _upcomingRides.removeWhere(
                                (item) => item['id'] == ride['id']);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Booking to ${ride['to']} cancelled successfully.'),
                              backgroundColor: const Color(0xFFE52020),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE52020),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Yes, Cancel',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic top background asset
    final bgAsset = _selectedTab == 0
        ? 'assets/images/passenger_booking_bg_1.png'
        : 'assets/images/passenger_booking_bg_2.png';

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F4),
      body: Stack(
        children: [
          // ─── Dynamic Top Header Background Image ───
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 180,
            child: Image.asset(
              bgAsset,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          // ─── Fixed Header and Tab Bar ───
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Header Row (Back Button + Centered Title)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Arrow circular container
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PassengerDashboard()),
                          );
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Color(0xFFE52020),
                            size: 24,
                          ),
                        ),
                      ),
                      // Title with Diamond Divider
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Transform.translate(
                              offset: const Offset(0, 45),
                              child: Text(
                                'My Bookings',
                                style: GoogleFonts.inter(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFFE52020),
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Transform.translate(
                              offset: const Offset(0, 40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 32,
                                    height: 1.2,
                                    color: const Color(0xFFE52020),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '❖',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFFE52020),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 32,
                                    height: 1.2,
                                    color: const Color(0xFFE52020),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 44), // placeholder for alignment
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                // Sliding Pill Tab Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Sliding Selector Background
                        AnimatedAlign(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeInOut,
                          alignment: _selectedTab == 0
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: FractionallySizedBox(
                            widthFactor: 0.5,
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE52020),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        // Tab Buttons
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedTab = 0),
                                behavior: HitTestBehavior.opaque,
                                child: Center(
                                  child: Text(
                                    'Upcoming',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: _selectedTab == 0
                                          ? Colors.white
                                          : const Color(0xFF718096),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedTab = 1),
                                behavior: HitTestBehavior.opaque,
                                child: Center(
                                  child: Text(
                                    'Completed',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: _selectedTab == 1
                                          ? Colors.white
                                          : const Color(0xFF718096),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // List content – now scrollable independently
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 120),
                      child: _selectedTab == 0
                          ? _buildUpcomingList()
                          : _buildCompletedList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════
  // UPCOMING TAB LIST
  // ════════════════════════════════════════════════════
  Widget _buildUpcomingList() {
    if (_upcomingRides.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Icon(Icons.calendar_today_outlined,
                size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No upcoming bookings',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: _upcomingRides.map((ride) {
        final isConfirmed = ride['status'] == 'Confirmed';
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
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
                    builder: (context) => RideDetailsPage(
                      driverName: ride['driverName'],
                      driverInitials: ride['driverName']
                          .split(' ')
                          .map((e) => e[0])
                          .join(),
                      driverRating: ride['driverRating'],
                      totalRides: 128,
                      pickupLocation: ride['from'],
                      dropoffLocation: ride['to'],
                      pricePerSeat: int.tryParse(
                              ride['price'].replaceAll(RegExp(r'[^0-9]'), '')) ??
                          700,
                      availableSeats: 3,
                    ),
                  ),
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row (Route and Status Badge)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${ride['from']} → ${ride['to']}',
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: isConfirmed
                                ? const Color(0xFFECFDF5)
                                : const Color(0xFFFFF7ED),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            ride['status'],
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isConfirmed
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFEA580C),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Subtitle (Date and Time)
                    Text(
                      '${ride['date']}  •  ${ride['time']}',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE52020),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Driver Information Row
                    Row(
                      children: [
                        // Default Red Outline Avatar
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFFE52020), width: 1.2),
                            color: const Color(0xFFFFF1F2),
                          ),
                          child: const Icon(
                            Icons.person_outline_rounded,
                            color: Color(0xFFE52020),
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Driver details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ride['driverName'],
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                ride['driverPhone'],
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                ride['seats'],
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Rating rating indicators
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Color(0xFF10B981), size: 18),
                            const SizedBox(width: 4),
                            Text(
                              ride['driverRating'].toString(),
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Pricing Row / Info Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // For confirmed rides, show "1 Seat" bold info on left
                        isConfirmed
                            ? RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '1 ',
                                      style: GoogleFonts.inter(
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFFE52020),
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Seat',
                                      style: GoogleFonts.inter(
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF1A1A1A),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),

                        // Price (shown left for pending, right for confirmed)
                        Align(
                          alignment: isConfirmed
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Text(
                            ride['price'],
                            style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFE52020),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Action Buttons for Confirmed Booking
                    if (isConfirmed) ...[
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          // Chat Button
                          Expanded(
                            child: SizedBox(
                              height: 42,
                              child: OutlinedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Opening chat with ${ride['driverName']}...'),
                                      backgroundColor: const Color(0xFFE52020),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                      color: Color(0xFFFECACA), width: 1.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  elevation: 0,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                          Icons.chat_bubble_outline_rounded,
                                          color: Color(0xFFE52020),
                                          size: 18),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Chat',
                                        style: GoogleFonts.inter(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFFE52020),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Call Button
                          Expanded(
                            child: SizedBox(
                              height: 42,
                              child: OutlinedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Calling ${ride['driverName']} (${ride['driverPhone']})...'),
                                      backgroundColor: const Color(0xFFE52020),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                      color: Color(0xFFFECACA), width: 1.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  elevation: 0,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.call_outlined,
                                          color: Color(0xFFE52020), size: 18),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Call',
                                        style: GoogleFonts.inter(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFFE52020),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Cancel Button
                          Expanded(
                            child: SizedBox(
                              height: 42,
                              child: OutlinedButton(
                                onPressed: () => _showCancelDialog(ride),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                      color: Color(0xFFFECACA), width: 1.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  elevation: 0,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.cancel_outlined,
                                          color: Color(0xFFE52020), size: 18),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Cancel',
                                        style: GoogleFonts.inter(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFFE52020),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ════════════════════════════════════════════════════
  // COMPLETED TAB LIST
  // ════════════════════════════════════════════════════
  Widget _buildCompletedList() {
    return Column(
      children: _completedRides.map((ride) {
        final currentRating = ride['rating'] as int;
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // ─── Custom Curve & Pin Illustration in Background ───
              Positioned(
                right: 16,
                bottom: 16,
                width: 130,
                height: 60,
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    // The dotted curve line
                    Positioned.fill(
                      child: CustomPaint(
                        painter: DashedCurvePainter(),
                      ),
                    ),
                    // Grey Pin at the end of the curve
                    const Positioned(
                      right: 0,
                      bottom: 22,
                      child: Icon(
                        Icons.location_on,
                        color: Color(0xFFCBD5E1), // light grey pin
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),

              // ─── Card Content Foreground ───
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row (Route and Status Badge)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${ride['from']} → ${ride['to']}',
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: ride['badgeColor'],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            ride['status'],
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: ride['textColor'],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Subtitle (Date and Time in Red)
                    Text(
                      '${ride['date']}  •  ${ride['time']}',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE52020),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Driver Row
                    Row(
                      children: [
                        // Default Red Outline Avatar
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFFE52020), width: 1.2),
                            color: const Color(0xFFFFF1F2),
                          ),
                          child: const Icon(
                            Icons.person_outline_rounded,
                            color: Color(0xFFE52020),
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Driver details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ride['driverName'],
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                ride['driverPhone'],
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Rating Section ("Rate this ride" + 5 interactive stars)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rate this ride',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: List.generate(5, (index) {
                            final starIndex = index + 1;
                            final isSelected = starIndex <= currentRating;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  ride['rating'] = starIndex;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Thank you for rating ${ride['driverName']} $starIndex stars!'),
                                    backgroundColor: const Color(0xFF007A48),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Icon(
                                  isSelected
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  color: isSelected
                                      ? const Color(0xFFFBBF24)
                                      : const Color(0xFFCBD5E1),
                                  size: 24,
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ════════════════════════════════════════════════════
// CUSTOM PAINTER FOR DASHED WAVE PATH
// ════════════════════════════════════════════════════
class DashedCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCBD5E1) // light grey
      ..style = PaintingStyle.fill;

    final path = Path();
    // Wave curve starting from left, curving down then up to the right
    path.moveTo(0, size.height * 0.6);
    path.cubicTo(
      size.width * 0.35,
      size.height * 0.95,
      size.width * 0.65,
      size.height * 0.25,
      size.width * 0.95,
      size.height * 0.35,
    );

    const dotDistance = 7.0;

    // Draw dotted circle effect along path metrics
    for (final pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final tangent = pathMetric.getTangentForOffset(distance);
        if (tangent != null) {
          canvas.drawCircle(tangent.position, 1.8, paint);
        }
        distance += dotDistance;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
