// Importa librería para generar palabras aleatorias
import 'package:english_words/english_words.dart';

// Importa los widgets principales de Flutter
import 'package:flutter/material.dart';

// Importa Provider para manejo de estado
import 'package:provider/provider.dart';


// Punto de inicio de la aplicación
void main() {
  runApp(MyApp());
}


// Widget principal de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // Provider para compartir el estado global
    return ChangeNotifierProvider(

      // Crea el estado principal de la app
      create: (context) => MyAppState(),

      child: MaterialApp(

        // Título de la aplicación
        title: 'Namer App',

        // Tema principal
        theme: ThemeData(
          useMaterial3: true,

          // Colores de la app
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 49, 204, 85),
          ),
        ),

        // Página inicial
        home: MyHomePage(),
      ),
    );
  }
}


// Clase que controla el estado de la aplicación
class MyAppState extends ChangeNotifier {

  // Palabra actual aleatoria
  var current = WordPair.random();

  // Genera una nueva palabra
  void getNext() {
    current = WordPair.random();

    // Actualiza la interfaz
    notifyListeners();
  }

  // Lista de favoritos
  var favorites = <WordPair>[];

  // Agrega o elimina favoritos
  void toggleFavorite() {

    // Si ya existe, la elimina
    if (favorites.contains(current)) {
      favorites.remove(current);

    // Si no existe, la agrega
    } else {
      favorites.add(current);
    }

    // Actualiza la interfaz
    notifyListeners();
  }

  // Elimina un favorito específico
  void removeFavorite(WordPair pair) {
    favorites.remove(pair);

    // Refresca la pantalla
    notifyListeners();
  }
}


// Página principal con navegación
class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


// Estado de la página principal
class _MyHomePageState extends State<MyHomePage> {

  // Índice de navegación seleccionado
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    // Variable para almacenar la página actual
    Widget page;

    // Cambia entre páginas
    switch (selectedIndex) {

      // Página principal
      case 0:
        page = GeneratorPage();
        break;

      // Página de favoritos
      case 1:
        page = FavoritesPage();
        break;

      // Error si no existe la página
      default:
        throw UnimplementedError(
          'no widget for selectedIndex'
        );
    }

    // Adaptación del diseño según tamaño de pantalla
    return LayoutBuilder(
      builder: (context, constraints) {

        return Scaffold(

          body: Row(
            children: [

              // Área segura de navegación
              SafeArea(

                child: NavigationRail(

                  // Expande menú en pantallas grandes
                  extended: constraints.maxWidth >= 600,

                  // Opciones del menú
                  destinations: [

                    // Botón Home
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),

                    // Botón Favorites
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],

                  // Índice seleccionado
                  selectedIndex: selectedIndex,

                  // Cambia de página
                  onDestinationSelected: (value) {

                    setState(() {

                      // Actualiza índice
                      selectedIndex = value;
                    });
                  },
                ),
              ),

              // Contenido principal
              Expanded(
                child: Container(

                  // Color de fondo
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer,

                  // Página actual
                  child: page,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


// Página para generar palabras
class GeneratorPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    // Obtiene el estado actual
    var appState = context.watch<MyAppState>();

    // Obtiene la palabra actual
    var pair = appState.current;

    // Icono dinámico
    IconData icon;

    // Verifica si está en favoritos
    if (appState.favorites.contains(pair)) {

      // Corazón lleno
      icon = Icons.favorite;

    } else {

      // Corazón vacío
      icon = Icons.favorite_border;
    }

    return Center(

      child: Column(

        // Centra verticalmente
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          // Tarjeta grande con palabra
          BigCard(pair: pair),

          SizedBox(height: 10),

          Row(

            // Ajusta tamaño mínimo
            mainAxisSize: MainAxisSize.min,

            children: [

              // Botón Like
              ElevatedButton.icon(

                onPressed: () {

                  // Agrega o quita favorito
                  appState.toggleFavorite();
                },

                // Icono dinámico
                icon: Icon(icon),

                // Texto del botón
                label: Text('Like'),
              ),

              SizedBox(width: 10),

              // Botón Next
              ElevatedButton(

                onPressed: () {

                  // Genera nueva palabra
                  appState.getNext();
                },

                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


// Página de favoritos
class FavoritesPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    // Obtiene el estado actual
    var appState = context.watch<MyAppState>();

    // Lista de favoritos
    var favorites = appState.favorites;

    // Si no hay favoritos
    if (favorites.isEmpty) {

      return Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            // Icono vacío
            Icon(Icons.favorite_border, size: 60),

            SizedBox(height: 10),

            // Mensaje
            Text(
              'No favorites yet 💔',

              style: Theme.of(context)
                  .textTheme
                  .titleMedium,
            ),
          ],
        ),
      );
    }

    // Lista de favoritos
    return Column(
      children: [

        // Texto superior
        Padding(
          padding: const EdgeInsets.all(16),

          child: Text(

            // Cantidad de favoritos
            'You have ${favorites.length} favorites ❤️',

            style: Theme.of(context)
                .textTheme
                .titleLarge,
          ),
        ),

        // Lista expandible
        Expanded(

          child: ListView.builder(

            // Cantidad de elementos
            itemCount: favorites.length,

            itemBuilder: (context, index) {

              // Obtiene favorito actual
              var pair = favorites[index];

              return Card(

                // Márgenes de la tarjeta
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),

                child: ListTile(

                  // Icono lateral
                  leading: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),

                  // Texto principal
                  title: Text(
                    pair.asLowerCase,

                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Texto secundario
                  subtitle: Text(
                    "${pair.first} ${pair.second}",
                  ),

                  // Icono de eliminar
                  trailing: Icon(Icons.delete),

                  // Elimina favorito al tocar
                  onTap: () {
                    appState.removeFavorite(pair);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}


// Widget de tarjeta grande
class BigCard extends StatelessWidget {

  const BigCard({
    super.key,

    // Palabra recibida
    required this.pair,
  });

  // Variable de palabra
  final WordPair pair;

  @override
  Widget build(BuildContext context) {

    // Obtiene el tema actual
    final theme = Theme.of(context);

    // Estilo del texto
    final style = theme.textTheme.displayMedium!.copyWith(

      // Color del texto
      color: theme.colorScheme.onPrimary,
    );

    return Card(

      // Color de la tarjeta
      color: theme.colorScheme.primary,

      child: Padding(

        // Espaciado interno
        padding: const EdgeInsets.all(20),

        child: Text(

          // Muestra palabra en minúsculas
          pair.asLowerCase,

          // Estilo del texto
          style: style,

          // Lectura accesible
          semanticsLabel:
              "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}