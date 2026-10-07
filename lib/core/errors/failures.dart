abstract class Failure {
  final String message;
  const Failure(this.message);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Error en el almacenamiento local.']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Error de conexión con el servidor Supabase.']);
}

class AudioFailure extends Failure {
  const AudioFailure([super.message = 'Error al reproducir el fonema de audio.']);
}
