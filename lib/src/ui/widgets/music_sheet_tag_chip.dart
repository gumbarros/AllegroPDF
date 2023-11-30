import 'package:allegro_pdf/src/models/music_sheet_tag.dart';
import 'package:flutter/material.dart';

class MusicSheetTagChip extends StatelessWidget {
  final MusicSheetTag tag;
  const MusicSheetTagChip({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    final color = Color(tag.color);
    final brightness = ThemeData.estimateBrightnessForColor(color);
    final textColor =
        brightness == Brightness.dark ? Colors.white : Colors.black;
    return Chip(
      label: Text(tag.title, style: TextStyle(color: textColor)),
      backgroundColor: color,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
    );
  }
}
