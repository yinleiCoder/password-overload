import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 倒计时动画圆
class CountdownCircle extends StatefulWidget {
  const CountdownCircle({super.key, required this.countdownDuration, required this.circleRadius, required this.color, this.onComplete});

  final Duration countdownDuration;
  final int circleRadius;
  final Color color;
  final VoidCallback? onComplete;

  @override
  State<CountdownCircle> createState() => _CountdownCircleState();
}

class _CountdownCircleState extends State<CountdownCircle> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.countdownDuration)
      ..addListener(() {
        setState(() {
        //_remainingSeconds = _countdownTotalSeconds -
        //               (_controller.value * _countdownTotalSeconds).floor();
        });
      })
      ..addStatusListener((AnimationStatus status) {
        if(status == AnimationStatus.completed) {
          if(widget.onComplete != null) {
            widget.onComplete!();
          }
        }
        print(status);
      });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.circleRadius.r,
      height: widget.circleRadius.r,
      child: CustomPaint(
        painter: CountdownCirclePainter(
          progress: controller.value,
          color: widget.color,
        ),
      ),
    );
  }
}

class CountdownCirclePainter extends CustomPainter {
  final double progress;
  final Color color;

  CountdownCirclePainter({super.repaint, required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);

    final backgroundPaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, backgroundPaint);

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(center.dx, center.dy);
    double angle = 2 * pi * progress - pi / 2;
    path.lineTo(center.dx + radius * cos(-pi / 2), center.dy + radius * sin(-pi / 2));
    path.arcTo(Rect.fromCircle(center: center, radius: radius), -pi / 2, 2 * pi * progress, false);
    path.close();
    canvas.drawPath(path, progressPaint);

  }

  @override
  bool shouldRepaint(covariant CountdownCirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }

}
