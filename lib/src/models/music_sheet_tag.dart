class MusicSheetTag {
  final int? id;
  final String title;
  final int color;

  MusicSheetTag({
    required this.id,
    required this.title,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'color': color,
    };
  }

  factory MusicSheetTag.fromMap(Map<String, dynamic> map) {
    return MusicSheetTag(
        id: map['id'], title: map['title'], color: map['color']);
  }
}
