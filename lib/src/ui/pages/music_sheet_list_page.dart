import 'dart:io';

import 'package:allegro_pdf/src/models/music_sheet.dart';
import 'package:allegro_pdf/src/models/music_sheet_tag.dart';
import 'package:allegro_pdf/src/repository/music_sheet_repository.dart';
import 'package:allegro_pdf/src/repository/music_sheet_tag_repository.dart';
import 'package:allegro_pdf/src/ui/dialogs/music_sheet_dialog.dart';
import 'package:allegro_pdf/src/ui/widgets/music_sheet_tag_chip.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:path_provider/path_provider.dart';

class MusicSheetListPage extends StatefulWidget {
  const MusicSheetListPage({super.key});

  @override
  State<MusicSheetListPage> createState() => _MusicSheetListPageState();
}

class _MusicSheetListPageState extends State<MusicSheetListPage> {
  static const _pageSize = 20;

  final PagingController<int, MusicSheet> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Visibility(
          child: FloatingActionButton.extended(
              icon: const Icon(Icons.add),
              label: const Text("Add"),
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf'],
                );

                if (result == null) {
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
                  await repository.insertMusicSheet(
                      MusicSheet(title: r.name, filePath: filePath, tags: []));
                }

                _pagingController.refresh();
              }),
        ),
        appBar: AppBar(
          title: const Text(
            "AllegroPDF",
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
              icon: const Icon(Icons.label),
              tooltip: "Tags",
              onPressed: () async {
                context.go('/tags');
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: "Settings",
              onPressed: () async {},
            )
          ],
        ),
        body: FutureBuilder(
            future: MusicSheetTagRepository().getAllMusicSheetsTags(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                  final availableTags = snapshot.data!;
                  return PagedListView.separated(
                    pagingController: _pagingController,
                    separatorBuilder: (_, __) => const Divider(),
                    builderDelegate: PagedChildBuilderDelegate<MusicSheet>(
                        itemBuilder: (context, musicSheet, index) {
                      return ListTile(
                        title: Row(
                          children: [
                            Text(musicSheet.title),
                            const SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: Wrap(
                                spacing: 4.0,
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.center,
                                runSpacing: 4.0,
                                children: musicSheet.tags.map((tag) {
                                  return MusicSheetTagChip(tag: tag);
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            await showMusicSheetDialog(context,
                                musicSheet: musicSheet,
                                availableTags: availableTags);
                          },
                        ),
                        onTap: () {
                          context.go('/pdf', extra: musicSheet);
                        },
                      );
                    }),
                  );
              }
            }));
  }

  Future<void> showMusicSheetDialog(BuildContext context,
      {required MusicSheet musicSheet,
      required List<MusicSheetTag> availableTags}) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MusicSheetDialog(
          musicSheet: musicSheet,
          availableTags: availableTags,
          pagingController: _pagingController,
        );
      },
    );
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final repository = MusicSheetRepository();

      final newItems = await repository.getAllMusicSheets(pageKey, _pageSize);

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
