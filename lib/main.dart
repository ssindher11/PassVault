import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pass_vault/injection.dart';
import 'package:pass_vault/res/color.dart';
import 'package:pass_vault/res/typography.dart';
import 'package:pass_vault/utils/glowless_scroll_behavior.dart';

import 'presentation/pages/home_page.dart';

void main() {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  setupDI();
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
      debugShowCheckedModeBanner: false,
      scrollBehavior: GlowlessScrollBehavior(),
      home: const HomePage(),
      builder: (context, widget) {
        return FutureBuilder(
          future: locator.allReady(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              FlutterNativeSplash.remove();
              return widget ?? Container(color: Colors.white);
            } else {
              return Container(color: Colors.white);
            }
          },
        );
      },
    );
  }
}
