import 'dart:async';

import 'package:allegro_pdf/src/models/music_sheet.dart';
import 'package:allegro_pdf/src/repository/repository_base.dart';
import 'package:sqflite/sqflite.dart';

class MusicSheetRepository extends RepositoryBase {
  Future<int> insertMusicSheet(MusicSheet musicSheet) async {
    await openDB();
    int musicSheetId = await db.insert('music_sheets', musicSheet.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    for (var tag in musicSheet.tags) {
      int tagId = await db.insert('tags', tag.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);

      await db.insert('music_tags', {
        'musicSheetId': musicSheetId,
        'tagId': tagId,
      });
    }

    await closeDB();

    return musicSheetId;
  }

  Future<List<MusicSheet>> getAllMusicSheets(int pageKey, int pageSize) async {
    await openDB();

    final int offset = (pageKey - 1) * pageSize;

    final List<Map<String, dynamic>> musicSheetsMaps = await db.query(
      'music_sheets',
      limit: pageSize,
      offset: offset,
    );

    List<MusicSheet> musicSheets = [];

    for (var result in musicSheetsMaps) {
      final map = Map<String, dynamic>.from(result);

      final tagsMaps = await db.rawQuery('''
        SELECT tags.id, tags.title, tags.color
        FROM tags
        INNER JOIN music_tags ON music_tags.tagId = tags.id
        WHERE music_tags.musicSheetId = ${map['id']}
      ''');

      map['tags'] = tagsMaps;

      musicSheets.add(MusicSheet.fromMap(map));
    }

    await closeDB();

    return musicSheets;
  }

  Future updateMusicSheet(MusicSheet musicSheet) async {
    await openDB();

    await db.update(
      'music_sheets',
      musicSheet.toMap(),
      where: 'id = ?',
      whereArgs: [musicSheet.id],
    );

    await db.delete('music_tags',
        where: 'musicSheetId = ?', whereArgs: [musicSheet.id]);

    for (var tag in musicSheet.tags) {
      await db.insert('music_tags', {
        'musicSheetId': musicSheet.id,
        'tagId': tag.id,
      });
    }
    await closeDB();
  }

  Future deleteMusicSheet(int id) async {
    await openDB();

    await db.delete(
      'music_sheets',
      where: 'id = ?',
      whereArgs: [id],
    );

    await closeDB();
  }
}
