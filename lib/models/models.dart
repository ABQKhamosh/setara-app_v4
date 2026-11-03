import 'dart:math';
import 'package:flutter/material.dart';

final Random appRng = Random();

enum QType { choice, arrange, match }

class Question {
  final QType type;
  final String prompt;
  final String visual;
  final List<String> options;
  final int answer;
  final List<String> tokens;
  final List<String> left;
  final List<String> right;
  final String explain;
  final bool ltr;

  const Question._({
    required this.type,
    required this.prompt,
    this.visual = '',
    this.options = const <String>[],
    this.answer = 0,
    this.tokens = const <String>[],
    this.left = const <String>[],
    this.right = const <String>[],
    this.explain = '',
    this.ltr = false,
  });

  factory Question.mcq(String prompt, String correct, List<String> wrongs,
      {String visual = '', String explain = '', bool ltr = false}) {
    final List<String> opts = <String>[correct];
    for (final String w in wrongs) {
      if (!opts.contains(w) && opts.length < 4) {
        opts.add(w);
      }
    }
    opts.shuffle(appRng);
    return Question._(
        type: QType.choice,
        prompt: prompt,
        visual: visual,
        options: opts,
        answer: opts.indexOf(correct),
        explain: explain,
        ltr: ltr);
  }

  factory Question.arrange(String prompt, List<String> tokens,
      {String visual = '', String explain = '', bool ltr = false}) {
    return Question._(
        type: QType.arrange, prompt: prompt, visual: visual, tokens: tokens, explain: explain, ltr: ltr);
  }

  factory Question.match(String prompt, List<String> left, List<String> right) {
    return Question._(type: QType.match, prompt: prompt, left: left, right: right);
  }

  /// قالب: سوال|جواب درست|غلط۱|غلط۲|غلط۳|~تصویر|!توضیح   (علامت ^ = نیم‌فاصله)
  factory Question.parse(String line) {
    String fix(String s) => s.replaceAll('^', '\u200c');
    final List<String> parts = line.split('|');
    final String prompt = fix(parts[0].trim());
    final String correct = fix(parts[1].trim());
    String visual = '';
    String explain = '';
    final List<String> wrongs = <String>[];
    for (int i = 2; i < parts.length; i++) {
      final String p = parts[i].trim();
      if (p.isEmpty) continue;
      if (p.startsWith('~')) {
        visual = fix(p.substring(1));
      } else if (p.startsWith('!')) {
        explain = fix(p.substring(1));
      } else {
        wrongs.add(fix(p));
      }
    }
    return Question.mcq(prompt, correct, wrongs, visual: visual, explain: explain);
  }
}

class Lesson {
  final String id;
  final String title;
  final String emoji;
  final List<Question> Function() build;
  Lesson(this.id, this.title, this.emoji, this.build);
}

class Subject {
  final String id;
  final String title;
  final String emoji;
  final Color color;
  final Color dark;
  final List<Lesson> Function(int grade) lessonsFor;
  Subject({
    required this.id,
    required this.title,
    required this.emoji,
    required this.color,
    required this.dark,
    required this.lessonsFor,
  });
}

Lesson genLesson(String id, String title, String emoji, int n, Question Function(int i) one) {
  return Lesson(id, title, emoji, () => List<Question>.generate(n, (int i) => one(i)));
}

Lesson dslLesson(String id, String title, String emoji, List<String> lines, {int take = 8}) {
  return Lesson(id, title, emoji, () {
    final List<Question> all = lines.map((String l) => Question.parse(l)).toList();
    all.shuffle(appRng);
    return all.take(take).toList();
  });
}
