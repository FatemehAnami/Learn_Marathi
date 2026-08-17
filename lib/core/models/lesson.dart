import 'word.dart';

class Lesson {
  final int id;
  final String title;
  //final String emoji;
  final List<Word> words;

  const Lesson({
    required this.id,
    required this.title,
    //required this.emoji,
    required this.words,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json["id"],
      title: json["title"],
      //emoji: json["emoji"],
      words: (json["words"] as List)
          .map((e) => Word.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      //"emoji": emoji,
      "words": words.map((e) => e.toJson()).toList(),
    };
  }
}