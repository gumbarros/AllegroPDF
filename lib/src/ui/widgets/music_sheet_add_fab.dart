import 'dart:io';

import 'package:allegro_pdf/src/models/music_sheet.dart';
import 'package:allegro_pdf/src/repository/music_sheet_repository.dart';
import 'package:allegro_pdf/src/ui/dialogs/loading_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:path_provider/path_provider.dart';

class MusicSheetAddFab extends StatelessWidget {
  const MusicSheetAddFab({
    super.key,
    required PagingController<int, MusicSheet> pagingController,
  }) : _pagingController = pagingController;

  final PagingController<int, MusicSheet> _pagingController;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Add"),
        onPressed: () async {
          await showLoadingDialog(context, message: "Adding sheet musics...");

          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowMultiple: true,
            allowedExtensions: ['pdf'],
          );

          if (result == null) {
            if (context.mounted) {
              context.pop();
            }
            return;
          }

          final repository = MusicSheetRepository();
          final Directory appDocumentsDir =
              await getApplicationDocumentsDirectory();

          for (final r in result.files) {
            final fileName = r.name;
            String filePath = '${appDocumentsDir.path}/$fileName';

            File file = File(r.path!);
            await file.copy(filePath);
            await repository.insertMusicSheet(MusicSheet(
                title: r.name.replaceAll('.pdf', ''),
                lastOpenedDate: null,
                filePath: filePath,
                tags: []));
          }

          if (context.mounted) {
            context.pop();
          }

          _pagingController.refresh();
        });
  }
}
