import '../../../../core/usecase/usecase.dart';
import '../entities/user_progress_entity.dart';
import '../repositories/progress_repository.dart';

class CompleteLevelParams {
  final String levelId;
  final int starsEarned;
  final String? nextLevelId;

  const CompleteLevelParams({
    required this.levelId,
    required this.starsEarned,
    this.nextLevelId,
  });
}

class CompleteLevelUseCase implements UseCase<UserProgressEntity, CompleteLevelParams> {
  final ProgressRepository repository;

  CompleteLevelUseCase(this.repository);

  @override
  Future<UserProgressEntity> call(CompleteLevelParams params) async {
    return await repository.completeLevel(
      params.levelId,
      params.starsEarned,
      nextLevelId: params.nextLevelId,
    );
  }
}
