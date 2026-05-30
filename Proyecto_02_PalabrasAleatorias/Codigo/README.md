# Proyecto 2: Aplicación de Flutter (Generador de Palabras y Favoritos)



---



## 1. Objetivo del Proyecto



Desarrollar una aplicación móvil utilizando Flutter que permita generar palabras aleatorias, interactuar con ellas mediante botones, marcarlas como favoritas y visualizarlas en una sección independiente.



Además, la aplicación implementa navegación entre pantallas y diseño responsivo, adaptándose a diferentes tamaños de pantalla para mejorar la experiencia del usuario.



---



## 2. Problema que Resuelve



El desarrollo de aplicaciones móviles modernas requiere interfaces interactivas, organizadas y adaptables. Este proyecto busca resolver la necesidad de comprender la creación de aplicaciones en Flutter que integren generación dinámica de contenido, manejo de estado y navegación entre pantallas.



Asimismo, permite practicar la gestión de información dentro de la aplicación mediante listas dinámicas y la interacción del usuario con la interfaz.



---



## 3. Tecnologías Utilizadas



* **Flutter**  - Framework utilizado para el desarrollo de interfaces móviles multiplataforma.

* **Dart** - Lenguaje de programación utilizado para la lógica de la aplicación.

* **Visual Studio Code** - Entorno de desarrollo utilizado para programar y ejecutar el proyecto.

* **Material Design** - Sistema de diseño utilizado para la construcción de la interfaz.

* **Web Server / Windows (x64)** - Entorno de ejecución utilizado para pruebas de la aplicación.



---



## 4. Conceptos Aplicados



### Widgets en Flutter



Se utilizaron widgets como `Text`, `Row`, `Column`, `Card`, `ElevatedButton`, `Scaffold`, `ListView` y `NavigationRail` para construir la interfaz de la aplicación.



---



### Manejo de Estado



Se implementó el uso de `StatefulWidget` y `setState()` para actualizar dinámicamente la interfaz cuando el usuario genera palabras o modifica favoritos.



---



### Navegación entre Pantallas



Se utilizó un sistema de navegación mediante menú lateral (Navigation Rail), permitiendo alternar entre la pantalla principal y la sección de favoritos.



---



### Diseño Responsivo



Se utilizó `LayoutBuilder` para adaptar la interfaz al tamaño de pantalla, permitiendo que la aplicación funcione correctamente en diferentes resoluciones.



---



### Interacción del Usuario



Se implementaron botones para:



* Generar nuevas palabras (`Next`)

* Marcar como favorito (`Like`)

* Eliminar elementos de favoritos



---



### Manejo de Listas



Se utilizó una lista dinámica (`List`) para almacenar los elementos favoritos y actualizar la interfaz en tiempo real.



---



## 5. Instrucciones de Ejecución



Verificar que Flutter esté instalado:



```bash

flutter --version

```



Ejecutar el proyecto:



```bash

flutter run

```



O en modo web:



```bash

flutter run -d web-server

```



---



## 6. Capturas de Pantalla



### Pantalla Principal



La aplicación muestra una palabra generada aleatoriamente junto con botones de interacción (Like y Next).



![Pantalla Principal](./Capturas/pantalla\_inicio.png)



---



### Navegación entre pantallas



La aplicación permite cambiar entre la pantalla principal y favoritos mediante el menú lateral.



![Navegación](./Capturas/menu.png)



---



### Generación de Palabras



Al presionar el botón “Next”, se genera una nueva combinación de palabras.



![Generación de Palabras](./Capturas/Next.png)



---



### Sistema de Favoritos



El usuario puede marcar palabras como favoritas utilizando el botón de Like.



![Favoritos](./Capturas/Like.png)



---



### Lista de Favoritos



Se muestra una lista independiente con los elementos guardados. Cada elemento incluye un icono de bote de basura para eliminar la palabra si ya no se desea mantener en favoritos.



![Lista de Favoritos](./Capturas/Favorites.png)



---



## 7. Reflexión Personal



### ¿Qué aprendí?



Aprendí a desarrollar interfaces móviles con Flutter, utilizando widgets, manejo de estado, navegación entre pantallas y diseño responsivo. También comprendí cómo estructurar una aplicación modular y reutilizable.



---



### ¿Qué fue difícil?



Lo más complejo fue entender la navegación entre pantallas y la actualización dinámica del estado, especialmente al implementar la lista de favoritos y su sincronización con la interfaz.



---



### ¿Qué mejoraría?



Como mejora futura, integraría almacenamiento local para que los favoritos se mantengan incluso al cerrar la aplicación, además de mejorar el diseño visual con animaciones y una interfaz más profesional.







