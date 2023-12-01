import 'package:allegro_pdf/src/models/music_sheet.dart';
import 'package:allegro_pdf/src/models/music_sheet_tag.dart';
import 'package:allegro_pdf/src/ui/widgets/music_sheet_tag_choice_chips.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

typedef OnSaveCallback = Future Function(
    String title, List<MusicSheetTag> tags);

class MusicSheetDialog extends StatefulWidget {
  final MusicSheet? musicSheet;
  final PagingController pagingController;
  final List<MusicSheetTag> availableTags;
  final String dialogTitle;

  final OnSaveCallback onSaveCallback;

  const MusicSheetDialog(
      {super.key,
      required this.dialogTitle,
      this.musicSheet,
      required this.pagingController,
      required this.availableTags,
      required this.onSaveCallback});

  @override
  State<MusicSheetDialog> createState() => _MusicSheetDialogState();
}

class _MusicSheetDialogState extends State<MusicSheetDialog> {
  final titleController = TextEditingController();

  @override
  void initState() {
    titleController.text = widget.musicSheet?.title ?? '';

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
      title: Text(widget.dialogTitle),
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
            selectedTags: widget.musicSheet?.tags ?? [],
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.onSaveCallback(
                titleController.text, widget.musicSheet?.tags ?? []);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
