import 'package:allegro_pdf/src/repository/music_sheet_tag_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final musicSheetTagProvider = FutureProvider.autoDispose((ref) async {
  final repository = MusicSheetTagRepository();

  return await repository.getAllMusicSheetsTags();
});
