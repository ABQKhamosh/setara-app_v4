import 'dart:math';
import '../core/fa.dart';
import '../models/models.dart';

final Random _r = appRng;
T _pick<T>(List<T> l) => l[_r.nextInt(l.length)];

const List<List<String>> kDariLetters = [
  ['ا', 'انگور', '🍇'], ['ب', 'بز', '🐐'], ['پ', 'پروانه', '🦋'], ['ت', 'توپ', '⚽'],
  ['ث', 'ثروت', '💰'], ['ج', 'جوجه', '🐥'], ['چ', 'چای', '🍵'], ['ح', 'حلزون', '🐌'],
  ['خ', 'خرگوش', '🐰'], ['د', 'دست', '✋'], ['ذ', 'ذرت', '🌽'], ['ر', 'روباه', '🦊'],
  ['ز', 'زرافه', '🦒'], ['ژ', 'ژله', '🍮'], ['س', 'سیب', '🍎'], ['ش', 'شیر', '🦁'],
  ['ص', 'صندوق', '📦'], ['ض', 'ضرب', '✖️'], ['ط', 'طبل', '🥁'], ['ظ', 'ظرف', '🍽️'],
  ['ع', 'عینک', '👓'], ['غ', 'غنچه', '🌷'], ['ف', 'فیل', '🐘'], ['ق', 'قلم', '✏️'],
  ['ک', 'کتاب', '📖'], ['گ', 'گل', '🌹'], ['ل', 'لیمو', '🍋'], ['م', 'ماهی', '🐟'],
  ['ن', 'نان', '🍞'], ['و', 'ورزش', '🏃'], ['ه', 'هندوانه', '🍉'], ['ی', 'یخ', '❄️'],
];

const List<List<String>> kDariWords = [
  ['سیب', '🍎'], ['گل', '🌹'], ['ماهی', '🐟'], ['توپ', '⚽'], ['کتاب', '📖'], ['قلم', '✏️'],
  ['خانه', '🏠'], ['گربه', '🐱'], ['سگ', '🐶'], ['شیر', '🦁'], ['فیل', '🐘'], ['نان', '🍞'],
  ['آب', '💧'], ['ماه', '🌙'], ['ستاره', '⭐'], ['درخت', '🌳'], ['گاو', '🐄'], ['بز', '🐐'],
  ['مرغ', '🐔'], ['کفش', '👟'], ['موتر', '🚗'], ['بایسکل', '🚲'], ['کوه', '⛰️'], ['ابر', '☁️'],
  ['باران', '🌧️'], ['برف', '⛄'], ['دست', '✋'], ['چشم', '👁️'], ['گوش', '👂'], ['بینی', '👃'],
  ['آفتاب', '☀️'],
];

List<Question> _alphaQuestions(List<List<String>> group) {
  final List<Question> qs = <Question>[];
  for (final List<String> e in group) {
    final List<String> wl = kDariLetters.where((x) => x[0] != e[0]).map((x) => x[0]).toList()..shuffle(_r);
    qs.add(Question.mcq('این با کدام حرف شروع می\u200cشود؟', e[0], wl.take(3).toList(),
        visual: e[2], explain: '${e[1]} با «${e[0]}» شروع می\u200cشود.'));
    final List<String> ww = kDariLetters.where((x) => x[0] != e[0]).map((x) => x[1]).toList()..shuffle(_r);
    qs.add(Question.mcq('کدام کلمه با حرف «${e[0]}» شروع می\u200cشود؟', e[1], ww.take(3).toList(), visual: e[0]));
  }
  final List<List<String>> two = List<List<String>>.from(group)..shuffle(_r);
  for (final List<String> e in two.take(2)) {
    qs.add(Question.arrange('حرف\u200cها را مرتب کن تا کلمه بسازی', e[1].split(''), visual: e[2]));
  }
  qs.shuffle(_r);
  return qs;
}

List<Lesson> _alphabetLessons() {
  final List<Lesson> out = <Lesson>[];
  for (int g = 0; g < 8; g++) {
    final List<List<String>> group = kDariLetters.sublist(g * 4, g * 4 + 4);
    final String title = group.map((e) => e[0]).join('  ');
    out.add(Lesson('alpha$g', title, group[0][2], () => _alphaQuestions(group)));
  }
  return out;
}

List<Question> buildWordGame({int n = 8}) {
  final List<List<String>> pool = List<List<String>>.from(kDariWords)..shuffle(_r);
  final List<Question> qs = <Question>[];
  for (final List<String> w in pool) {
    if (qs.length >= n) break;
    if (qs.length.isEven) {
      final List<String> wr = kDariWords.where((x) => x[0] != w[0]).map((x) => x[0]).toList()..shuffle(_r);
      qs.add(Question.mcq('این چیست؟', w[0], wr.take(3).toList(), visual: w[1]));
    } else if (w[0].length >= 2 && w[0].length <= 6) {
      qs.add(Question.arrange('حرف\u200cها را مرتب کن', w[0].split(''), visual: w[1]));
    } else {
      final List<String> wr = kDariWords.where((x) => x[0] != w[0]).map((x) => x[0]).toList()..shuffle(_r);
      qs.add(Question.mcq('این چیست؟', w[0], wr.take(3).toList(), visual: w[1]));
    }
  }
  return qs;
}

const List<List<String>> _opposites = [
  ['بزرگ', 'کوچک'], ['بالا', 'پایین'], ['سرد', 'گرم'], ['روز', 'شب'], ['خوب', 'بد'],
  ['تازه', 'کهنه'], ['دور', 'نزدیک'], ['سنگین', 'سبک'], ['تند', 'کند'], ['زیاد', 'کم'],
  ['سفید', 'سیاه'], ['خوشحال', 'غمگین'], ['پر', 'خالی'], ['روشن', 'تاریک'], ['باز', 'بسته'],
  ['بلند', 'کوتاه'],
];

const List<List<String>> _synonyms = [
  ['زیبا', 'قشنگ'], ['بزرگ', 'کلان'], ['خانه', 'منزل'], ['دوست', 'رفیق'], ['راه', 'جاده'],
  ['شاد', 'خوشحال'], ['مکتب', 'مدرسه'], ['معلم', 'استاد'], ['موتر', 'ماشین'], ['خوراک', 'غذا'],
  ['سریع', 'تیز'], ['کودک', 'طفل'],
];

const List<List<String>> _plurals = [
  ['کتاب', 'کتاب\u200cها'], ['گل', 'گل\u200cها'], ['درخت', 'درخت\u200cها'], ['شاگرد', 'شاگردان'],
  ['معلم', 'معلمان'], ['پرنده', 'پرندگان'], ['ماهی', 'ماهی\u200cها'], ['کودک', 'کودکان'],
  ['دانشمند', 'دانشمندان'], ['خانه', 'خانه\u200cها'], ['برادر', 'برادران'], ['بچه', 'بچه\u200cها'],
];

Question _pairQ(List<List<String>> pairs, String Function(String) prompt, {bool both = false}) {
  final List<String> p = _pick(pairs);
  final bool rev = both && _r.nextBool();
  final String q = rev ? p[1] : p[0];
  final String a = rev ? p[0] : p[1];
  final List<String> wr = pairs.where((x) => x[0] != p[0]).map((x) => rev ? x[0] : x[1]).toList()..shuffle(_r);
  return Question.mcq(prompt(q), a, wr.take(3).toList());
}

const List<List<String>> _gram = [
  ['کتاب', 'اسم'], ['گل', 'اسم'], ['مکتب', 'اسم'], ['کابل', 'اسم'],
  ['رفت', 'فعل'], ['نوشت', 'فعل'], ['می\u200cدود', 'فعل'], ['خورد', 'فعل'],
  ['زیبا', 'صفت'], ['بزرگ', 'صفت'], ['سبز', 'صفت'], ['تیز', 'صفت'],
];

Question _grammarQ() {
  final List<String> g = _pick(_gram);
  final List<String> wr = ['اسم', 'فعل', 'صفت'].where((x) => x != g[1]).toList();
  return Question.mcq('«${g[0]}» چه نوع کلمه\u200cای است؟', g[1], wr, explain: '«${g[0]}» یک ${g[1]} است.');
}

const List<String> _cloze = [
  'گاو ... می^دهد.|شیر|نان|سنگ',
  'ما با ... می^نویسیم.|قلم|کفش|چوکی',
  'ما با ... می^بینیم.|چشم|گوش|دست',
  'ماهی در ... زندگی می^کند.|آب|خاک|هوا',
  'پرنده با ... پرواز می^کند.|بال|دم|چشم',
  'در شب ... می^درخشد.|ماه|آفتاب|برف',
  'ما با ... می^شنویم.|گوش|بینی|پا',
  'در زمستان ... می^بارد.|برف|آفتاب|گل',
  'من در ... درس می^خوانم.|مکتب|دریا|کوه',
  'آفتاب در صبح ... می^کند.|طلوع|غروب|خواب',
  'مرغ ... می^گذارد.|تخم|شیر|پشم',
  'پدرم هر روز به ... می^رود.|کار|آسمان|ابر',
];

const List<String> _proverbs = [
  'توانا بود هر که ...|دانا بود|نادان بود|تنبل بود',
  'کوه به کوه نمی^رسد، اما ... به آدم می^رسد.|آدم|سنگ|درخت',
  'قطره قطره جمع گردد، وانگهی ... شود.|دریا|کوه|باغ',
  'دوست آن باشد که گیرد دست ... .|دوست|سنگ|چوب',
  'کار امروز را به ... مینداز.|فردا|پار|شب',
  'یک ... صدا ندارد.|دست|پا|چشم',
  'دانستن، ... است.|توانستن|خوردن|رفتن',
  'صبر تلخ است، ولی ... شیرین دارد.|بر|سنگ|آب',
];

const List<String> _spelling = [
  'کدام کلمه درست نوشته شده است؟|صابون|سابون|ثابون',
  'کدام کلمه درست نوشته شده است؟|ظرف|زرف|ذرف',
  'کدام کلمه درست نوشته شده است؟|قلم|غلم|قلن',
  'کدام کلمه درست نوشته شده است؟|حیوان|هیوان|خیوان',
  'کدام کلمه درست نوشته شده است؟|طبیب|تبیب|ظبیب',
  'کدام کلمه درست نوشته شده است؟|ذخیره|زخیره|ظخیره',
  'کدام کلمه درست نوشته شده است؟|صبح|سبح|ثبح',
  'کدام کلمه درست نوشته شده است؟|ضرر|زرر|ظرر',
  'کدام کلمه درست نوشته شده است؟|عزیز|ازیز|اذیز',
  'کدام کلمه درست نوشته شده است؟|مکتب|مکطب|مکتپ',
];

const String _p1 =
    'علی هر صبح زود از خواب بیدار می^شود. او دست و رویش را می^شوید و ناشتا می^خورد. بعد کتاب^هایش را در بکسش می^گذارد و با دوستش فرید به مکتب می^رود.';
const String _p2 =
    'کبک پرنده^ای زیبا و خوش^آواز است. او در کوه^ها و دامنهٔ دشت^ها زندگی می^کند. کبک دانه و حشرات کوچک می^خورد و روی زمین راه می^رود. پاها و منقار کبک سرخ است.';
const String _p3 =
    'انار میوه^ای سرخ و دانه^دار است. در افغانستان، انار قندهار مشهور است. در هر انار دانه^های آبدار فراوان وجود دارد. انار برای صحت بدن مفید است.';
const String _p4 =
    'آب برای زندگی همهٔ جانداران لازم است. باران از ابرها می^بارد و در دریا و دریاچه جمع می^شود. آفتاب آب را گرم می^کند و آب بخار می^شود. بخار دوباره ابر می^سازد.';

const List<String> _reading3 = [
  'علی هر صبح چه وقت بیدار می^شود؟|زود|دیر|ظهر|~$_p1',
  'علی با کی به مکتب می^رود؟|فرید|احمد|پدرش|~$_p1',
  'علی کتاب^هایش را در کجا می^گذارد؟|بکس|میز|خانه|~$_p1',
  'علی بعد از بیدار شدن چه می^خورد؟|ناشتا|شام|میوه|~$_p1',
];
const List<String> _reading4 = [
  'کبک در کجا زندگی می^کند؟|کوه و دشت|دریا|شهر|~$_p2',
  'کبک چه می^خورد؟|دانه و حشرات|گوشت|برگ|~$_p2',
  'رنگ پاهای کبک چیست؟|سرخ|سبز|سیاه|~$_p2',
  'کبک روی چه چیزی راه می^رود؟|زمین|آب|ابر|~$_p2',
];
const List<String> _reading5 = [
  'کدام انار در افغانستان مشهور است؟|انار قندهار|انار کابل|انار هرات|~$_p3',
  'درون انار چه چیزی است؟|دانه^های آبدار|هسته|برف|~$_p3',
  'انار برای چه مفید است؟|صحت بدن|بازی|خواب|~$_p3',
  'وقتی آفتاب آب را گرم می^کند، آب چه می^شود؟|بخار|یخ|سنگ|~$_p4',
  'باران از کجا می^بارد؟|ابرها|کوه|زمین|~$_p4',
  'بخار دوباره چه می^سازد؟|ابر|برف|سنگ|~$_p4',
];

List<Lesson> dariLessons(int grade) {
  switch (grade) {
    case 1:
      return [
        ..._alphabetLessons(),
        Lesson('words', 'کلمه\u200cها', '🏠', () => buildWordGame(n: 8)),
      ];
    case 2:
      return [
        Lesson('words2', 'کلمه\u200cسازی', '🔤', () => buildWordGame(n: 8)),
        genLesson('opp', 'متضادها', '↔️', 8, (int i) => _pairQ(_opposites, (q) => 'متضاد «$q» کدام است؟', both: true)),
        genLesson('plural', 'مفرد و جمع', '📚', 8, (int i) => _pairQ(_plurals, (q) => 'جمع «$q» کدام است؟')),
        dslLesson('cloze', 'جمله را کامل کن', '✍️', _cloze),
      ];
    case 3:
      return [
        genLesson('syn', 'هم\u200cمعنی', '🔗', 8, (int i) => _pairQ(_synonyms, (q) => 'هم\u200cمعنی «$q» کدام است؟', both: true)),
        genLesson('gram', 'اسم، فعل، صفت', '🧩', 8, (int i) => _grammarQ()),
        dslLesson('cloze3', 'جمله را کامل کن', '✍️', _cloze),
        dslLesson('spell3', 'املا', '✏️', _spelling),
        dslLesson('read3', 'خواندن و فهمیدن', '📰', _reading3, take: 3),
      ];
    case 4:
      return [
        genLesson('opp4', 'متضاد و هم\u200cمعنی', '↔️', 8,
            (int i) => i.isEven ? _pairQ(_opposites, (q) => 'متضاد «$q» کدام است؟', both: true) : _pairQ(_synonyms, (q) => 'هم\u200cمعنی «$q» کدام است؟', both: true)),
        genLesson('gram4', 'نوع کلمه', '🧩', 8, (int i) => _grammarQ()),
        dslLesson('spell4', 'املا', '✏️', _spelling),
        dslLesson('prov4', 'ضرب\u200cالمثل', '💬', _proverbs),
        dslLesson('read4', 'خواندن و فهمیدن', '📰', _reading4, take: 3),
      ];
    default:
      return [
        genLesson('gram5', 'نوع کلمه', '🧩', 8, (int i) => _grammarQ()),
        dslLesson('spell5', 'املا', '✏️', _spelling),
        dslLesson('prov5', 'ضرب\u200cالمثل', '💬', _proverbs),
        dslLesson('read5', 'خواندن و فهمیدن', '📰', _reading5, take: 3),
        dslLesson('cloze5', 'جمله را کامل کن', '✍️', _cloze),
      ];
  }
}

// ---------- پښتو ----------
const List<List<String>> kPashtoWords = [
  ['ګل', '🌹', 'گل'], ['کتاب', '📖', 'کتاب'], ['اوبه', '💧', 'آب'], ['کور', '🏠', 'خانه'],
  ['پیشو', '🐱', 'گربه'], ['سپی', '🐶', 'سگ'], ['غر', '⛰️', 'کوه'], ['لمر', '☀️', 'آفتاب'],
  ['سپوږمۍ', '🌙', 'ماه'], ['ستوری', '⭐', 'ستاره'], ['ډوډۍ', '🍞', 'نان'], ['شودې', '🥛', 'شیر'],
  ['مڼه', '🍎', 'سیب'], ['اس', '🐴', 'اسپ'], ['غوا', '🐄', 'گاو'], ['ونه', '🌳', 'درخت'],
];

const List<String> _pNum = ['یو', 'دوه', 'درې', 'څلور', 'پنځه', 'شپږ', 'اوه', 'اته', 'نهه', 'لس'];

const List<List<String>> _pColors = [
  ['سور', '#E53935', 'سرخ'], ['شین', '#43A047', 'سبز'], ['زیړ', '#FDD835', 'زرد'],
  ['تور', '#212121', 'سیاه'], ['سپین', '#FAFAFA', 'سفید'],
];

const List<String> _pPhrases = [
  'معنی «مننه» چیست؟|تشکر|ببخشید|خدا حافظ',
  'معنی «ښه راغلاست» چیست؟|خوش آمدید|خدا حافظ|ببخشید',
  'معنی «په مخه ښه» چیست؟|خدا حافظ|تشکر|سلام',
  'معنی «ښه» چیست؟|خوب|بد|زیاد',
  'معنی «مور» چیست؟|مادر|پدر|خواهر',
  'معنی «پلار» چیست؟|پدر|مادر|برادر',
  'معنی «ورور» چیست؟|برادر|خواهر|پدر',
  'معنی «خور» چیست؟|خواهر|برادر|مادر',
  'معنی «نوم» چیست؟|نام|کتاب|خانه',
  'معنی «زه» چیست؟|من|تو|او',
  'معنی «ته» چیست؟|تو|من|او',
];

Question _pWordQ(int i) {
  final List<String> w = _pick(kPashtoWords);
  final List<List<String>> others = kPashtoWords.where((x) => x[0] != w[0]).toList()..shuffle(_r);
  if (i.isEven) {
    return Question.mcq('این به پښتو چیست؟', w[0], others.take(3).map((x) => x[0]).toList(), visual: w[1]);
  }
  return Question.mcq('معنی «${w[0]}» چیست؟', w[2], others.take(3).map((x) => x[2]).toList(), visual: w[1]);
}

Question _pNumQ(int i) {
  final int n = _r.nextInt(10);
  final List<int> idx = List<int>.generate(10, (int k) => k)..remove(n)..shuffle(_r);
  if (i.isEven) {
    return Question.mcq('عدد ${faDigits(n + 1)} به پښتو چیست؟', _pNum[n], idx.take(3).map((k) => _pNum[k]).toList(),
        visual: faDigits(n + 1));
  }
  return Question.mcq('«${_pNum[n]}» چه عددی است؟', faDigits(n + 1), idx.take(3).map((k) => faDigits(k + 1)).toList(),
      visual: _pNum[n]);
}

Question _pColorQ(int i) {
  final List<String> c = _pick(_pColors);
  final List<List<String>> others = _pColors.where((x) => x[0] != c[0]).toList()..shuffle(_r);
  if (i.isEven) {
    return Question.mcq('این رنگ به پښتو چیست؟', c[0], others.take(3).map((x) => x[0]).toList(), visual: c[1]);
  }
  return Question.mcq('«${c[0]}» چه رنگی است؟', c[2], others.take(3).map((x) => x[2]).toList(), visual: c[1]);
}

List<Lesson> pashtoLessons(int grade) {
  return [
    genLesson('words', 'کلمه\u200cها', '🌹', 8, (int i) => _pWordQ(i)),
    genLesson('nums', 'شمردن تا ۱۰', '🔢', 8, (int i) => _pNumQ(i)),
    genLesson('colors', 'رنگ\u200cها', '🎨', 6, (int i) => _pColorQ(i)),
    dslLesson('phrases', 'سلام و خانواده', '👋', _pPhrases),
  ];
}
