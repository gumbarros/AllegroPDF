import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

enum PdfSwipeDirection { horizontal, vertical }

@immutable
class Settings {
  final ThemeMode themeMode;
  final ThemeMode pdfThemeMode;
  final FlexScheme colorTheme;
  final PdfSwipeDirection swipeDirection;

  final Locale? locale;
  const Settings({
    this.themeMode = ThemeMode.system,
    this.pdfThemeMode = ThemeMode.light,
    this.locale,
    this.colorTheme = FlexScheme.bahamaBlue,
    this.swipeDirection = PdfSwipeDirection.horizontal,
  });

  Settings copyWith({
    ThemeMode? themeMode,
    ThemeMode? pdfThemeMode,
    FlexScheme? colorTheme,
    Locale? locale,
    bool replaceLocale = false,
    PdfSwipeDirection? swipeDirection,
  }) {
    return Settings(
      themeMode: themeMode ?? this.themeMode,
      pdfThemeMode: pdfThemeMode ?? this.pdfThemeMode,
      locale: replaceLocale ? locale : locale ?? this.locale,
      colorTheme: colorTheme ?? this.colorTheme,
      swipeDirection: swipeDirection ?? this.swipeDirection,
    );
  }
}
