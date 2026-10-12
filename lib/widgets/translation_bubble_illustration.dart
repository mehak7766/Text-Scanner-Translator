import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A custom widget reproducing the Language Translator icon with:
/// - Orange speech bubble with Chinese character '文'
/// - Blue speech bubble with letter 'A'
/// - Dark curved cyclical exchange arrows
class TranslationBubbleIllustration extends StatefulWidget {
  final double size;
  final bool enableAnimation;

  const TranslationBubbleIllustration({
    super.key,
    this.size = 180,
    this.enableAnimation = true,
  });

  @override
  State<TranslationBubbleIllustration> createState() =>
      _TranslationBubbleIllustrationState();
}

class _TranslationBubbleIllustrationState
    extends State<TranslationBubbleIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.enableAnimation) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double s = widget.size;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        // Subtle floating movement for a lively premium feel
        final floatOffset = widget.enableAnimation
            ? math.sin(_pulseAnimation.value * math.pi) * 3.0
            : 0.0;

        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: SizedBox(
            width: s,
            height: s,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Top curved arrow (charcoal black)
                Positioned(
                  top: s * 0.05,
                  right: s * 0.22,
                  child: CustomPaint(
                    size: Size(s * 0.28, s * 0.26),
                    painter: _TopCurvedArrowPainter(),
                  ),
                ),

                // Blue bubble with 'A' (placed on right side)
                Positioned(
                  top: s * 0.28,
                  right: s * 0.08,
                  child: _buildChatBubble(
                    width: s * 0.44,
                    height: s * 0.35,
                    colorStart: const Color(0xFF1E88E5),
                    colorEnd: const Color(0xFF0F65C4),
                    character: 'A',
                    isTailOnLeft: true,
                    fontSize: s * 0.19,
                    fontFamily: 'Roboto',
                  ),
                ),

                // Orange bubble with '文' (placed on left side, slightly overlapping)
                Positioned(
                  top: s * 0.18,
                  left: s * 0.08,
                  child: _buildChatBubble(
                    width: s * 0.44,
                    height: s * 0.35,
                    colorStart: const Color(0xFFFF9138),
                    colorEnd: const Color(0xFFE8690B),
                    character: '文',
                    isTailOnLeft: false,
                    fontSize: s * 0.18,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                // Bottom curved arrow (charcoal black)
                Positioned(
                  bottom: s * 0.07,
                  left: s * 0.22,
                  child: CustomPaint(
                    size: Size(s * 0.28, s * 0.26),
                    painter: _BottomCurvedArrowPainter(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChatBubble({
    required double width,
    required double height,
    required Color colorStart,
    required Color colorEnd,
    required String character,
    required bool isTailOnLeft,
    required double fontSize,
    FontWeight fontWeight = FontWeight.bold,
    String? fontFamily,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(14),
          topRight: const Radius.circular(14),
          bottomLeft: Radius.circular(isTailOnLeft ? 4 : 14),
          bottomRight: Radius.circular(isTailOnLeft ? 14 : 4),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorStart, colorEnd],
        ),
        boxShadow: [
          BoxShadow(
            color: colorEnd.withOpacity(0.35),
            blurRadius: 16,
            spreadRadius: 1,
            offset: const Offset(0, 7),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Speech tail extension
          Positioned(
            bottom: -5,
            left: isTailOnLeft ? 10 : null,
            right: isTailOnLeft ? null : 10,
            child: CustomPaint(
              size: const Size(12, 8),
              painter: _BubbleTailPainter(
                color: colorEnd,
                isLeft: isTailOnLeft,
              ),
            ),
          ),
          // Character text
          Center(
            child: Text(
              character,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: fontWeight,
                fontFamily: fontFamily,
                shadows: const [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the small speech bubble pointer tail
class _BubbleTailPainter extends CustomPainter {
  final Color color;
  final bool isLeft;

  _BubbleTailPainter({required this.color, required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    if (isLeft) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width * 0.2, size.height);
      path.close();
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width * 0.8, size.height);
      path.close();
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BubbleTailPainter oldDelegate) => false;
}

/// Top curved exchange arrow (charcoal black)
class _TopCurvedArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E2024)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.6
      ..strokeCap = StrokeCap.round;

    final path = Path();
    // Arc curving up and to the right
    path.moveTo(size.width * 0.15, size.height * 0.85);
    path.quadraticBezierTo(
      size.width * 0.55,
      size.height * 0.05,
      size.width * 0.90,
      size.height * 0.40,
    );
    canvas.drawPath(path, paint);

    // Arrowhead pointing down-right
    final arrowHead = Paint()
      ..color = const Color(0xFF1E2024)
      ..style = PaintingStyle.fill;

    final headPath = Path()
      ..moveTo(size.width * 0.70, size.height * 0.20)
      ..lineTo(size.width * 0.98, size.height * 0.45)
      ..lineTo(size.width * 0.82, size.height * 0.75)
      ..close();
    canvas.drawPath(headPath, arrowHead);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Bottom curved exchange arrow (charcoal black)
class _BottomCurvedArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E2024)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.6
      ..strokeCap = StrokeCap.round;

    final path = Path();
    // Arc curving down and to the left
    path.moveTo(size.width * 0.85, size.height * 0.15);
    path.quadraticBezierTo(
      size.width * 0.45,
      size.height * 0.95,
      size.width * 0.10,
      size.height * 0.60,
    );
    canvas.drawPath(path, paint);

    // Arrowhead pointing up-left
    final arrowHead = Paint()
      ..color = const Color(0xFF1E2024)
      ..style = PaintingStyle.fill;

    final headPath = Path()
      ..moveTo(size.width * 0.30, size.height * 0.80)
      ..lineTo(size.width * 0.02, size.height * 0.55)
      ..lineTo(size.width * 0.18, size.height * 0.25)
      ..close();
    canvas.drawPath(headPath, arrowHead);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
