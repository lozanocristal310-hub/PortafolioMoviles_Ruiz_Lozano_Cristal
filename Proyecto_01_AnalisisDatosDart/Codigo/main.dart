// Importa funciones para manejo de archivos
import 'dart:io';

// Importa funciones para trabajar con JSON
import 'dart:convert';


// ================= CLASE =================

// Clase que representa un registro
class Registro {

  // Nombre de la persona
  String nombre;

  // Edad de la persona
  int edad;

  // Salario de la persona
  double salario;

  // Constructor de la clase
  Registro({
    required this.nombre,
    required this.edad,
    required this.salario,
  });

  // Convierte JSON a objeto Registro
  factory Registro.fromJson(Map<String, dynamic> json) {

    return Registro(

      // Obtiene nombre o valor por defecto
      nombre: json['nombre'] ?? 'Desconocido',

      // Obtiene edad o 0
      edad: json['edad'] ?? 0,

      // Obtiene salario o 0
      salario: (json['salario'] ?? 0).toDouble(),
    );
  }

  // Convierte objeto Registro a JSON
  Map<String, dynamic> toJson() {

    return {

      // Guarda nombre
      'nombre': nombre,

      // Guarda edad
      'edad': edad,

      // Guarda salario
      'salario': salario,
    };
  }
}


// ================= CARGAR JSON =================

// Carga datos desde un archivo JSON
List<Registro> cargarDatos(String ruta) {

  try {

    // Abre archivo
    final file = File(ruta);

    // Verifica si existe
    if (!file.existsSync()) {

      print("Error: Archivo no encontrado.");
      return [];
    }

    // Lee contenido del archivo
    final contenido = file.readAsStringSync();

    // Convierte JSON a lista
    final List<dynamic> datos = jsonDecode(contenido);

    // Convierte lista JSON a objetos Registro
    return datos
        .map((e) => Registro.fromJson(e))
        .toList();

  } catch (e) {

    // Muestra error
    print("Error al cargar JSON: $e");
    return [];
  }
}


// ================= MOSTRAR =================

// Muestra registros en consola
void mostrarRegistros(List<Registro> lista) {

  // Verifica si la lista está vacía
  if (lista.isEmpty) {

    print("No hay datos.");
    return;
  }

  // Recorre cada registro
  for (var r in lista) {

    // Muestra información
    print(
      "${r.nombre} | Edad: ${r.edad} | Salario: ${r.salario}"
    );
  }
}


// ================= BUSQUEDAS =================

// Busca registros por nombre
List<Registro> buscarPorNombre(
  List<Registro> lista,
  String nombre,
) {

  return lista
      .where((r) =>

          // Compara nombres sin importar mayúsculas
          r.nombre
              .toLowerCase()
              .contains(nombre.toLowerCase()))
      .toList();
}


// Filtra registros por edad mínima
List<Registro> filtrarPorEdad(
  List<Registro> lista,
  int edadMin,
) {

  return lista
      .where((r) => r.edad >= edadMin)
      .toList();
}


// Filtra registros por salario mínimo
List<Registro> filtrarPorSalario(
  List<Registro> lista,
  double salarioMin,
) {

  return lista
      .where((r) => r.salario >= salarioMin)
      .toList();
}


// ================= ESTADISTICAS =================

// Calcula promedio de salarios
double promedioSalario(List<Registro> lista) {

  // Verifica lista vacía
  if (lista.isEmpty) return 0;

  // Suma salarios
  double suma = lista.fold(
    0,
    (sum, r) => sum + r.salario,
  );

  // Retorna promedio
  return suma / lista.length;
}


// Calcula promedio de edades
double promedioEdad(List<Registro> lista) {

  // Verifica lista vacía
  if (lista.isEmpty) return 0;

  // Suma edades
  double suma = lista.fold(
    0,
    (sum, r) => sum + r.edad,
  );

  // Retorna promedio
  return suma / lista.length;
}


// Obtiene edad mínima
int edadMin(List<Registro> lista) {

  // Verifica lista vacía
  if (lista.isEmpty) return 0;

  // Busca valor menor
  return lista
      .map((r) => r.edad)
      .reduce((a, b) => a < b ? a : b);
}


// Obtiene edad máxima
int edadMax(List<Registro> lista) {

  // Verifica lista vacía
  if (lista.isEmpty) return 0;

  // Busca valor mayor
  return lista
      .map((r) => r.edad)
      .reduce((a, b) => a > b ? a : b);
}


// Obtiene salario mínimo
double salarioMin(List<Registro> lista) {

  // Verifica lista vacía
  if (lista.isEmpty) return 0;

  // Busca salario menor
  return lista
      .map((r) => r.salario)
      .reduce((a, b) => a < b ? a : b);
}


// Obtiene salario máximo
double salarioMax(List<Registro> lista) {

  // Verifica lista vacía
  if (lista.isEmpty) return 0;

  // Busca salario mayor
  return lista
      .map((r) => r.salario)
      .reduce((a, b) => a > b ? a : b);
}


// Cuenta salarios altos
int salariosAltos(List<Registro> lista) {

  return lista
      .where((r) => r.salario >= 7000)
      .length;
}


// Cuenta menores de 30 años
int menores30(List<Registro> lista) {

  return lista
      .where((r) => r.edad < 30)
      .length;
}


// Obtiene total de registros
int totalRegistros(List<Registro> lista) {

  return lista.length;
}


// ================= EXPORTAR =================

// Exporta estadísticas a JSON
void exportarResumen(
  List<Registro> lista,
  String ruta,
) {

  try {

    // Crea archivo
    final file = File(ruta);

    // Mapa con estadísticas
    Map<String, dynamic> resumen = {

      // Total de registros
      'total': totalRegistros(lista),

      // Promedio salario
      'promedio_salario': promedioSalario(lista),

      // Edad mínima
      'edad_min': edadMin(lista),

      // Edad máxima
      'edad_max': edadMax(lista),

      // Promedio edad
      'promedio_edad': promedioEdad(lista),

      // Salario mínimo
      'salario_min': salarioMin(lista),

      // Salario máximo
      'salario_max': salarioMax(lista),

      // Cantidad salarios altos
      'salarios_altos': salariosAltos(lista),

      // Cantidad menores de 30
      'menores_30': menores30(lista),

      // Fecha actual
      'fecha_reporte':
          DateTime.now().toString().split(' ')[0]
    };

    // Guarda JSON en archivo
    file.writeAsStringSync(
      jsonEncode(resumen),
    );

    print("Resumen exportado correctamente.");

  } catch (e) {

    // Muestra error
    print("Error al exportar: $e");
  }
}


// ================= MENU =================

// Menú principal del sistema
void menu(List<Registro> lista) {

  // Ciclo infinito del menú
  while (true) {

    // Opciones del menú
    print('''
===== MENU =====
1. Mostrar registros
2. Buscar por nombre
3. Filtrar por edad
4. Filtrar por salario
5. Ver estadísticas
6. Exportar resumen
0. Salir
''');

    // Lee opción del usuario
    String? opcion = stdin.readLineSync();

    // Evalúa opción
    switch (opcion) {

      // Mostrar registros
      case '1':
        mostrarRegistros(lista);
        break;

      // Buscar por nombre
      case '2':

        print("Ingresa nombre:");

        // Lee nombre
        String? nombre = stdin.readLineSync();

        // Verifica entrada válida
        if (nombre != null && nombre.isNotEmpty) {

          mostrarRegistros(
            buscarPorNombre(lista, nombre),
          );

        } else {

          print("Entrada inválida.");
        }
        break;

      // Filtrar por edad
      case '3':

        print("Edad mínima:");

        // Lee edad
        String? edad = stdin.readLineSync();

        // Convierte a entero
        int? edadInt = int.tryParse(edad ?? '');

        // Verifica valor válido
        if (edadInt != null) {

          mostrarRegistros(
            filtrarPorEdad(lista, edadInt),
          );

        } else {

          print("Edad inválida.");
        }
        break;

      // Filtrar por salario
      case '4':

        print("Salario mínimo:");

        // Lee salario
        String? salario = stdin.readLineSync();

        // Convierte a double
        double? salarioDouble =
            double.tryParse(salario ?? '');

        // Verifica valor válido
        if (salarioDouble != null) {

          mostrarRegistros(
            filtrarPorSalario(
              lista,
              salarioDouble,
            ),
          );

        } else {

          print("Salario inválido.");
        }
        break;

      // Mostrar estadísticas
      case '5':

        print("Total: ${totalRegistros(lista)}");

        print(
          "Promedio salario: ${promedioSalario(lista)}"
        );

        print("Edad mínima: ${edadMin(lista)}");

        print("Edad máxima: ${edadMax(lista)}");

        print(
          "Promedio edad: ${promedioEdad(lista)}"
        );

        break;

      // Exportar resumen
      case '6':

        exportarResumen(
          lista,
          'resumen.json',
        );

        break;

      // Salir del programa
      case '0':

        print("Saliendo...");
        return;

      // Opción incorrecta
      default:

        print("Opción inválida.");
    }
  }
}


// ================= MAIN =================

// Punto de inicio del programa
void main() {

  // Carga datos del archivo JSON
  List<Registro> datos =
      cargarDatos('datos.json');

  // Verifica si se cargaron datos
  if (datos.isEmpty) {

    print("No se pudieron cargar datos.");
    return;
  }

  // Inicia menú principal
  menu(datos);
}