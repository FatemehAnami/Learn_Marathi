class Example {
  final String id;
  final String marathi;
  final String transliteration;
  final String english;
  final String audio;

  const Example({
    required this.id,
    required this.marathi,
    required this.transliteration,
    required this.english,
    required this.audio,
  });

  factory Example.fromJson(Map<String, dynamic> json) {
    return Example(
      id: json["id"],
      marathi: json["marathi"],
      transliteration: json["transliteration"],
      english: json["english"],
      audio: json["audio"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "marathi": marathi,
      "transliteration": transliteration,
      "english": english,
      "audio": audio,
    };
  }
}