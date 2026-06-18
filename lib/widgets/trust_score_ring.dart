import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/theme.dart';

class TrustScoreRing extends StatelessWidget {
  final double score;
  final double size;
  final double strokeWidth;

  const TrustScoreRing({
    Key? key,
    required this.score,
    this.size = 120,
    this.strokeWidth = 9,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              score: score,
              strokeWidth: strokeWidth,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                score.round().toString(),
                style: AppTheme.headingStyle(
                  fontSize: size * 0.24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              Text(
                "trust score",
                style: AppTheme.bodyStyle(
                  fontSize: size * 0.075,
                  fontWeight: FontWeight.w600,
                  color: AppColors.tan,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double score;
  final double strokeWidth;

  _RingPainter({
    required this.score,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = AppColors.sand
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    final double sweepAngle = 2 * pi * (score / 100);
    final progressPaint = Paint()
      ..color = AppColors.forest
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
