import 'package:flutter/material.dart';
import '../models/models.dart';
import 'content_data.dart';
import 'dari_data.dart';
import 'english_data.dart';
import 'math_data.dart';

final List<Subject> kSubjects = <Subject>[
  Subject(id: 'math', title: 'ریاضی', emoji: '🔢', color: const Color(0xFF3D7EF5), dark: const Color(0xFF2658C4), lessonsFor: mathLessons),
  Subject(id: 'dari', title: 'دری', emoji: '📖', color: const Color(0xFFE5484D), dark: const Color(0xFFB02E34), lessonsFor: dariLessons),
  Subject(id: 'pashto', title: 'پښتو', emoji: '🌹', color: const Color(0xFFF28C28), dark: const Color(0xFFC06A10), lessonsFor: pashtoLessons),
  Subject(id: 'science', title: 'علوم', emoji: '🔬', color: const Color(0xFF3BAF5B), dark: const Color(0xFF278040), lessonsFor: scienceLessons),
  Subject(id: 'islam', title: 'دینیات', emoji: '🕌', color: const Color(0xFF12A3A3), dark: const Color(0xFF0B7777), lessonsFor: islamicLessons),
  Subject(id: 'social', title: 'افغانستان من', emoji: '🏔️', color: const Color(0xFF8A5CF6), dark: const Color(0xFF6538CC), lessonsFor: socialLessons),
  Subject(id: 'english', title: 'انگلیسی', emoji: '🔤', color: const Color(0xFFEC5BA0), dark: const Color(0xFFBC3C7D), lessonsFor: englishLessons),
];

Subject subjectById(String id) {
  for (final Subject s in kSubjects) {
    if (s.id == id) return s;
  }
  return kSubjects.first;
}
