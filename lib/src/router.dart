import 'package:allegro_pdf/src/models/music_sheet.dart';
import 'package:allegro_pdf/src/ui/pages/music_sheet_list_page.dart';
import 'package:allegro_pdf/src/ui/pages/music_sheet_pdf_page.dart';
import 'package:allegro_pdf/src/ui/pages/music_sheet_tag_list_page.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

final router = GoRouter(
  routes: [
    GoRoute(
        path: '/',
        builder: (context, state) => const MusicSheetListPage(),
        routes: [
          GoRoute(
            path: 'pdf',
            builder: (context, state) =>
                MusicSheetPdfPage(musicSheet: state.extra! as MusicSheet),
          ),
          GoRoute(
            path: 'tags',
            builder: (context, state) => MusicSheetTagListPage(
              pagingController: state.extra! as PagingController,
            ),
          ),
        ]),
  ],
);
