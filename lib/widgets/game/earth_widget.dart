import 'package:flutter/material.dart';

class EarthWidget extends StatelessWidget {
  final int lives;

  const EarthWidget({
    super.key,
    required this.lives,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final earthHeight = screenHeight * 0.1; // 화면 높이의 1/10

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: earthHeight,
      child: CustomPaint(
        painter: EarthPainter(lives),
        child: Container(),
      ),
    );
  }
}

class EarthPainter extends CustomPainter {
  final int lives;

  EarthPainter(this.lives);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // 지구를 곡선 형태로 그리기 (반원보다 작은 일부)
    final path = Path();
    final centerX = size.width / 2;
    final radius = size.width * 0.6; // 가로 너비를 꽉 채움
    
    // 곡선 그리기 (하단에서 시작해서 위로 올라가는 곡선)
    path.moveTo(0, size.height);
    path.quadraticBezierTo(
      centerX,
      size.height * 0.3, // 곡선의 높이 조절
      size.width,
      size.height,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // 지구 그라데이션
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.blue.shade400,
        Colors.blue.shade600,
        Colors.blue.shade800,
      ],
    );

    paint.shader = gradient.createShader(
      Rect.fromLTWH(0, 0, size.width, size.height),
    );

    canvas.drawPath(path, paint);

    // 외곽선
    paint.shader = null;
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.cyan.withOpacity(0.5);
    paint.strokeWidth = 2;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(EarthPainter oldDelegate) {
    return oldDelegate.lives != lives;
  }
}

