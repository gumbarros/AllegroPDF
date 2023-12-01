import 'package:flutter/material.dart';

class MusicSheetDeleteDialog extends StatelessWidget {
  const MusicSheetDeleteDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirm Deletion"),
      content: const Text("Are you sure you want to delete this music sheet?"),
      actions: <Widget>[
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: const Text("Delete"),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
