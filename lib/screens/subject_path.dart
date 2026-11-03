import 'package:flutter/material.dart';
import '../core/app_state.dart';
import '../core/fa.dart';
import '../core/theme.dart';
import '../models/models.dart';
import '../widgets/common.dart';
import 'lesson_player.dart';

class SubjectPathScreen extends StatelessWidget {
  final Subject subject;
  const SubjectPathScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (BuildContext context, Widget? child) {
        final AppState s = AppState.instance;
        final List<Lesson> lessons = subject.lessonsFor(s.grade);
        final String prefix = '${subject.id}_g${s.grade}_';
        final int done = s.doneIn(prefix);
        const List<double> offsets = [0.0, -0.5, 0.0, 0.5];
        return Scaffold(
          body: Column(
            children: [
              Container(
                width: double.infinity,
                color: subject.color,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          RoundIconButton(
                            icon: Icons.arrow_forward_rounded,
                            onTap: () => Navigator.of(context).pop(),
                            bg: Colors.white.withAlpha(60),
                            fg: Colors.white,
                          ),
                          const SizedBox(width: 12),
                          Text(subject.emoji, style: const TextStyle(fontSize: 28)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(subject.title,
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
                          ),
                          StatChip(
                            icon: const SeedIcon(size: 16),
                            text: faDigits(s.seeds),
                            bg: Colors.white,
                            fg: const Color(0xFF8A5A00),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text('صنف ${faDigits(s.grade)}، ${faDigits(done)} از ${faDigits(lessons.length)} درس تمام شد',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white.withAlpha(230))),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
                  itemCount: lessons.length,
                  itemBuilder: (BuildContext context, int i) {
                    final Lesson lesson = lessons[i];
                    final String key = '$prefix${lesson.id}';
                    final int st = s.stars(key);
                    final bool unlocked = i == 0 || s.stars('$prefix${lessons[i - 1].id}') > 0;
                    final bool current = unlocked && st == 0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 26),
                      child: Align(
                        alignment: Alignment(offsets[i % 4], 0),
                        child: _LessonNode(
                          lesson: lesson,
                          stars: st,
                          unlocked: unlocked,
                          current: current,
                          subject: subject,
                          onTap: () {
                            if (!unlocked) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('اول درس قبلی را تمام کن 🔒')),
                              );
                              return;
                            }
                            Navigator.of(context).push(MaterialPageRoute<void>(
                              builder: (BuildContext c) => LessonPlayer(
                                title: lesson.title,
                                color: subject.color,
                                dark: subject.dark,
                                subjectId: subject.id,
                                progressKey: key,
                                build: lesson.build,
                              ),
                            ));
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LessonNode extends StatelessWidget {
  final Lesson lesson;
  final int stars;
  final bool unlocked;
  final bool current;
  final Subject subject;
  final VoidCallback onTap;
  const _LessonNode({
    required this.lesson,
    required this.stars,
    required this.unlocked,
    required this.current,
    required this.subject,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = !unlocked ? const Color(0xFFD8D1C4) : (stars > 0 ? subject.color : Colors.white);
    final Color shadow = !unlocked ? const Color(0xFFB9B1A2) : (stars > 0 ? subject.dark : AppColors.line);
    return SizedBox(
      width: 150,
      child: Column(
        children: [
          if (current)
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(12)),
              child: const Text('شروع!', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppColors.ink)),
            ),
          Tappable(
            onTap: onTap,
            child: Container(
              width: 88,
              height: 88,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: bg,
                shape: BoxShape.circle,
                border: Border.all(color: current ? subject.color : Colors.white, width: 4),
                boxShadow: [BoxShadow(color: shadow, offset: const Offset(0, 6))],
              ),
              child: Text(unlocked ? lesson.emoji : '🔒', style: const TextStyle(fontSize: 38)),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int k = 0; k < 3; k++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(Icons.circle, size: 11, color: k < stars ? AppColors.anar : AppColors.line),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(lesson.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.ink, height: 1.3)),
        ],
      ),
    );
  }
}
