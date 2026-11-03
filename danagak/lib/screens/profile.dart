import 'package:flutter/material.dart';
import '../core/app_state.dart';
import '../core/fa.dart';
import '../core/theme.dart';
import '../widgets/common.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _about(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext c) => AlertDialog(
        title: const Text('دربارهٔ داناگک'),
        content: const Text(
          'داناگک، برنامهٔ آموزشی برای کودکان صنف اول تا پنجم است.\n\n'
          'این برنامه به اینترنت نیاز ندارد، تبلیغات ندارد و هیچ اطلاعاتی از کودک جمع یا ارسال نمی\u200cکند. '
          'پیشرفت فقط روی همین دستگاه ذخیره می\u200cشود.\n\n'
          'داناگک کمک آموزشی است و جای مکتب و معلم را نمی\u200cگیرد.\n\n'
          'نسخهٔ ۲٫۰',
          style: TextStyle(height: 1.6),
        ),
        actions: [TextButton(onPressed: () => Navigator.of(c).pop(), child: const Text('بسیار خوب'))],
      ),
    );
  }

  Future<void> _reset(BuildContext context) async {
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (BuildContext c) => AlertDialog(
        title: const Text('پاک کردن پیشرفت؟'),
        content: const Text('همهٔ دانه\u200cها و درس\u200cهای تمام\u200cشده پاک می\u200cشود. مطمئنی؟'),
        actions: [
          TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('نه')),
          TextButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('بلی، پاک کن')),
        ],
      ),
    );
    if (ok == true) AppState.instance.resetProgress();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (BuildContext context, Widget? child) {
        final AppState s = AppState.instance;
        return ListView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
          children: [
            Center(
              child: Container(
                width: 100,
                height: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.anar, width: 4),
                ),
                child: Text(s.avatarEmoji, style: const TextStyle(fontSize: 54)),
              ),
            ),
            const SizedBox(height: 10),
            Center(child: Text(s.name, style: Txt.h1)),
            Center(child: Text('صنف ${faDigits(s.grade)}', style: Txt.small.copyWith(fontSize: 15))),
            const SizedBox(height: 20),
            const Text('صنف من', style: Txt.h2),
            const SizedBox(height: 8),
            Row(
              children: [
                for (int g = 1; g <= 5; g++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Tappable(
                        onTap: () => AppState.instance.setGrade(g),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: s.grade == g ? AppColors.anar : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: s.grade == g ? AppColors.anarDark : AppColors.line, width: 2),
                          ),
                          child: Text(faDigits(g),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: s.grade == g ? Colors.white : AppColors.ink)),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            const Text('دوست من', style: Txt.h2),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (int a = 0; a < AppState.avatars.length; a++)
                  Tappable(
                    onTap: () => AppState.instance.setAvatar(a),
                    child: Container(
                      width: 56,
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: s.avatar == a ? AppColors.anarLight : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: s.avatar == a ? AppColors.anar : AppColors.line, width: 3),
                      ),
                      child: Text(AppState.avatars[a], style: const TextStyle(fontSize: 28)),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1CC),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                'نکته برای والدین: روزی ۱۵ تا ۲۰ دقیقه برای کودکان این سن کافی است. '
                'بعد از هر درس از او بخواهید چیزی که یاد گرفت برایتان بگوید.',
                style: Txt.body,
              ),
            ),
            const SizedBox(height: 16),
            ChunkyButton(
              label: 'دربارهٔ داناگک',
              color: Colors.white,
              shadow: AppColors.line,
              textColor: AppColors.ink,
              height: 50,
              onTap: () => _about(context),
            ),
            const SizedBox(height: 8),
            ChunkyButton(
              label: 'پاک کردن پیشرفت',
              color: Colors.white,
              shadow: AppColors.line,
              textColor: AppColors.anarDark,
              height: 50,
              onTap: () => _reset(context),
            ),
          ],
        );
      },
    );
  }
}
