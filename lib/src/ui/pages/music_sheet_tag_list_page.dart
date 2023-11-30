import 'package:allegro_pdf/src/models/music_sheet_tag.dart';
import 'package:allegro_pdf/src/repository/music_sheet_tag_repository.dart';
import 'package:allegro_pdf/src/ui/dialogs/music_sheet_tag_dialog.dart';
import 'package:allegro_pdf/src/ui/widgets/music_sheet_tag_chip.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MusicSheetTagListPage extends StatefulWidget {
  const MusicSheetTagListPage({super.key});

  @override
  State<MusicSheetTagListPage> createState() => _MusicSheetTagListPageState();
}

class _MusicSheetTagListPageState extends State<MusicSheetTagListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Visibility(
          child: FloatingActionButton.extended(
              icon: const Icon(Icons.add),
              label: const Text("Add"),
              onPressed: () async {
                await showMusicSheetTagDialog(context);
              }),
        ),
        appBar: AppBar(
            title: const Text(
              "Tags",
            ),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary),
        body: FutureBuilder(
            future: MusicSheetTagRepository().getAllMusicSheetsTags(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                  final tags = snapshot.data!;
                  return ListView.separated(
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final tag = tags[index];
                      return ListTile(
                        leading: MusicSheetTagChip(tag: tag),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            await showMusicSheetTagDialog(context,
                                tagToEdit: tag);
                          },
                        ),
                        onTap: () {
                          context.go('/pdf', extra: tag);
                        },
                      );
                    },
                    itemCount: tags.length,
                  );
              }
            }));
  }

  Future<void> showMusicSheetTagDialog(BuildContext context,
      {MusicSheetTag? tagToEdit}) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MusicSheetTagDialog(
            tagToEdit: tagToEdit, callback: () => setState(() {}));
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
