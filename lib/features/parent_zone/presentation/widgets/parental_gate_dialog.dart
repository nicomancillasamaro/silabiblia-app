import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ParentalGateDialog extends StatefulWidget {
  final VoidCallback onPassed;

  const ParentalGateDialog({super.key, required this.onPassed});

  static Future<void> show(BuildContext context, VoidCallback onPassed) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ParentalGateDialog(onPassed: onPassed),
    );
  }

  @override
  State<ParentalGateDialog> createState() => _ParentalGateDialogState();
}

class _ParentalGateDialogState extends State<ParentalGateDialog> {
  late int _num1;
  late int _num2;
  late int _expectedAnswer;
  final TextEditingController _controller = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _generateChallenge();
  }

  void _generateChallenge() {
    final rand = Random();
    _num1 = rand.nextInt(8) + 2;
    _num2 = rand.nextInt(8) + 2;
    _expectedAnswer = _num1 + _num2;
  }

  void _verifyAnswer() {
    final input = int.tryParse(_controller.text.trim());
    if (input == _expectedAnswer) {
      Navigator.of(context).pop();
      widget.onPassed();
    } else {
      setState(() {
        _errorMessage = 'Respuesta incorrecta. Intenta nuevamente.';
        _controller.clear();
        _generateChallenge();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: Column(
        children: [
          const Icon(Icons.security_rounded, size: 48, color: AppTheme.primaryBlue),
          const SizedBox(height: 8),
          const Text(
            'Zona de Padres 🔒',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          const Text(
            'Para proteger a los niños (COPPA), resuelve esta suma para continuar:',
            style: TextStyle(fontSize: 14, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '¿Cuánto es $_num1 + $_num2?',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlue,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            autofocus: true,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: 'Tu respuesta',
              errorText: _errorMessage,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onSubmitted: (_) => _verifyAnswer(),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: _verifyAnswer,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.emeraldGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text('Ingresar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
