import 'package:allegro_pdf/src/models/settings.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';

final _settingsBox = Hive.box("settings");

Settings loadSettingsFromBox() {
  final settings = Settings(
      themeMode:
          ThemeMode.values[_settingsBox.get("themeMode", defaultValue: 0)],
      pdfThemeMode:
          ThemeMode.values[_settingsBox.get("pdfThemeMode", defaultValue: 1)],
      locale: _settingsBox.get("locale", defaultValue: null),
      swipeDirection: PdfSwipeDirection
          .values[_settingsBox.get("pdfSwipeDirection", defaultValue: 0)],
      colorTheme: FlexScheme.values[_settingsBox.get("colorTheme",
          defaultValue: FlexScheme.bahamaBlue.index)]);

  return settings;
}

class SettingsNotifer extends Notifier<Settings> {
  SettingsNotifer() : super();

  void setThemeMode(ThemeMode themeMode) async {
    _settingsBox.put("themeMode", themeMode.index);
    state = state.copyWith(themeMode: themeMode);
  }

  void setPdfThemeMode(ThemeMode themeMode) async {
    _settingsBox.put("pdfThemeMode", themeMode.index);
    state = state.copyWith(pdfThemeMode: themeMode);
  }

  void setLocale(Locale? locale) async {
    _settingsBox.put("locale", locale);
    state = state.copyWith(locale: locale, replaceLocale: true);
  }

  void setColorScheme(FlexScheme colorTheme) async {
    _settingsBox.put("colorTheme", colorTheme.index);
    state = state.copyWith(colorTheme: colorTheme);
  }

  void setSwipeDirection(PdfSwipeDirection pdfSwipeDirection) {
    _settingsBox.put("pdfSwipeDirection", pdfSwipeDirection.index);
    state = state.copyWith(swipeDirection: pdfSwipeDirection);
  }

  @override
  Settings build() {
    return loadSettingsFromBox();
  }
}

final settingsProvider = NotifierProvider<SettingsNotifer, Settings>(() {
  return SettingsNotifer();
});
