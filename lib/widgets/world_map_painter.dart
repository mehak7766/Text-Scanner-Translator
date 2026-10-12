import 'package:flutter/material.dart';

/// A custom painter that draws a subtle, elegant world map silhouette
/// matching the exact background visible in the provided design attachment.
class WorldMapPainter extends CustomPainter {
  final Color mapColor;

  const WorldMapPainter({
    this.mapColor = const Color(0xFFE4ECF8),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = mapColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final double w = size.width;
    final double h = size.height;

    // Normalizing scale based on standard map aspect ratio
    // The map is positioned primarily in the upper half to 70% of the screen.
    canvas.save();

    // 1. Greenland (Top Left)
    final greenland = Path()
      ..moveTo(w * 0.05, h * 0.08)
      ..quadraticBezierTo(w * 0.12, h * 0.06, w * 0.17, h * 0.10)
      ..quadraticBezierTo(w * 0.18, h * 0.16, w * 0.13, h * 0.22)
      ..quadraticBezierTo(w * 0.08, h * 0.20, w * 0.04, h * 0.15)
      ..close();
    canvas.drawPath(greenland, paint);

    // 2. North America (Far Left)
    final northAmerica = Path()
      ..moveTo(0, h * 0.07)
      ..quadraticBezierTo(w * 0.04, h * 0.05, w * 0.06, h * 0.11)
      ..quadraticBezierTo(w * 0.03, h * 0.18, w * 0.05, h * 0.25)
      ..quadraticBezierTo(w * 0.08, h * 0.32, w * 0.03, h * 0.39)
      ..lineTo(0, h * 0.40)
      ..close();
    canvas.drawPath(northAmerica, paint);

    // 3. Europe & Scandinavia (Top Center)
    final europe = Path()
      ..moveTo(w * 0.35, h * 0.04)
      ..quadraticBezierTo(w * 0.42, h * 0.03, w * 0.45, h * 0.07)
      ..quadraticBezierTo(w * 0.48, h * 0.11, w * 0.44, h * 0.17)
      ..quadraticBezierTo(w * 0.40, h * 0.20, w * 0.34, h * 0.18)
      ..quadraticBezierTo(w * 0.29, h * 0.15, w * 0.28, h * 0.10)
      ..quadraticBezierTo(w * 0.30, h * 0.05, w * 0.35, h * 0.04)
      ..close();
    canvas.drawPath(europe, paint);

    // UK & Ireland islands
    final ukIsland = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(w * 0.30, h * 0.13),
        width: w * 0.035,
        height: h * 0.045,
      ));
    canvas.drawPath(ukIsland, paint);

    // Mediterranean details
    final mediterraneanIslands = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(w * 0.41, h * 0.22),
        width: w * 0.02,
        height: h * 0.015,
      ))
      ..addOval(Rect.fromCenter(
        center: Offset(w * 0.45, h * 0.23),
        width: w * 0.025,
        height: h * 0.018,
      ));
    canvas.drawPath(mediterraneanIslands, paint);

    // 4. Africa (Center - directly behind the translation bubbles)
    final africa = Path()
      ..moveTo(w * 0.27, h * 0.26)
      ..quadraticBezierTo(w * 0.37, h * 0.25, w * 0.53, h * 0.27)
      ..quadraticBezierTo(w * 0.65, h * 0.30, w * 0.67, h * 0.35)
      ..quadraticBezierTo(w * 0.62, h * 0.42, w * 0.58, h * 0.48)
      ..quadraticBezierTo(w * 0.54, h * 0.56, w * 0.50, h * 0.60)
      ..quadraticBezierTo(w * 0.45, h * 0.55, w * 0.39, h * 0.46)
      ..quadraticBezierTo(w * 0.30, h * 0.45, w * 0.24, h * 0.40)
      ..quadraticBezierTo(w * 0.20, h * 0.34, w * 0.27, h * 0.26)
      ..close();
    canvas.drawPath(africa, paint);

    // Madagascar
    final madagascar = Path()
      ..moveTo(w * 0.70, h * 0.46)
      ..quadraticBezierTo(w * 0.73, h * 0.48, w * 0.71, h * 0.54)
      ..quadraticBezierTo(w * 0.68, h * 0.53, w * 0.69, h * 0.47)
      ..close();
    canvas.drawPath(madagascar, paint);

    // 5. Asia & Middle East (Top & Middle Right)
    final asia = Path()
      ..moveTo(w * 0.50, h * 0.04)
      ..quadraticBezierTo(w * 0.72, h * 0.02, w * 0.95, h * 0.05)
      ..quadraticBezierTo(w * 1.02, h * 0.12, w * 0.98, h * 0.22)
      ..quadraticBezierTo(w * 0.90, h * 0.30, w * 0.82, h * 0.28)
      ..quadraticBezierTo(w * 0.78, h * 0.36, w * 0.70, h * 0.35) // India/Arabian peninsula
      ..quadraticBezierTo(w * 0.63, h * 0.30, w * 0.56, h * 0.24)
      ..quadraticBezierTo(w * 0.50, h * 0.15, w * 0.50, h * 0.04)
      ..close();
    canvas.drawPath(asia, paint);

    // Indian Subcontinent tip
    final india = Path()
      ..moveTo(w * 0.72, h * 0.26)
      ..lineTo(w * 0.78, h * 0.26)
      ..lineTo(w * 0.75, h * 0.35)
      ..close();
    canvas.drawPath(india, paint);

    // Japan & East Asia islands
    final eastIslands = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(w * 0.95, h * 0.20),
        width: w * 0.03,
        height: h * 0.07,
      ))
      ..addOval(Rect.fromCenter(
        center: Offset(w * 0.88, h * 0.35),
        width: w * 0.04,
        height: h * 0.02,
      ));
    canvas.drawPath(eastIslands, paint);

    // 6. South America (Faint on Lower Left)
    final southAmerica = Path()
      ..moveTo(0, h * 0.45)
      ..quadraticBezierTo(w * 0.12, h * 0.46, w * 0.10, h * 0.58)
      ..quadraticBezierTo(w * 0.06, h * 0.68, 0, h * 0.72)
      ..close();
    canvas.drawPath(southAmerica, paint);

    // 7. Australia (Lower Right)
    final australia = Path()
      ..moveTo(w * 0.84, h * 0.54)
      ..quadraticBezierTo(w * 0.94, h * 0.52, w * 0.98, h * 0.58)
      ..quadraticBezierTo(w * 0.96, h * 0.66, w * 0.88, h * 0.67)
      ..quadraticBezierTo(w * 0.82, h * 0.62, w * 0.84, h * 0.54)
      ..close();
    canvas.drawPath(australia, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant WorldMapPainter oldDelegate) =>
      oldDelegate.mapColor != mapColor;
}
