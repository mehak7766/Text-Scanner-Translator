import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../widgets/world_map_painter.dart';
import '../widgets/translation_bubble_illustration.dart';
import '../widgets/privacy_policy_sheet.dart';
import 'home_screen.dart';

/// Screen 3: The exact Onboard Continue Screen matching the user's provided design.
/// Features:
/// - Subtle World Map watermark background
/// - Dual translation chat bubbles illustration (文 & A with curved arrows)
/// - "Language Translator" heading
/// - "Translate your text in any language" subtitle
/// - Interactive "I accept the Privacy policy" checkbox with clickable policy sheet
/// - Vibrant rounded orange "Continue" button
class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen>
    with SingleTickerProviderStateMixin {
  bool _isPrivacyAccepted = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _onContinuePressed() {
    if (!_isPrivacyAccepted) {
      _shakeController.forward(from: 0.0);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Please accept the Privacy Policy to proceed.',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.primaryOrange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // Navigate to Home screen with a smooth transition
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
              ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _openPrivacyPolicy() {
    PrivacyPolicySheet.show(
      context,
      onAccept: () {
        setState(() {
          _isPrivacyAccepted = true;
        });
      },
    );
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
          // 1. Subtle World Map Background (Watermark)
          const Positioned.fill(
            child: CustomPaint(
              painter: WorldMapPainter(
                mapColor: Color(0xFFE8EEF8),
              ),
            ),
          ),

          // 2. Main Content
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            // Top flexible space to match exact vertical placement
                            SizedBox(height: screenHeight * 0.16),

                            // Central Illustration: Dual chat bubbles & exchange arrows
                            const Center(
                              child: TranslationBubbleIllustration(
                                size: 190,
                                enableAnimation: true,
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Headline: "Language Translator"
                            const Text(
                              'Language Translator',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E2024),
                                letterSpacing: -0.3,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Subtitle: "Translate your text in any language"
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32),
                              child: Text(
                                'Translate your text in any language',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF4A4E57),
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ),

                            // Flexible space pushing terms and button towards bottom
                            const Spacer(),

                            // Checkbox Row: "I accept the Privacy policy"
                            AnimatedBuilder(
                              animation: _shakeAnimation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(_shakeAnimation.value, 0),
                                  child: child,
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Custom square checkbox matching the photo
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isPrivacyAccepted = !_isPrivacyAccepted;
                                        });
                                      },
                                      child: Container(
                                        width: 22,
                                        height: 22,
                                        margin: const EdgeInsets.only(right: 12),
                                        decoration: BoxDecoration(
                                          color: _isPrivacyAccepted
                                              ? AppColors.primaryOrange
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            color: _isPrivacyAccepted
                                                ? AppColors.primaryOrange
                                                : const Color(0xFF222428),
                                            width: 1.8,
                                          ),
                                        ),
                                        child: _isPrivacyAccepted
                                            ? const Icon(
                                                Icons.check,
                                                size: 16,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                    ),

                                    // Agreement text with clickable privacy policy link
                                    Flexible(
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'I accept the',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF33373D),
                                          ),
                                          children: [
                                            TextSpan(
                                              text: 'Privacy policy',
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF3B5998),
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor:
                                                    Color(0xFF3B5998),
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = _openPrivacyPolicy,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 38),

                            // Continue Button
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 42),
                              child: SizedBox(
                                width: screenWidth * 0.65,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: _onContinuePressed,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFA8427),
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    'Continue',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Bottom spacing
                            SizedBox(height: screenHeight * 0.08),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
