import 'dart:async';

import 'package:allegro_pdf/src/models/music_sheet.dart';
import 'package:allegro_pdf/src/repository/repository_base.dart';
import 'package:sqflite/sqflite.dart';

class MusicSheetRepository extends RepositoryBase {
  Future<int> insertMusicSheet(MusicSheet musicSheet) async {
    await openDB();
    int musicSheetId = await db.insert('music_sheets', musicSheet.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);

    for (var tag in musicSheet.tags) {
      int tagId = await db.insert('tags', tag.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);

      await db.insert('music_tags', {
        'musicSheetId': musicSheetId,
        'tagId': tagId,
      });
    }

    return musicSheetId;
  }

  Future<List<MusicSheet>> getAllMusicSheets({
    required int pageKey,
    required int pageSize,
    String? titleFilter,
    List<String>? tagsFilter,
    String orderByColumn = "lastOpenedDate",
    String orderByDirection = "DESC",
  }) async {
    await openDB();

    final int offset = pageKey * pageSize;

    String query = 'SELECT * FROM music_sheets';

    List<dynamic> queryArgs = [];

    if (titleFilter != null || (tagsFilter != null && tagsFilter.isNotEmpty)) {
      query += ' WHERE 1=1';
      if (titleFilter != null && titleFilter.isNotEmpty) {
        query += ' AND title LIKE ?';
        queryArgs.add('%$titleFilter%');
      }
      if (tagsFilter != null && tagsFilter.isNotEmpty) {
        query +=
            ' AND id IN (SELECT musicSheetId FROM music_tags WHERE tagId IN (SELECT id FROM tags WHERE title IN (${List.filled(tagsFilter.length, '?').join(', ')})))';
        queryArgs.addAll(tagsFilter);
      }
    }

    query += ' ORDER BY $orderByColumn $orderByDirection';

    query += ' LIMIT ? OFFSET ?';

    queryArgs.addAll([pageSize, offset]);

    final List<Map<String, dynamic>> musicSheetsMaps = await db.rawQuery(
      query,
      queryArgs,
    );

    List<MusicSheet> musicSheets = [];

    for (var result in musicSheetsMaps) {
      final map = Map<String, dynamic>.from(result);

      final tagsMaps = await db.rawQuery('''
      SELECT tags.id, tags.title, tags.color
      FROM tags
      INNER JOIN music_tags ON music_tags.tagId = tags.id
      WHERE music_tags.musicSheetId = ?
    ''', [map['id']]);

      map['tags'] = tagsMaps;

      musicSheets.add(MusicSheet.fromMap(map));
    }

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
  }

  Future deleteMusicSheet(int id) async {
    await openDB();

    await db.delete(
      'music_sheets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
