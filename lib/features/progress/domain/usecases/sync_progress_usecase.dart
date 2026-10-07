import '../../../../core/usecase/usecase.dart';
import '../entities/user_progress_entity.dart';
import '../repositories/progress_repository.dart';

class SyncProgressUseCase implements UseCase<UserProgressEntity, NoParams> {
  final ProgressRepository repository;

  SyncProgressUseCase(this.repository);

  @override
  Future<UserProgressEntity> call(NoParams params) async {
    return await repository.syncWithCloud();
  }
}
