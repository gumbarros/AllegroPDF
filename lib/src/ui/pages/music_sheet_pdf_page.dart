import 'package:allegro_pdf/src/models/music_sheet.dart';
import 'package:allegro_pdf/src/models/settings.dart';
import 'package:allegro_pdf/src/providers/settings_provider.dart';
import 'package:allegro_pdf/src/ui/dialogs/jump_to_page_dialog.dart';
import 'package:allegro_pdf/src/ui/widgets/sliding_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicSheetPdfPage extends StatefulWidget {
  final MusicSheet musicSheet;

  const MusicSheetPdfPage({Key? key, required this.musicSheet})
      : super(key: key);

  @override
  State<MusicSheetPdfPage> createState() => _MusicSheetPdfPageState();
}

class _MusicSheetPdfPageState extends State<MusicSheetPdfPage>
    with SingleTickerProviderStateMixin {
  late final PDFViewController controller;
  late final AnimationController animationController;

  bool appBarVisible = true;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SlidingWidget(
        controller: animationController,
        visible: appBarVisible,
        child: AppBar(
          title: Text(
            widget.musicSheet.title,
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
              icon: const Icon(Icons.search_outlined),
              onPressed: () async => await _showJumpToPageDialog(context),
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTapDown: (_) {},
        child: Consumer(
          builder: (context, ref, _) {
            return PDFView(
              filePath: widget.musicSheet.filePath,
              swipeHorizontal: ref.watch(settingsProvider).swipeDirection ==
                  PdfSwipeDirection.horizontal,
              gestureRecognizers: {}
                ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()
                  ..onTapDown = (details) async {
                    final RenderBox box =
                        context.findRenderObject() as RenderBox;
                    final tapPosition =
                        box.globalToLocal(details.globalPosition);

                    final screenWidth = MediaQuery.of(context).size.width;
                    final currentPage = await controller.getCurrentPage() ?? 1;

                    final exclusionThreshold = screenWidth / 4;

                    if (tapPosition.dx < screenWidth / 2 - exclusionThreshold) {
                      await controller.setPage(currentPage - 1);
                    } else if (tapPosition.dx >
                        screenWidth / 2 + exclusionThreshold) {
                      await controller.setPage(currentPage + 1);
                    }
                  })),
              onViewCreated: (pdfController) {
                controller = pdfController;
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(appBarVisible ? Icons.fullscreen : Icons.fullscreen_exit),
        onPressed: () => setState(() => appBarVisible = !appBarVisible),
      ),
    );
  }

  Future _showJumpToPageDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return JumpToPageDialog(pdfControler: controller);
      },
    );
  }
}
