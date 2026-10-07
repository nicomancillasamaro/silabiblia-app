import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../minigames/presentation/pages/jericho_puzzle_page.dart';
import '../../../minigames/presentation/pages/noah_ark_vowels_page.dart';
import '../../../minigames/presentation/pages/syllable_memory_page.dart';
import '../../../parent_zone/presentation/pages/parent_dashboard_page.dart';
import '../../../parent_zone/presentation/widgets/parental_gate_dialog.dart';
import '../../../progress/presentation/providers/progress_provider.dart';
import '../../domain/entities/level_entity.dart';
import '../providers/levels_provider.dart';

class LevelMapPage extends StatelessWidget {
  const LevelMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final levelsProvider = Provider.of<LevelsProvider>(context);
    final progressProvider = Provider.of<ProgressProvider>(context);
    final levels = levelsProvider.levels;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SilaBiblia 📖✨',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.secondaryGold,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Text('⭐', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 4),
                Text(
                  '${progressProvider.progress.totalStars}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkSlate,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.family_restroom_rounded, size: 28),
            tooltip: 'Zona de Padres',
            onPressed: () {
              ParentalGateDialog.show(context, () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ParentDashboardPage(),
                  ),
                );
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F2FE), Color(0xFFF0F9FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text('🕊️', style: TextStyle(fontSize: 36)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Aprende a leer con Historias de la Biblia',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          'Estructura Clean Architecture: Domain, Data y Presentation.',
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildWorldHeader(
              title: 'Mundo 1: Vocales y Creación (Génesis) 🌳',
              color: AppTheme.emeraldGreen,
            ),
            ...levels
                .where((l) => l.worldType == WorldType.creationVowels)
                .map((level) => _buildLevelTile(context, level, progressProvider)),

            const SizedBox(height: 24),

            _buildWorldHeader(
              title: 'Mundo 2: Consonantes Directas (M, P, S, L) 🕊️',
              color: AppTheme.primaryBlue,
            ),
            ...levels
                .where((l) => l.worldType == WorldType.directConsonants)
                .map((level) => _buildLevelTile(context, level, progressProvider)),

            const SizedBox(height: 24),

            _buildWorldHeader(
              title: 'Mundo 3: Sílabas Trabadas (CR, TR, CL) ✝️',
              color: AppTheme.accentPurple,
            ),
            ...levels
                .where((l) => l.worldType == WorldType.blendedSyllables)
                .map((level) => _buildLevelTile(context, level, progressProvider)),
          ],
        ),
      ),
    );
  }

  Widget _buildWorldHeader({required String title, required Color color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildLevelTile(BuildContext context, LevelEntity level, ProgressProvider progressProvider) {
    final isUnlocked = progressProvider.isLevelUnlocked(level.id) || level.isUnlocked;
    final stars = progressProvider.getStarsForLevel(level.id);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        color: isUnlocked ? Colors.white : const Color(0xFFF1F5F9),
        elevation: isUnlocked ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isUnlocked ? AppTheme.primaryBlue.withOpacity(0.3) : Colors.black12,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: isUnlocked ? AppTheme.secondaryGold.withOpacity(0.2) : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                level.emojiIcon,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          title: Text(
            level.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isUnlocked ? AppTheme.darkSlate : Colors.grey,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                level.biblicalNarrative,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 6),
              if (isUnlocked)
                Row(
                  children: List.generate(3, (index) {
                    return Icon(
                      index < stars ? Icons.star_rounded : Icons.star_border_rounded,
                      color: AppTheme.secondaryGold,
                      size: 20,
                    );
                  }),
                )
              else
                const Text(
                  '🔒 Desbloquea completando los niveles anteriores',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
            ],
          ),
          trailing: isUnlocked
              ? ElevatedButton(
                  onPressed: () {
                    Widget destination;
                    if (level.worldType == WorldType.creationVowels) {
                      destination = NoahArkVowelsPage(level: level);
                    } else if (level.worldType == WorldType.directConsonants) {
                      destination = SyllableMemoryPage(level: level);
                    } else {
                      destination = JerichoPuzzlePage(level: level);
                    }

                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => destination),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.emeraldGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Jugar'),
                )
              : const Icon(Icons.lock_rounded, color: Colors.grey),
        ),
      ),
    );
  }
}
