class UserProgressEntity {
  final int totalStars;
  final Map<String, int> levelStars;
  final Set<String> unlockedLevelIds;
  final bool isSyncedWithCloud;

  const UserProgressEntity({
    required this.totalStars,
    required this.levelStars,
    required this.unlockedLevelIds,
    this.isSyncedWithCloud = false,
  });

  UserProgressEntity copyWith({
    int? totalStars,
    Map<String, int>? levelStars,
    Set<String>? unlockedLevelIds,
    bool? isSyncedWithCloud,
  }) {
    return UserProgressEntity(
      totalStars: totalStars ?? this.totalStars,
      levelStars: levelStars ?? this.levelStars,
      unlockedLevelIds: unlockedLevelIds ?? this.unlockedLevelIds,
      isSyncedWithCloud: isSyncedWithCloud ?? this.isSyncedWithCloud,
    );
  }
}
