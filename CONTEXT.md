# Contexto del Proyecto: PokeDex iOS

> **Última actualización:** 07 de Octubre de 2026  
> **Propósito del documento:** Fuente central de verdad del estado actual, arquitectura, dependencias y funcionalidades de la aplicación PokeDex iOS.  
> **Regla de mantenimiento:** Este archivo **debe actualizarse obligatoriamente** cada vez que se agregue, modifique, elimine o refactorice cualquier módulo, pantalla, endpoint o flujo en el proyecto.

---

## 1. Visión General del Proyecto
**PokeDex iOS** es una aplicación desarrollada en **SwiftUI** para dispositivos Apple (iOS 16.2+), que permite a los usuarios explorar el catálogo de Pokémon de la primera generación (151 Pokémon) utilizando la **PokeAPI**, inspeccionar sus detalles y estadísticas, y armar un equipo personalizado de hasta 6 Pokémon.

---

## 2. Ficha Técnica y Entorno
- **Lenguaje:** Swift 5.0
- **Framework UI:** SwiftUI
- **Plataforma objetivo:** iOS 16.2+
- **Concurrencia:** Swift Concurrency (`async/await`, `@MainActor`)
- **Gestión de dependencias:** Swift Package Manager / Bundle Resources
- **Control de calidad:** SwiftLint (`v0.59.0`), SwiftFormat (`v0.63.1`), XCTest

---

## 3. Arquitectura del Proyecto (MVVM + Clean Architecture)

El proyecto sigue una arquitectura **MVVM desacoplada con principios de Clean Architecture**, organizada por *features* y capas de abstracción:

```
PokeDex/
├── Config/                  # Capa de configuración global
│   └── AppConfig.swift      # Modelo tipado y loader para config.json
├── Resources/               # Recursos de configuración
│   └── config.json          # Endpoints, límites, timeouts y URLs base
├── Features/                # Módulos organizados por Clean Architecture
│   └── MainPokemonList/
│       ├── Data/
│       │   ├── RemoteDataManager/     # Conexión HTTP / URLSession
│       │   └── Repository/            # Implementación del repositorio
│       ├── Domain/
│       │   ├── Protocols/             # Interfaces de UseCases y Servicios
│       │   └── UseCases/              # Lógica de negocio (FetchPokemonsUseCase)
│       └── Presentation/
│           ├── ViewModel/             # PokemonListViewModel (@MainActor)
│           └── Views/                 # PokemonListView (SwiftUI)
├── Models/                  # Modelos de dominio y DTOs (PokemonResult, PokemonDetail, etc.)
├── Services/                # Servicios transversales (TeamManager, PokemonService)
├── Views/                   # Vistas comunes (PokemonDetailView, StatView, PokemonRowView, PokemonTeamView)
├── ViewModels/              # ViewModels de vistas transversales (PokemonDetailViewModel)
└── PokeDexApp.swift         # Punto de entrada de la aplicación
```

### Reglas de las Capas:
1. **Presentation Layer (Views y ViewModels):**
   - Vistas declarativas en SwiftUI.
   - `ViewModel` hereda de `ObservableObject` y está anotado con `@MainActor`.
   - El ViewModel se comunica **únicamente con Casos de Uso (Domain)** a través de protocolos, nunca directamente con el repositorio o data managers.
2. **Domain Layer (Lógica de Negocio):**
   - Casos de uso (`UseCase`) que orquestan una acción específica (e.g. `FetchPokemonsUseCase`).
   - Define los protocolos que la capa de datos debe implementar (Inversión de Dependencias).
   - Es agnóstica a frameworks de UI y red.
3. **Data Layer (Acceso a Datos):**
   - `Repository`: Orquesta fuentes de datos remotas y locales.
   - `RemoteDataManager`: Consume la API REST utilizando las URLs generadas por `AppConfig.shared`.

---

## 4. Funcionalidades y Pantallas Actuales

### 4.1. Pantalla Principal (`ContentView` - TabView)
- **Tab 1: Pokédex (`PokemonListView`)**
  - Muestra una lista de Pokémon cargados desde PokeAPI.
  - Barra de búsqueda interactiva (`.searchable`) que filtra los Pokémon localmente por nombre en tiempo real.
  - Indicador de carga (`ProgressView`) y manejo de errores con mensajes amigables.
  - Celda de Pokémon (`PokemonRowView`) con carga asíncrona de sprites oficiales.
- **Tab 2: Equipo Pokémon (`PokemonTeamView`)**
  - Lista de los Pokémon seleccionados en el equipo actual.
  - Administrado por `TeamManager` inyectado como `@EnvironmentObject`.
  - Capacidad máxima: 6 Pokémon.
  - Opción de eliminar Pokémon del equipo.

### 4.2. Vista de Detalle (`PokemonDetailView`)
- Navegación al tocar un Pokémon de la lista.
- Muestra imagen en alta resolución, nombre, tipos elementales estilizados (`PokemonType`).
- Barra de estadísticas visuales (`StatView`) para HP, Attack, Defense, Special Attack, Special Defense y Speed.
- Botón para agregar o quitar al Pokémon del equipo activo.

---

## 5. Configuración Global (`AppConfig` y `config.json`)

Toda constante de red y entorno está centralizada en:
- **`PokeDex/Resources/config.json`**:
  - `api.baseURL`: `"https://pokeapi.co/api/v2"`
  - `api.pokemonPath`: `"/pokemon"`
  - `api.defaultLimit`: `151`
  - `api.timeoutInterval`: `30.0`
  - `sprites.baseURL`: `"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon"`
- **`AppConfig.shared`**: Instancia singleton accesible globalmente que expone:
  - `pokemonListURL: URL?`
  - `spriteURL(for: Int) -> URL?`
  - Fallback automático a `AppConfig.defaultConfiguration` si el archivo no está en el bundle.

---

## 6. Pruebas Unitarias (`PokeDexTests`)

Ubicación: `PokeDexTests/`
- **`AppConfigTests.swift`**: Pruebas de carga, decodificación JSON, fallback y formateo de URLs.
- **`PokeDexTests.swift`**: Pruebas unitarias de `PokemonListViewModel` utilizando `MockFetchPokemonsUseCase` para flujos de éxito, fallo y filtrado de búsqueda.

---

## 7. Verificación de Código y Calidad
- **Script unificado:** [`lint.sh`](file:///Users/carlos/Documents/GitHub/Pokedex-ios/lint.sh)
  - `./lint.sh`: Verifica formato y reglas de SwiftLint sin alterar código.
  - `./lint.sh --fix`: Aplica corrección automática de formato.
  - `./lint.sh --install-hook`: Instala el pre-commit hook en `.git/hooks/pre-commit`.

---

## 8. Flujo de Pull Requests y Automatización de Agente
- **Blueprint Estándar de Pull Request:** [`.github/pull_request_template.md`](file:///Users/carlos/Documents/GitHub/Pokedex-ios/.github/pull_request_template.md)
  - Plantilla obligatoria en GitHub con resumen, clasificación de capas MVVM + Clean Architecture, checklist de calidad y sección de evidencias.
- **Skill de Agente Antigravity:** [`.agents/skills/pull-request/SKILL.md`](file:///Users/carlos/Documents/GitHub/Pokedex-ios/.agents/skills/pull-request/SKILL.md)
  - Procedimiento automatizado en 4 fases para validar branches, ejecutar quality gates, hacer commit semántico y generar el PR.
- **Script de Validación Pre-PR:** [`.agents/skills/pull-request/scripts/verify_pr.sh`](file:///Users/carlos/Documents/GitHub/Pokedex-ios/.agents/skills/pull-request/scripts/verify_pr.sh)
  - Ejecuta validación consolidada de linteo (`lint.sh`), tests unitarios y comprobación de actualización de `CONTEXT.md`.

