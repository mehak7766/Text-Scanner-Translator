import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../widgets/world_map_painter.dart';
import 'onboard_screen.dart';

/// Screen 2: Intro / Feature Walkthrough Screen
/// Features:
/// - 3 informative feature slides (OCR Scanner, Translation, Audio/Export)
/// - Interactive PageView with animated dot indicators
/// - "Skip" button to jump directly to Screen 3
/// - "Next" / "Get Started" button leading smoothly to OnboardScreen
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_IntroPageData> _pages = const [
    _IntroPageData(
      title: 'Scan & Extract Text',
      subtitle:
          'Point your camera at documents, receipts, book pages, or notes to extract editable text with high OCR precision.',
      badgeText: 'AI OCR ENGINE',
      iconData: Icons.document_scanner_rounded,
      secondaryIcon: Icons.camera_alt_outlined,
      gradientColors: [Color(0xFFFF9138), Color(0xFFFA8427)],
    ),
    _IntroPageData(
      title: 'Translate 100+ Languages',
      subtitle:
          'Break down language barriers in seconds. Instantly translate scanned content or custom text across the globe.',
      badgeText: 'INSTANT TRANSLATION',
      iconData: Icons.g_translate_rounded,
      secondaryIcon: Icons.language_rounded,
      gradientColors: [Color(0xFF1E88E5), Color(0xFF0F65C4)],
    ),
    _IntroPageData(
      title: 'Listen, Copy & Share',
      subtitle:
          'Hear correct pronunciations with text-to-speech, copy snippets to your clipboard, and export notes with ease.',
      badgeText: 'SMART EXPORT & TTS',
      iconData: Icons.record_voice_over_rounded,
      secondaryIcon: Icons.share_rounded,
      gradientColors: [Color(0xFF26A69A), Color(0xFF00897B)],
    ),
  ];

  void _onNextPressed() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _navigateToOnboard();
    }
  }

  void _navigateToOnboard() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const OnboardScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background World Map Watermark
          const Positioned.fill(
            child: CustomPaint(
              painter: WorldMapPainter(
                mapColor: Color(0xFFE8EEF8),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top Navigation Bar (Skip Button)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // App tiny brand badge
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryOrange.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.document_scanner,
                              color: AppColors.primaryOrange,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Text Scanner',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),

                      // Skip Button
                      TextButton(
                        onPressed: _navigateToOnboard,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textMedium,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                        ),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // PageView for 3 Intro slides
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      final item = _pages[index];
                      return _buildSlideContent(item, screenHeight);
                    },
                  ),
                ),

                // Bottom Controls: Page Indicator & Next Button
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    32,
                    16,
                    32,
                    24 + mediaQuery.padding.bottom * 0.5,
                  ),
                  child: Column(
                    children: [
                      // Animated Indicator Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_pages.length, (index) {
                          final isSelected = _currentPage == index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 7,
                            width: isSelected ? 26 : 7,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryOrange
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 32),

                      // Next / Get Started Button
                      SizedBox(
                        width: screenWidth * 0.65,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _onNextPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryOrange,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _currentPage == _pages.length - 1
                                    ? 'Get Started'
                                    : 'Next',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 18,
                                color: Colors.white,
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
        ],
      ),
    );
  }

  Widget _buildSlideContent(_IntroPageData item, double screenHeight) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Graphic Illustration Card
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: item.gradientColors.last.withOpacity(0.18),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
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
              alignment: Alignment.center,
              children: [
                // Background radial glow
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        item.gradientColors.first.withOpacity(0.15),
                        item.gradientColors.last.withOpacity(0.05),
                      ],
                    ),
                  ),
                ),

                // Main Center Icon
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: item.gradientColors,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: item.gradientColors.last.withOpacity(0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    item.iconData,
                    size: 46,
                    color: Colors.white,
                  ),
                ),

                // Floating small accessory badge
                Positioned(
                  top: 26,
                  right: 26,
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      item.secondaryIcon,
                      size: 16,
                      color: item.gradientColors.last,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 36),

          // Feature Badge Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: item.gradientColors.first.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              item.badgeText,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: item.gradientColors.last,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Title
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 12),

          // Subtitle
          Text(
            item.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              height: 1.45,
              fontWeight: FontWeight.w400,
              color: AppColors.textMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _IntroPageData {
  final String title;
  final String subtitle;
  final String badgeText;
  final IconData iconData;
  final IconData secondaryIcon;
  final List<Color> gradientColors;

  const _IntroPageData({
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.iconData,
    required this.secondaryIcon,
    required this.gradientColors,
  });
}
