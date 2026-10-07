import '../entities/user_progress_entity.dart';

abstract class ProgressRepository {
  Future<UserProgressEntity> getProgress();
  Future<UserProgressEntity> completeLevel(String levelId, int starsEarned, {String? nextLevelId});
  Future<UserProgressEntity> syncWithCloud();
}
