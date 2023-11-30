import 'package:allegro_pdf/src/models/music_sheet.dart';
import 'package:allegro_pdf/src/models/music_sheet_tag.dart';
import 'package:allegro_pdf/src/repository/music_sheet_repository.dart';
import 'package:allegro_pdf/src/ui/widgets/music_sheet_tag_choice_chips.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class MusicSheetDialog extends StatefulWidget {
  final MusicSheet musicSheet;
  final PagingController pagingController;

  final List<MusicSheetTag> availableTags;

  const MusicSheetDialog({
    super.key,
    required this.musicSheet,
    required this.pagingController,
    required this.availableTags,
  });

  @override
  State<MusicSheetDialog> createState() => _MusicSheetDialogState();
}

class _MusicSheetDialogState extends State<MusicSheetDialog> {
  final titleController = TextEditingController();

  @override
  void initState() {
    titleController.text = widget.musicSheet.title;
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Music Sheet'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 50),
          MusicSheetTagChoiceChips(
            availableTags: widget.availableTags,
            selectedTags: widget.musicSheet.tags,
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final updatedMusicSheet = MusicSheet(
              id: widget.musicSheet.id,
              title: titleController.text,
              filePath: widget.musicSheet.filePath,
              tags: widget.musicSheet.tags,
            );
            final repository = MusicSheetRepository();
            await repository.updateMusicSheet(updatedMusicSheet);
            if (context.mounted) {
              widget.pagingController.refresh();
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
