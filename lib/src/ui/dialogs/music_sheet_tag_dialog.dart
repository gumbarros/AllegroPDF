import 'package:allegro_pdf/l10n/localization_extension.dart';
import 'package:allegro_pdf/src/models/music_sheet_tag.dart';
import 'package:allegro_pdf/src/providers/music_sheet_tag_provider.dart';
import 'package:allegro_pdf/src/repository/music_sheet_tag_repository.dart';
import 'package:allegro_pdf/src/ui/widgets/color_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicSheetTagDialog extends ConsumerStatefulWidget {
  final MusicSheetTag? tagToEdit;
  const MusicSheetTagDialog({super.key, this.tagToEdit});

  @override
  ConsumerState<MusicSheetTagDialog> createState() =>
      _MusicSheetTagDialogState();
}

class _MusicSheetTagDialogState extends ConsumerState<MusicSheetTagDialog> {
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
      title: Text(isEditing
          ? context.localization.editTag
          : context.localization.addTag),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: context.localization.title),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 50),
          InputDecorator(
            decoration: InputDecoration(labelText: context.localization.color),
            child: ColorSelector(
              selectedColor: _selectedColor,
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.localization.cancel),
        ),
        TextButton(
          onPressed: () async {
            final newTag = MusicSheetTag(
              id: isEditing ? widget.tagToEdit!.id : null,
              title: _titleController.text,
              color: _selectedColor.value,
            );

            final repository = MusicSheetTagRepository();

            if (isEditing) {
              await repository.updateTag(newTag);
            } else {
              await repository.insertTag(newTag);
            }

            ref.invalidate(musicSheetTagProvider);

            if (context.mounted) {
              Navigator.of(context).pop(newTag);
            }
          },
          child: Text(isEditing
              ? context.localization.update
              : context.localization.add),
        ),
      ],
    );
  }
}
