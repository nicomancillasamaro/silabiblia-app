import '../../domain/entities/user_progress_entity.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/progress_local_datasource.dart';
import '../datasources/progress_remote_supabase_datasource.dart';
import '../models/user_progress_model.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressLocalDataSource localDataSource;
  final ProgressRemoteSupabaseDataSource? remoteDataSource;

  ProgressRepositoryImpl({
    required this.localDataSource,
    this.remoteDataSource,
  });

  @override
  Future<UserProgressEntity> getProgress() async {
    return await localDataSource.getSavedProgress();
  }

  @override
  Future<UserProgressEntity> completeLevel(
    String levelId,
    int starsEarned, {
    String? nextLevelId,
  }) async {
    final current = await localDataSource.getSavedProgress();
    final updatedStarsMap = Map<String, int>.from(current.levelStars);
    final prevStars = updatedStarsMap[levelId] ?? 0;
    
    int newTotalStars = current.totalStars;
    if (starsEarned > prevStars) {
      newTotalStars += (starsEarned - prevStars);
      updatedStarsMap[levelId] = starsEarned;
    }

    final updatedUnlocked = Set<String>.from(current.unlockedLevelIds);
    if (nextLevelId != null) {
      updatedUnlocked.add(nextLevelId);
    }

    final updatedModel = UserProgressModel(
      totalStars: newTotalStars,
      levelStars: updatedStarsMap,
      unlockedLevelIds: updatedUnlocked,
      isSyncedWithCloud: false, // Remains offline-first until parent triggers cloud sync
    );

    await localDataSource.saveProgress(updatedModel);
    return updatedModel;
  }

  @override
  Future<UserProgressEntity> syncWithCloud() async {
    final current = await localDataSource.getSavedProgress();
    
    bool isSuccess = true;
    if (remoteDataSource != null) {
      isSuccess = await remoteDataSource!.syncUserProgress(current);
    }

    final syncedModel = UserProgressModel(
      totalStars: current.totalStars,
      levelStars: current.levelStars,
      unlockedLevelIds: current.unlockedLevelIds,
      isSyncedWithCloud: isSuccess,
    );
    
    await localDataSource.saveProgress(syncedModel);
    return syncedModel;
  }
}
