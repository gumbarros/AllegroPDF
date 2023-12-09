import 'package:allegro_pdf/l10n/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class JumpToPageDialog extends StatefulWidget {
  const JumpToPageDialog({
    super.key,
    required this.pdfControler,
  });

  final PDFViewController pdfControler;

  @override
  State<JumpToPageDialog> createState() => _JumpToPageDialogState();
}

class _JumpToPageDialogState extends State<JumpToPageDialog> {
  final TextEditingController pageController = TextEditingController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.localization.jumpToPage),
      content: TextField(
        controller: pageController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: context.localization.pageNumber),
      ),
      actions: [
        TextButton(
          onPressed: () {
            final enteredPage = int.tryParse(pageController.text);
            if (enteredPage != null && enteredPage > 0) {
              widget.pdfControler.setPage(enteredPage);
              Navigator.pop(context);
            }
          },
          child: Text(context.localization.go),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(context.localization.cancel),
        ),
      ],
    );
  }
}
