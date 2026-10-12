import 'dart:async';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../widgets/world_map_painter.dart';
import 'intro_screen.dart';

/// Screen 1: Splash Screen
/// Features:
/// - Branded animated logo with optical scanner viewfinder & translation badges
/// - Faint world map silhouette background
/// - Smooth pulse and scan beam animation
/// - Automatically transitions to IntroScreen after 2.8 seconds
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _scanBeamAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _scanBeamAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    _animController.forward();

    // Transition to Screen 2 (IntroScreen) after 2.8 seconds
    _timer = Timer(const Duration(milliseconds: 2800), _navigateToNextScreen);
  }

  void _navigateToNextScreen() {
    if (!mounted) return;
    _timer?.cancel();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const IntroScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _navigateToNextScreen, // Allow quick tap to skip during presentation
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Faint World Map watermark in background for thematic consistency
            const Positioned.fill(
              child: CustomPaint(
                painter: WorldMapPainter(
                  mapColor: Color(0xFFE8EEF8),
                ),
              ),
            ),

            SafeArea(
              child: Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Stylized Scanner + Translator Icon
                        _buildScannerLogo(),

                        const SizedBox(height: 28),

                        // App Title
                        const Text(
                          'Text Scanner',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            color: AppColors.textDark,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Subtitle
                        const Text(
                          'OCR Scanner & Instant Translator',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textMedium,
                            letterSpacing: 0.2,
                          ),
                        ),

                        const SizedBox(height: 48),

                        // Loading Indicator / Dots
                        _buildLoadingIndicator(),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Project Branding
            const Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'AI POWERED UTILITY • FAST & SECURE',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9AA0A6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerLogo() {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withOpacity(0.18),
            blurRadius: 28,
            offset: const Offset(0, 10),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Corner Viewfinder Brackets
          Positioned(
            top: 14,
            left: 14,
            child: _buildCorner(isTop: true, isLeft: true),
          ),
          Positioned(
            top: 14,
            right: 14,
            child: _buildCorner(isTop: true, isLeft: false),
          ),
          Positioned(
            bottom: 14,
            left: 14,
            child: _buildCorner(isTop: false, isLeft: true),
          ),
          Positioned(
            bottom: 14,
            right: 14,
            child: _buildCorner(isTop: false, isLeft: false),
          ),

          // Central Icon: Dual Translation Bubbles miniature
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Mini Orange bubble
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF9138), Color(0xFFE8690B)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryOrange.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '文',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              // Mini Blue bubble
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E88E5), Color(0xFF0F65C4)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.translatorBlue.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'A',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Moving Scanner Laser Line
          AnimatedBuilder(
            animation: _scanBeamAnimation,
            builder: (context, child) {
              return Positioned(
                top: 24 + (74 * _scanBeamAnimation.value),
                left: 20,
                right: 20,
                child: Container(
                  height: 2.5,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.primaryOrange,
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryOrange.withOpacity(0.6),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCorner({required bool isTop, required bool isLeft}) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? const BorderSide(color: AppColors.primaryOrange, width: 2.5)
              : BorderSide.none,
          bottom: !isTop
              ? const BorderSide(color: AppColors.primaryOrange, width: 2.5)
              : BorderSide.none,
          left: isLeft
              ? const BorderSide(color: AppColors.primaryOrange, width: 2.5)
              : BorderSide.none,
          right: !isLeft
              ? const BorderSide(color: AppColors.primaryOrange, width: 2.5)
              : BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 44,
      height: 44,
      child: CircularProgressIndicator(
        strokeWidth: 2.8,
        valueColor: AlwaysStoppedAnimation<Color>(
          AppColors.primaryOrange.withOpacity(0.85),
        ),
      ),
    );
  }
}
