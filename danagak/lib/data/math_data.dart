import 'dart:math';
import '../core/fa.dart';
import '../models/models.dart';

final Random _r = appRng;

int _ri(int a, int b) => a + _r.nextInt(b - a + 1);
T _pick<T>(List<T> l) => l[_r.nextInt(l.length)];
String _f(int n) => faDigits(n);
String _fr(int n, int d) => '${_f(n)}/${_f(d)}';

List<int> _wrong(int ans, {int minV = 0, int n = 3}) {
  final Set<int> s = <int>{};
  int guard = 0;
  while (s.length < n && guard < 100) {
    guard++;
    int d = _ri(1, 4 + min(6, ans ~/ 10));
    if (_r.nextBool()) d = -d;
    final int v = ans + d;
    if (v != ans && v >= minV) s.add(v);
  }
  int k = 1;
  while (s.length < n) {
    final int v = ans + k;
    if (v != ans) s.add(v);
    k++;
  }
  return s.toList();
}

Question _eq(String expr, int ans, {int minV = 0}) {
  final List<String> w = _wrong(ans, minV: minV).map((int x) => _f(x)).toList();
  return Question.mcq('جواب را پیدا کن', _f(ans), w, visual: '$expr = ؟', ltr: true);
}

Question _word(String prompt, int ans, {String visual = '🧮'}) {
  final List<String> w = _wrong(ans, minV: 0).map((int x) => _f(x)).toList();
  return Question.mcq(prompt, _f(ans), w, visual: visual);
}

// ---------- صنف اول ----------
Question _count() {
  final int n = _ri(1, 10);
  final String e = _pick(['🍎', '⭐', '🐟', '🎈', '🌸', '🐥', '🍌', '⚽', '🚗', '🍉']);
  final List<String> w = _wrong(n, minV: 1).map((int x) => _f(x)).toList();
  return Question.mcq('چند تا می‌بینی؟', _f(n), w, visual: List<String>.filled(n, e).join(' '));
}

Question _add10() {
  final int a = _ri(1, 9);
  final int b = _ri(1, 10 - a);
  return _eq('${_f(a)} + ${_f(b)}', a + b);
}

Question _add20() {
  final int a = _ri(5, 14);
  final int b = _ri(2, 20 - a);
  return _eq('${_f(a)} + ${_f(b)}', a + b);
}

Question _sub10() {
  final int a = _ri(2, 10);
  final int b = _ri(1, a - 1);
  return _eq('${_f(a)} − ${_f(b)}', a - b);
}

Question _compare(int mx) {
  final int a = _ri(0, mx);
  int b = _ri(0, mx);
  while (b == a) {
    b = _ri(0, mx);
  }
  final bool bigger = _r.nextBool();
  final int ans = bigger ? (a > b ? a : b) : (a < b ? a : b);
  final int other = ans == a ? b : a;
  return Question.mcq(bigger ? 'کدام عدد بزرگ‌تر است؟' : 'کدام عدد کوچک‌تر است؟', _f(ans), [_f(other)],
      visual: '${_f(a)}    ${_f(b)}', ltr: true);
}

Question _next() {
  final int start = _ri(1, 8);
  final int step = _ri(1, 3);
  final int ans = start + 3 * step;
  final String seq = [start, start + step, start + 2 * step].map((int x) => _f(x)).join(' , ');
  final List<String> w = _wrong(ans, minV: 1).map((int x) => _f(x)).toList();
  return Question.mcq('عدد بعدی چیست؟', _f(ans), w, visual: '$seq , ؟', ltr: true);
}

const List<List<String>> _shapes = [
  ['circle', 'دایره'],
  ['square', 'مربع'],
  ['triangle', 'مثلث'],
  ['rect', 'مستطیل'],
  ['star', 'ستاره'],
  ['diamond', 'لوزی'],
];

Question _shapeName() {
  final List<String> s = _pick(_shapes);
  final List<String> wr = _shapes.where((x) => x[1] != s[1]).map((x) => x[1]).toList()..shuffle(_r);
  return Question.mcq('این شکل چه نام دارد؟', s[1], wr.take(3).toList(), visual: 'shape:${s[0]}');
}

const List<String> _shapeFacts = [
  'مثلث چند ضلع دارد؟|۳|۴|۵|۶',
  'مربع چند ضلع دارد؟|۴|۳|۵|۶',
  'مستطیل چند ضلع دارد؟|۴|۳|۵|۲',
  'کدام شکل ضلع ندارد؟|دایره|مربع|مثلث|مستطیل',
  'کدام شکل سه گوشه دارد؟|مثلث|دایره|مربع|مستطیل',
  'کدام شکل چهار ضلع برابر دارد؟|مربع|مثلث|دایره|ستاره',
];

Question _shape(int i) => i % 3 == 2 ? Question.parse(_pick(_shapeFacts)) : _shapeName();

// ---------- صنف دوم ----------
Question _place() {
  final int n = _ri(11, 99);
  if (_r.nextBool()) {
    final int ans = n ~/ 10;
    return Question.mcq('عدد ${_f(n)} چند دهگان دارد؟', _f(ans), _wrong(ans, minV: 0).map((int x) => _f(x)).toList(), visual: _f(n));
  }
  final int one = n % 10;
  return Question.mcq('رقم یکان عدد ${_f(n)} کدام است؟', _f(one), _wrong(one, minV: 0).map((int x) => _f(x)).toList(), visual: _f(n));
}

Question _add100() {
  final int a = _ri(10, 80);
  final int b = _ri(5, 100 - a);
  return _eq('${_f(a)} + ${_f(b)}', a + b);
}

Question _sub100() {
  final int a = _ri(20, 99);
  final int b = _ri(5, a - 1);
  return _eq('${_f(a)} − ${_f(b)}', a - b);
}

Question _times(List<int> facs, int maxB) {
  final int a = _pick(facs);
  final int b = _ri(1, maxB);
  return _eq('${_f(a)} × ${_f(b)}', a * b, minV: 0);
}

Question _div(int maxD, int maxQ) {
  final int d = _ri(2, maxD);
  final int q = _ri(2, maxQ);
  return _eq('${_f(d * q)} ÷ ${_f(d)}', q, minV: 0);
}

Question _money() {
  const List<String> items = ['قلم', 'کتابچه', 'نان', 'بسکویت', 'خودکار'];
  if (_r.nextBool()) {
    final String item = _pick(items);
    final int p = _pick([5, 10, 15, 20, 25]);
    final int q = _ri(2, 5);
    return _word('یک $item ${_f(p)} افغانی است. ${_f(q)} عدد آن چند افغانی می‌شود؟', p * q, visual: '💰');
  }
  final int have = _pick([20, 30, 50, 100]);
  final int spent = _ri(5, have - 5);
  return _word('${_f(have)} افغانی داشتی و ${_f(spent)} افغانی خرچ کردی. چند افغانی باقی ماند؟', have - spent, visual: '💰');
}

Question _evenOdd() {
  final int n = _ri(1, 30);
  final bool even = n % 2 == 0;
  return Question.mcq('عدد ${_f(n)} جفت است یا تاق؟', even ? 'جفت' : 'تاق', [even ? 'تاق' : 'جفت'], visual: _f(n));
}

Question _order(int count, int mx, {bool asc = true}) {
  final Set<int> s = <int>{};
  while (s.length < count) {
    s.add(_ri(1, mx));
  }
  List<int> list = s.toList()..sort();
  if (!asc) list = list.reversed.toList();
  return Question.arrange(asc ? 'عددها را از کوچک به بزرگ مرتب کن' : 'عددها را از بزرگ به کوچک مرتب کن',
      list.map((int x) => _f(x)).toList(),
      ltr: true, visual: '🔢');
}

// ---------- صنف سوم ----------
Question _add3() {
  final int a = _ri(100, 600);
  final int b = _ri(100, 999 - a);
  return _eq('${_f(a)} + ${_f(b)}', a + b);
}

Question _sub3() {
  final int a = _ri(200, 999);
  final int b = _ri(100, a - 1);
  return _eq('${_f(a)} − ${_f(b)}', a - b);
}

Question _fracOf() {
  final int k = _pick([2, 3, 4]);
  final int base = k * _ri(2, 6);
  const Map<int, String> nm = {2: 'نصف', 3: 'یک سوم', 4: 'یک چهارم'};
  return _word('${nm[k]} عدد ${_f(base)} چند است؟', base ~/ k, visual: '🍕');
}

const List<String> _measureLines = [
  'یک متر چند سانتی^متر است؟|۱۰۰|۱۰|۱۰۰۰|۵۰',
  'یک کیلوگرام چند گرام است؟|۱۰۰۰|۱۰۰|۱۰|۵۰۰',
  'یک ساعت چند دقیقه است؟|۶۰|۳۰|۱۰۰|۲۴',
  'یک شبانه^روز چند ساعت است؟|۲۴|۱۲|۶۰|۱۰۰',
  'یک هفته چند روز است؟|۷|۵|۱۰|۶',
  'یک سال چند ماه است؟|۱۲|۱۰|۷|۳۰',
  'یک کیلومتر چند متر است؟|۱۰۰۰|۱۰۰|۱۰|۱۰۰۰۰',
  'نیم ساعت چند دقیقه است؟|۳۰|۱۵|۶۰|۴۵',
  'یک لیتر چند میلی^لیتر است؟|۱۰۰۰|۱۰۰|۱۰|۵۰۰',
];

Question _measure() => Question.parse(_pick(_measureLines));

Question _wordProblem(bool hard) {
  const List<String> names = ['علی', 'احمد', 'زهرا', 'مریم', 'فرید', 'سمیرا', 'نادر', 'مینا'];
  const List<String> things = ['کتاب', 'سیب', 'قلم', 'توپ', 'گل', 'نان'];
  final String n = _pick(names);
  final String t = _pick(things);
  final int k = _r.nextInt(hard ? 4 : 3);
  if (k == 0) {
    final int a = _ri(hard ? 20 : 3, hard ? 90 : 15);
    final int b = _ri(hard ? 10 : 2, hard ? 80 : 12);
    return _word('$n ${_f(a)} $t دارد و ${_f(b)} $t دیگر گرفت. حالا چند $t دارد؟', a + b);
  }
  if (k == 1) {
    final int a = _ri(hard ? 50 : 8, hard ? 120 : 20);
    final int b = _ri(2, a - 1);
    return _word('$n ${_f(a)} $t داشت. ${_f(b)} $t به دوستش داد. چند $t باقی ماند؟', a - b);
  }
  if (k == 2) {
    final int a = _ri(2, hard ? 12 : 6);
    final int b = _ri(2, hard ? 9 : 5);
    return _word('در هر سبد ${_f(a)} $t است. در ${_f(b)} سبد چند $t است؟', a * b);
  }
  final int friends = _ri(3, 9);
  final int each = _ri(4, 15);
  return _word('${_f(friends * each)} $t را بین ${_f(friends)} دوست مساوی تقسیم کردیم. هر دوست چند $t می‌گیرد؟', each);
}

// ---------- صنف چهارم ----------
Question _mulBig(int digits) {
  final int a = digits == 2 ? _ri(12, 49) : _ri(101, 499);
  final int b = digits == 2 ? _ri(3, 9) : _ri(2, 9);
  return _eq('${_f(a)} × ${_f(b)}', a * b);
}

Question _divBig(bool hard) {
  final int d = hard ? _ri(3, 12) : _ri(2, 9);
  final int q = hard ? _ri(30, 150) : _ri(11, 60);
  return _eq('${_f(d * q)} ÷ ${_f(d)}', q);
}

Question _fracEquiv() {
  const List<List<int>> bases = [
    [1, 2], [1, 3], [2, 3], [3, 4], [1, 4], [2, 5]
  ];
  final List<int> b = _pick(bases);
  final int m = _ri(2, 4);
  final int ans = b[0] * m;
  final List<String> w = _wrong(ans, minV: 1).map((int x) => _f(x)).toList();
  return Question.mcq('کسر مساوی را کامل کن', _f(ans), w,
      visual: '${_fr(b[0], b[1])} = ؟/${_f(b[1] * m)}', ltr: true);
}

Question _fracAddSame() {
  final int d = _ri(5, 12);
  final int a = _ri(1, d - 3);
  final int b = _ri(1, d - a - 1);
  final int ans = a + b;
  final List<String> w = _wrong(ans, minV: 1).map((int x) => _fr(x, d)).toList();
  return Question.mcq('جمع کسرها', _fr(ans, d), w, visual: '${_fr(a, d)} + ${_fr(b, d)} = ؟', ltr: true);
}

Question _place4() {
  final int n = _ri(1000, 9999);
  const List<String> names = ['هزارگان', 'صدگان', 'دهگان', 'یکان'];
  const List<int> divs = [1000, 100, 10, 1];
  final int k = _r.nextInt(4);
  final int ans = (n ~/ divs[k]) % 10;
  return Question.mcq('رقم ${names[k]} در عدد ${_f(n)} کدام است؟', _f(ans),
      _wrong(ans, minV: 0).map((int x) => _f(x)).toList(), visual: _f(n));
}

Question _geom(bool hard) {
  final int a = _ri(hard ? 6 : 3, hard ? 25 : 12);
  final int b = _ri(hard ? 4 : 2, hard ? 18 : 9);
  final int kind = _r.nextInt(hard ? 4 : 3);
  if (kind == 0) {
    return _word('محیط مستطیلی به طول ${_f(a)} و عرض ${_f(b)} چند است؟', 2 * (a + b), visual: '📐');
  }
  if (kind == 1) {
    return _word('مساحت مستطیلی به طول ${_f(a)} و عرض ${_f(b)} چند است؟', a * b, visual: '📐');
  }
  if (kind == 2) {
    return _word('محیط مربعی به ضلع ${_f(a)} چند است؟', 4 * a, visual: '📐');
  }
  return _word('مساحت مربعی به ضلع ${_f(a)} چند است؟', a * a, visual: '📐');
}

// ---------- صنف پنجم ----------
Question _fracAddDiff() {
  const List<List<int>> pairs = [
    [2, 4], [3, 6], [2, 6], [5, 10], [2, 8], [4, 8]
  ];
  final List<int> p = _pick(pairs);
  final int d1 = p[0];
  final int d2 = p[1];
  final int k = d2 ~/ d1;
  final int b = _ri(1, d2 - k - 1);
  final int ans = k + b;
  final List<String> w = _wrong(ans, minV: 1).map((int x) => _f(x)).toList();
  return Question.mcq('کسرها را جمع کن', _f(ans), w,
      visual: '${_fr(1, d1)} + ${_fr(b, d2)} = ؟/${_f(d2)}', ltr: true);
}

const List<List<int>> _simp = [
  [2, 4, 1, 2], [3, 6, 1, 2], [4, 8, 1, 2], [6, 9, 2, 3], [10, 15, 2, 3],
  [6, 8, 3, 4], [9, 12, 3, 4], [4, 10, 2, 5], [15, 20, 3, 4], [8, 12, 2, 3],
];

Question _fracSimplify() {
  final List<int> s = _pick(_simp);
  final String correct = _fr(s[2], s[3]);
  final List<String> pool = _simp.map((x) => _fr(x[2], x[3])).toSet().where((x) => x != correct).toList()..shuffle(_r);
  return Question.mcq('کسر را ساده کن', correct, pool.take(3).toList(), visual: '${_fr(s[0], s[1])} = ؟', ltr: true);
}

String _dec(int tenths) => faDigits('${tenths ~/ 10}.${tenths % 10}').replaceAll('.', '٫');

Question _decimal() {
  final bool add = _r.nextBool();
  int a = _ri(11, 99);
  final int b = _ri(11, 99);
  if (!add) {
    if (a == b) a += 5;
    if (b > a) {
      return _decQ(b, a, false);
    }
  }
  return _decQ(a, b, add);
}

Question _decQ(int a, int b, bool add) {
  final int ans = add ? a + b : a - b;
  final String op = add ? '+' : '−';
  final List<String> w = _wrong(ans, minV: 1).map((int x) => _dec(x)).toList();
  return Question.mcq('جواب را پیدا کن', _dec(ans), w, visual: '${_dec(a)} $op ${_dec(b)} = ؟', ltr: true);
}

Question _percent() {
  final int p = _pick([10, 20, 25, 50]);
  final int base = _pick([40, 80, 100, 120, 200, 400]);
  return _word('${_f(p)}٪ از ${_f(base)} چند است؟', base * p ~/ 100, visual: '${_f(p)}٪');
}

// ---------- فهرست درس‌ها ----------
List<Lesson> mathLessons(int grade) {
  switch (grade) {
    case 1:
      return [
        genLesson('count', 'شمارش', '🍎', 8, (int i) => _count()),
        genLesson('add10', 'جمع تا ۱۰', '➕', 8, (int i) => _add10()),
        genLesson('sub10', 'تفریق تا ۱۰', '➖', 8, (int i) => _sub10()),
        genLesson('cmp', 'کدام بزرگ\u200cتر؟', '⚖️', 8, (int i) => _compare(20)),
        genLesson('next', 'عدد بعدی', '🔢', 8, (int i) => _next()),
        genLesson('shape', 'شکل\u200cها', '🔷', 8, (int i) => _shape(i)),
        genLesson('add20', 'جمع تا ۲۰', '🎈', 8, (int i) => _add20()),
      ];
    case 2:
      return [
        genLesson('tens', 'دهگان و یکان', '🔟', 8, (int i) => _place()),
        genLesson('add100', 'جمع تا ۱۰۰', '➕', 8, (int i) => _add100()),
        genLesson('sub100', 'تفریق تا ۱۰۰', '➖', 8, (int i) => _sub100()),
        genLesson('times', 'ضرب ۲، ۵ و ۱۰', '✖️', 8, (int i) => _times([2, 5, 10], 10)),
        genLesson('money', 'پول افغانی', '💰', 8, (int i) => _money()),
        genLesson('evenodd', 'جفت و تاق', '🎯', 8, (int i) => _evenOdd()),
        genLesson('order', 'ترتیب عددها', '📶', 6, (int i) => _order(4, 99, asc: i.isEven)),
      ];
    case 3:
      return [
        genLesson('mul', 'جدول ضرب', '✖️', 10, (int i) => _times([2, 3, 4, 5, 6, 7, 8, 9], 9)),
        genLesson('div', 'تقسیم', '➗', 8, (int i) => _div(9, 9)),
        genLesson('add3', 'جمع و تفریق سه رقمی', '🧮', 8, (int i) => i.isEven ? _add3() : _sub3()),
        genLesson('frac', 'نصف و ربع', '🍕', 8, (int i) => _fracOf()),
        genLesson('measure', 'اندازه\u200cگیری', '📏', 6, (int i) => _measure()),
        genLesson('word', 'مسئله\u200cهای لفظی', '📝', 6, (int i) => _wordProblem(false)),
      ];
    case 4:
      return [
        genLesson('mul2', 'ضرب بزرگ\u200cتر', '✖️', 8, (int i) => _mulBig(2)),
        genLesson('div2', 'تقسیم بزرگ\u200cتر', '➗', 8, (int i) => _divBig(false)),
        genLesson('fraceq', 'کسرها', '🍰', 8, (int i) => i.isEven ? _fracEquiv() : _fracAddSame()),
        genLesson('place4', 'ارزش مکانی', '🔢', 8, (int i) => _place4()),
        genLesson('geom', 'محیط و مساحت', '📐', 8, (int i) => _geom(false)),
        genLesson('order4', 'مرتب\u200cسازی', '📶', 6, (int i) => _order(5, 999, asc: i.isEven)),
      ];
    default:
      return [
        genLesson('mul3', 'ضرب سه رقمی', '✖️', 8, (int i) => _mulBig(3)),
        genLesson('div3', 'تقسیم', '➗', 8, (int i) => _divBig(true)),
        genLesson('fracadd', 'جمع و ساده کردن کسر', '🍰', 8, (int i) => i.isEven ? _fracAddDiff() : _fracSimplify()),
        genLesson('dec', 'اعشار', '🔟', 8, (int i) => _decimal()),
        genLesson('pct', 'فیصدی', '💯', 8, (int i) => _percent()),
        genLesson('geom5', 'مساحت و محیط', '📐', 8, (int i) => _geom(true)),
        genLesson('word5', 'مسئله\u200cهای لفظی', '📝', 6, (int i) => _wordProblem(true)),
      ];
  }
}

/// سوال برای بازی «ریاضی سریع» مطابق صنف
Question speedQuestion(int grade) {
  final int g = grade < 1 ? 1 : (grade > 5 ? 5 : grade);
  switch (g) {
    case 1:
      return _r.nextBool() ? _add10() : _sub10();
    case 2:
      return _r.nextBool() ? _add100() : _sub100();
    case 3:
      final int k = _r.nextInt(3);
      if (k == 0) return _times([2, 3, 4, 5, 6, 7, 8, 9], 9);
      if (k == 1) return _div(9, 9);
      return _r.nextBool() ? _add3() : _sub3();
    case 4:
      return _r.nextBool() ? _mulBig(2) : _divBig(false);
    default:
      return _r.nextBool() ? _mulBig(3) : _divBig(true);
  }
}
