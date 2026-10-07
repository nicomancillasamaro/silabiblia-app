import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/audio/sound_service.dart';
import 'core/theme/app_theme.dart';
import 'features/levels/presentation/pages/level_map_page.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Clean Architecture Dependency Injection Setup
  await InjectionContainer.init();

  // Precarga de audio para latencia cero
  await SoundService().preloadPhonemes();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: InjectionContainer.levelsProvider),
        ChangeNotifierProvider.value(value: InjectionContainer.progressProvider),
      ],
      child: const SilaBibliaApp(),
    ),
  );
}

class SilaBibliaApp extends StatelessWidget {
  const SilaBibliaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SilaBiblia - Clean Architecture',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LevelMapPage(),
    );
  }
}
