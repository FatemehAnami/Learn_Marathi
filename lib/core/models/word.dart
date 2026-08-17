import 'example.dart';

class Word {
  final String id;
  final String marathi;
  final String transliteration;
  final String english;
  final String emoji;
  final String audio;
  final List<Example> examples;

  const Word({
    required this.id,
    required this.marathi,
    required this.transliteration,
    required this.english,
    required this.emoji,
    required this.audio,
    required this.examples,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json["id"],
      marathi: json["marathi"],
      transliteration: json["transliteration"],
      english: json["english"],
      emoji: json["emoji"],
      audio: json["audio"],

      examples: (json["examples"] as List)
          .map((e) => Example.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "marathi": marathi,
      "transliteration": transliteration,
      "english": english,
      "emoji": emoji,
      "audio": audio,
      "examples": examples
          .map((e) => e.toJson())
          .toList(),
    };
  }
}

