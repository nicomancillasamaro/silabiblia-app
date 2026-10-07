import '../entities/level_entity.dart';

abstract class LevelRepository {
  Future<List<LevelEntity>> getLevels();
  Future<void> unlockLevel(String levelId);
}
