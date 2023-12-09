import 'package:allegro_pdf/l10n/localization_extension.dart';
import 'package:allegro_pdf/src/models/music_sheet_tag.dart';
import 'package:allegro_pdf/src/providers/music_sheet_tag_provider.dart';
import 'package:allegro_pdf/src/repository/music_sheet_tag_repository.dart';
import 'package:allegro_pdf/src/ui/dialogs/music_sheet_tag_dialog.dart';
import 'package:allegro_pdf/src/ui/widgets/music_sheet_tag_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class MusicSheetTagListPage extends ConsumerWidget {
  final PagingController pagingController;

  const MusicSheetTagListPage({super.key, required this.pagingController});

  @override
  Widget build(BuildContext context, ref) {
    final tagsState = ref.watch(musicSheetTagProvider);

    return Scaffold(
        floatingActionButton: Visibility(
          child: FloatingActionButton.extended(
              icon: const Icon(Icons.add),
              label: Text(context.localization.add),
              onPressed: () async {
                await showMusicSheetTagDialog(context);
              }),
        ),
        appBar: AppBar(
            title: const Text(
              "Tags",
            ),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary),
        body: tagsState.when(
            data: (tags) {
              return ListView.separated(
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final tag = tags[index];
                  return ListTile(
                      leading: MusicSheetTagChip(tag: tag),
                      trailing: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                await showMusicSheetTagDialog(context,
                                    tagToEdit: tag);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                bool confirmDelete = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                          context.localization.confirmDeletion),
                                      content: Text(context.localization
                                          .tagDeletionConfirmation),
                                      actions: <Widget>[
                                        TextButton(
                                          child:
                                              Text(context.localization.cancel),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                        TextButton(
                                          child:
                                              Text(context.localization.delete),
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirmDelete) {
                                  final repository = MusicSheetTagRepository();
                                  await repository.deleteTag(tag.id!);
                                  if (context.mounted) {
                                    ref.invalidate(musicSheetTagProvider);
                                    pagingController.refresh();
                                  }
                                }
                              },
                            )
                          ],
                        ),
                      ));
                },
                itemCount: tags.length,
              );
            },
            error: (error, _) => Center(child: Text('Error: $error')),
            loading: () => const Center(child: CircularProgressIndicator())));
  }

  Future<void> showMusicSheetTagDialog(BuildContext context,
      {MusicSheetTag? tagToEdit}) async {
    final newTag = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return MusicSheetTagDialog(tagToEdit: tagToEdit);
        });

    if (newTag != null && context.mounted) {
      pagingController.refresh();
    }
  }
}
