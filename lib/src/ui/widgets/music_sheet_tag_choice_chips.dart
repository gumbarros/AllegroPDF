import 'package:allegro_pdf/src/models/music_sheet_tag.dart';
import 'package:flutter/material.dart';

class MusicSheetTagChoiceChips extends StatefulWidget {
  final List<MusicSheetTag> availableTags;
  final List<MusicSheetTag> selectedTags;

  const MusicSheetTagChoiceChips({
    super.key,
    required this.availableTags,
    required this.selectedTags,
  });

  @override
  State<MusicSheetTagChoiceChips> createState() =>
      _MusicSheetTagChoiceChipsState();
}

class _MusicSheetTagChoiceChipsState extends State<MusicSheetTagChoiceChips> {
  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(label: Text("Tags")),
      child: Column(
        children: <Widget>[
          Wrap(
            children: getChoiceChips().toList(),
          ),
        ],
      ),
    );
  }

  Iterable<Widget> getChoiceChips() sync* {
    for (final tag in widget.availableTags) {
      final color = Color(tag.color);
      final brightness = ThemeData.estimateBrightnessForColor(color);
      final textColor =
          brightness == Brightness.dark ? Colors.white : Colors.black;
      yield Container(
        margin: const EdgeInsets.all(5.0),
        child: ChoiceChip(
          label: Text(
            tag.title,
            style: TextStyle(color: textColor),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: Color(tag.color),
          checkmarkColor: textColor,
          selectedColor: Color(tag.color),
          selected: widget.selectedTags.any((t) => tag.id == t.id),
          onSelected: (bool selected) {
            setState(() {
              bool containsTag = widget.selectedTags.any((t) => t.id == tag.id);
              if (containsTag) {
                widget.selectedTags.removeWhere((t) => t.id == tag.id);
              } else {
                widget.selectedTags.add(tag);
              }
            });
          },
        ),
      );
    }
  }
}
