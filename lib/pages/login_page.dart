import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'otp_verification_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    // Trigger fade-in after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _visible = true);
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onSendOtp() {
    final phone =
        _phoneController.text.isNotEmpty ? _phoneController.text : '98XXXXXXXX';
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            OtpVerificationPage(phoneNumber: phone),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOut,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ─── Top hero section: back button + welcome text + car image ───
                      _buildHeroSection(context),

                      // ─── Mobile number input ───
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                        child: _buildPhoneInputSection(),
                      ),

                      // ─── Send OTP Button ───
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                        child: _buildSendOtpButton(),
                      ),

                      // ─── Terms & Conditions ───
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
                        child: _buildTermsSection(),
                      ),

                      // ─── Continue with divider ───
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                        child: _buildContinueWithDivider(),
                      ),

                      // ─── Social login buttons ───
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                        child: _buildSocialLoginButtons(),
                      ),

                      const Spacer(),

                      // ─── Bottom cityscape illustration ───
                      _buildBottomIllustration(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // HERO SECTION — Back button, Welcome to Yatri, car image
  // ════════════════════════════════════════════════════════════
  Widget _buildHeroSection(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.38,
      child: Stack(
        children: [
          // ── Car + Nepal illustration on the right side ──
          Positioned(
            right: -20,
            top: 30,
            bottom: 0,
            width: MediaQuery.of(context).size.width * 0.65,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    Colors.white,
                    Colors.white,
                    Colors.white.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.white,
                      Colors.white.withValues(alpha: 0.0),
                    ],
                    stops: const [0.0, 0.75, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: Image.asset(
                  'assets/images/login_bg.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),

          // ── Back button (top-left) ──
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFE52020).withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFFE52020),
                  size: 20,
                ),
              ),
            ),
          ),

          // ── Welcome text overlay on the left ──
          Positioned(
            left: 24,
            top: MediaQuery.of(context).padding.top + 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                    height: 1.2,
                  ),
                ),
                Text(
                  'Yatri',
                  style: GoogleFonts.poppins(
                    fontSize: 52,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFE52020),
                    height: 1.1,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your ride, your way.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF666666),
                    height: 1.4,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Get moving with ',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF666666),
                        height: 1.4,
                      ),
                    ),
                    Text(
                      'Yatri.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFE52020),
                        height: 1.4,
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

  // ════════════════════════════════════════════════════════════
  // PHONE INPUT SECTION — Country code + phone number
  // ════════════════════════════════════════════════════════════
  Widget _buildPhoneInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mobile Number',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFE52020).withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              // Country code section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '+977',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: const Color(0xFF666666),
                      size: 20,
                    ),
                  ],
                ),
              ),
              // Vertical divider
              Container(
                width: 1,
                height: 28,
                color: const Color(0xFFE0E0E0),
              ),
              // Phone number input
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF1A1A1A),
                  ),
                  decoration: InputDecoration(
                    hintText: '98XXXXXXXX',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFBBBBBB),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                ),
              ),
              // Phone icon
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Icon(
                  Icons.phone,
                  color: const Color(0xFFE52020),
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════
  // SEND OTP BUTTON
  // ════════════════════════════════════════════════════════════
  Widget _buildSendOtpButton() {
    return GestureDetector(
      onTap: _onSendOtp,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE52020), Color(0xFFCC1A1A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE52020).withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const SizedBox(width: 40), // balance the arrow on the right
            Text(
              'Send OTP',
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 18),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // TERMS & CONDITIONS
  // ════════════════════════════════════════════════════════════
  Widget _buildTermsSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.verified_user_outlined,
              color: const Color(0xFFE52020),
              size: 20,
            ),
            const SizedBox(width: 6),
            Text(
              'By continuing, you agree to our',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF666666),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Terms & Conditions',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFE52020),
              ),
            ),
            Text(
              ' and ',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF666666),
              ),
            ),
            Text(
              'Privacy Policy',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFE52020),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════
  // CONTINUE WITH DIVIDER — Red lines + decorative icon
  // ════════════════════════════════════════════════════════════
  Widget _buildContinueWithDivider() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      const Color(0xFFE52020).withValues(alpha: 0.4),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _buildDecorativeYatriIcon(),
            ),
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFE52020).withValues(alpha: 0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Continue with',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  // Decorative mandala image replacing the small red box above "Continue with"
  Widget _buildDecorativeYatriIcon() {
    return Image.asset(
      'assets/images/login_mandala.png',
      width: 28,
      height: 28,
      fit: BoxFit.cover,
    );
  }

  // ════════════════════════════════════════════════════════════
  // SOCIAL LOGIN BUTTONS — Google and Apple
  // ════════════════════════════════════════════════════════════
  Widget _buildSocialLoginButtons() {
    return Row(
      children: [
        // Google button
        Expanded(
          child: _buildSocialButton(
            icon: _buildGoogleIcon(),
            label: 'Google',
          ),
        ),
        const SizedBox(width: 14),
        // Apple button
        Expanded(
          child: _buildSocialButton(
            icon: const Icon(
              Icons.apple,
              color: Color(0xFF1A1A1A),
              size: 22,
            ),
            label: 'Apple',
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required Widget icon,
    required String label,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE8E8E8),
          width: 1.2,
        ),
        // Added subtle shadow to make button stand out on white background
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }

  // Google "G" icon built with colored text
  Widget _buildGoogleIcon() {
    return SizedBox(
      width: 22,
      height: 22,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'G',
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [
                    Color(0xFF4285F4), // blue
                    Color(0xFF34A853), // green
                    Color(0xFFFBBC05), // yellow
                    Color(0xFFEA4335), // red
                  ],
                  stops: [0.0, 0.33, 0.66, 1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(const Rect.fromLTWH(0, 0, 22, 22)),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // BOTTOM ILLUSTRATION — City skyline with bridge, car, and colored bar
  // ════════════════════════════════════════════════════════════
  Widget _buildBottomIllustration() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // City skyline illustration
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.0),
                Colors.white.withValues(alpha: 0.5),
                Colors.white,
              ],
              stops: const [0.0, 0.2, 0.5],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          child: Image.asset(
            'assets/images/login_bottom_bg.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 110, // reduced to move up slightly
          ),
        ),
        // Removed decorative yellow line that was visible at the bottom
      ],
    );
  }
}

class _YatriKnotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE52020)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    // Draw two overlapping squares to resemble a stylized knot
    final double s = size.width * 0.6;
    final Offset center = Offset(size.width / 2, size.height / 2);
    // First square (axis-aligned)
    final Path path = Path();
    path.addRect(Rect.fromCenter(center: center, width: s, height: s));
    // Second square rotated 45°
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(45 * 3.1415927 / 180);
    canvas.translate(-center.dx, -center.dy);
    path.addRect(Rect.fromCenter(center: center, width: s, height: s));
    canvas.restore();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
