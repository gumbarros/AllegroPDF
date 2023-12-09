import 'package:allegro_pdf/l10n/localization_extension.dart';
import 'package:allegro_pdf/src/models/settings.dart';
import 'package:allegro_pdf/src/providers/settings_provider.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final settings = ref.watch(settingsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: Text(AppLocalizations.of(context)!.theme),
            trailing: DropdownButton<FlexScheme>(
              value: settings.colorTheme,
              onChanged: (FlexScheme? colorScheme) {
                ref
                    .read(settingsProvider.notifier)
                    .setColorScheme(colorScheme ?? FlexScheme.bahamaBlue);
              },
              items: FlexScheme.values.map<DropdownMenuItem<FlexScheme>>(
                (FlexScheme mode) {
                  return DropdownMenuItem<FlexScheme>(
                    value: mode,
                    child: Text(mode.toString().split('.').last.capitalize),
                  );
                },
              ).toList(),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.light_mode),
            title: Text(AppLocalizations.of(context)!.themeMode),
            trailing: DropdownButton<ThemeMode>(
              value: settings.themeMode,
              onChanged: (ThemeMode? themeMode) {
                ref
                    .read(settingsProvider.notifier)
                    .setThemeMode(themeMode ?? ThemeMode.system);
              },
              items: ThemeMode.values.map<DropdownMenuItem<ThemeMode>>(
                (ThemeMode mode) {
                  return DropdownMenuItem<ThemeMode>(
                    value: mode,
                    child: Text(_getThemeModeLocalization(mode, context)),
                  );
                },
              ).toList(),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.description),
            title: Text(AppLocalizations.of(context)!.pdfThemeMode),
            trailing: DropdownButton<ThemeMode>(
              value: settings.pdfThemeMode,
              onChanged: (ThemeMode? themeMode) {
                ref
                    .read(settingsProvider.notifier)
                    .setPdfThemeMode(themeMode ?? ThemeMode.system);
              },
              items: ThemeMode.values.map<DropdownMenuItem<ThemeMode>>(
                (ThemeMode mode) {
                  return DropdownMenuItem<ThemeMode>(
                    value: mode,
                    child: Text(_getThemeModeLocalization(mode, context)),
                  );
                },
              ).toList(),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.compare_arrows),
            title: Text(AppLocalizations.of(context)!.pdfSwipeDirection),
            trailing: DropdownButton<PdfSwipeDirection>(
              value: settings.swipeDirection,
              onChanged: (PdfSwipeDirection? swipeDirection) {
                ref.read(settingsProvider.notifier).setSwipeDirection(
                    swipeDirection ?? PdfSwipeDirection.horizontal);
              },
              items: PdfSwipeDirection.values
                  .map<DropdownMenuItem<PdfSwipeDirection>>(
                (PdfSwipeDirection swipeDirection) {
                  return DropdownMenuItem<PdfSwipeDirection>(
                    value: swipeDirection,
                    child: Text(
                        swipeDirection.toString().split('.').last.capitalize),
                  );
                },
              ).toList(),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(AppLocalizations.of(context)!.language),
            trailing: DropdownButton<Locale?>(
              value: ref.watch(settingsProvider).locale,
              onChanged: (Locale? locale) {
                ref.read(settingsProvider.notifier).setLocale(locale);
              },
              items: [
                DropdownMenuItem<Locale?>(
                  value: null,
                  child: Text(
                    context.localization.system,
                  ),
                ),
                ...AppLocalizations.supportedLocales
                    .map<DropdownMenuItem<Locale?>>(
                  (Locale? locale) {
                    return DropdownMenuItem<Locale?>(
                      value: locale,
                      child: Text(
                        locale?.toLanguageTag() ?? context.localization.system,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(AppLocalizations.of(context)!.about),
            subtitle: Text(AppLocalizations.of(context)!.aboutMessage),
            onTap: () async {
              await launchUrl(
                  Uri.parse("https://www.github.com/gumbarros/AllegroPdf"));
            },
          ),
        ],
      ),
    );
  }

  String _getThemeModeLocalization(ThemeMode mode, BuildContext context) {
    switch (mode) {
      case ThemeMode.light:
        return context.localization.light;
      case ThemeMode.dark:
        return context.localization.dark;
      default:
        return context.localization.system;
    }
  }
}
