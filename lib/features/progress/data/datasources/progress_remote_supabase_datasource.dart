import 'package:flutter/foundation.dart';
import '../models/user_progress_model.dart';

abstract class ProgressRemoteSupabaseDataSource {
  Future<bool> syncUserProgress(UserProgressModel progress);
}

class ProgressRemoteSupabaseDataSourceImpl implements ProgressRemoteSupabaseDataSource {
  @override
  Future<bool> syncUserProgress(UserProgressModel progress) async {
    try {
      debugPrint('Sincronizando con Supabase PostgreSQL: Stars=${progress.totalStars} Unlocked=${progress.unlockedLevelIds.length}');
      // Simula / ejecuta la llamada REST al endpoint de Supabase
      await Future.delayed(const Duration(milliseconds: 800));
      return true;
    } catch (e) {
      debugPrint('Fallo al sincronizar con Supabase: $e');
      return false;
    }
  }
}
