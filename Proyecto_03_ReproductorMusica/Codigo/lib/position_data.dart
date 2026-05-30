// Clase que almacena información sobre la reproducción del audio
class PositionData {

  // Tiempo actual de reproducción
  final Duration position;

  // Parte del audio que ya fue cargada
  final Duration bufferedPosition;

  // Duración total de la canción
  final Duration duration;

  // Constructor de la clase
  PositionData(
    this.position,
    this.bufferedPosition,
    this.duration,
  );
}