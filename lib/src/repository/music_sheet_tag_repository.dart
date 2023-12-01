import 'package:allegro_pdf/src/models/music_sheet_tag.dart';
import 'package:allegro_pdf/src/repository/repository_base.dart';
import 'package:sqflite/sql.dart';

class MusicSheetTagRepository extends RepositoryBase {
  Future<int> insertTag(MusicSheetTag newTag) async {
    await openDB();

    int tagId = await db.insert('tags', newTag.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return tagId;
  }

  Future<List<MusicSheetTag>> getAllMusicSheetsTags() async {
    await openDB();

    final List<Map<String, dynamic>> maps = await db.query('tags');

    List<MusicSheetTag> tags = [];

    for (var tag in maps) {
      tags.add(MusicSheetTag.fromMap(tag));
    }
    return tags;
  }

  Future updateTag(MusicSheetTag tag) async {
    await openDB();
    await db.update(
      'tags',
      tag.toMap(),
      where: 'id = ?',
      whereArgs: [tag.id],
    );
  }

  Future deleteTag(int id) async {
    await openDB();
    await db.delete(
      'tags',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
