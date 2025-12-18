import 'dart:math';
import 'package:flutter/material.dart';

class Planet {
  final String id;
  Offset position;
  double radius;
  double health;
  double maxHealth;
  double speed;
  Color color;
  bool isBoss;
  bool isDestroyed;

  Planet({
    required this.id,
    required this.position,
    required this.radius,
    required this.health,
    required this.maxHealth,
    required this.speed,
    required this.color,
    this.isBoss = false,
    this.isDestroyed = false,
  });

  void takeDamage(double damage) {
    health = (health - damage).clamp(0, maxHealth);
    if (health <= 0) {
      isDestroyed = true;
    }
  }

  void update(double deltaTime, double screenHeight) {
    if (!isDestroyed && deltaTime > 0 && deltaTime < 1.0) {
      // 부드러운 이동을 위해 deltaTime을 정확히 사용
      // speed는 픽셀/초 단위이므로 deltaTime(초)를 곱함
      position = Offset(
        position.dx,
        position.dy + (speed * deltaTime),
      );
    }
  }

  bool isOffScreen(double screenHeight) {
    return position.dy > screenHeight + radius;
  }

  bool checkCollision(Offset point) {
    final distance = (point - position).distance;
    return distance <= radius;
  }

  // 행성 그리기
  void draw(Canvas canvas, Paint paint) {
    if (isDestroyed) return;

    paint.color = color;
    canvas.drawCircle(position, radius, paint);

    // 보스는 더 크고 특별한 효과
    if (isBoss) {
      paint.color = Colors.red.withOpacity(0.3);
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 3;
      canvas.drawCircle(position, radius + 5, paint);
      paint.style = PaintingStyle.fill;
    }
  }
}

