enum WorldType {
  creationVowels,      // Mundo 1: Vocales y Creación (Génesis)
  directConsonants,    // Mundo 2: Consonantes directas (M, P, S, L, T)
  blendedSyllables,    // Mundo 3: Sílabas trabadas (Tra, Cla, Tla, Bra, Fra)
}

class LevelEntity {
  final String id;
  final WorldType worldType;
  final int levelNumber;
  final String title;
  final String biblicalNarrative;
  final String targetPhoneme;
  final String wordExample;
  final String emojiIcon;
  final int maxStars;
  final bool isUnlocked;

  const LevelEntity({
    required this.id,
    required this.worldType,
    required this.levelNumber,
    required this.title,
    required this.biblicalNarrative,
    required this.targetPhoneme,
    required this.wordExample,
    required this.emojiIcon,
    this.maxStars = 3,
    this.isUnlocked = false,
  });

  LevelEntity copyWith({
    String? id,
    WorldType? worldType,
    int? levelNumber,
    String? title,
    String? biblicalNarrative,
    String? targetPhoneme,
    String? wordExample,
    String? emojiIcon,
    int? maxStars,
    bool? isUnlocked,
  }) {
    return LevelEntity(
      id: id ?? this.id,
      worldType: worldType ?? this.worldType,
      levelNumber: levelNumber ?? this.levelNumber,
      title: title ?? this.title,
      biblicalNarrative: biblicalNarrative ?? this.biblicalNarrative,
      targetPhoneme: targetPhoneme ?? this.targetPhoneme,
      wordExample: wordExample ?? this.wordExample,
      emojiIcon: emojiIcon ?? this.emojiIcon,
      maxStars: maxStars ?? this.maxStars,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}
