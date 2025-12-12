# Pokédex App

Proyecto Flutter que consume la PokeAPI para mostrar un listado de Pokémon, su detalle y una sección de “Mi Pokédex” donde se pueden capturar, editar y liberar Pokémon de forma local.

---

## Características principales

- Listado paginado de Pokémon obtenido desde la [PokeAPI](https://pokeapi.co/).
- Vista de detalle con:
  - Imagen del Pokémon.
  - ID, nombre, tipos, altura, peso.
  - Estadísticas base (HP, Attack, Defense, etc.).
- Sección “My pokedex” (CRUD local):
  - Capturar un Pokémon desde la vista de detalle (Create).
  - Listar todos los Pokémon capturados (Read).
  - Editar nickname y notas (Update).
  - Liberar un Pokémon (Delete).
- Manejo de estado con Riverpod.
- Consumo HTTP con Dio.
- Navegación declarativa con go_router.
- Íconos de app generados con flutter_launcher_icons.
- Splash screen nativo con flutter_native_splash.

---

## Mejoras funcionales

- Búsqueda y filtros:
  - Buscar Pokémon por nombre/ID.
  - Filtrar por tipo.
- Vista offline:
  - Cachear lista y detalles con una base de datos local (por ejemplo, Isar) para uso sin conexión.
- Comparación de pokemones:
  - Comparar estadisticas entre pokemones capturados 
- Animaciones:
  - Animaciones al capturar o liberar un Pokémon.
- Pruebas:
  - Unit tests de repositorios.
  - Widget tests para las pantallas principales.

---

## Estimación de esfuerzo

Aproximadamente 3–4 días hábiles de trabajo.

---

## Pasos para ejecutar la app

- Clonar el repositorio:

  - git clone https://github.com/e-3rnesto/pokedex.git

- Instalar dependencias:
  - flutter pub get

- (Opcional, solo si modificaste íconos o splash) Regenerar recursos:

  - dart run flutter_launcher_icons
  - dart run flutter_native_splash:create