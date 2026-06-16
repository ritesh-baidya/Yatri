import 'package:flutter/material.dart';
import '../util/responsive.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileHeroSection(context),
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
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildProfileMainContentSection(),
              ),
            ),
          ),
          const SizedBox(height: 100), // Space for bottom nav bar
        ],
      ),
    );
  }

  Widget _buildProfileHeroSection(BuildContext context) {
    final r = Responsive(context);
    return Container(
      width: double.infinity,
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
            padding: EdgeInsets.fromLTRB(20, r.heightPct(0.06), 20, 24),
            child: Column(
              children: [
                // Profile Info Row
                Row(
                  children: [
                    // Profile Image with Green Border and Badge
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF10B981), width: 2),
                          ),
                          child: const CircleAvatar(
                            radius: 45,
                            backgroundImage: AssetImage('assets/images/user.png'),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 5,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, color: Colors.white, size: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    // Name and Contact
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Ram Kumar",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.chevron_right, color: Colors.white, size: 24),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                "ramkumar@email.com",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 14),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.phone, color: Color(0xFF10B981), size: 14),
                              const SizedBox(width: 6),
                              Text(
                                "+977 982xxxxxxx",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Stats Card
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: Row(
                    children: [
                      // Rating
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star, color: Color(0xFFF59E0B), size: 32),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "4.8",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "Your Rating",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(width: 1, height: 30, color: Colors.white.withValues(alpha: 0.2)),
                      // Total Rides
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFF059669),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.directions_car, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "298",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "Total Rides",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ],
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

  List<Widget> _buildProfileMainContentSection() {
    return [
      _buildProfileMenuItem(
        icon: Icons.person_outline,
        title: "Profile & Documents",
        subtitle: "Profile information, Vehicle information and Documents",
      ),
      const Divider(height: 1, color: Color(0xFFF1F5F9)),
      _buildProfileMenuItem(
        icon: Icons.account_balance_wallet_outlined,
        title: "Load Wallet",
        subtitle: "Add money to your wallet and track transactions",
      ),
      const Divider(height: 1, color: Color(0xFFF1F5F9)),
      _buildProfileMenuItem(
        icon: Icons.headset_mic_outlined,
        title: "Help & Support",
        subtitle: "Get help, contact support and view FAQs",
      ),
      const Divider(height: 1, color: Color(0xFFF1F5F9)),
      _buildProfileMenuItem(
        icon: Icons.settings_outlined,
        title: "Settings",
        subtitle: "Manage your app preferences and account settings",
      ),
      const SizedBox(height: 24),
      // Switch to Passenger Card
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFDCFCE7)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFF059669),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.people_outline, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Switch to Passenger Mode",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Book rides for your travel",
                    style: TextStyle(
                      fontSize: 13,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF065F46),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Text("Switch", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right, color: Colors.white, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Widget _buildProfileMenuItem({required IconData icon, required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF059669), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 24),
        ],
      ),
    );
  }
}
