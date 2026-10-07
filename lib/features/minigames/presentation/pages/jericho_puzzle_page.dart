import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../../core/audio/sound_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../levels/domain/entities/level_entity.dart';
import '../../../progress/presentation/providers/progress_provider.dart';

class JerichoPuzzlePage extends StatefulWidget {
  final LevelEntity level;

  const JerichoPuzzlePage({super.key, required this.level});

  @override
  State<JerichoPuzzlePage> createState() => _JerichoPuzzlePageState();
}

class _JerichoPuzzlePageState extends State<JerichoPuzzlePage> {
  late String _consonantDouble; // e.g. "CR" or "TR"
  late String _targetVowel;     // e.g. "U" or "I"
  late String _targetWord;      // e.g. "Cruz" or "Trigo"

  final List<String> _vowels = ['A', 'E', 'I', 'O', 'U'];
  bool _isSolved = false;

  @override
  void initState() {
    super.initState();
    _setupLevel();
  }

  void _setupLevel() {
    if (widget.level.targetPhoneme.startsWith('CR')) {
      _consonantDouble = 'CR';
      _targetVowel = 'U';
      _targetWord = 'Cruz ✝️';
    } else {
      _consonantDouble = 'TR';
      _targetVowel = 'I';
      _targetWord = 'Trigo 🌾';
    }
    _isSolved = false;
  }

  void _onVowelSelected(String vowel) {
    final fullSyllable = '$_consonantDouble$vowel';
    SoundService().playPhoneme(fullSyllable);

    if (vowel == _targetVowel) {
      setState(() {
        _isSolved = true;
        Provider.of<ProgressProvider>(context, listen: false).completeLevel(
          widget.level.id,
          3,
        );
      });
    } else {
      SoundService().playSfx('error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Uniste "$_consonantDouble$vowel". Para formar "$_targetWord" necesitas la vocal "$_targetVowel".'),
          duration: const Duration(seconds: 2),
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
          gradient: LinearGradient(
            colors: [Color(0xFF8338EC), Color(0xFF3A0CA3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
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
                    const Icon(Icons.fort_rounded, color: AppTheme.secondaryGold, size: 30),
                  ],
                ),
              ),

              // Instructions
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Text('🧱 ', style: TextStyle(fontSize: 28)),
                    Expanded(
                      child: Text(
                        '¡Rompecabezas Fonético! Une la consonante "$_consonantDouble" con la vocal correcta para formar "$_targetWord" y derribar la muralla.',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

              // Visual Wall / Jericho Obstacle
              Expanded(
                flex: 2,
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: _isSolved ? AppTheme.emeraldGreen : const Color(0xFF8D5B4C),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: AppTheme.secondaryGold, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isSolved ? '🏰✨' : '🧱🧱🧱',
                          style: const TextStyle(fontSize: 54),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppTheme.secondaryGold,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                _consonantDouble,
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.darkSlate,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text('+', style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: Text(
                                _isSolved ? _targetVowel : '?',
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Vowels Selectors
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Wrap(
                  spacing: 16,
                  children: _vowels.map((v) {
                    return ElevatedButton(
                      onPressed: _isSolved ? null : () => _onVowelSelected(v),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondaryGold,
                        foregroundColor: AppTheme.darkSlate,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        elevation: 6,
                      ),
                      child: Text(
                        v,
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                ),
              ),

              if (_isSolved)
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.black87,
                  child: Column(
                    children: [
                      Text(
                        '🎉 ¡Muralla Derribada! Formaste "$_consonantDouble$_targetVowel" 🎉',
                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ).animate().scale().fade(),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.emeraldGreen,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                        child: const Text('Volver al Mapa', style: TextStyle(fontSize: 18, color: Colors.white)),
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
}
