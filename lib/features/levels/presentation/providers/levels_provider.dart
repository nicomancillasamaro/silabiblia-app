import 'package:flutter/foundation.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/level_entity.dart';
import '../../domain/usecases/get_levels_usecase.dart';

class LevelsProvider extends ChangeNotifier {
  final GetLevelsUseCase getLevelsUseCase;

  List<LevelEntity> _levels = [];
  bool _isLoading = false;

  LevelsProvider({required this.getLevelsUseCase});

  List<LevelEntity> get levels => _levels;
  bool get isLoading => _isLoading;

  Future<void> fetchLevels() async {
    _isLoading = true;
    notifyListeners();

    _levels = await getLevelsUseCase(const NoParams());
    _isLoading = false;
    notifyListeners();
  }
}
