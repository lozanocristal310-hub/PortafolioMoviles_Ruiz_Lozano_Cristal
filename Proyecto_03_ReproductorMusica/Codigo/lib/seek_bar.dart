// Importa los widgets de Flutter
import 'package:flutter/material.dart';

// Widget personalizado para la barra de reproducción
class SeekBar extends StatelessWidget {

  // Duración total de la canción
  final Duration duration;

  // Posición actual del audio
  final Duration position;

  // Parte del audio cargada en memoria
  final Duration bufferedPosition;

  // Evento que detecta cambios en la barra
  final ValueChanged<Duration>? onChangeEnd;

  // Constructor de la clase
  SeekBar({
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChangeEnd
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // Barra deslizante de reproducción
        Slider(
          activeColor: Colors.yellow,
          inactiveColor: Colors.grey,

          // Valor mínimo y máximo de la barra
          min: 0.0,
          max: duration.inMilliseconds.toDouble(),

          // Posición actual de la canción
          value: position.inMilliseconds
              .toDouble()
              .clamp(
                0.0,
                duration.inMilliseconds.toDouble(),
              ),

          // Cambia la posición del audio
          onChanged: (value) {
            onChangeEnd?.call(
              Duration(milliseconds: value.round())
            );
          },
        ),

        // Muestra el tiempo actual y duración total
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [

            // Tiempo actual
            Text(
              _formatDuration(position),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),

            // Duración total
            Text(
              _formatDuration(duration),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Convierte la duración al formato minutos:segundos
  String _formatDuration(Duration duration) {

    String twoDigits(int n) =>
        n.toString().padLeft(2, '0');

    final minutes =
        twoDigits(duration.inMinutes.remainder(60));

    final seconds =
        twoDigits(duration.inSeconds.remainder(60));

    return '$minutes:$seconds';
  }
}