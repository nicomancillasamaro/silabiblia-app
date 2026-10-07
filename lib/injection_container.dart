import 'package:hive_flutter/hive_flutter.dart';

import 'core/services/supabase_service.dart';
import 'features/levels/data/datasources/level_local_datasource.dart';
import 'features/levels/data/repositories/level_repository_impl.dart';
import 'features/levels/domain/usecases/get_levels_usecase.dart';
import 'features/levels/presentation/providers/levels_provider.dart';

import 'features/progress/data/datasources/progress_local_datasource.dart';
import 'features/progress/data/datasources/progress_remote_supabase_datasource.dart';
import 'features/progress/data/repositories/progress_repository_impl.dart';
import 'features/progress/domain/usecases/complete_level_usecase.dart';
import 'features/progress/domain/usecases/sync_progress_usecase.dart';
import 'features/progress/presentation/providers/progress_provider.dart';

class InjectionContainer {
  static late final LevelsProvider levelsProvider;
  static late final ProgressProvider progressProvider;

  static Future<void> init() async {
    // 1. Initialize Hive Flutter Local Persistence & Supabase Service
    await Hive.initFlutter();
    await SupabaseService().init();

    // 2. Data Sources
    final progressLocalDataSource = ProgressLocalDataSourceImpl();
    final progressRemoteDataSource = ProgressRemoteSupabaseDataSourceImpl();

    final levelLocalDataSource = LevelLocalDataSourceImpl(
      progressLocalDataSource: progressLocalDataSource,
    );

    // 3. Repositories
    final levelRepository = LevelRepositoryImpl(localDataSource: levelLocalDataSource);
    final progressRepository = ProgressRepositoryImpl(
      localDataSource: progressLocalDataSource,
      remoteDataSource: progressRemoteDataSource,
    );

    // 4. Use Cases
    final getLevelsUseCase = GetLevelsUseCase(levelRepository);
    final completeLevelUseCase = CompleteLevelUseCase(progressRepository);
    final syncProgressUseCase = SyncProgressUseCase(progressRepository);

    // 5. Presentation Providers
    levelsProvider = LevelsProvider(getLevelsUseCase: getLevelsUseCase);
    await levelsProvider.fetchLevels();

    progressProvider = ProgressProvider(
      completeLevelUseCase: completeLevelUseCase,
      syncProgressUseCase: syncProgressUseCase,
    );
  }
}
