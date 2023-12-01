import 'package:allegro_pdf/src/router.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: AllegroPdfApp()));
}

class AllegroPdfApp extends StatelessWidget {
  const AllegroPdfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AllegroPdf',
      themeMode: ThemeMode.system,
      theme: FlexThemeData.light(scheme: FlexScheme.bahamaBlue),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.bahamaBlue),
      routerConfig: router,
    );
  }
}
