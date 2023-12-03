import 'package:allegro_pdf/src/models/settings.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:package_info_plus/package_info_plus.dart';

final _settingsBox = Hive.box("settings");

Settings loadSettingsFromBox() {
  final settings = Settings(
      themeMode:
          ThemeMode.values[_settingsBox.get("themeMode", defaultValue: 0)],
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

final buildInfoProvider = FutureProvider<String>((ref) async {
  final info = await PackageInfo.fromPlatform();

  return "${info.appName} - ${info.version}+${info.buildNumber}-${kDebugMode ? "DEBUG" : "RELEASE"}";
});
