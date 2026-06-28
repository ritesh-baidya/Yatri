import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'passenger_booking_confirmed_page.dart';

class RideDetailsPage extends StatefulWidget {
  final String driverName;
  final String driverInitials;
  final double driverRating;
  final int totalRides;
  final String pickupLocation;
  final String dropoffLocation;
  final String estimatedDuration;
  final int pricePerSeat;
  final int availableSeats;
  final List<String> amenities;

  const RideDetailsPage({
    super.key,
    this.driverName = 'Ram Kumar',
    this.driverInitials = 'RK',
    this.driverRating = 4.8,
    this.totalRides = 128,
    this.pickupLocation = 'Gongabu, Kathmandu',
    this.dropoffLocation = 'Lakeside, Pokhara',
    this.estimatedDuration = '5 hr',
    this.pricePerSeat = 700,
    this.availableSeats = 3,
    this.amenities = const ['AC', 'Music', 'Charger', 'No Smoking'],
  });

  @override
  State<RideDetailsPage> createState() => _RideDetailsPageState();
}

class _RideDetailsPageState extends State<RideDetailsPage> {
  int _selectedSeats = 1;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 480;

    Widget mainContent = Scaffold(
      backgroundColor: const Color(0xFFFAF7F4),
      body: Stack(
        children: [
          // ─── Top Right Festive Banner ───
          Positioned(
            top: 47,
            right: 0,
            width: width * 0.40,
            child: Image.asset(
              'assets/images/passenger_rider_details_bg_1.png',
              fit: BoxFit.contain,
            ),
          ),
          // ─── Main Content ───
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // ─── Header ───
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
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
                            color: Color(0xFF1A1A1A),
                            size: 22,
                          ),
                        ),
                      ),
                      // Title
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Ride Details',
                              style: GoogleFonts.inter(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFE52020),
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 32,
                                  height: 1.2,
                                  color: const Color(0xFFDC2626),
                                ),
                                const SizedBox(width: 8),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Transform.rotate(
                                      angle: 45 * 3.1415927 / 180,
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border.all(
                                            color: const Color(0xFFDC2626),
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 4,
                                      height: 4,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFDC2626),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 32,
                                  height: 1.2,
                                  color: const Color(0xFFDC2626),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 44),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ─── Scrollable Content ───
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        // ─── Driver Info Card ───
                        _buildDriverCard(),
                        const SizedBox(height: 12),
                        // ─── Route Card ───
                        _buildRouteCard(),
                        const SizedBox(height: 12),
                        // ─── Combined Seat Selector & Trip Info Card ───
                        _buildCombinedSeatsAndInfoCard(),
                        const SizedBox(height: 12),
                        // ─── Amenities ───
                        _buildAmenities(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ─── Bottom Book Button ───
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 16 + MediaQuery.of(context).padding.bottom),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF7F4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookingConfirmedPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE52020),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Book This Seat',
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // Desktop wrapper
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
                  child: mainContent,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return mainContent;
  }

  // ════════════════════════════════════════════════════
  // DRIVER CARD
  // ════════════════════════════════════════════════════
  Widget _buildDriverCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE2E8F0).withValues(alpha: 0.6),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar Circle with Initials
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFEE2D5),
                border: Border.all(
                  color: const Color(0xFFFFD0BC),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  widget.driverInitials,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Driver Name & Rating
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.driverName,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    runSpacing: 2,
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFE52020), size: 18),
                      Text(
                        widget.driverRating.toString(),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      Text(
                        '(${widget.totalRides} rides)',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Verified Badge
            Flexible(
              flex: 2,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7), // Light green background
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified_user_rounded,
                        color: Color(0xFF22C55E),
                        size: 15,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Verified Driver',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════
  // ROUTE CARD (Pickup → Drop-off)
  // ════════════════════════════════════════════════════
  Widget _buildRouteCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE2E8F0).withValues(alpha: 0.6),
            width: 1,
          ),
          image: const DecorationImage(
            image: AssetImage('assets/images/passenger_rider_details_bg_2.png'),
            fit: BoxFit.fitHeight,
            alignment: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pickup Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Green circle walking icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCFCE7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.directions_walk_rounded,
                    color: Color(0xFF16A34A),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PICKUP',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF16A34A),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.pickupLocation,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Dotted line connector centered with the circles
            Padding(
              padding: const EdgeInsets.only(left: 19),
              child: Column(
                children: List.generate(
                  5,
                  (index) => Container(
                    width: 2,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 2.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF94A3B8),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
            ),

            // Drop-off Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Red circle location pin icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEE2E2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Color(0xFFE52020),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DROP-OFF',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFE52020),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.dropoffLocation,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════
  // COMBINED SEAT SELECTOR & TRIP INFO CARD
  // ════════════════════════════════════════════════════
  Widget _buildCombinedSeatsAndInfoCard() {
    final bool canMinus = _selectedSeats > 1;
    final bool canPlus = _selectedSeats < widget.availableSeats;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFFE2E8F0).withValues(alpha: 0.6),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Title row with decorative arrows ──
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.arrow_right_alt_rounded,
                    color: Color(0xFFE52020), size: 18),
                const SizedBox(width: 6),
                Text(
                  'Select number of seats',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(width: 6),
                Transform.scale(
                  scaleX: -1,
                  child: const Icon(Icons.arrow_right_alt_rounded,
                      color: Color(0xFFE52020), size: 18),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // ── Minus / Count / Plus ──
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Minus Button
                GestureDetector(
                  onTap: () {
                    if (canMinus) setState(() => _selectedSeats--);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: canMinus
                            ? const Color(0xFFFCA5A5)
                            : const Color(0xFFE2E8F0),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.remove_rounded,
                      color: canMinus
                          ? const Color(0xFFE52020)
                          : const Color(0xFFCBD5E1),
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Count box
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$_selectedSeats',
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Plus Button
                GestureDetector(
                  onTap: () {
                    if (canPlus) setState(() => _selectedSeats++);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: canPlus
                            ? const Color(0xFFFCA5A5)
                            : const Color(0xFFE2E8F0),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      color: canPlus
                          ? const Color(0xFFE52020)
                          : const Color(0xFFCBD5E1),
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // ── Maximum seats label ──
            Text(
              'Maximum ${widget.availableSeats} seats',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),

            // Horizontal Divider
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Divider(
                color: Color(0xFFE2E8F0),
                height: 1,
                thickness: 0.8,
              ),
            ),

            // ── Trip Info Details ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Box 1: Est. duration
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        color: Color(0xFF7C3AED),
                        size: 22,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.estimatedDuration,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1A1A1A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Est. duration',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF94A3B8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                // Divider 1
                Container(
                  width: 1,
                  height: 32,
                  color: const Color(0xFFE2E8F0),
                ),
                // Box 2: Price per person
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.account_balance_wallet_outlined,
                        color: Color(0xFFE52020),
                        size: 22,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Rs. ${widget.pricePerSeat * _selectedSeats}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1A1A1A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Total price',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF94A3B8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                // Divider 2
                Container(
                  width: 1,
                  height: 32,
                  color: const Color(0xFFE2E8F0),
                ),
                // Box 3: Seats left
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.person_outline_rounded,
                        color: Color(0xFFEA580C),
                        size: 22,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${widget.availableSeats - _selectedSeats} Seats left',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1A1A1A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Limited seats',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFE52020),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════
  // AMENITIES
  // ════════════════════════════════════════════════════
  Widget _buildAmenities() {
    final amenityData = <Map<String, dynamic>>[
      {
        'icon': Icons.ac_unit_rounded,
        'label': 'AC',
        'color': const Color(0xFF0EA5E9),
        'bgColor': const Color(0xFFE0F2FE),
      },
      {
        'icon': Icons.music_note_rounded,
        'label': 'Music',
        'color': const Color(0xFF7C3AED),
        'bgColor': const Color(0xFFF3E8FF),
      },
      {
        'icon': Icons.electrical_services_rounded,
        'label': 'Charger',
        'color': const Color(0xFF16A34A),
        'bgColor': const Color(0xFFDCFCE7),
      },
      {
        'icon': Icons.smoke_free_rounded,
        'label': 'No Smoking',
        'color': const Color(0xFFE52020),
        'bgColor': const Color(0xFFFEE2E2),
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE2E8F0).withValues(alpha: 0.6),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amenities',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                // AC
                Expanded(child: _buildAmenityItem(amenityData[0])),
                _buildAmenityDivider(),
                // Music
                Expanded(child: _buildAmenityItem(amenityData[1])),
                _buildAmenityDivider(),
                // Charger
                Expanded(child: _buildAmenityItem(amenityData[2])),
                _buildAmenityDivider(),
                // No Smoking
                Expanded(child: _buildAmenityItem(amenityData[3])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenityItem(Map<String, dynamic> amenity) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: amenity['bgColor'],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            amenity['icon'],
            color: amenity['color'],
            size: 18,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          amenity['label'],
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E293B),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAmenityDivider() {
    return Container(
      width: 1,
      height: 32,
      color: const Color(0xFFE2E8F0),
    );
  }



  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: isBold ? const Color(0xFF1A1A1A) : const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: isBold ? const Color(0xFFE52020) : const Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }
}

class _SeatPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE52020)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Head (Circle)
    canvas.drawCircle(Offset(w * 0.38, h * 0.22), 5.5, paint);

    // Seat frame
    final path = Path();
    path.moveTo(w * 0.35, h * 0.36);
    path.lineTo(w * 0.42, h * 0.64);
    path.quadraticBezierTo(w * 0.44, h * 0.72, w * 0.54, h * 0.72);
    path.lineTo(w * 0.74, h * 0.72);
    path.quadraticBezierTo(w * 0.84, h * 0.72, w * 0.84, h * 0.62);
    path.quadraticBezierTo(w * 0.84, h * 0.52, w * 0.74, h * 0.52);
    path.lineTo(w * 0.54, h * 0.52);
    path.quadraticBezierTo(w * 0.46, h * 0.52, w * 0.45, h * 0.42);
    path.lineTo(w * 0.43, h * 0.36);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
