class Vocabulary {
  int id;
  String word;
  String category;
  String meaning;
  String description;

  Vocabulary({
    required this.id,
    required this.word,
    required this.category,
    required this.meaning,
    required this.description,
  });

  factory Vocabulary.fromJson(Map<String, dynamic> json) {
    return Vocabulary(
      id: json['id'],
      word: json['word'],
      category: json['category'],
      meaning: json['meaning'],
      description: json['description'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': (id == 0) ? null : id,
      'word': word,
      'category': category,
      'meaning': meaning,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'Vocabulary{id: $id, word: $word, category: $category, meaning: $meaning, description: $description}';
  }
}
