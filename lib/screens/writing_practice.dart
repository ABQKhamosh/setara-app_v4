import 'package:flutter/material.dart';
import '../core/app_state.dart';
import '../core/fa.dart';
import '../core/theme.dart';
import '../data/dari_data.dart';
import '../widgets/common.dart';

class WritingPractice extends StatefulWidget {
  const WritingPractice({super.key});
  @override
  State<WritingPractice> createState() => _WritingPracticeState();
}

class _WritingPracticeState extends State<WritingPractice> {
  int _cat = 0;
  int _idx = 0;
  final List<List<Offset>> _strokes = <List<Offset>>[];

  List<String> get _items {
    if (_cat == 0) return kDariLetters.map((List<String> e) => e[0]).toList();
    if (_cat == 1) return <String>['۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹', '۰'];
    return List<String>.generate(26, (int i) => String.fromCharCode(65 + i));
  }

  int get _points => _strokes.fold<int>(0, (int a, List<Offset> s) => a + s.length);

  void _setCat(int c) {
    setState(() {
      _cat = c;
      _idx = 0;
      _strokes.clear();
    });
  }

  void _step(int d) {
    final int n = _items.length;
    setState(() {
      _idx = (_idx + d + n) % n;
      _strokes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final String ch = _items[_idx];
    const List<String> cats = ['حروف دری', 'عددها', 'English'];
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
                  const Expanded(child: Text('تمرین نوشتن ✍️', style: Txt.h1)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  for (int c = 0; c < 3; c++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Tappable(
                          onTap: () => _setCat(c),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _cat == c ? const Color(0xFF3BAF5B) : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: _cat == c ? const Color(0xFF278040) : AppColors.line, width: 2),
                            ),
                            child: Text(cats[c],
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: _cat == c ? Colors.white : AppColors.ink)),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text('روی حرف کمرنگ با انگشتت بنویس', style: Txt.small.copyWith(fontSize: 14)),
              const SizedBox(height: 8),
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
                    child: Stack(
                      children: [
                        Center(
                          child: Text(ch,
                              textDirection: dirFor(ch),
                              style: TextStyle(
                                  fontSize: 240,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF3BAF5B).withAlpha(45))),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onPanStart: (DragStartDetails d) => setState(() => _strokes.add(<Offset>[d.localPosition])),
                          onPanUpdate: (DragUpdateDetails d) {
                            if (_strokes.isEmpty) return;
                            setState(() => _strokes.last.add(d.localPosition));
                          },
                          child: CustomPaint(painter: _StrokePainter(_strokes), size: Size.infinite),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  RoundIconButton(icon: Icons.arrow_forward_rounded, onTap: () => _step(-1)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ChunkyButton(
                      label: 'پاک کن',
                      color: Colors.white,
                      shadow: AppColors.line,
                      textColor: AppColors.ink,
                      height: 50,
                      onTap: () => setState(() => _strokes.clear()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ChunkyButton(
                      label: 'آفرین! بعدی',
                      color: const Color(0xFF3BAF5B),
                      shadow: const Color(0xFF278040),
                      height: 50,
                      onTap: _points >= 25
                          ? () {
                              AppState.instance.addSeeds(1);
                              _step(1);
                            }
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  RoundIconButton(icon: Icons.arrow_back_rounded, onTap: () => _step(1)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StrokePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  _StrokePainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint p = Paint()
      ..color = AppColors.anar
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    for (final List<Offset> s in strokes) {
      if (s.length == 1) {
        canvas.drawCircle(s.first, 6, Paint()..color = AppColors.anar);
        continue;
      }
      final Path path = Path()..moveTo(s.first.dx, s.first.dy);
      for (int i = 1; i < s.length; i++) {
        path.lineTo(s[i].dx, s[i].dy);
      }
      canvas.drawPath(path, p);
    }
  }

  @override
  bool shouldRepaint(covariant _StrokePainter old) => true;
}
