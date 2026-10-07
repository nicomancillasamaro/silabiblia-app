import '../../domain/entities/level_entity.dart';

class LevelModel extends LevelEntity {
  const LevelModel({
    required super.id,
    required super.worldType,
    required super.levelNumber,
    required super.title,
    required super.biblicalNarrative,
    required super.targetPhoneme,
    required super.wordExample,
    required super.emojiIcon,
    super.maxStars,
    super.isUnlocked,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      id: json['id'] as String,
      worldType: WorldType.values.firstWhere(
        (e) => e.name == json['worldType'],
        orElse: () => WorldType.creationVowels,
      ),
      levelNumber: json['levelNumber'] as int? ?? 1,
      title: json['title'] as String,
      biblicalNarrative: json['biblicalNarrative'] as String,
      targetPhoneme: json['targetPhoneme'] as String,
      wordExample: json['wordExample'] as String,
      emojiIcon: json['emojiIcon'] as String,
      maxStars: json['maxStars'] as int? ?? 3,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'worldType': worldType.name,
      'levelNumber': levelNumber,
      'title': title,
      'biblicalNarrative': biblicalNarrative,
      'targetPhoneme': targetPhoneme,
      'wordExample': wordExample,
      'emojiIcon': emojiIcon,
      'maxStars': maxStars,
      'isUnlocked': isUnlocked,
    };
  }
}
