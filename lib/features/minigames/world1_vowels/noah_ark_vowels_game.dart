import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/audio/sound_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/level_model.dart';
import '../../../models/user_progress.dart';

class NoahArkVowelsGame extends StatefulWidget {
  final LevelModel level;

  const NoahArkVowelsGame({super.key, required this.level});

  @override
  State<NoahArkVowelsGame> createState() => _NoahArkVowelsGameState();
}

class _NoahArkVowelsGameState extends State<NoahArkVowelsGame> {
  late String _targetVowel;
  final List<String> _availableVowels = ['A', 'E', 'I', 'O', 'U'];
  final List<String> _spawnedVowels = [];
  int _collectedCount = 0;
  final int _requiredCount = 3;
  bool _isLevelComplete = false;

  @override
  void initState() {
    super.initState();
    _targetVowel = widget.level.targetPhoneme;
    _setupGame();
  }

  void _setupGame() {
    _spawnedVowels.clear();
    _collectedCount = 0;
    _isLevelComplete = false;
    
    // Add target vowels and distractors
    _spawnedVowels.add(_targetVowel);
    _spawnedVowels.add(_targetVowel);
    _spawnedVowels.add(_targetVowel);
    
    // Add distractors
    for (var v in _availableVowels) {
      if (v != _targetVowel) {
        _spawnedVowels.add(v);
      }
    }
    _spawnedVowels.shuffle();
  }

  void _onVowelAccepted(String vowel) {
    if (vowel == _targetVowel) {
      SoundService().playPhoneme(vowel);
      setState(() {
        _collectedCount++;
        _spawnedVowels.remove(vowel);
        if (_collectedCount >= _requiredCount) {
          _isLevelComplete = true;
          Provider.of<UserProgress>(context, listen: false).completeLevel(
            widget.level.id,
            3,
            nextLevelId: 'w1_l2_e',
          );
        }
      });
    } else {
      SoundService().playSfx('error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Buscamos la vocal "$_targetVowel"! Intenta con otra letra. 🚢'),
          duration: const Duration(seconds: 1),
          backgroundColor: AppTheme.warmOrange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.skyGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Navigation & Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 28),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text(
                      widget.level.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up_rounded, color: Colors.white, size: 30),
                      onPressed: () => SoundService().playPhoneme(_targetVowel),
                    ),
                  ],
                ),
              ),

              // Narrative Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Text('📖 ', style: TextStyle(fontSize: 28)),
                    Expanded(
                      child: Text(
                        '¡Ayuda a Noé a subir las vocales "${_targetVowel}" al Arca! (Arrastra las letras al barco)',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

              // Floating Vowels Area (Draggable)
              Expanded(
                flex: 2,
                child: Center(
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: _spawnedVowels.map((vowel) {
                      return Draggable<String>(
                        data: vowel,
                        feedback: Material(
                          color: Colors.transparent,
                          child: _buildVowelCard(vowel, isDragging: true),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.3,
                          child: _buildVowelCard(vowel),
                        ),
                        child: _buildVowelCard(vowel),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Target DragTarget (El Arca de Noé)
              Expanded(
                flex: 2,
                child: DragTarget<String>(
                  onWillAccept: (data) => true,
                  onAccept: (data) => _onVowelAccepted(data),
                  builder: (context, candidateData, rejectedData) {
                    final isHovered = candidateData.isNotEmpty;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: AppTheme.arkGradient,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: isHovered ? AppTheme.secondaryGold : Colors.white54,
                          width: isHovered ? 4 : 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🚢', style: TextStyle(fontSize: 64)),
                          const SizedBox(height: 8),
                          Text(
                            isHovered ? '¡Suelta la vocal aquí!' : 'El Arca de Noé',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(_requiredCount, (index) {
                              final isFilled = index < _collectedCount;
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                child: Icon(
                                  isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                                  color: AppTheme.secondaryGold,
                                  size: 36,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Level Complete Dialog Banner
              if (_isLevelComplete)
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.black87,
                  child: Column(
                    children: [
                      const Text(
                        '🎉 ¡Nivel Completado! 🎉',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ).animate().scale().fade(),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.emeraldGreen,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                        child: const Text('Continuar en el Mapa', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVowelCard(String vowel, {bool isDragging = false}) {
    return Container(
      width: isDragging ? 80 : 72,
      height: isDragging ? 80 : 72,
      decoration: BoxDecoration(
        color: AppTheme.secondaryGold,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          vowel,
          style: TextStyle(
            fontSize: isDragging ? 40 : 36,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkSlate,
          ),
        ),
      ),
    ).animate().scale(duration: 200.ms);
  }
}
