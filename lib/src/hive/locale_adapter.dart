import 'package:flutter/material.dart';
import 'package:hive/hive.dart' show BinaryReader, BinaryWriter, TypeAdapter;

class LocaleAdapter extends TypeAdapter<Locale> {
  @override
  final int typeId = 100;

  @override
  Locale read(BinaryReader reader) {
    final languageCode = reader.readString();
    final countryCode = reader.readString();

    if (countryCode.isNotEmpty) {
      return Locale(languageCode, countryCode);
    } else {
      return Locale(languageCode);
    }
  }

  @override
  void write(BinaryWriter writer, Locale obj) {
    writer.writeString(obj.languageCode);
    writer.writeString(obj.countryCode ?? ''); // Handle null country code
  }
}
