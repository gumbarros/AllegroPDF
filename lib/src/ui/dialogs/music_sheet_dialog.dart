import 'package:allegro_pdf/l10n/localization_extension.dart';
import 'package:allegro_pdf/src/models/music_sheet_tag.dart';
import 'package:allegro_pdf/src/ui/widgets/music_sheet_tag_choice_chips.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

typedef OnSaveCallback = Future Function(
    String title, List<MusicSheetTag> tags);

class MusicSheetDialog extends StatefulWidget {
  final String? musicSheetTitle;
  final List<MusicSheetTag>? musicSheetTags;
  final PagingController pagingController;
  final List<MusicSheetTag> availableTags;
  final String dialogTitle;

  final OnSaveCallback onSaveCallback;

  const MusicSheetDialog(
      {super.key,
      this.musicSheetTitle,
      this.musicSheetTags,
      required this.dialogTitle,
      required this.pagingController,
      required this.availableTags,
      required this.onSaveCallback});

  @override
  State<MusicSheetDialog> createState() => _MusicSheetDialogState();
}

class _MusicSheetDialogState extends State<MusicSheetDialog> {
  final titleController = TextEditingController();

  late List<MusicSheetTag> selectedTags;

  @override
  void initState() {
    titleController.text = widget.musicSheetTitle ?? '';
    selectedTags = widget.musicSheetTags ?? [];
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
            decoration: InputDecoration(labelText: context.localization.title),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 50),
          MusicSheetTagChoiceChips(
            availableTags: widget.availableTags,
            selectedTags: selectedTags,
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(context.localization.cancel),
        ),
        TextButton(
          onPressed: () {
            widget.onSaveCallback(titleController.text, selectedTags);
          },
          child: Text(context.localization.save),
        ),
      ],
    );
  }
}
