import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../util/responsive.dart';
import '../pages/rider_dashboard.dart';

class PassengerProfilePage extends StatelessWidget {
  const PassengerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F4), // match off-white background
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom +
              100, // extra spacing for bottom nav bar
        ),
        child: Column(
          children: [
            // ─── Header Hero Section ───
            _buildProfileHeroSection(context, r),

            // ─── Settings List Container ───
            Transform.translate(
              offset: const Offset(
                  0, 0), // moved down to prevent overlapping the cropped image
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Column(
                      children: _buildProfileMenuItems(),
                    ),
                  ),
                ),
              ),
            ),

            // ─── Switch to Driver Mode Banner ───
            Transform.translate(
              offset: const Offset(0, -12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSwitchDriverCard(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeroSection(BuildContext context, Responsive r) {


    return Container(
      width: double.infinity,
      height: 230, // cropped height
      decoration: const BoxDecoration(
        color: Color(0xFFFAF7F4),
      ),
      child: Stack(
        children: [
          // Background watercolor image with Nyatapola temple
          Positioned.fill(
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Colors.transparent,
                  ],
                  stops: [0.85, 1.0], // smooth fade towards the bottom
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                'assets/images/passenger_profile_bg.png',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          // Profile row containing avatar, name, email and phone number
          Positioned(
            left: 15,
            bottom: 100, // adjusted for the new cropped height
            right: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Avatar with Red Border
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE52020),
                      width: 2.0,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        AssetImage('assets/images/profile_image.jpg'),
                  ),
                ),
                const SizedBox(width: 18),
                // Name & Info Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Sushma Shrestha',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'sushma@email.com',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '+977 98xxxxxxxx',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: const Color(
                              0xFFE52020), // red colored phone number
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildProfileMenuItems() {
    final menuData = [
      {'icon': Icons.person_outline_rounded, 'title': 'Edit Profile'},
      {'icon': Icons.credit_card_outlined, 'title': 'Payment Methods'},
      {
        'icon': Icons.account_balance_wallet_outlined,
        'title': 'My Wallet',
        'trailing': 'Rs. 589'
      },
      {'icon': Icons.confirmation_num_outlined, 'title': 'Coupon'},
      {'icon': Icons.shield_outlined, 'title': 'Safety'},
      {'icon': Icons.help_outline_rounded, 'title': 'Help & Support'},
      {'icon': Icons.settings_outlined, 'title': 'Settings'},
    ];

    final widgets = <Widget>[];

    for (var i = 0; i < menuData.length; i++) {
      final item = menuData[i];
      widgets.add(
        _buildProfileMenuItem(
          icon: item['icon'] as IconData,
          title: item['title'] as String,
          trailingText: item['trailing'] as String?,
        ),
      );

      if (i < menuData.length - 1) {
        widgets.add(
          const Divider(
            height: 1,
            color: Color(0xFFF1F5F9),
          ),
        );
      }
    }

    return widgets;
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    String? trailingText,
  }) {
    return InkWell(
      onTap: () {
        // Menu item click action
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            // Soft red background with red icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F2), // soft light red tint
                borderRadius: BorderRadius.circular(9),
              ),
              alignment: Alignment.center,
              child: Icon(
                icon,
                color: const Color(0xFFE52020), // Red theme
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(width: 6),
            ],
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFE52020), // red chevron
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchDriverCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Faint city skyline background on the bottom right
            Positioned(
              right: -10,
              bottom: -5,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.18, // soft faint background
                  child: Image.asset(
                    'assets/images/passenger_bottom_bg.png',
                    height: 70,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Content row
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Car outline in red inside light red circle
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF1F2),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.directions_car_outlined,
                      color: Color(0xFFE52020),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Switch to Driver Mode',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Start earning rides and more',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Solid Red Switch Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const RiderDashboard(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 400),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB91C1C), // Crimson Red
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Switch',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
