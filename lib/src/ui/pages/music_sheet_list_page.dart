import 'package:allegro_pdf/l10n/localization_extension.dart';
import 'package:allegro_pdf/src/models/music_sheet.dart';
import 'package:allegro_pdf/src/models/music_sheet_tag.dart';
import 'package:allegro_pdf/src/providers/music_sheet_tag_provider.dart';
import 'package:allegro_pdf/src/repository/music_sheet_repository.dart';
import 'package:allegro_pdf/src/ui/dialogs/music_sheet_delete_dialog.dart';
import 'package:allegro_pdf/src/ui/dialogs/music_sheet_dialog.dart';
import 'package:allegro_pdf/src/ui/dialogs/order_by_dialog.dart';
import 'package:allegro_pdf/src/ui/widgets/music_sheet_add_fab.dart';
import 'package:allegro_pdf/src/ui/widgets/music_sheet_tag_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class MusicSheetListPage extends ConsumerStatefulWidget {
  const MusicSheetListPage({super.key});

  @override
  ConsumerState<MusicSheetListPage> createState() => _MusicSheetListPageState();
}

class _MusicSheetListPageState extends ConsumerState<MusicSheetListPage> {
  static const _pageSize = 20;

  final PagingController<int, MusicSheet> _pagingController =
      PagingController(firstPageKey: 0);

  String? titleFilter;
  List<MusicSheetTag> tagsFilter = [];

  bool get isFilterApplied =>
      (titleFilter != null && titleFilter!.isNotEmpty) || tagsFilter.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final tagsState = ref.watch(musicSheetTagProvider);

    return Scaffold(
        floatingActionButton: Visibility(
          child: MusicSheetAddFab(pagingController: _pagingController),
        ),
        appBar: AppBar(
          title: const Text(
            "AllegroPDF",
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            Visibility(
              visible: tagsState.hasValue,
              child: IconButton(
                icon: const Icon(Icons.filter_alt),
                tooltip: AppLocalizations.of(context)!.filters,
                onPressed: () {
                  _showFilterDialog(context, availableTags: tagsState.value!);
                },
              ),
            ),
            Visibility(
              visible: tagsState.hasValue,
              child: IconButton(
                icon: const Icon(Icons.sort),
                tooltip: AppLocalizations.of(context)!.sort,
                onPressed: () {
                  _showOrderByDialog(context);
                },
              ),
            ),
            IconButton(
                icon: const Icon(Icons.label),
                tooltip: "Tags",
                onPressed: () async {
                  context.go('/tags', extra: _pagingController);
                }),
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: AppLocalizations.of(context)!.settings,
              onPressed: () async {
                context.go('/settings');
              },
            )
          ],
        ),
        body: tagsState.when(
            data: (availableTags) {
              return PagedListView.separated(
                pagingController: _pagingController,
                separatorBuilder: (_, __) => const Divider(),
                builderDelegate: PagedChildBuilderDelegate<MusicSheet>(
                    noItemsFoundIndicatorBuilder: (context) {
                  final message = isFilterApplied
                      ? AppLocalizations.of(context)!.filterMessage
                      : AppLocalizations.of(context)!.welcome;
                  return Center(
                      child: Text(
                    message,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ));
                }, itemBuilder: (context, musicSheet, index) {
                  return ListTile(
                    title: Text(musicSheet.title),
                    leading: const Icon(Icons.music_note_rounded),
                    subtitle: Container(
                      margin: const EdgeInsets.only(top: 4.0),
                      child: Wrap(
                        spacing: 4.0,
                        direction: Axis.horizontal,
                        runSpacing: 4.0,
                        children: musicSheet.tags.map((tag) {
                          return MusicSheetTagChip(tag: tag);
                        }).toList(),
                      ),
                    ),
                    trailing: Wrap(
                      alignment: WrapAlignment.end,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            await _showEditDialog(context,
                                musicSheet: musicSheet,
                                availableTags: availableTags);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            bool confirmDelete = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const MusicSheetDeleteDialog();
                              },
                            );

                            if (confirmDelete) {
                              final repository = MusicSheetRepository();
                              await repository.deleteMusicSheet(musicSheet.id!);
                              if (context.mounted) {
                                _pagingController.refresh();
                              }
                            }
                          },
                        )
                      ],
                    ),
                    onTap: () async {
                      musicSheet.lastOpenedDate = DateTime.now();

                      final repository = MusicSheetRepository();

                      await repository.updateMusicSheet(musicSheet);

                      _pagingController.refresh();

                      if (context.mounted) {
                        context.go('/pdf', extra: musicSheet);
                      }
                    },
                  );
                }),
              );
            },
            error: (error, _) => Center(child: Text('Error: $error')),
            loading: () => const Center(child: CircularProgressIndicator())));
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final repository = MusicSheetRepository();

      final newItems = await repository.getAllMusicSheets(
          pageKey: (pageKey / 20).truncate(),
          pageSize: _pageSize,
          titleFilter: titleFilter,
          orderByColumn: ref.read(orderByColumnProvider),
          orderByDirection: ref.read(orderByDirectionProvider),
          tagsFilter: tagsFilter.map((t) => t.title).toList());

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

  Future _showOrderByDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return const OrderByDialog();
        });

    _pagingController.refresh();
  }

  Future<void> _showFilterDialog(BuildContext context,
      {required List<MusicSheetTag> availableTags}) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MusicSheetDialog(
            dialogTitle: context.localization.filters,
            onSaveCallback: (title, tags) async {
              titleFilter = title;
              tagsFilter = tags;

              _pagingController.refresh();
              context.pop();
            },
            musicSheetTags: tagsFilter,
            musicSheetTitle: titleFilter,
            availableTags: availableTags,
            pagingController: _pagingController);
      },
    );
  }

  Future<void> _showEditDialog(BuildContext context,
      {required MusicSheet musicSheet,
      required List<MusicSheetTag> availableTags}) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MusicSheetDialog(
            dialogTitle: context.localization.editMusicSheet,
            onSaveCallback: (title, tags) async {
              final newMusicSheet = MusicSheet(
                id: musicSheet.id,
                title: title,
                filePath: musicSheet.filePath,
                tags: tags,
                lastOpenedDate: musicSheet.lastOpenedDate,
              );

              final repository = MusicSheetRepository();
              await repository.updateMusicSheet(newMusicSheet);
              _pagingController.refresh();
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            musicSheetTitle: musicSheet.title,
            musicSheetTags: musicSheet.tags,
            availableTags: availableTags,
            pagingController: _pagingController);
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

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
