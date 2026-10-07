import 'package:flutter/foundation.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/user_progress_entity.dart';
import '../../domain/usecases/complete_level_usecase.dart';
import '../../domain/usecases/sync_progress_usecase.dart';

class ProgressProvider extends ChangeNotifier {
  final CompleteLevelUseCase completeLevelUseCase;
  final SyncProgressUseCase syncProgressUseCase;

  UserProgressEntity _progress = const UserProgressEntity(
    totalStars: 0,
    levelStars: {},
    unlockedLevelIds: {'w1_l1_a', 'w1_l2_e'},
    isSyncedWithCloud: false,
  );

  ProgressProvider({
    required this.completeLevelUseCase,
    required this.syncProgressUseCase,
  });

  UserProgressEntity get progress => _progress;

  bool isLevelUnlocked(String levelId) {
    return _progress.unlockedLevelIds.contains(levelId);
  }

  int getStarsForLevel(String levelId) {
    return _progress.levelStars[levelId] ?? 0;
  }

  Future<void> completeLevel(String levelId, int starsEarned, {String? nextLevelId}) async {
    _progress = await completeLevelUseCase(
      CompleteLevelParams(
        levelId: levelId,
        starsEarned: starsEarned,
        nextLevelId: nextLevelId,
      ),
    );
    notifyListeners();
  }

  Future<void> syncCloud() async {
    _progress = await syncProgressUseCase(const NoParams());
    notifyListeners();
  }
}
