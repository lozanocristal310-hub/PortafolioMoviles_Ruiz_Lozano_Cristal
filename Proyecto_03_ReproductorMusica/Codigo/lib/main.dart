// Importa los widgets principales de Flutter
import 'package:flutter/material.dart';

// Importa la pantalla principal del reproductor
import 'music_player_screen.dart';

// Función principal que inicia la aplicación
void main() {
  runApp(const MusicPlayerApp());
}

// Widget principal de la aplicación
class MusicPlayerApp extends StatelessWidget {
  const MusicPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Oculta la etiqueta de DEBUG
      debugShowCheckedModeBanner: false,

      // Nombre de la aplicación
      title: 'Music Player',

      // Pantalla principal que se mostrará al iniciar
      home: const MusicPlayerScreen(),
    );
  }
}
