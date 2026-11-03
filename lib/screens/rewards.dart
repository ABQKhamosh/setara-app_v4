import 'package:flutter/material.dart';
import '../core/app_state.dart';
import '../core/fa.dart';
import '../core/theme.dart';
import '../widgets/common.dart';

const List<String> _stickers = [
  '🦁', '🐘', '🦊', '🐰', '🐼', '🦒', '🐯', '🐬', '🦋', '🐢', '🐧', '🐝',
  '🐞', '🌈', '🚀', '⚽', '🎨', '🎸', '🏔️', '🌺', '🍉', '🍇', '🏆', '👑',
];

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (BuildContext context, Widget? child) {
        final AppState s = AppState.instance;
        final int unlocked = s.unlockedStickers;
        return ListView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
          children: [
            const Text('جایزه\u200cها', style: Txt.h1),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Color(0xFFFFE9C7), Color(0xFFFFD6DC)],
                ),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: AppColors.line, width: 2),
              ),
              child: Column(
                children: [
                  Text(AppState.levelEmojis[s.level], style: const TextStyle(fontSize: 64)),
                  Text(AppState.levelNames[s.level], style: Txt.h1),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: s.levelProgress,
                      minHeight: 14,
                      backgroundColor: Colors.white,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.anar),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(s.seedsToNext == 0 ? 'بالاترین مرحله! 👑' : '${faDigits(s.seedsToNext)} دانه تا مرحلهٔ بعد', style: Txt.small),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _stat('🍎', 'درس', faDigits(s.totalDone)),
                const SizedBox(width: 10),
                _stat('🔥', 'روز پیاپی', faDigits(s.streak)),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.line, width: 2),
                    ),
                    child: Column(
                      children: [
                        const SeedIcon(size: 24),
                        const SizedBox(height: 4),
                        Text(faDigits(s.seeds), style: Txt.h2),
                        const Text('دانه', style: Txt.small),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('برچسب\u200cها (${faDigits(unlocked)} از ${faDigits(_stickers.length)})', style: Txt.h2),
            const SizedBox(height: 4),
            const Text('با هر ۶ دانه یک برچسب تازه باز می\u200cشود.', style: Txt.small),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                for (int i = 0; i < _stickers.length; i++)
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: i < unlocked ? Colors.white : const Color(0xFFEFE8DA),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: i < unlocked ? AppColors.gold : AppColors.line, width: 2.5),
                    ),
                    child: i < unlocked
                        ? Text(_stickers[i], style: const TextStyle(fontSize: 38))
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('🔒', style: TextStyle(fontSize: 22)),
                              Text(faDigits((i + 1) * 6), style: Txt.small),
                            ],
                          ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _stat(String emoji, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.line, width: 2),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(value, style: Txt.h2),
            Text(label, style: Txt.small),
          ],
        ),
      ),
    );
  }
}
