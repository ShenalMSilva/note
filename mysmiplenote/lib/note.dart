class Note {
  final int? id;
  final String title;
  final String content;
  final DateTime createdTime;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdTime,
  });

  // Convert a Note into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'created_time': createdTime.toIso8601String(),
    };
  }

  // Extract a Note object from a Map.
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdTime: DateTime.parse(map['created_time']),
    );
  }

  // Add a copy method to create a new instance with a modified id
  Note copy({int? id}) {
    return Note(
      id: id ?? this.id,
      title: title,
      content: content,
      createdTime: createdTime,
    );
  }
}
