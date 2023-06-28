class WordofDay {
  int id;
  String word;
  String meaning;
  String example;

  WordofDay({
    required this.id,
    required this.word,
    required this.meaning,
    required this.example,
  });

  factory WordofDay.fromJson(Map<String, dynamic> json) {
    return WordofDay(
      id: json['id'],
      word: json['word'],
      meaning: json['meaning'],
      example: json['example'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': (id == 0) ? null : id,
      "word": word,
      "meaning": meaning,
      "example": example,
    };
  }

  @override
  String toString() {
    return 'WordofDay{id:$id, word: $word, meaning: $meaning, example: $example}';
  }
}
