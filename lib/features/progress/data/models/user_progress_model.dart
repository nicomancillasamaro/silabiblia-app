import '../../domain/entities/user_progress_entity.dart';

class UserProgressModel extends UserProgressEntity {
  const UserProgressModel({
    required super.totalStars,
    required super.levelStars,
    required super.unlockedLevelIds,
    super.isSyncedWithCloud,
  });

  factory UserProgressModel.fromJson(Map<String, dynamic> json) {
    return UserProgressModel(
      totalStars: json['total_stars'] as int? ?? 0,
      levelStars: Map<String, int>.from(json['level_stars'] ?? {}),
      unlockedLevelIds: Set<String>.from(json['unlocked_levels'] ?? ['w1_l1_a', 'w1_l2_e']),
      isSyncedWithCloud: json['is_synced'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_stars': totalStars,
      'level_stars': levelStars,
      'unlocked_levels': unlockedLevelIds.toList(),
      'is_synced': isSyncedWithCloud,
    };
  }
}
