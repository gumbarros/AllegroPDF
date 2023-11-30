import 'package:allegro_pdf/src/models/music_sheet.dart';
import 'package:allegro_pdf/src/ui/pages/music_sheet_list_page.dart';
import 'package:allegro_pdf/src/ui/pages/music_sheet_pdf_page.dart';
import 'package:allegro_pdf/src/ui/pages/music_sheet_tag_list_page.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const AllegroPdfApp());
}

final _router = GoRouter(
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
            builder: (context, state) => MusicSheetTagListPage(),
          ),
        ]),
  ],
);

class AllegroPdfApp extends StatelessWidget {
  const AllegroPdfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AllegroPDF',
      themeMode: ThemeMode.system,
      theme: FlexThemeData.light(scheme: FlexScheme.bahamaBlue),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.bahamaBlue),
      routerConfig: _router,
    );
  }
}
