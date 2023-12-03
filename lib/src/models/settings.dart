import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

enum PdfSwipeDirection { horizontal, vertical }

@immutable
class Settings {
  final ThemeMode themeMode;
  final FlexScheme colorTheme;
  final PdfSwipeDirection swipeDirection; // New property

  const Settings({
    this.themeMode = ThemeMode.system,
    this.colorTheme = FlexScheme.bahamaBlue,
    this.swipeDirection = PdfSwipeDirection.horizontal, // Default value
  });

  Settings copyWith({
    ThemeMode? themeMode,
    FlexScheme? colorTheme,
    PdfSwipeDirection? swipeDirection, // Include in copyWith method
  }) {
    return Settings(
      themeMode: themeMode ?? this.themeMode,
      colorTheme: colorTheme ?? this.colorTheme,
      swipeDirection: swipeDirection ?? this.swipeDirection,
    );
  }
}
