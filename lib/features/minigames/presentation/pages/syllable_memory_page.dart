import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../../core/audio/sound_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../levels/domain/entities/level_entity.dart';
import '../../../progress/presentation/providers/progress_provider.dart';

class MemoryCardItem {
  final String id;
  final String textOrEmoji;
  final String phonemeSound;
  final bool isImage;
  bool isFaceUp;
  bool isMatched;

  MemoryCardItem({
    required this.id,
    required this.textOrEmoji,
    required this.phonemeSound,
    required this.isImage,
    this.isFaceUp = false,
    this.isMatched = false,
  });
}

class SyllableMemoryPage extends StatefulWidget {
  final LevelEntity level;

  const SyllableMemoryPage({super.key, required this.level});

  @override
  State<SyllableMemoryPage> createState() => _SyllableMemoryPageState();
}

class _SyllableMemoryPageState extends State<SyllableMemoryPage> {
  final List<MemoryCardItem> _cards = [];
  MemoryCardItem? _firstSelectedCard;
  bool _isProcessing = false;
  int _matchesFound = 0;
  bool _isGameComplete = false;

  @override
  void initState() {
    super.initState();
    _initializeCards();
  }

  void _initializeCards() {
    _cards.clear();
    _matchesFound = 0;
    _isGameComplete = false;

    final pairs = [
      {'syllable': 'MA', 'emoji': '🍞 Maná'},
      {'syllable': 'PA', 'emoji': '🕊️ Paloma'},
      {'syllable': 'SA', 'emoji': '🎶 Salmo'},
      {'syllable': 'LA', 'emoji': '💡 Luz'},
    ];

    for (var p in pairs) {
      final id = p['syllable']!;
      _cards.add(MemoryCardItem(
        id: id,
        textOrEmoji: id,
        phonemeSound: id,
        isImage: false,
      ));
      _cards.add(MemoryCardItem(
        id: id,
        textOrEmoji: p['emoji']!,
        phonemeSound: id,
        isImage: true,
      ));
    }

    _cards.shuffle();
  }

  void _onCardTapped(MemoryCardItem card) {
    if (_isProcessing || card.isFaceUp || card.isMatched) return;

    SoundService().playPhoneme(card.phonemeSound);

    setState(() {
      card.isFaceUp = true;
    });

    if (_firstSelectedCard == null) {
      _firstSelectedCard = card;
    } else {
      _isProcessing = true;
      final first = _firstSelectedCard!;

      if (first.id == card.id) {
        // Match found!
        setState(() {
          first.isMatched = true;
          card.isMatched = true;
          _matchesFound++;
          _firstSelectedCard = null;
          _isProcessing = false;

          if (_matchesFound >= 4) {
            _isGameComplete = true;
            Provider.of<ProgressProvider>(context, listen: false).completeLevel(
              widget.level.id,
              3,
              nextLevelId: 'w3_l1_cruz',
            );
          }
        });
      } else {
        // No match - turn face down after short delay
        Timer(const Duration(milliseconds: 900), () {
          setState(() {
            first.isFaceUp = false;
            card.isFaceUp = false;
            _firstSelectedCard = null;
            _isProcessing = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3A86FF), Color(0xFF0056D2)],
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
                    const Icon(Icons.style_rounded, color: AppTheme.secondaryGold, size: 30),
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
                  children: const [
                    Text('🧩 ', style: TextStyle(fontSize: 28)),
                    Expanded(
                      child: Text(
                        '¡Memorama Silábico! Voltea las tarjetas y encuentra las parejas de palabras bíblicas.',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

              // Cards Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossGridCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _cards.length,
                    itemBuilder: (context, index) {
                      final card = _cards[index];
                      return GestureDetector(
                        onTap: () => _onCardTapped(card),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: card.isMatched
                                ? AppTheme.emeraldGreen
                                : (card.isFaceUp ? Colors.white : AppTheme.secondaryGold),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: card.isFaceUp || card.isMatched
                                ? Text(
                                    card.textOrEmoji,
                                    style: TextStyle(
                                      fontSize: card.isImage ? 20 : 32,
                                      fontWeight: FontWeight.bold,
                                      color: card.isMatched ? Colors.white : AppTheme.darkSlate,
                                    ),
                                    textAlign: TextAlign.center,
                                  ).animate().scale()
                                : const Text(
                                    '❓',
                                    style: TextStyle(fontSize: 36),
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              if (_isGameComplete)
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.black87,
                  child: Column(
                    children: [
                      const Text(
                        '🎉 ¡Memorama Completado! 🎉',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
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
