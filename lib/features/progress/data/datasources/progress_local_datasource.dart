import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_progress_model.dart';

abstract class ProgressLocalDataSource {
  Future<UserProgressModel> getSavedProgress();
  Future<void> saveProgress(UserProgressModel progress);
}

class ProgressLocalDataSourceImpl implements ProgressLocalDataSource {
  static const String boxName = 'silabiblia_user_progress';
  static const String progressKey = 'current_user_progress';

  Box? _box;

  Future<Box> _getBox() async {
    if (_box != null && _box!.isOpen) return _box!;
    _box = await Hive.openBox(boxName);
    return _box!;
  }

  @override
  Future<UserProgressModel> getSavedProgress() async {
    try {
      final box = await _getBox();
      final data = box.get(progressKey);

      if (data != null && data is Map) {
        return UserProgressModel.fromJson(Map<String, dynamic>.from(data));
      }
    } catch (e) {
      // Fallback if cache fails
    }

    return const UserProgressModel(
      totalStars: 0,
      levelStars: {},
      unlockedLevelIds: {'w1_l1_a', 'w1_l2_e'},
      isSyncedWithCloud: false,
    );
  }

  @override
  Future<void> saveProgress(UserProgressModel progress) async {
    try {
      final box = await _getBox();
      await box.put(progressKey, progress.toJson());
    } catch (e) {
      // Fallback local memory
    }
  }
}
