import 'dart:math';
import 'package:flutter/material.dart';
import '../core/fa.dart';
import '../core/theme.dart';

class Tappable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const Tappable({super.key, required this.child, this.onTap});
  @override
  State<Tappable> createState() => _TappableState();
}

class _TappableState extends State<Tappable> {
  bool _down = false;
  void _set(bool v) {
    if (mounted) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (TapDownDetails d) => _set(true),
      onTapCancel: () => _set(false),
      onTapUp: (TapUpDetails d) => _set(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 90),
        child: widget.child,
      ),
    );
  }
}

class ChunkyButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final Color color;
  final Color shadow;
  final double height;
  final double fontSize;
  final Color textColor;
  const ChunkyButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color = AppColors.anar,
    this.shadow = AppColors.anarDark,
    this.height = 56,
    this.fontSize = 18,
    this.textColor = Colors.white,
  });
  @override
  State<ChunkyButton> createState() => _ChunkyButtonState();
}

class _ChunkyButtonState extends State<ChunkyButton> {
  bool _down = false;
  void _set(bool v) {
    if (mounted) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.onTap != null;
    final Color base = enabled ? widget.color : const Color(0xFFD8D1C4);
    final Color sh = enabled ? widget.shadow : const Color(0xFFB9B1A2);
    final Color tc = enabled ? widget.textColor : const Color(0xFF8C8577);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (TapDownDetails d) {
        if (enabled) _set(true);
      },
      onTapCancel: () => _set(false),
      onTapUp: (TapUpDetails d) => _set(false),
      onTap: widget.onTap,
      child: SizedBox(
        height: widget.height + 5,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: widget.height,
              child: DecoratedBox(
                decoration: BoxDecoration(color: sh, borderRadius: BorderRadius.circular(18)),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 70),
              left: 0,
              right: 0,
              top: _down ? 4 : 0,
              height: widget.height,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(18)),
                child: Text(
                  widget.label,
                  style: TextStyle(color: tc, fontSize: widget.fontSize, fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SeedIcon extends StatelessWidget {
  final double size;
  const SeedIcon({super.key, this.size = 20});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.2,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFD866), Color(0xFFE0A100)],
              ),
              borderRadius: BorderRadius.all(Radius.elliptical(size / 2, size * 0.6)),
            ),
          ),
          Positioned(
            left: size * 0.22,
            top: size * 0.2,
            child: Container(
              width: size * 0.2,
              height: size * 0.3,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(150),
                borderRadius: BorderRadius.circular(size),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatChip extends StatelessWidget {
  final Widget icon;
  final String text;
  final Color bg;
  final Color fg;
  const StatChip({super.key, required this.icon, required this.text, required this.bg, required this.fg});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 6),
          Text(text, style: TextStyle(fontWeight: FontWeight.w900, color: fg, fontSize: 16)),
        ],
      ),
    );
  }
}

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color bg;
  final Color fg;
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.bg = Colors.white,
    this.fg = AppColors.ink,
  });
  @override
  Widget build(BuildContext context) {
    return Tappable(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, color: fg, size: 24),
      ),
    );
  }
}

class SpeechBubble extends StatelessWidget {
  final String text;
  const SpeechBubble({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line, width: 2),
      ),
      child: Text(text, style: Txt.body),
    );
  }
}

class _Piece {
  final double x;
  final double delay;
  final double speed;
  final double size;
  final Color color;
  final double spin;
  _Piece(this.x, this.delay, this.speed, this.size, this.color, this.spin);
}

class ConfettiBurst extends StatefulWidget {
  const ConfettiBurst({super.key});
  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  final List<_Piece> _pieces = <_Piece>[];

  @override
  void initState() {
    super.initState();
    final Random r = Random();
    const List<Color> colors = [
      AppColors.anar,
      AppColors.gold,
      AppColors.leaf,
      Color(0xFF3D7EF5),
      Color(0xFFEC5BA0),
      Color(0xFF8A5CF6),
    ];
    for (int i = 0; i < 48; i++) {
      _pieces.add(_Piece(r.nextDouble(), r.nextDouble() * 0.4, 0.6 + r.nextDouble() * 0.6,
          6 + r.nextDouble() * 8, colors[r.nextInt(colors.length)], r.nextDouble() * 6));
    }
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 2600))..forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _c,
        builder: (BuildContext context, Widget? child) {
          return CustomPaint(painter: _ConfettiPainter(_pieces, _c.value), size: Size.infinite);
        },
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<_Piece> pieces;
  final double progress;
  _ConfettiPainter(this.pieces, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (final _Piece p in pieces) {
      final double t = ((progress - p.delay) / (1 - p.delay)).clamp(0.0, 1.0).toDouble();
      if (t <= 0) continue;
      final double x = p.x * size.width + sin(t * 6 + p.spin) * 20;
      final double y = -20 + t * p.speed * (size.height + 40);
      final double op = t > 0.8 ? (1 - t) / 0.2 : 1.0;
      final Paint paint = Paint()
        ..color = p.color.withAlpha((255 * op).round().clamp(0, 255).toInt());
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(t * 8 + p.spin);
      canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.5), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) => old.progress != progress;
}

class ShapePainter extends CustomPainter {
  final String name;
  ShapePainter(this.name);

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Path p = Path();
    Color c = const Color(0xFF3D7EF5);
    switch (name) {
      case 'circle':
        c = const Color(0xFFE5484D);
        p.addOval(Rect.fromLTWH(w * 0.06, h * 0.06, w * 0.88, h * 0.88));
        break;
      case 'square':
        c = const Color(0xFF3D7EF5);
        p.addRect(Rect.fromLTWH(w * 0.12, h * 0.12, w * 0.76, h * 0.76));
        break;
      case 'rect':
        c = const Color(0xFFF28C28);
        p.addRect(Rect.fromLTWH(w * 0.02, h * 0.25, w * 0.96, h * 0.5));
        break;
      case 'triangle':
        c = const Color(0xFF3BAF5B);
        p.moveTo(w * 0.5, h * 0.08);
        p.lineTo(w * 0.94, h * 0.9);
        p.lineTo(w * 0.06, h * 0.9);
        p.close();
        break;
      case 'diamond':
        c = const Color(0xFF8A5CF6);
        p.moveTo(w * 0.5, h * 0.04);
        p.lineTo(w * 0.92, h * 0.5);
        p.lineTo(w * 0.5, h * 0.96);
        p.lineTo(w * 0.08, h * 0.5);
        p.close();
        break;
      default:
        c = const Color(0xFFFFC93C);
        for (int i = 0; i < 10; i++) {
          final double rad = i.isEven ? w * 0.47 : w * 0.2;
          final double a = -pi / 2 + i * pi / 5;
          final double px = w / 2 + rad * cos(a);
          final double py = h / 2 + h * 0.03 + rad * sin(a);
          if (i == 0) {
            p.moveTo(px, py);
          } else {
            p.lineTo(px, py);
          }
        }
        p.close();
    }
    canvas.drawPath(p, Paint()..color = c);
    final Color edge = HSLColor.fromColor(c).withLightness(0.35).toColor();
    canvas.drawPath(
        p,
        Paint()
          ..color = edge
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..strokeJoin = StrokeJoin.round);
  }

  @override
  bool shouldRepaint(covariant ShapePainter old) => old.name != name;
}

/// تصویر سوال: ایموجی/متن، رنگ (#RRGGBB)، شکل (shape:circle) یا متن طولانی
class VisualBox extends StatelessWidget {
  final String visual;
  final bool ltr;
  const VisualBox({super.key, required this.visual, this.ltr = false});

  @override
  Widget build(BuildContext context) {
    if (visual.isEmpty) return const SizedBox.shrink();
    if (visual.startsWith('#') && visual.length == 7) {
      final int v = int.tryParse(visual.substring(1), radix: 16) ?? 0xCCCCCC;
      return Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          color: Color(0xFF000000 | v),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 5),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(40), blurRadius: 10, offset: const Offset(0, 4))],
        ),
      );
    }
    if (visual.startsWith('shape:')) {
      return SizedBox(
        width: 110,
        height: 110,
        child: CustomPaint(painter: ShapePainter(visual.substring(6))),
      );
    }
    final int len = visual.runes.length;
    final TextDirection td = ltr ? TextDirection.ltr : dirFor(visual);
    if (len > 30) {
      return Text(visual,
          textDirection: td,
          style: const TextStyle(fontSize: 18, height: 1.8, fontWeight: FontWeight.w600, color: AppColors.ink));
    }
    final double fs = len <= 3 ? 76 : (len <= 12 ? 52 : 34);
    return Text(visual,
        textAlign: TextAlign.center,
        textDirection: td,
        style: TextStyle(fontSize: fs, height: 1.25, fontWeight: FontWeight.w900, color: AppColors.ink));
  }
}
