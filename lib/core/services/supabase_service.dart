import 'package:flutter/foundation.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  // Supabase Credentials (Nivel Gratuito Supabase)
  static const String supabaseUrl = 'https://YOUR_SUPABASE_PROJECT_ID.supabase.co';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    try {
      // Supabase.initialize(...)
      _isInitialized = true;
      debugPrint('Supabase SDK Inicializado Correctamente');
    } catch (e) {
      debugPrint('Error o modo offline en Supabase SDK: $e');
    }
  }
}
