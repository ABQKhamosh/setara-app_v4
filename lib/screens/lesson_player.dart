import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_state.dart';
import '../core/fa.dart';
import '../core/theme.dart';
import '../models/models.dart';
import '../widgets/common.dart';
import '../widgets/mascot.dart';

const List<String> _praise = ['آفرین!', 'عالی!', 'درست است!', 'ماشاءالله!', 'بسیار خوب!', 'زبردست!'];

class LessonPlayer extends StatefulWidget {
  final String title;
  final Color color;
  final Color dark;
  final String subjectId;
  final String? progressKey;
  final List<Question> Function() build;
  const LessonPlayer({
    super.key,
    required this.title,
    required this.color,
    required this.dark,
    required this.subjectId,
    required this.progressKey,
    required this.build,
  });
  @override
  State<LessonPlayer> createState() => _LessonPlayerState();
}

class _LessonPlayerState extends State<LessonPlayer> {
  late List<Question> _qs;
  int _i = 0;
  int _mistakes = 0;

  @override
  void initState() {
    super.initState();
    _qs = widget.build();
  }

  void _mistake() {
    _mistakes++;
  }

  void _next() {
    if (_i + 1 >= _qs.length) {
      _finish();
    } else {
      setState(() => _i++);
    }
  }

  void _finish() {
    final int stars = _mistakes <= 1 ? 3 : (_mistakes <= 4 ? 2 : 1);
    AppState.instance.recordLesson(key: widget.progressKey, earned: stars, subjectId: widget.subjectId);
    final LessonPlayer w = widget;
    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
      builder: (BuildContext c) => ResultScreen(
        stars: stars,
        mistakes: _mistakes,
        total: _qs.length,
        color: w.color,
        retry: () => LessonPlayer(
          title: w.title,
          color: w.color,
          dark: w.dark,
          subjectId: w.subjectId,
          progressKey: w.progressKey,
          build: w.build,
        ),
      ),
    ));
  }

  Future<void> _confirmExit() async {
    final bool? leave = await showDialog<bool>(
      context: context,
      builder: (BuildContext c) => AlertDialog(
        title: const Text('خارج می\u200cشوی؟'),
        content: const Text('اگر بروی، این درس تمام نمی\u200cشود.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('ادامه می\u200cدهم')),
          TextButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('خارج می\u200cشوم')),
        ],
      ),
    );
    if (leave == true && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Question q = _qs[_i];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
              child: Row(
                children: [
                  RoundIconButton(icon: Icons.close_rounded, onTap: _confirmExit, bg: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _i / _qs.length,
                        minHeight: 14,
                        backgroundColor: AppColors.line,
                        valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('${faDigits(_i + 1)}/${faDigits(_qs.length)}', style: Txt.small.copyWith(fontSize: 14)),
                ],
              ),
            ),
            Expanded(
              child: KeyedSubtree(
                key: ValueKey<int>(_i),
                child: _view(q),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _view(Question q) {
    switch (q.type) {
      case QType.choice:
        return _ChoiceView(q: q, color: widget.color, onMistake: _mistake, onNext: _next);
      case QType.arrange:
        return _ArrangeView(q: q, color: widget.color, dark: widget.dark, onMistake: _mistake, onNext: _next);
      case QType.match:
        return _MatchView(q: q, color: widget.color, dark: widget.dark, onMistake: _mistake, onNext: _next);
    }
  }
}

class _Feedback extends StatelessWidget {
  final String explain;
  final VoidCallback onNext;
  const _Feedback({required this.explain, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final String p = _praise[DateTime.now().millisecond % _praise.length];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: const BoxDecoration(
        color: AppColors.leafLight,
        border: Border(top: BorderSide(color: AppColors.leaf, width: 2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const DanagakMascot(size: 56, mood: MascotMood.cheer, animate: false),
              const SizedBox(width: 10),
              Expanded(
                child: Text(p,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.leafDark)),
              ),
            ],
          ),
          if (explain.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              child: Text(explain, style: Txt.body.copyWith(color: AppColors.leafDark)),
            ),
          const SizedBox(height: 10),
          ChunkyButton(label: 'ادامه', color: AppColors.leaf, shadow: AppColors.leafDark, onTap: onNext),
        ],
      ),
    );
  }
}

Widget _questionHeader(Question q) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(q.prompt, style: Txt.h2),
      if (q.visual.isNotEmpty) ...[
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.line, width: 2),
          ),
          child: VisualBox(visual: q.visual, ltr: q.ltr),
        ),
      ],
      const SizedBox(height: 18),
    ],
  );
}

// ---------------- سوال چندگزینه‌ای ----------------
class _ChoiceView extends StatefulWidget {
  final Question q;
  final Color color;
  final VoidCallback onMistake;
  final VoidCallback onNext;
  const _ChoiceView({required this.q, required this.color, required this.onMistake, required this.onNext});
  @override
  State<_ChoiceView> createState() => _ChoiceViewState();
}

class _ChoiceViewState extends State<_ChoiceView> {
  final Set<int> _wrong = <int>{};
  bool _correct = false;

  void _tap(int i) {
    if (_correct || _wrong.contains(i)) return;
    if (i == widget.q.answer) {
      setState(() => _correct = true);
      HapticFeedback.lightImpact();
    } else {
      setState(() => _wrong.add(i));
      widget.onMistake();
      HapticFeedback.mediumImpact();
    }
  }

  Widget _opt(int i) {
    final Question q = widget.q;
    final String text = q.options[i];
    final bool isWrong = _wrong.contains(i);
    final bool isRight = _correct && i == q.answer;
    Color bg = Colors.white;
    Color border = AppColors.line;
    Color fg = AppColors.ink;
    if (isRight) {
      bg = AppColors.leafLight;
      border = AppColors.leaf;
      fg = AppColors.leafDark;
    }
    if (isWrong) {
      bg = AppColors.anarLight;
      border = AppColors.anar;
      fg = AppColors.anarDark;
    }
    final double fs = text.runes.length > 22 ? 16 : 21;
    return Tappable(
      onTap: () => _tap(i),
      child: Container(
        constraints: const BoxConstraints(minHeight: 64),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border, width: 2.5),
          boxShadow: [BoxShadow(color: border, offset: const Offset(0, 4))],
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          textDirection: q.ltr ? TextDirection.ltr : dirFor(text),
          style: TextStyle(fontSize: fs, fontWeight: FontWeight.w800, color: fg, height: 1.3),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Question q = widget.q;
    final bool shortOpts = q.options.every((String o) => o.runes.length <= 9);
    final List<Widget> rows = <Widget>[];
    if (shortOpts && q.options.length > 1) {
      for (int i = 0; i < q.options.length; i += 2) {
        rows.add(Row(
          children: [
            Expanded(child: _opt(i)),
            const SizedBox(width: 12),
            Expanded(child: i + 1 < q.options.length ? _opt(i + 1) : const SizedBox.shrink()),
          ],
        ));
        rows.add(const SizedBox(height: 14));
      }
    } else {
      for (int i = 0; i < q.options.length; i++) {
        rows.add(_opt(i));
        rows.add(const SizedBox(height: 14));
      }
    }
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Column(children: [_questionHeader(q), ...rows]),
          ),
        ),
        if (_correct)
          _Feedback(explain: q.explain, onNext: widget.onNext)
        else if (_wrong.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            color: AppColors.anarLight,
            child: const Text('دوباره کوشش کن، تو می\u200cتوانی! 💪',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.anarDark)),
          )
        else
          const SizedBox(height: 4),
      ],
    );
  }
}

// ---------------- مرتب‌سازی ----------------
class _ArrangeView extends StatefulWidget {
  final Question q;
  final Color color;
  final Color dark;
  final VoidCallback onMistake;
  final VoidCallback onNext;
  const _ArrangeView({required this.q, required this.color, required this.dark, required this.onMistake, required this.onNext});
  @override
  State<_ArrangeView> createState() => _ArrangeViewState();
}

class _ArrangeViewState extends State<_ArrangeView> {
  late List<int> _bank;
  final List<int> _placed = <int>[];
  bool _done = false;
  bool _flashWrong = false;

  bool _isOriginalOrder(List<int> idx) {
    for (int k = 0; k < idx.length; k++) {
      if (widget.q.tokens[idx[k]] != widget.q.tokens[k]) return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _bank = List<int>.generate(widget.q.tokens.length, (int i) => i)..shuffle(appRng);
    if (_bank.length > 1 && _isOriginalOrder(_bank)) {
      _bank = _bank.reversed.toList();
    }
  }

  bool get _rtl {
    if (widget.q.ltr) return false;
    return hasArabicScript(widget.q.tokens.join());
  }

  List<String> get _placedText => _placed.map((int i) => widget.q.tokens[i]).toList();

  void _check() {
    final List<String> got = _placedText;
    bool ok = got.length == widget.q.tokens.length;
    for (int k = 0; ok && k < got.length; k++) {
      if (got[k] != widget.q.tokens[k]) ok = false;
    }
    if (ok) {
      setState(() => _done = true);
      HapticFeedback.lightImpact();
    } else {
      widget.onMistake();
      HapticFeedback.mediumImpact();
      setState(() => _flashWrong = true);
      Future<void>.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _placed.clear();
            _flashWrong = false;
          });
        }
      });
    }
  }

  Widget _tile(String text, Color bg, Color border, Color fg, VoidCallback? onTap) {
    return Tappable(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 52, minHeight: 56),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: 2.5),
          boxShadow: [BoxShadow(color: border, offset: const Offset(0, 3))],
        ),
        child: Text(text,
            textDirection: dirFor(text),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: fg)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Question q = widget.q;
    final TextDirection td = _rtl ? TextDirection.rtl : TextDirection.ltr;
    final Color placedBg = _flashWrong ? AppColors.anarLight : (_done ? AppColors.leafLight : Colors.white);
    final Color placedBorder = _flashWrong ? AppColors.anar : (_done ? AppColors.leaf : widget.color);
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Column(
              children: [
                _questionHeader(q),
                if (_placed.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(_placedText.join(),
                        textDirection: td,
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.ink)),
                  ),
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 84),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.line, width: 2),
                  ),
                  child: Wrap(
                    textDirection: td,
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final int i in _placed)
                        _tile(q.tokens[i], placedBg, placedBorder, AppColors.ink, (_done || _flashWrong) ? null : () => setState(() => _placed.remove(i))),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Wrap(
                  textDirection: td,
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final int i in _bank)
                      _placed.contains(i)
                          ? _tile(q.tokens[i], const Color(0xFFEFE8DA), const Color(0xFFEFE8DA), const Color(0xFFEFE8DA), null)
                          : _tile(q.tokens[i], Colors.white, AppColors.line, AppColors.ink,
                              (_done || _flashWrong) ? null : () => setState(() => _placed.add(i))),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (_done)
          _Feedback(explain: q.explain, onNext: widget.onNext)
        else
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: ChunkyButton(
              label: 'بررسی',
              color: widget.color,
              shadow: widget.dark,
              onTap: (_placed.length == q.tokens.length && !_flashWrong) ? _check : null,
            ),
          ),
      ],
    );
  }
}

// ---------------- جفت‌یابی ----------------
class _MatchView extends StatefulWidget {
  final Question q;
  final Color color;
  final Color dark;
  final VoidCallback onMistake;
  final VoidCallback onNext;
  const _MatchView({required this.q, required this.color, required this.dark, required this.onMistake, required this.onNext});
  @override
  State<_MatchView> createState() => _MatchViewState();
}

class _MatchViewState extends State<_MatchView> {
  late List<int> _rightOrder;
  int? _selLeft;
  final Set<int> _doneLeft = <int>{};
  final Set<int> _doneRightPos = <int>{};
  int? _flashRightPos;

  @override
  void initState() {
    super.initState();
    _rightOrder = List<int>.generate(widget.q.right.length, (int i) => i)..shuffle(appRng);
  }

  bool get _complete => _doneLeft.length == widget.q.left.length;

  void _tapLeft(int i) {
    if (_doneLeft.contains(i)) return;
    setState(() => _selLeft = i);
  }

  void _tapRight(int pos) {
    if (_doneRightPos.contains(pos) || _selLeft == null) return;
    final int sel = _selLeft!;
    if (_rightOrder[pos] == sel) {
      setState(() {
        _doneLeft.add(sel);
        _doneRightPos.add(pos);
        _selLeft = null;
      });
      HapticFeedback.lightImpact();
    } else {
      widget.onMistake();
      HapticFeedback.mediumImpact();
      setState(() => _flashRightPos = pos);
      Future<void>.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _flashRightPos = null);
      });
    }
  }

  Widget _cell(String text, Color bg, Color border, Color fg, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Tappable(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 60),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border, width: 2.5),
            boxShadow: [BoxShadow(color: border, offset: const Offset(0, 3))],
          ),
          child: Text(text,
              textAlign: TextAlign.center,
              textDirection: dirFor(text),
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: fg)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Question q = widget.q;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Column(
              children: [
                _questionHeader(q),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          for (int i = 0; i < q.left.length; i++)
                            _doneLeft.contains(i)
                                ? _cell(q.left[i], AppColors.leafLight, AppColors.leaf, AppColors.leafDark, () {})
                                : _cell(
                                    q.left[i],
                                    _selLeft == i ? widget.color : Colors.white,
                                    _selLeft == i ? widget.dark : AppColors.line,
                                    _selLeft == i ? Colors.white : AppColors.ink,
                                    () => _tapLeft(i)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        children: [
                          for (int pos = 0; pos < _rightOrder.length; pos++)
                            _doneRightPos.contains(pos)
                                ? _cell(q.right[_rightOrder[pos]], AppColors.leafLight, AppColors.leaf, AppColors.leafDark, () {})
                                : _cell(
                                    q.right[_rightOrder[pos]],
                                    _flashRightPos == pos ? AppColors.anarLight : Colors.white,
                                    _flashRightPos == pos ? AppColors.anar : AppColors.line,
                                    _flashRightPos == pos ? AppColors.anarDark : AppColors.ink,
                                    () => _tapRight(pos)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (_complete) _Feedback(explain: '', onNext: widget.onNext),
      ],
    );
  }
}

// ---------------- صفحهٔ نتیجه ----------------
class ResultScreen extends StatelessWidget {
  final int stars;
  final int mistakes;
  final int total;
  final Color color;
  final Widget Function() retry;
  const ResultScreen({
    super.key,
    required this.stars,
    required this.mistakes,
    required this.total,
    required this.color,
    required this.retry,
  });

  @override
  Widget build(BuildContext context) {
    final String title = stars == 3 ? 'عالی بود! 🎉' : (stars == 2 ? 'خیلی خوب!' : 'آفرین، ادامه بده!');
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              child: Column(
                children: [
                  const Spacer(),
                  DanagakMascot(size: 170, mood: stars >= 2 ? MascotMood.cheer : MascotMood.happy),
                  const SizedBox(height: 10),
                  Text(title, style: Txt.h1.copyWith(fontSize: 30)),
                  const SizedBox(height: 6),
                  Text('${faDigits(stars)} دانه برای باغ دانش تو', style: Txt.body),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int k = 0; k < 3; k++)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: k < stars
                              ? TweenAnimationBuilder<double>(
                                  tween: Tween<double>(begin: 0.0, end: 1.0),
                                  duration: Duration(milliseconds: 500 + k * 250),
                                  curve: Curves.elasticOut,
                                  builder: (BuildContext c, double v, Widget? child) => Transform.scale(scale: v, child: child),
                                  child: const SeedIcon(size: 54),
                                )
                              : Container(
                                  width: 54,
                                  height: 65,
                                  decoration: BoxDecoration(
                                    color: AppColors.line,
                                    borderRadius: const BorderRadius.all(Radius.elliptical(27, 32)),
                                  ),
                                ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    mistakes == 0 ? 'هیچ اشتباهی نداشتی!' : 'اشتباه\u200cها: ${faDigits(mistakes)} از ${faDigits(total)} سوال',
                    style: Txt.small.copyWith(fontSize: 15),
                  ),
                  const Spacer(),
                  ChunkyButton(label: 'ادامه', color: color, shadow: AppColors.ink.withAlpha(90), onTap: () => Navigator.of(context).pop()),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (BuildContext c) => retry())),
                    child: const Text('یک بار دیگر', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),
          ),
          const Positioned.fill(child: ConfettiBurst()),
        ],
      ),
    );
  }
}
