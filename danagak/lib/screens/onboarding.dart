import 'package:flutter/material.dart';
import '../core/app_state.dart';
import '../core/fa.dart';
import '../core/theme.dart';
import '../widgets/common.dart';
import '../widgets/mascot.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;
  final TextEditingController _ctrl = TextEditingController();
  int _grade = 1;
  int _avatar = 0;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < 3) {
      setState(() => _step++);
    } else {
      AppState.instance.saveProfile(_ctrl.text, _grade, _avatar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
          child: Column(
            children: [
              SizedBox(
                height: 44,
                child: Row(
                  children: [
                    if (_step > 0)
                      RoundIconButton(
                        icon: Icons.arrow_forward_rounded,
                        onTap: () => setState(() => _step--),
                      ),
                    const Spacer(),
                    Row(
                      children: [
                        for (int i = 0; i < 4; i++)
                          Container(
                            width: i == _step ? 22 : 10,
                            height: 10,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color: i <= _step ? AppColors.anar : AppColors.line,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: KeyedSubtree(key: ValueKey<int>(_step), child: _stepBody()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepBody() {
    switch (_step) {
      case 0:
        return _page(
          mood: MascotMood.cheer,
          title: 'سلام! من داناگک هستم 👋',
          sub: 'من با تو درس می\u200cخوانم و بازی می\u200cکنیم.\nدانه\u200cدانه، دانا می\u200cشویم!',
          child: const SizedBox.shrink(),
          button: 'بیا شروع کنیم',
          enabled: true,
        );
      case 1:
        return _page(
          mood: MascotMood.think,
          title: 'اسم تو چیست؟',
          sub: 'می\u200cخواهم تو را با اسمت صدا کنم.',
          child: TextField(
            controller: _ctrl,
            textAlign: TextAlign.center,
            maxLength: 16,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
            decoration: InputDecoration(
              hintText: 'نام تو',
              counterText: '',
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: AppColors.line, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: AppColors.anar, width: 2.5),
              ),
            ),
            onChanged: (String v) => setState(() {}),
          ),
          button: 'ادامه',
          enabled: _ctrl.text.trim().length >= 2,
        );
      case 2:
        return _page(
          mood: MascotMood.happy,
          title: 'در کدام صنف هستی؟',
          sub: 'درس\u200cها مطابق صنف تو آماده می\u200cشوند.',
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              for (int g = 1; g <= 5; g++)
                Tappable(
                  onTap: () => setState(() => _grade = g),
                  child: Container(
                    width: 92,
                    height: 76,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _grade == g ? AppColors.anar : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: _grade == g ? AppColors.anarDark : AppColors.line, width: 2.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(faDigits(g),
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: _grade == g ? Colors.white : AppColors.ink)),
                        Text('صنف',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: _grade == g ? Colors.white : AppColors.inkSoft)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          button: 'ادامه',
          enabled: true,
        );
      default:
        return _page(
          mood: MascotMood.cheer,
          title: 'یک دوست انتخاب کن',
          sub: 'او در سفر یادگیری همراه تو است.',
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              for (int a = 0; a < AppState.avatars.length; a++)
                Tappable(
                  onTap: () => setState(() => _avatar = a),
                  child: Container(
                    width: 70,
                    height: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _avatar == a ? AppColors.anarLight : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: _avatar == a ? AppColors.anar : AppColors.line, width: 3),
                    ),
                    child: Text(AppState.avatars[a], style: const TextStyle(fontSize: 36)),
                  ),
                ),
            ],
          ),
          button: 'شروع یادگیری',
          enabled: true,
        );
    }
  }

  Widget _page({
    required MascotMood mood,
    required String title,
    required String sub,
    required Widget child,
    required String button,
    required bool enabled,
  }) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 8),
                DanagakMascot(size: _step == 0 ? 190 : 130, mood: mood),
                const SizedBox(height: 12),
                Text(title, textAlign: TextAlign.center, style: Txt.h1),
                const SizedBox(height: 8),
                Text(sub, textAlign: TextAlign.center, style: Txt.small.copyWith(fontSize: 15)),
                const SizedBox(height: 22),
                child,
              ],
            ),
          ),
        ),
        ChunkyButton(label: button, onTap: enabled ? _next : null),
      ],
    );
  }
}
