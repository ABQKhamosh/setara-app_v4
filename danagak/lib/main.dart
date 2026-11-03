import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/app_state.dart';
import 'core/theme.dart';
import 'screens/root.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await AppState.instance.load();
  runApp(const DanagakApp());
}

class DanagakApp extends StatelessWidget {
  const DanagakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'داناگک',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      builder: (BuildContext context, Widget? child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const RootGate(),
    );
  }
}
