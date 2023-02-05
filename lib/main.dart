import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pass_vault/res/color.dart';
import 'package:pass_vault/res/typography.dart';
import 'package:pass_vault/utils/glowless_scroll_behavior.dart';

import 'presentation/pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PassVault',
      theme: ThemeData(
        primaryColor: redPrimary,
        textTheme: textTheme,
        colorScheme: ThemeData().colorScheme.copyWith(primary: redPrimary),
      ),
      scrollBehavior: GlowlessScrollBehavior(),
      home: const HomePage(),
    );
  }
}
