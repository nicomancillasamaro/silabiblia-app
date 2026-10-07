import '../../domain/entities/level_entity.dart';
import '../../domain/repositories/level_repository.dart';
import '../datasources/level_local_datasource.dart';

class LevelRepositoryImpl implements LevelRepository {
  final LevelLocalDataSource localDataSource;

  LevelRepositoryImpl({required this.localDataSource});

  @override
  Future<List<LevelEntity>> getLevels() async {
    final models = await localDataSource.getCachedLevels();
    return models;
  }

  @override
  Future<void> unlockLevel(String levelId) async {
    await localDataSource.cacheUnlockedLevel(levelId);
  }
}
