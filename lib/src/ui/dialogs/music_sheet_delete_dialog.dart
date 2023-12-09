import 'package:allegro_pdf/l10n/localization_extension.dart';
import 'package:flutter/material.dart';

class MusicSheetDeleteDialog extends StatelessWidget {
  const MusicSheetDeleteDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.localization.confirmDeletion),
      content: Text(context.localization.musicSheetDeletionConfirmation),
      actions: <Widget>[
        TextButton(
          child: Text(context.localization.cancel),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: Text(context.localization.delete),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
