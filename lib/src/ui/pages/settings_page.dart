import 'package:allegro_pdf/src/models/settings.dart';
import 'package:allegro_pdf/src/providers/settings_provider.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final settings = ref.watch(settingsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Theme'),
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
            title: const Text('Theme Mode'),
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
                    child: Text(mode.toString().split('.').last.capitalize),
                  );
                },
              ).toList(),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.compare_arrows),
            title: const Text('Pdf Swipe Direction'),
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
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: const Text('Developed by Gustavo Mauricio de Barros'),
            onTap: () async {
              await launchUrl(
                  Uri.parse("https://www.github.com/gumbarros/AllegroPdf"));
            },
          ),
        ],
      ),
    );
  }
}
