class MusicSheetTag {
  final int? id;
  final String title;
  final int color; // Adding the color parameter

  MusicSheetTag({
    required this.id,
    required this.title,
    required this.color, // Including color in the constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'color': color, // Including color in the map
    };
  }

  factory MusicSheetTag.fromMap(Map<String, dynamic> map) {
    return MusicSheetTag(
      id: map['id'],
      title: map['title'],
      color: int.parse(map['color']), // Fetching color from the map
    );
  }
}
