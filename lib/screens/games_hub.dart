import 'dart:async';
import 'package:flutter/material.dart';
import '../core/app_state.dart';
import '../core/fa.dart';
import '../core/theme.dart';
import '../data/content_data.dart';
import '../data/dari_data.dart';
import '../data/math_data.dart';
import '../models/models.dart';
import '../widgets/common.dart';
import '../widgets/mascot.dart';
import 'drawing_pad.dart';
import 'lesson_player.dart';
import 'writing_practice.dart';

class GamesHub extends StatelessWidget {
  const GamesHub({super.key});

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext c) => page));
  }

  Widget _practice(String title, Color color, Color dark, List<Question> Function() build) {
    return LessonPlayer(title: title, color: color, dark: dark, subjectId: 'games', progressKey: null, build: build);
  }

  @override
  Widget build(BuildContext context) {
    final List<_GameItem> games = <_GameItem>[
      _GameItem('حافظه\u200cام', 'جفت\u200cها را پیدا کن', '🃏', const Color(0xFF8A5CF6), const Color(0xFF6538CC),
          () => _push(context, const MemoryGame())),
      _GameItem('ریاضی سریع', '۴۵ ثانیه وقت داری', '⚡', const Color(0xFF3D7EF5), const Color(0xFF2658C4),
          () => _push(context, const SpeedMathGame())),
      _GameItem('کلمه\u200cساز', 'حرف\u200cها را مرتب کن', '🔤', const Color(0xFFE5484D), const Color(0xFFB02E34),
          () => _push(context, _practice('کلمه\u200cساز', const Color(0xFFE5484D), const Color(0xFFB02E34), () => buildWordGame(n: 8)))),
      _GameItem('جفت\u200cیابی', 'به هم وصل کن', '🧩', const Color(0xFF12A3A3), const Color(0xFF0B7777),
          () => _push(context, _practice('جفت\u200cیابی', const Color(0xFF12A3A3), const Color(0xFF0B7777), buildMatchGame))),
      _GameItem('معما', 'فکر کن و پیدا کن', '❓', const Color(0xFFF28C28), const Color(0xFFC06A10),
          () => _push(context, _practice('معما', const Color(0xFFF28C28), const Color(0xFFC06A10), buildRiddles))),
      _GameItem('تمرین نوشتن', 'حرف و عدد بنویس', '✍️', const Color(0xFF3BAF5B), const Color(0xFF278040),
          () => _push(context, const WritingPractice())),
      _GameItem('نقاشی', 'رنگ بزن و بکش', '🎨', const Color(0xFFEC5BA0), const Color(0xFFBC3C7D),
          () => _push(context, const DrawingPad())),
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
      children: [
        const Text('بازی\u200cها', style: Txt.h1),
        const SizedBox(height: 4),
        const Text('با بازی کردن هم دانه می\u200cگیری!', style: Txt.small),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.95,
          children: [for (final _GameItem g in games) _GameCard(item: g)],
        ),
      ],
    );
  }
}

class _GameItem {
  final String title;
  final String sub;
  final String emoji;
  final Color color;
  final Color dark;
  final VoidCallback onTap;
  _GameItem(this.title, this.sub, this.emoji, this.color, this.dark, this.onTap);
}

class _GameCard extends StatelessWidget {
  final _GameItem item;
  const _GameCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Tappable(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: item.color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: item.dark, offset: const Offset(0, 6))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.emoji, style: const TextStyle(fontSize: 46)),
            const Spacer(),
            Text(item.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
            const SizedBox(height: 2),
            Text(item.sub, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white.withAlpha(230))),
          ],
        ),
      ),
    );
  }
}

// ======================= بازی حافظه =======================
class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});
  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  static const List<String> _pool = [
    '🐶', '🐱', '🐰', '🦁', '🐘', '🐟', '🍎', '🍌', '🍇', '🍉', '🚗', '⚽', '🌹', '⭐', '🐝', '🦋'
  ];
  late List<String> _cards;
  late List<bool> _open;
  late List<bool> _matched;
  late int _pairs;
  int? _first;
  bool _lock = false;
  int _moves = 0;
  int _found = 0;

  @override
  void initState() {
    super.initState();
    _pairs = AppState.instance.grade <= 2 ? 6 : 8;
    final List<String> picked = (List<String>.from(_pool)..shuffle(appRng)).take(_pairs).toList();
    _cards = <String>[...picked, ...picked]..shuffle(appRng);
    _open = List<bool>.filled(_cards.length, false);
    _matched = List<bool>.filled(_cards.length, false);
  }

  void _tap(int i) {
    if (_lock || _open[i] || _matched[i]) return;
    setState(() => _open[i] = true);
    final int? f = _first;
    if (f == null) {
      _first = i;
      return;
    }
    _moves++;
    if (_cards[f] == _cards[i]) {
      setState(() {
        _matched[f] = true;
        _matched[i] = true;
        _first = null;
        _found++;
      });
      if (_found == _pairs) _finish();
    } else {
      _lock = true;
      Future<void>.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        setState(() {
          _open[f] = false;
          _open[i] = false;
          _first = null;
          _lock = false;
        });
      });
    }
  }

  void _finish() {
    final int extra = _moves - _pairs;
    final int stars = extra <= 3 ? 3 : (extra <= 8 ? 2 : 1);
    AppState.instance.addSeeds(stars);
    Future<void>.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
        builder: (BuildContext c) => ResultScreen(
          stars: stars,
          mistakes: extra < 0 ? 0 : extra,
          total: _pairs,
          color: const Color(0xFF8A5CF6),
          retry: () => const MemoryGame(),
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final int cols = _pairs == 6 ? 3 : 4;
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
                  const Expanded(child: Text('حافظه\u200cام 🃏', style: Txt.h1)),
                  Text('حرکت: ${faDigits(_moves)}', style: Txt.h2),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: cols,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    for (int i = 0; i < _cards.length; i++)
                      Tappable(
                        onTap: () => _tap(i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _matched[i] ? AppColors.leafLight : (_open[i] ? Colors.white : const Color(0xFF8A5CF6)),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: _matched[i] ? AppColors.leaf : const Color(0xFF6538CC), width: 2.5),
                          ),
                          child: Text(_open[i] || _matched[i] ? _cards[i] : '❓',
                              style: TextStyle(fontSize: cols == 3 ? 44 : 36)),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================= ریاضی سریع =======================
class SpeedMathGame extends StatefulWidget {
  const SpeedMathGame({super.key});
  @override
  State<SpeedMathGame> createState() => _SpeedMathGameState();
}

class _SpeedMathGameState extends State<SpeedMathGame> {
  static const int _total = 45;
  int _phase = 0; // 0 شروع، 1 بازی، 2 پایان
  int _left = _total;
  int _score = 0;
  int _earned = 0;
  Timer? _timer;
  late Question _q;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _score = 0;
    _left = _total;
    _q = speedQuestion(AppState.instance.grade);
    setState(() => _phase = 1);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (!mounted) return;
      setState(() => _left--);
      if (_left <= 0) _end();
    });
  }

  void _end() {
    _timer?.cancel();
    final int seeds = _score == 0 ? 0 : (_score ~/ 3 + 1 > 5 ? 5 : _score ~/ 3 + 1);
    _earned = seeds;
    if (seeds > 0) AppState.instance.addSeeds(seeds);
    AppState.instance.setBestSpeed(_score);
    setState(() => _phase = 2);
  }

  void _answer(int i) {
    if (i == _q.answer) {
      _score++;
    } else {
      _left = _left > 2 ? _left - 2 : 0;
    }
    if (_left <= 0) {
      _end();
      return;
    }
    setState(() => _q = speedQuestion(AppState.instance.grade));
  }

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
                  const Expanded(child: Text('ریاضی سریع ⚡', style: Txt.h1)),
                  if (_phase == 1) Text('${faDigits(_score)} ✅', style: Txt.h2),
                ],
              ),
              const SizedBox(height: 14),
              Expanded(child: _phase == 1 ? _play() : _startOrEnd()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _startOrEnd() {
    final bool end = _phase == 2;
    return Column(
      children: [
        const Spacer(),
        DanagakMascot(size: 150, mood: end ? MascotMood.cheer : MascotMood.happy),
        const SizedBox(height: 14),
        Text(end ? 'امتیاز تو: ${faDigits(_score)}' : 'آماده\u200cای؟', style: Txt.h1.copyWith(fontSize: 30)),
        const SizedBox(height: 8),
        Text(
          end
              ? 'بهترین امتیاز: ${faDigits(AppState.instance.bestSpeed)}\n${faDigits(_earned)} دانه گرفتی'
              : 'در ۴۵ ثانیه تا می\u200cتوانی جواب بده.\nجواب غلط ۲ ثانیه وقت می\u200cگیرد.',
          textAlign: TextAlign.center,
          style: Txt.body,
        ),
        const Spacer(),
        ChunkyButton(label: end ? 'دوباره' : 'شروع', color: const Color(0xFF3D7EF5), shadow: const Color(0xFF2658C4), onTap: _start),
      ],
    );
  }

  Widget _play() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: _left / _total,
            minHeight: 14,
            backgroundColor: AppColors.line,
            valueColor: AlwaysStoppedAnimation<Color>(_left <= 10 ? AppColors.anar : const Color(0xFF3D7EF5)),
          ),
        ),
        const SizedBox(height: 6),
        Text('${faDigits(_left)} ثانیه', style: Txt.small.copyWith(fontSize: 14)),
        const Spacer(),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.line, width: 2),
          ),
          child: VisualBox(visual: _q.visual, ltr: true),
        ),
        const Spacer(),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.2,
          children: [
            for (int i = 0; i < _q.options.length; i++)
              Tappable(
                onTap: () => _answer(i),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.line, width: 2.5),
                    boxShadow: const [BoxShadow(color: AppColors.line, offset: Offset(0, 4))],
                  ),
                  child: Text(_q.options[i],
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.ink)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
