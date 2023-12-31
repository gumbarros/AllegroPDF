import 'package:allegro_pdf/src/hive/locale_adapter.dart';
import 'package:allegro_pdf/src/providers/settings_provider.dart';
import 'package:allegro_pdf/src/router.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> ensureInitialized() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(LocaleAdapter());
  await Hive.openBox('settings');
}

Future<void> main() async {
  await ensureInitialized();
  runApp(const ProviderScope(child: AllegroPdfApp()));
}

class AllegroPdfApp extends ConsumerWidget {
  const AllegroPdfApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final colorTheme = ref.watch(settingsProvider).colorTheme;

    return MaterialApp.router(
      title: 'AllegroPDF',
      themeMode: ref.watch(settingsProvider).themeMode,
      theme: FlexThemeData.light(scheme: colorTheme),
      debugShowCheckedModeBanner: false,
      locale: ref.watch(settingsProvider).locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      darkTheme: FlexThemeData.dark(scheme: colorTheme),
      routerConfig: router,
    );
  }
}
