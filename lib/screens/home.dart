import 'package:flutter/material.dart';
import '../core/app_state.dart';
import '../core/fa.dart';
import '../core/theme.dart';
import '../data/subjects.dart';
import '../models/models.dart';
import '../widgets/common.dart';
import '../widgets/mascot.dart';
import 'subject_path.dart';

const List<String> _messages = [
  'امروز یک درس تازه یاد بگیریم؟',
  'هر روز یک قدم، هر قدم یک دانه!',
  'تو می\u200cتوانی! بیا شروع کنیم.',
  'دانه\u200cدانه دانا می\u200cشویم!',
  'اشتباه کردن بد نیست، یاد گرفتن خوب است.',
  'بیا باغ دانش را بزرگ\u200cتر کنیم!',
  'یک بازی هم فراموش نشود!',
];

void openSubject(BuildContext context, Subject subject) {
  Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext c) => SubjectPathScreen(subject: subject)));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (BuildContext context, Widget? child) {
        final AppState s = AppState.instance;
        final String msg = _messages[DateTime.now().day % _messages.length];
        return ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.line, width: 2),
                  ),
                  child: Text(s.avatarEmoji, style: const TextStyle(fontSize: 30)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('سلام، ${s.name}!', style: Txt.h2, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text('صنف ${faDigits(s.grade)}', style: Txt.small),
                    ],
                  ),
                ),
                StatChip(
                  icon: const Text('🔥', style: TextStyle(fontSize: 16)),
                  text: faDigits(s.streak),
                  bg: const Color(0xFFFFEBD0),
                  fg: const Color(0xFFB45F06),
                ),
                const SizedBox(width: 8),
                StatChip(
                  icon: const SeedIcon(size: 16),
                  text: faDigits(s.seeds),
                  bg: const Color(0xFFFFF1CC),
                  fg: const Color(0xFF8A5A00),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Color(0xFFFFE9C7), Color(0xFFFFD6DC)],
                ),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: AppColors.line, width: 2),
              ),
              child: Row(
                children: [
                  const DanagakMascot(size: 104),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SpeechBubble(text: msg),
                        const SizedBox(height: 12),
                        ChunkyButton(
                          label: 'ادامه بده',
                          height: 48,
                          fontSize: 17,
                          onTap: () => openSubject(context, subjectById(s.lastSubject)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.line, width: 2),
              ),
              child: Row(
                children: [
                  Text(AppState.levelEmojis[s.level], style: const TextStyle(fontSize: 40)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('باغ دانش: ${AppState.levelNames[s.level]}', style: Txt.h2),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: s.levelProgress,
                            minHeight: 12,
                            backgroundColor: AppColors.anarLight,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.anar),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          s.seedsToNext == 0 ? 'به بالاترین مرحله رسیدی! 👑' : '${faDigits(s.seedsToNext)} دانهٔ دیگر تا مرحلهٔ بعد',
                          style: Txt.small,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text('درس\u200cها', style: Txt.h1),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.92,
              children: [
                for (final Subject sub in kSubjects) _SubjectCard(subject: sub, grade: s.grade),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final Subject subject;
  final int grade;
  const _SubjectCard({required this.subject, required this.grade});

  @override
  Widget build(BuildContext context) {
    final int total = subject.lessonsFor(grade).length;
    final int done = AppState.instance.doneIn('${subject.id}_g${grade}_');
    return Tappable(
      onTap: () => openSubject(context, subject),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: subject.color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: subject.dark, offset: const Offset(0, 6))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 58,
              height: 58,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.white.withAlpha(60), shape: BoxShape.circle),
              child: Text(subject.emoji, style: const TextStyle(fontSize: 32)),
            ),
            const Spacer(),
            Text(subject.title,
                style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: Colors.white)),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : done / total,
                minHeight: 8,
                backgroundColor: Colors.white.withAlpha(70),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(height: 4),
            Text('${faDigits(done)} از ${faDigits(total)} درس',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white.withAlpha(230))),
          ],
        ),
      ),
    );
  }
}
