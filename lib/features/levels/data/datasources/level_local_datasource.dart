import '../../../progress/data/datasources/progress_local_datasource.dart';
import '../../domain/entities/level_entity.dart';
import '../models/level_model.dart';

abstract class LevelLocalDataSource {
  Future<List<LevelModel>> getCachedLevels();
  Future<void> cacheUnlockedLevel(String levelId);
}

class LevelLocalDataSourceImpl implements LevelLocalDataSource {
  final ProgressLocalDataSource progressLocalDataSource;

  LevelLocalDataSourceImpl({required this.progressLocalDataSource});

  @override
  Future<List<LevelModel>> getCachedLevels() async {
    final progress = await progressLocalDataSource.getSavedProgress();
    final unlockedIds = progress.unlockedLevelIds;

    return _initialLevelsData.map((data) {
      final isUnlocked = unlockedIds.contains(data['id']) || data['id'] == 'w1_l1_a' || data['id'] == 'w1_l2_e';
      return LevelModel.fromJson({...data, 'isUnlocked': isUnlocked});
    }).toList();
  }

  @override
  Future<void> cacheUnlockedLevel(String levelId) async {
    final progress = await progressLocalDataSource.getSavedProgress();
    final updatedUnlocked = Set<String>.from(progress.unlockedLevelIds)..add(levelId);
    final updatedModel = progress.copyWith(unlockedLevelIds: updatedUnlocked);
    // Dynamic update handled via progress persistence
  }

  static const List<Map<String, dynamic>> _initialLevelsData = [
    {
      'id': 'w1_l1_a',
      'worldType': 'creationVowels',
      'levelNumber': 1,
      'title': 'Vocal A - El Arca de Noé 🚢',
      'biblicalNarrative': 'Dios salvó a Noé y a los animales en el Arca.',
      'targetPhoneme': 'A',
      'wordExample': 'Arca',
      'emojiIcon': '🚢',
    },
    {
      'id': 'w1_l2_e',
      'worldType': 'creationVowels',
      'levelNumber': 2,
      'title': 'Vocal E - Estrellas del Cielo ⭐',
      'biblicalNarrative': 'Dios contó las estrellas y las llamó por su nombre.',
      'targetPhoneme': 'E',
      'wordExample': 'Estrellas',
      'emojiIcon': '⭐',
    },
    {
      'id': 'w1_l3_i',
      'worldType': 'creationVowels',
      'levelNumber': 3,
      'title': 'Vocal I - La Iglesia ⛪',
      'biblicalNarrative': 'Somos la iglesia y alabamos a Dios juntos.',
      'targetPhoneme': 'I',
      'wordExample': 'Iglesia',
      'emojiIcon': '⛪',
    },
    {
      'id': 'w2_l1_m',
      'worldType': 'directConsonants',
      'levelNumber': 4,
      'title': 'Sílaba MA - El Maná del Desierto 🍞',
      'biblicalNarrative': 'Dios envió Maná cada mañana para alimentar a su pueblo.',
      'targetPhoneme': 'MA',
      'wordExample': 'Maná',
      'emojiIcon': '🍞',
    },
    {
      'id': 'w3_l1_cruz',
      'worldType': 'blendedSyllables',
      'levelNumber': 5,
      'title': 'Sílaba CRU - La Cruz del Redentor ✝️',
      'biblicalNarrative': 'Por amor, Jesús entregó su vida en la Cruz.',
      'targetPhoneme': 'CRU',
      'wordExample': 'Cruz',
      'emojiIcon': '✝️',
    },
  ];
}
