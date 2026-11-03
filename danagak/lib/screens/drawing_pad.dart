import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../widgets/common.dart';

class _Stroke {
  final Color color;
  final double width;
  final List<Offset> points;
  _Stroke(this.color, this.width, this.points);
}

class DrawingPad extends StatefulWidget {
  const DrawingPad({super.key});
  @override
  State<DrawingPad> createState() => _DrawingPadState();
}

class _DrawingPadState extends State<DrawingPad> {
  static const List<Color> _palette = [
    Color(0xFFE53935), Color(0xFFFB8C00), Color(0xFFFDD835), Color(0xFF43A047),
    Color(0xFF1E88E5), Color(0xFF8E24AA), Color(0xFF6D4C41), Color(0xFF212121),
  ];
  final List<_Stroke> _strokes = <_Stroke>[];
  Color _color = _palette[0];
  double _width = 8;
  bool _eraser = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  RoundIconButton(icon: Icons.arrow_forward_rounded, onTap: () => Navigator.of(context).pop()),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('نقاشی 🎨', style: Txt.h1)),
                  RoundIconButton(
                    icon: Icons.undo_rounded,
                    onTap: () {
                      if (_strokes.isNotEmpty) setState(() => _strokes.removeLast());
                    },
                  ),
                  const SizedBox(width: 8),
                  RoundIconButton(icon: Icons.delete_outline_rounded, onTap: () => setState(() => _strokes.clear())),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.line, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onPanStart: (DragStartDetails d) => setState(() =>
                          _strokes.add(_Stroke(_eraser ? Colors.white : _color, _eraser ? 26 : _width, <Offset>[d.localPosition]))),
                      onPanUpdate: (DragUpdateDetails d) {
                        if (_strokes.isEmpty) return;
                        setState(() => _strokes.last.points.add(d.localPosition));
                      },
                      child: CustomPaint(painter: _PadPainter(_strokes), size: Size.infinite),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final Color c in _palette)
                    Tappable(
                      onTap: () => setState(() {
                        _color = c;
                        _eraser = false;
                      }),
                      child: Container(
                        width: 34,
                        height: 34,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: (!_eraser && _color == c) ? AppColors.ink : Colors.white, width: 3),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final double w in <double>[5, 9, 15])
                    Tappable(
                      onTap: () => setState(() {
                        _width = w;
                        _eraser = false;
                      }),
                      child: Container(
                        width: 48,
                        height: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: (!_eraser && _width == w) ? AppColors.anarLight : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.line, width: 2),
                        ),
                        child: Container(
                            width: w + 4,
                            height: w + 4,
                            decoration: const BoxDecoration(color: AppColors.ink, shape: BoxShape.circle)),
                      ),
                    ),
                  Tappable(
                    onTap: () => setState(() => _eraser = true),
                    child: Container(
                      width: 48,
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _eraser ? AppColors.anarLight : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.line, width: 2),
                      ),
                      child: const Text('🧽', style: TextStyle(fontSize: 22)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PadPainter extends CustomPainter {
  final List<_Stroke> strokes;
  _PadPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    for (final _Stroke s in strokes) {
      if (s.points.length == 1) {
        canvas.drawCircle(s.points.first, s.width / 2, Paint()..color = s.color);
        continue;
      }
      final Paint p = Paint()
        ..color = s.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = s.width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      final Path path = Path()..moveTo(s.points.first.dx, s.points.first.dy);
      for (int i = 1; i < s.points.length; i++) {
        path.lineTo(s.points[i].dx, s.points[i].dy);
      }
      canvas.drawPath(path, p);
    }
  }

  @override
  bool shouldRepaint(covariant _PadPainter old) => true;
}
