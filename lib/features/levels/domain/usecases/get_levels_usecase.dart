import '../../../../core/usecase/usecase.dart';
import '../entities/level_entity.dart';
import '../repositories/level_repository.dart';

class GetLevelsUseCase implements UseCase<List<LevelEntity>, NoParams> {
  final LevelRepository repository;

  GetLevelsUseCase(this.repository);

  @override
  Future<List<LevelEntity>> call(NoParams params) async {
    return await repository.getLevels();
  }
}
