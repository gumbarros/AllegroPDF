import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class RepositoryBase {
  @protected
  late Database db;

  /// Opens the database.
  Future<void> openDB() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'allegro_pdf.db'),
      onCreate: (db, version) async {
        // Create tables on database creation.
        await db.execute(
          'CREATE TABLE music_sheets(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, filePath TEXT UNIQUE)',
        );

        await db.execute(
          'CREATE TABLE tags(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, color INTEGER)',
        );

        await db.execute(
          'CREATE TABLE music_tags(musicSheetId INTEGER, tagId INTEGER, FOREIGN KEY(musicSheetId) REFERENCES music_sheets(id), FOREIGN KEY(tagId) REFERENCES tags(id), PRIMARY KEY(musicSheetId, tagId))',
        );
      },
      version: 1,
    );
  }

  Future<void> closeDB() async {
    await db.close();
  }
}
