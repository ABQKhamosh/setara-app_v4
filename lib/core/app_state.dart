import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  AppState._();
  static final AppState instance = AppState._();

  SharedPreferences? _prefs;
  String name = '';
  int grade = 1;
  int avatar = 0;
  int seeds = 0;
  int streak = 0;
  String lastDay = '';
  String lastSubject = 'math';
  int bestSpeed = 0;
  final Map<String, int> _stars = <String, int>{};

  static const List<String> avatars = ['🦁', '🐰', '🦊', '🐼', '🐯', '🐧', '🦋', '🐬'];
  static const List<int> levelStarts = [0, 10, 30, 60, 100, 150, 210, 280];
  static const List<String> levelNames = [
    'دانهٔ کوچک', 'جوانه', 'نهال', 'درخت جوان', 'درخت دانش', 'شگوفه', 'باغ سرسبز', 'استاد باغ'
  ];
  static const List<String> levelEmojis = ['🌰', '🌱', '🌿', '🌳', '🌸', '🏡', '🏞️', '👑'];

  bool get hasProfile => name.isNotEmpty;
  String get avatarEmoji => avatars[avatar % avatars.length];

  Future<void> load() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    _prefs = p;
    name = p.getString('name') ?? '';
    grade = p.getInt('grade') ?? 1;
    avatar = p.getInt('avatar') ?? 0;
    seeds = p.getInt('seeds') ?? 0;
    streak = p.getInt('streak') ?? 0;
    lastDay = p.getString('lastDay') ?? '';
    lastSubject = p.getString('lastSubject') ?? 'math';
    bestSpeed = p.getInt('bestSpeed') ?? 0;
    _stars.clear();
    final List<String> list = p.getStringList('progress') ?? <String>[];
    for (final String e in list) {
      final int i = e.lastIndexOf('=');
      if (i > 0) {
        _stars[e.substring(0, i)] = int.tryParse(e.substring(i + 1)) ?? 0;
      }
    }
    if (lastDay.isNotEmpty) {
      final DateTime now = DateTime.now();
      final String y = _fmt(now.subtract(const Duration(days: 1)));
      if (lastDay != _fmt(now) && lastDay != y) {
        streak = 0;
      }
    }
  }

  String _fmt(DateTime d) => '${d.year}-${d.month}-${d.day}';

  void _save() {
    final SharedPreferences? p = _prefs;
    if (p == null) return;
    p.setString('name', name);
    p.setInt('grade', grade);
    p.setInt('avatar', avatar);
    p.setInt('seeds', seeds);
    p.setInt('streak', streak);
    p.setString('lastDay', lastDay);
    p.setString('lastSubject', lastSubject);
    p.setInt('bestSpeed', bestSpeed);
    p.setStringList('progress', _stars.entries.map((e) => '${e.key}=${e.value}').toList());
  }

  void saveProfile(String n, int g, int a) {
    name = n.trim();
    grade = g;
    avatar = a;
    _save();
    notifyListeners();
  }

  void setGrade(int g) {
    grade = g;
    _save();
    notifyListeners();
  }

  void setAvatar(int a) {
    avatar = a;
    _save();
    notifyListeners();
  }

  int stars(String key) => _stars[key] ?? 0;

  int doneIn(String prefix) =>
      _stars.entries.where((e) => e.key.startsWith(prefix) && e.value > 0).length;

  int get totalDone => _stars.values.where((v) => v > 0).length;

  void _touchStreak() {
    final DateTime now = DateTime.now();
    final String today = _fmt(now);
    if (lastDay == today) return;
    final String y = _fmt(now.subtract(const Duration(days: 1)));
    streak = (lastDay == y) ? streak + 1 : 1;
    lastDay = today;
  }

  void recordLesson({String? key, required int earned, required String subjectId}) {
    if (key != null) {
      final int old = _stars[key] ?? 0;
      if (earned > old) {
        _stars[key] = earned;
      }
    }
    seeds += earned;
    lastSubject = subjectId;
    _touchStreak();
    _save();
    notifyListeners();
  }

  void addSeeds(int n) {
    seeds += n;
    _touchStreak();
    _save();
    notifyListeners();
  }

  void setBestSpeed(int v) {
    if (v > bestSpeed) {
      bestSpeed = v;
      _save();
      notifyListeners();
    }
  }

  void resetProgress() {
    _stars.clear();
    seeds = 0;
    streak = 0;
    lastDay = '';
    bestSpeed = 0;
    _save();
    notifyListeners();
  }

  int get level {
    int l = 0;
    for (int i = 0; i < levelStarts.length; i++) {
      if (seeds >= levelStarts[i]) l = i;
    }
    return l;
  }

  double get levelProgress {
    final int l = level;
    if (l >= levelStarts.length - 1) return 1.0;
    final int a = levelStarts[l];
    final int b = levelStarts[l + 1];
    return (seeds - a) / (b - a);
  }

  int get seedsToNext {
    final int l = level;
    if (l >= levelStarts.length - 1) return 0;
    return levelStarts[l + 1] - seeds;
  }

  int get unlockedStickers {
    final int n = seeds ~/ 6;
    return n > 24 ? 24 : n;
  }
}
