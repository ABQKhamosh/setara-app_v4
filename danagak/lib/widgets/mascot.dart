import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme.dart';

enum MascotMood { happy, cheer, think, oops }

/// داناگک: یک دانهٔ خندان با کلاه فارغ‌التحصیلی و جوانهٔ سبز
class DanagakMascot extends StatefulWidget {
  final double size;
  final MascotMood mood;
  final bool animate;
  const DanagakMascot({super.key, this.size = 120, this.mood = MascotMood.happy, this.animate = true});
  @override
  State<DanagakMascot> createState() => _DanagakMascotState();
}

class _DanagakMascotState extends State<DanagakMascot> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    if (widget.animate) {
      _c.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (BuildContext context, Widget? child) {
        final double t = Curves.easeInOut.transform(_c.value);
        final double dy = widget.mood == MascotMood.cheer ? -10 * t : -5 * t;
        return Transform.translate(offset: Offset(0, dy), child: child);
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: CustomPaint(painter: _MascotPainter(widget.mood)),
      ),
    );
  }
}

class _MascotPainter extends CustomPainter {
  final MascotMood mood;
  _MascotPainter(this.mood);

  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.width;
    final Offset c = Offset(s * 0.5, s * 0.62);
    const Color brown = Color(0xFFB86F08);

    // سایه
    canvas.drawOval(
        Rect.fromCenter(center: Offset(s * 0.5, s * 0.96), width: s * 0.46, height: s * 0.07),
        Paint()..color = Colors.black.withAlpha(35));

    // پاها
    final Paint dark = Paint()..color = brown;
    canvas.drawOval(Rect.fromCenter(center: Offset(s * 0.40, s * 0.935), width: s * 0.15, height: s * 0.08), dark);
    canvas.drawOval(Rect.fromCenter(center: Offset(s * 0.60, s * 0.935), width: s * 0.15, height: s * 0.08), dark);

    // دست‌ها
    if (mood == MascotMood.cheer) {
      canvas.drawOval(Rect.fromCenter(center: Offset(s * 0.15, s * 0.46), width: s * 0.11, height: s * 0.2), dark);
      canvas.drawOval(Rect.fromCenter(center: Offset(s * 0.85, s * 0.46), width: s * 0.11, height: s * 0.2), dark);
    } else {
      canvas.drawOval(Rect.fromCenter(center: Offset(s * 0.18, s * 0.68), width: s * 0.11, height: s * 0.18), dark);
      canvas.drawOval(Rect.fromCenter(center: Offset(s * 0.82, s * 0.68), width: s * 0.11, height: s * 0.18), dark);
    }

    // بدن (دانه)
    final Rect bodyRect = Rect.fromCenter(center: c, width: s * 0.62, height: s * 0.68);
    final Paint body = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.35, -0.45),
        radius: 1.0,
        colors: [Color(0xFFFFE08A), Color(0xFFF6B93B), Color(0xFFD98A0B)],
      ).createShader(bodyRect);
    canvas.drawOval(bodyRect, body);
    canvas.drawOval(Rect.fromCenter(center: Offset(s * 0.34, s * 0.50), width: s * 0.09, height: s * 0.06),
        Paint()..color = Colors.white.withAlpha(90));

    // چهره
    final Paint cheek = Paint()..color = const Color(0x66FF9FB0);
    canvas.drawOval(Rect.fromCenter(center: Offset(s * 0.34, s * 0.68), width: s * 0.11, height: s * 0.065), cheek);
    canvas.drawOval(Rect.fromCenter(center: Offset(s * 0.66, s * 0.68), width: s * 0.11, height: s * 0.065), cheek);

    final Paint white = Paint()..color = Colors.white;
    final Paint pupil = Paint()..color = AppColors.ink;
    final Offset le = Offset(s * 0.41, s * 0.58);
    final Offset re = Offset(s * 0.59, s * 0.58);
    if (mood == MascotMood.cheer) {
      final Paint stroke = Paint()
        ..color = AppColors.ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.026
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(Rect.fromCenter(center: le, width: s * 0.09, height: s * 0.09), pi, pi, false, stroke);
      canvas.drawArc(Rect.fromCenter(center: re, width: s * 0.09, height: s * 0.09), pi, pi, false, stroke);
    } else {
      canvas.drawCircle(le, s * 0.056, white);
      canvas.drawCircle(re, s * 0.056, white);
      final double dx = mood == MascotMood.think ? s * 0.018 : 0.0;
      final double dy = mood == MascotMood.think ? -s * 0.018 : s * 0.005;
      canvas.drawCircle(le.translate(dx, dy), s * 0.031, pupil);
      canvas.drawCircle(re.translate(dx, dy), s * 0.031, pupil);
      canvas.drawCircle(le.translate(dx + s * 0.011, dy - s * 0.011), s * 0.01, white);
      canvas.drawCircle(re.translate(dx + s * 0.011, dy - s * 0.011), s * 0.01, white);
    }

    final Offset mc = Offset(s * 0.5, s * 0.71);
    final Paint mouthLine = Paint()
      ..color = AppColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.024
      ..strokeCap = StrokeCap.round;
    switch (mood) {
      case MascotMood.happy:
        canvas.drawArc(Rect.fromCenter(center: mc, width: s * 0.15, height: s * 0.09), 0.15, pi - 0.3, false, mouthLine);
        break;
      case MascotMood.cheer:
        final Path m = Path()
          ..moveTo(mc.dx - s * 0.09, mc.dy - s * 0.02)
          ..quadraticBezierTo(mc.dx, mc.dy + s * 0.15, mc.dx + s * 0.09, mc.dy - s * 0.02)
          ..close();
        canvas.drawPath(m, Paint()..color = AppColors.ink);
        canvas.drawOval(Rect.fromCenter(center: Offset(mc.dx, mc.dy + s * 0.04), width: s * 0.06, height: s * 0.035),
            Paint()..color = const Color(0xFFFF8FA0));
        break;
      case MascotMood.think:
        canvas.drawCircle(Offset(mc.dx + s * 0.02, mc.dy + s * 0.01), s * 0.02, Paint()..color = AppColors.ink);
        break;
      case MascotMood.oops:
        canvas.drawArc(Rect.fromCenter(center: Offset(mc.dx, mc.dy + s * 0.04), width: s * 0.13, height: s * 0.07),
            pi + 0.2, pi - 0.4, false, mouthLine);
        break;
    }

    // کلاه فارغ‌التحصیلی
    final Paint capDark = Paint()..color = AppColors.ink;
    final Path capBase = Path()
      ..moveTo(s * 0.36, s * 0.33)
      ..lineTo(s * 0.64, s * 0.33)
      ..lineTo(s * 0.62, s * 0.41)
      ..quadraticBezierTo(s * 0.5, s * 0.45, s * 0.38, s * 0.41)
      ..close();
    canvas.drawPath(capBase, capDark);
    final Path board = Path()
      ..moveTo(s * 0.26, s * 0.31)
      ..lineTo(s * 0.5, s * 0.22)
      ..lineTo(s * 0.74, s * 0.31)
      ..lineTo(s * 0.5, s * 0.40)
      ..close();
    canvas.drawPath(board, Paint()..color = const Color(0xFF3B3350));
    // منگوله
    canvas.drawLine(
        Offset(s * 0.70, s * 0.31),
        Offset(s * 0.70, s * 0.44),
        Paint()
          ..color = AppColors.gold
          ..strokeWidth = s * 0.016
          ..strokeCap = StrokeCap.round);
    canvas.drawCircle(Offset(s * 0.70, s * 0.455), s * 0.02, Paint()..color = AppColors.gold);

    // جوانهٔ سبز بالای کلاه
    final Paint leafPaint = Paint()..color = AppColors.leaf;
    final Path leftLeaf = Path()
      ..moveTo(s * 0.5, s * 0.235)
      ..quadraticBezierTo(s * 0.36, s * 0.04, s * 0.22, s * 0.12)
      ..quadraticBezierTo(s * 0.30, s * 0.24, s * 0.5, s * 0.235)
      ..close();
    final Path rightLeaf = Path()
      ..moveTo(s * 0.5, s * 0.235)
      ..quadraticBezierTo(s * 0.64, s * 0.02, s * 0.80, s * 0.10)
      ..quadraticBezierTo(s * 0.72, s * 0.23, s * 0.5, s * 0.235)
      ..close();
    canvas.drawPath(leftLeaf, leafPaint);
    canvas.drawPath(rightLeaf, Paint()..color = const Color(0xFF3FB56D));
  }

  @override
  bool shouldRepaint(covariant _MascotPainter old) => old.mood != mood;
}
