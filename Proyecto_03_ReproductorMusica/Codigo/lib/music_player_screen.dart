// Librerías utilizadas para matemáticas y efectos visuales
import 'dart:math';
import 'dart:ui';

// Librerías principales de Flutter y reproducción de audio
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

// Archivos personalizados del proyecto
import 'package:musicplayer/position_data.dart';
import 'package:musicplayer/seek_bar.dart';

// Librería utilizada para combinar streams
import 'package:rxdart/rxdart.dart';

// Pantalla principal del reproductor
class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() =>
      _MusicPlayerScreenState();
}

// Clase principal que controla la lógica y la interfaz
class _MusicPlayerScreenState
    extends State<MusicPlayerScreen>
    with SingleTickerProviderStateMixin {

  // Reproductor de audio
  late AudioPlayer _audioPlayer;

  // Lista de reproducción
  late ConcatenatingAudioSource playlistSource;

  // Controlador de animación para girar el disco
  late AnimationController _rotationController;

  // Estado de reproducción
  bool isPlaying = false;

  // Índice de la canción actual
  int currentIndex = 0;

  // Lista de canciones
  final List<Map<String, String>> playlist = [
    {
      'title': 'Un Verano Sin Ti',
      'artist': 'Bad Bunny',
      'audio': 'assets/audio/Un Verano Sin Ti.mp3',
      'image': 'assets/images/cover1.png',
    },
    {
      'title': 'Viento',
      'artist': 'Caifanes',
      'audio': 'assets/audio/Viento.mp3',
      'image': 'assets/images/cover2.jpg',
    },
    {
      'title': 'Mariposa Traicionera',
      'artist': 'Mana',
      'audio': 'assets/audio/Mariposa Traicionera.mp3',
      'image': 'assets/images/cover3.jpg',
    },
    {
      'title': 'Ya Borracho',
      'artist': 'Herencia De Grandes',
      'audio': 'assets/audio/Ya Borracho.mp3',
      'image': 'assets/images/cover4.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();

    // Inicialización del reproductor
    _audioPlayer = AudioPlayer();

    // Configuración de la animación del disco
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );

    // Creación de la lista de reproducción
    playlistSource = ConcatenatingAudioSource(
      children: playlist.map((song) {
        return AudioSource.asset(song['audio']!);
      }).toList(),
    );

    // Inicializa el reproductor
    _initializePlayer();
  }

  // Configuración inicial del reproductor
  Future<void> _initializePlayer() async {
    try {

      // Carga la lista de canciones
      await _audioPlayer.setAudioSource(
        playlistSource,
        initialIndex: currentIndex,
      );

      // Detecta cambios de canción
      _audioPlayer.currentIndexStream.listen((index) {
        if (index != null) {
          setState(() {
            currentIndex = index;
          });
        }
      });

      // Detecta si la música está reproduciéndose
      _audioPlayer.playerStateStream.listen((state) {
        setState(() {
          isPlaying = state.playing;
        });

        // Inicia o detiene la animación del disco
        if (state.playing) {
          _rotationController.repeat();
        } else {
          _rotationController.stop();
        }
      });
    } catch (e) {

      // Muestra errores en consola
      print("Error initializing player: $e");
    }
  }

  // Función Play / Pause
  Future<void> _playPause() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  // Cambia a la siguiente canción
  Future<void> _nextSong() async {
    await _audioPlayer.seekToNext();
    await _audioPlayer.play();
  }

  // Regresa a la canción anterior
  Future<void> _previousSong() async {
    await _audioPlayer.seekToPrevious();
    await _audioPlayer.play();
  }

  // Stream que actualiza la barra de progreso
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream.map(
          (duration) => duration ?? Duration.zero,
        ),
        (position, bufferedPosition, duration) =>
            PositionData(
              position,
              bufferedPosition,
              duration ?? Duration.zero,
            ),
      );

  @override
  void dispose() {

    // Libera recursos utilizados
    _rotationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // Obtiene la canción actual
    final currentSong = playlist[currentIndex];

    return Scaffold(

      // Color principal de fondo
      backgroundColor: const Color(0xFF121212),

      body: SafeArea(
        child: Container(

          // Fondo con degradado
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0D0D0D),
                Color(0xFF1A1A1A),
                Color(0xFF24123A),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),

          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),

            child: Column(
              children: [

                const SizedBox(height: 10),

                // Título principal
                const Text(
                  "HEARME",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 6,
                  ),
                ),

                const SizedBox(height: 40),

                // Área del disco animado
                Expanded(
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _rotationController,
                      builder: (context, child) {

                        // Rotación del disco
                        return Transform.rotate(
                          angle:
                              _rotationController.value *
                              2 *
                              pi,

                          child: Stack(
                            alignment: Alignment.center,
                            children: [

                              // Disco principal
                              Container(
                                width: 360,
                                height: 360,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.grey.shade900,
                                      Colors.black,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors
                                          .deepPurple
                                          .withOpacity(0.45),
                                      blurRadius: 50,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                              ),

                              // Borde decorativo
                              Container(
                                width: 340,
                                height: 340,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white10,
                                    width: 2,
                                  ),
                                ),
                              ),

                              // Imagen de la canción
                              Container(
                                width: 320,
                                height: 320,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage(
                                      currentSong['image']!,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.5),
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                              ),

                              // Centro del disco
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white
                                          .withOpacity(0.4),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Nombre de la canción
                Text(
                  currentSong['title']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // Nombre del artista
                Text(
                  currentSong['artist']!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 35),

                // Contenedor de la barra de progreso
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white10,
                    ),
                  ),

                  // Actualiza la barra en tiempo real
                  child: StreamBuilder<PositionData>(
                    stream: _positionDataStream,
                    builder: (context, snapshot) {

                      final positionData = snapshot.data;

                      return SeekBar(
                        duration:
                            positionData?.duration ??
                            Duration.zero,

                        position:
                            positionData?.position ??
                            Duration.zero,

                        bufferedPosition:
                            positionData?.bufferedPosition ??
                            Duration.zero,

                        onChangeEnd: _audioPlayer.seek,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 40),

                // Área de botones con efecto glassmorphism
                ClipRRect(
                  borderRadius: BorderRadius.circular(35),

                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 10,
                      sigmaY: 10,
                    ),

                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 18,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius:
                            BorderRadius.circular(35),

                        border: Border.all(
                          color: Colors.white10,
                        ),
                      ),

                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceAround,

                        children: [

                          // Botón canción anterior
                          IconButton(
                            onPressed: _previousSong,
                            icon: const Icon(
                              Icons.skip_previous_rounded,
                              color: Colors.white,
                              size: 45,
                            ),
                          ),

                          // Botón Play / Pause
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,

                              gradient: const LinearGradient(
                                colors: [
                                  Colors.deepPurple,
                                  Colors.purpleAccent,
                                ],
                              ),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors
                                      .deepPurpleAccent
                                      .withOpacity(0.6),
                                  blurRadius: 25,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),

                            child: IconButton(
                              padding:
                                  const EdgeInsets.all(18),

                              onPressed: _playPause,

                              icon: Icon(
                                isPlaying
                                    ? Icons.pause_rounded
                                    : Icons
                                        .play_arrow_rounded,

                                color: Colors.white,
                                size: 42,
                              ),
                            ),
                          ),

                          // Botón siguiente canción
                          IconButton(
                            onPressed: _nextSong,
                            icon: const Icon(
                              Icons.skip_next_rounded,
                              color: Colors.white,
                              size: 45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}