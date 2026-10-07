import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../progress/presentation/providers/progress_provider.dart';

class ParentDashboardPage extends StatelessWidget {
  const ParentDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final progressProvider = Provider.of<ProgressProvider>(context);
    final progress = progressProvider.progress;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Padres y Progreso 📊'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF3C4),
                        shape: BoxShape.circle,
                      ),
                      child: const Text('⭐', style: TextStyle(fontSize: 32)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${progress.totalStars} Estrellas Ganadas',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkSlate,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Niveles desbloqueados: ${progress.unlockedLevelIds.length} / 10',
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Sincronización en la Nube (Supabase)',
              style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              color: Colors.white,
              child: ListTile(
                leading: Icon(
                  progress.isSyncedWithCloud ? Icons.cloud_done : Icons.cloud_queue,
                  color: progress.isSyncedWithCloud ? AppTheme.emeraldGreen : AppTheme.warmOrange,
                  size: 32,
                ),
                title: Text(
                  progress.isSyncedWithCloud
                      ? 'Progreso Sincronizado en la Nube'
                      : 'Guardado Localmente (Offline-First)',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  progress.isSyncedWithCloud
                      ? 'Tus datos están respaldados en Supabase.'
                      : 'Los datos están locales. Toca para sincronizar con la nube.',
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    progressProvider.syncCloud();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('¡Sincronización ejecutuada vía SyncProgressUseCase! ☁️'),
                        backgroundColor: AppTheme.emeraldGreen,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Sincronizar'),
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Sostenibilidad y Apoyo al Ministerio 🕊️',
              style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SilaBiblia es 100% Gratuito y Libre de Anuncios',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'No mostramos publicidad de terceros ni cobramos suscripciones a las familias. Si deseas apoyar el desarrollo continuo de nuevos mundos fonéticos y narrativas bíblicas, puedes realizar una donación voluntaria.',
                    style: TextStyle(fontSize: 14, color: Colors.black70),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Redirigiendo a enlace de donación voluntaria (Stripe/Buy Me a Coffee)...'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.favorite, color: Colors.redAccent),
                    label: const Text('Apoyar el proyecto con una donación'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.darkSlate,
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
