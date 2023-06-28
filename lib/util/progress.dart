class Progress {
  int id;
  String userId;
  int alphabet;
  int sound;
  int word;
  int sentence;
  int paragraph;
  Progress({
    required this.id,
    required this.userId,
    required this.alphabet,
    required this.sound,
    required this.word,
    required this.sentence,
    required this.paragraph,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': (id == 0) ? null : id,
      'userId': userId,
      'alphabet': alphabet,
      'sound': sound,
      'word': word,
      'sentence': sentence,
      'paragraph': paragraph,
    };
  }

  factory Progress.fromMap(Map<String, dynamic> map) {
    return Progress(
      id: map['id'],
      userId: map['userId'],
      alphabet: map['alphabet'],
      sound: map['sound'],
      word: map['word'],
      sentence: map['sentence'],
      paragraph: map['paragraph'],
    );
  }
}
