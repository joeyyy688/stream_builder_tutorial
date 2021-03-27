// To parse this JSON data, do
//
//     final owlBot = owlBotFromJson(jsonString);

import 'dart:convert';

OwlBot owlBotFromJson(String str) => OwlBot.fromJson(json.decode(str));

String owlBotToJson(OwlBot data) => json.encode(data.toJson());

class OwlBot {
  OwlBot({
    this.definitions,
    this.word,
    this.pronunciation,
  });

  List<Definition> definitions;
  String word;
  String pronunciation;

  factory OwlBot.fromJson(Map<String, dynamic> json) => OwlBot(
        definitions: List<Definition>.from(
            json["definitions"].map((x) => Definition.fromJson(x))),
        word: json["word"],
        pronunciation: json["pronunciation"],
      );

  Map<String, dynamic> toJson() => {
        "definitions": List<dynamic>.from(definitions.map((x) => x.toJson())),
        "word": word,
        "pronunciation": pronunciation,
      };
}

class Definition {
  Definition({
    this.type,
    this.definition,
    this.example,
    this.imageUrl,
    this.emoji,
  });

  String type;
  String definition;
  String example;
  String imageUrl;
  String emoji;

  factory Definition.fromJson(Map<String, dynamic> json) => Definition(
        type: json["type"],
        definition: json["definition"],
        example: json["example"] == null ? null : json["example"],
        imageUrl: json["image_url"] == null ? null : json["image_url"],
        emoji: json["emoji"] == null ? null : json["emoji"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "definition": definition,
        "example": example == null ? null : example,
        "image_url": imageUrl == null ? null : imageUrl,
        "emoji": emoji == null ? null : emoji,
      };
}
