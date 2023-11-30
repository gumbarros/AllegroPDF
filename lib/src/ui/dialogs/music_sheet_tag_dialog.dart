import 'package:allegro_pdf/src/models/music_sheet_tag.dart';
import 'package:allegro_pdf/src/repository/music_sheet_tag_repository.dart';
import 'package:allegro_pdf/src/ui/widgets/color_selector.dart';
import 'package:flutter/material.dart';

class MusicSheetTagDialog extends StatefulWidget {
  final MusicSheetTag? tagToEdit;
  final Function callback;
  const MusicSheetTagDialog({Key? key, this.tagToEdit, required this.callback})
      : super(key: key);

  @override
  State<MusicSheetTagDialog> createState() => _MusicSheetTagDialogState();
}

class _MusicSheetTagDialogState extends State<MusicSheetTagDialog> {
  late TextEditingController _titleController;
  late Color _selectedColor;
  bool get isEditing => widget.tagToEdit != null;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.tagToEdit?.title ?? '');
    _selectedColor = Color(widget.tagToEdit?.color ?? 0xFFFFFFFF);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Edit Tag' : 'Add Tag'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
            ),
            ColorSelector(
              selectedColor: _selectedColor,
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final newTag = MusicSheetTag(
              id: isEditing ? widget.tagToEdit!.id : null,
              title: _titleController.text,
              color: _selectedColor.value,
            );

            final repository = MusicSheetTagRepository();

            if (isEditing) {
              repository.updateTag(newTag);
            } else {
              repository.insertTag(newTag);
            }

            widget.callback();

            Navigator.of(context).pop(newTag);
          },
          child: Text(isEditing ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}
