import 'package:flutter/material.dart';
import '../../core/models/planet.dart';

class PlanetPainter extends CustomPainter {
  final List<Planet> planets;

  PlanetPainter(this.planets);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final planet in planets) {
      if (!planet.isDestroyed) {
        planet.draw(canvas, paint);
      }
    }
  }

  @override
  bool shouldRepaint(PlanetPainter oldDelegate) {
    // 매 프레임마다 리페인트 (행성이 계속 움직이므로)
    // 위치 비교는 비용이 많이 들고, 행성이 많을수록 느려지므로
    // 단순히 항상 true를 반환하는 것이 더 효율적
    return true;
  }
}

