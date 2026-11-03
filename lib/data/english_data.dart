import 'dart:math';
import '../core/fa.dart';
import '../models/models.dart';

final Random _r = appRng;
T _pick<T>(List<T> l) => l[_r.nextInt(l.length)];

const List<List<String>> _letters = [
  ['A', 'Apple', '🍎'], ['B', 'Ball', '⚽'], ['C', 'Cat', '🐱'], ['D', 'Dog', '🐶'],
  ['E', 'Elephant', '🐘'], ['F', 'Fish', '🐟'], ['G', 'Grapes', '🍇'], ['H', 'House', '🏠'],
  ['I', 'Ice cream', '🍦'], ['J', 'Jet', '✈️'], ['K', 'Key', '🔑'], ['L', 'Lion', '🦁'],
  ['M', 'Moon', '🌙'], ['N', 'Nose', '👃'], ['O', 'Orange', '🍊'], ['P', 'Pizza', '🍕'],
  ['Q', 'Queen', '👸'], ['R', 'Rainbow', '🌈'], ['S', 'Sun', '☀️'], ['T', 'Tree', '🌳'],
  ['U', 'Umbrella', '☂️'], ['V', 'Violin', '🎻'], ['W', 'Watch', '⌚'], ['Z', 'Zebra', '🦓'],
];

List<Question> _letterQuestions(List<List<String>> group) {
  final List<Question> qs = <Question>[];
  for (final List<String> e in group) {
    final List<String> wl = _letters.where((x) => x[0] != e[0]).map((x) => x[0]).toList()..shuffle(_r);
    qs.add(Question.mcq('این با کدام حرف شروع می\u200cشود؟', e[0], wl.take(3).toList(), visual: e[2]));
    final List<String> ww = _letters.where((x) => x[0] != e[0]).map((x) => x[1]).toList()..shuffle(_r);
    qs.add(Question.mcq('کدام کلمه با حرف ${e[0]} شروع می\u200cشود؟', e[1], ww.take(3).toList(), visual: e[0]));
  }
  qs.shuffle(_r);
  return qs.take(10).toList();
}

List<Lesson> _letterLessons() {
  final List<Lesson> out = <Lesson>[];
  for (int g = 0; g < 4; g++) {
    final List<List<String>> group = _letters.sublist(g * 6, g * 6 + 6);
    out.add(Lesson('abc$g', '${group.first[0]} تا ${group.last[0]}', group[0][2], () => _letterQuestions(group)));
  }
  return out;
}

Question _afterLetter() {
  final int i = _r.nextInt(25);
  final String a = String.fromCharCode(65 + i);
  final String b = String.fromCharCode(66 + i);
  final List<String> wr = <String>[];
  while (wr.length < 3) {
    final String c = String.fromCharCode(65 + _r.nextInt(26));
    if (c != b && c != a && !wr.contains(c)) wr.add(c);
  }
  return Question.mcq('بعد از حرف $a کدام حرف می\u200cآید؟', b, wr, visual: '$a  ؟');
}

const List<List<String>> _colors = [
  ['Red', '#E53935', 'سرخ'], ['Blue', '#1E88E5', 'آبی'], ['Green', '#43A047', 'سبز'],
  ['Yellow', '#FDD835', 'زرد'], ['Black', '#212121', 'سیاه'], ['Orange', '#FB8C00', 'نارنجی'],
  ['Purple', '#8E24AA', 'بنفش'], ['Pink', '#EC407A', 'گلی'],
];

Question _colorQ(int i) {
  final List<String> c = _pick(_colors);
  final List<List<String>> o = _colors.where((x) => x[0] != c[0]).toList()..shuffle(_r);
  if (i.isEven) {
    return Question.mcq('این رنگ به انگلیسی چیست؟', c[0], o.take(3).map((x) => x[0]).toList(), visual: c[1]);
  }
  return Question.mcq('«${c[0]}» چه رنگی است؟', c[2], o.take(3).map((x) => x[2]).toList(), visual: c[1]);
}

Question _numQ(int i) {
  const List<String> nums = ['One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten'];
  final int n = _r.nextInt(10);
  final List<int> idx = List<int>.generate(10, (int k) => k)..remove(n)..shuffle(_r);
  if (i.isEven) {
    return Question.mcq('عدد ${faDigits(n + 1)} به انگلیسی چیست؟', nums[n], idx.take(3).map((k) => nums[k]).toList(),
        visual: faDigits(n + 1));
  }
  return Question.mcq('«${nums[n]}» چه عددی است؟', faDigits(n + 1), idx.take(3).map((k) => faDigits(k + 1)).toList(),
      visual: nums[n]);
}

const List<List<String>> _animals = [
  ['Cat', '🐱'], ['Dog', '🐶'], ['Fish', '🐟'], ['Bird', '🐦'], ['Cow', '🐄'], ['Horse', '🐴'],
  ['Rabbit', '🐰'], ['Lion', '🦁'], ['Elephant', '🐘'], ['Monkey', '🐒'], ['Duck', '🦆'], ['Frog', '🐸'],
];
const List<List<String>> _fruits = [
  ['Apple', '🍎'], ['Banana', '🍌'], ['Grapes', '🍇'], ['Orange', '🍊'], ['Watermelon', '🍉'],
  ['Lemon', '🍋'], ['Cherry', '🍒'], ['Strawberry', '🍓'], ['Pineapple', '🍍'], ['Peach', '🍑'],
];

Question _picWord(List<List<String>> list) {
  final List<String> w = _pick(list);
  final List<String> o = list.where((x) => x[0] != w[0]).map((x) => x[0]).toList()..shuffle(_r);
  return Question.mcq('این به انگلیسی چیست؟', w[0], o.take(3).toList(), visual: w[1]);
}

const List<List<String>> _vocab = [
  ['مادر', 'Mother'], ['پدر', 'Father'], ['برادر', 'Brother'], ['خواهر', 'Sister'],
  ['مادرکلان', 'Grandmother'], ['پدرکلان', 'Grandfather'], ['معلم', 'Teacher'], ['شاگرد', 'Student'],
  ['دوست', 'Friend'], ['مکتب', 'School'], ['کتاب', 'Book'], ['قلم', 'Pen'],
  ['چوکی', 'Chair'], ['میز', 'Table'], ['بکس', 'Bag'], ['آب', 'Water'],
];

Question _vocabQ(int i) {
  final List<String> v = _pick(_vocab);
  final List<List<String>> o = _vocab.where((x) => x[0] != v[0]).toList()..shuffle(_r);
  if (i.isEven) {
    return Question.mcq('«${v[0]}» به انگلیسی چیست؟', v[1], o.take(3).map((x) => x[1]).toList());
  }
  return Question.mcq('معنی «${v[1]}» چیست؟', v[0], o.take(3).map((x) => x[0]).toList());
}

const List<List<String>> _days = [
  ['Saturday', 'شنبه'], ['Sunday', 'یکشنبه'], ['Monday', 'دوشنبه'], ['Tuesday', 'سه\u200cشنبه'],
  ['Wednesday', 'چهارشنبه'], ['Thursday', 'پنجشنبه'], ['Friday', 'جمعه'],
];

Question _dayQ(int i) {
  if (i % 3 == 2) {
    final int k = _r.nextInt(6);
    final List<String> wr = _days.where((x) => x[0] != _days[k + 1][0]).map((x) => x[0]).toList()..shuffle(_r);
    return Question.mcq('After ${_days[k][0]} comes ...', _days[k + 1][0], wr.take(3).toList());
  }
  final List<String> d = _pick(_days);
  final List<List<String>> o = _days.where((x) => x[0] != d[0]).toList()..shuffle(_r);
  return Question.mcq('«${d[1]}» به انگلیسی چیست؟', d[0], o.take(3).map((x) => x[0]).toList());
}

const List<String> _months = [
  'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'
];

Question _monthQ() {
  final int k = _r.nextInt(11);
  final List<String> wr = _months.where((x) => x != _months[k + 1]).toList()..shuffle(_r);
  return Question.mcq('After ${_months[k]} comes ...', _months[k + 1], wr.take(3).toList());
}

const List<List<String>> _opp = [
  ['big', 'small'], ['hot', 'cold'], ['up', 'down'], ['happy', 'sad'], ['fast', 'slow'],
  ['day', 'night'], ['open', 'close'], ['old', 'new'], ['long', 'short'], ['hard', 'soft'],
];

Question _oppQ() {
  final List<String> p = _pick(_opp);
  final List<String> wr = _opp.where((x) => x[0] != p[0]).map((x) => x[1]).toList()..shuffle(_r);
  return Question.mcq('Opposite of "${p[0]}" ?', p[1], wr.take(3).toList());
}

const List<String> _gram4 = [
  'I ... a student.|am|is|are',
  'He ... a book.|reads|read|reading',
  'They ... happy.|are|is|am',
  'She ... to school every day.|goes|go|going',
  'We ... football.|play|plays|playing',
  'My name ... Ali.|is|am|are',
  'This is ... apple.|an|a|the',
  'There ... three books.|are|is|am',
  'It ... a cat.|is|are|am',
  'You ... my friend.|are|is|am',
];
const List<String> _gram5 = [
  'One book, two ...|books|bookes|book',
  'One child, two ...|children|childs|childes',
  'One man, two ...|men|mans|mens',
  'One foot, two ...|feet|foots|feets',
  'One box, two ...|boxes|boxs|boxies',
  'One tooth, two ...|teeth|tooths|toothes',
  'Yesterday I ... football.|played|play|plays',
  'Yesterday we ... to school.|went|go|goes',
  'She ... an apple yesterday.|ate|eat|eats',
  'He ... a bird last week.|saw|see|sees',
  'How are you?|I am fine, thank you.|I am ten years old.|My name is Ali.',
  'What is your name?|My name is Ali.|I am fine.|I am ten.',
];

List<Lesson> englishLessons(int grade) {
  switch (grade) {
    case 1:
      return [
        ..._letterLessons(),
        genLesson('colors', 'Colors - رنگ\u200cها', '🎨', 8, (int i) => _colorQ(i)),
        genLesson('nums', 'Numbers - عددها', '🔢', 8, (int i) => _numQ(i)),
        genLesson('order', 'ترتیب الفبا', '🔤', 6, (int i) => _afterLetter()),
      ];
    case 2:
      return [
        genLesson('animals', 'Animals', '🐾', 8, (int i) => _picWord(_animals)),
        genLesson('fruits', 'Fruits', '🍎', 8, (int i) => _picWord(_fruits)),
        genLesson('vocab', 'خانواده و مکتب', '🏫', 8, (int i) => _vocabQ(i)),
      ];
    case 3:
      return [
        genLesson('days', 'Days of the week', '📅', 8, (int i) => _dayQ(i)),
        genLesson('months', 'Months', '🗓️', 8, (int i) => _monthQ()),
        genLesson('opp', 'Opposites', '↔️', 8, (int i) => _oppQ()),
        genLesson('vocab3', 'خانواده و مکتب', '🏫', 8, (int i) => _vocabQ(i)),
      ];
    case 4:
      return [
        dslLesson('gram', 'Grammar: am / is / are', '✏️', _gram4, take: 8),
        genLesson('opp4', 'Opposites', '↔️', 8, (int i) => _oppQ()),
        genLesson('vocab4', 'کلمه\u200cهای مکتب', '🏫', 8, (int i) => _vocabQ(i)),
      ];
    default:
      return [
        dslLesson('gram5', 'Plurals and Past', '✏️', _gram5, take: 8),
        dslLesson('gram5b', 'Grammar: am / is / are', '✏️', _gram4, take: 8),
        genLesson('days5', 'Days & Months', '📅', 8, (int i) => i.isEven ? _dayQ(i) : _monthQ()),
      ];
  }
}
