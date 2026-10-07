# Reglas de Proyecto y Directrices de IA: PokeDex iOS

Este documento define los estándares arquitectónicos, directrices de desarrollo, flujo de trabajo y reglas obligatorias para el desarrollo en el proyecto **PokeDex iOS**. La IA asistente y cualquier contribuidor deben apegarse estrictamente a estas directrices en cada tarea.

---

## 1. Arquitectura Obligatoria: MVVM + Clean Architecture

El proyecto implementa estrictamente **MVVM combinado con Clean Architecture**, separando las responsabilidades en capas claramente delimitadas e independientes:

```
[ SwiftUI View ]  -->  [ ViewModel (@MainActor) ]  -->  [ Use Case (Protocol) ]  -->  [ Repository (Protocol) ]  -->  [ Data Manager (Remote / Local) ]
```

### 1.1. Capa de Presentación (Presentation)
- **Vistas (Views):** Vistas declarativas en SwiftUI. Su única responsabilidad es renderizar la interfaz y emitir acciones de usuario al ViewModel. **Nunca** deben contener lógica de negocio ni llamar a repositorios o data managers directamente.
- **ViewModels:**
  - Deben implementar `ObservableObject` y estar anotados con `@MainActor`.
  - Publican estado mediante `@Published`.
  - Reciben sus dependencias (**Casos de Uso**) a través del inicializador (`init`) inyectadas como **protocolos**.
  - Gestionan estados de carga (`isLoading`), resultados (`data`) y errores (`errorMessage`).

### 1.2. Capa de Dominio (Domain)
- Es el núcleo de la lógica de negocio y debe ser **completamente independiente** de frameworks de UI (`SwiftUI`, `UIKit`) y librerías externas.
- **Casos de Uso (Use Cases):** Cada caso de uso debe tener una única responsabilidad clara (Single Responsibility Principle) y exponer un protocolo con una función de ejecución (e.g. `execute() async throws -> [Entity]`).
- **Protocolos de Dominio:** Define las interfaces que la capa de datos debe implementar (Inversión de Dependencias).
- **Entidades de Dominio:** Modelos puros que representan los conceptos del negocio.

### 1.3. Capa de Datos (Data)
- **Repositorios (Repositories):** Implementan los protocolos definidos en el Dominio. Deciden si los datos provienen de fuentes remotas, caché local o almacenamiento persistente.
- **Data Managers:**
  - `RemoteDataManager`: Encapsula llamadas de red con `URLSession`.
  - `LocalDataManager`: Encapsula almacenamiento local si aplica.
- **DTOs / Modelos de Red:** Deben implementar `Codable` y mapearse a las entidades de dominio correspondientes.

### 1.4. Inversión de Dependencias
- Toda dependencia entre capas debe realizarse mediante **protocolos / interfaces**.
- Está prohibido el acoplamiento directo a implementaciones concretas para garantizar la testabilidad del sistema.

---

## 2. Pruebas Unitarias Obligatorias ("Todo lo que se toca debe tener pruebas")

> [!IMPORTANT]
> **Regla de Oro:** Cualquier componente nuevo o modificado (ViewModel, Caso de Uso, Repositorio, Servicio o Utilidad) **debe contar obligatoriamente con sus pruebas unitarias correspondientes** en el target `PokeDexTests`.

### Requisitos de Pruebas:
1. **Aislamiento mediante Mocks:** Toda prueba debe usar mocks basados en los protocolos del componente bajo prueba (e.g., `MockFetchPokemonsUseCase`).
2. **Cobertura de escenarios:**
   - Camino exitoso (Happy path).
   - Manejo de errores y fallos de red/decodificación.
   - Casos límite (filtros vacíos, datos nulos, colecciones vacías).
3. **ViewModels en Tests:** Las pruebas que interactúen con ViewModels deben estar marcadas con `@MainActor`.
4. **Nomenclatura:** Formato descriptivo BDD: `test_[método]_[escenario]_[resultadoEsperado]()`.

---

## 3. Mantenimiento Obligatorio de `CONTEXT.md`

> [!WARNING]
> El archivo [`CONTEXT.md`](file:///Users/carlos/Documents/GitHub/Pokedex-ios/CONTEXT.md) es la fuente de verdad viva del estado de la aplicación.
> **Cada vez que se introduzca un cambio funcional, nueva pantalla, modificación en la arquitectura, adición de endpoints o ajuste en modelos, es OBLIGATORIO actualizar `CONTEXT.md` antes de dar la tarea por concluida.**

El archivo `CONTEXT.md` debe reflejar siempre:
- Pantallas activas y su comportamiento.
- Estado de la arquitectura y carpetas.
- Endpoints y configuraciones activas.
- Suites de pruebas y herramientas de calidad disponibles.

---

## 4. Verificación Obligatoria Antes de Subir o Commitear Cambios

> [!CAUTION]
> **Ningún cambio puede considerarse terminado ni subirse al repositorio sin haber verificado localmente que las pruebas pasen y el código cumpla con los estándares de estilo.**

### Flujo de Verificación Pre-Commit:
1. **Ejecutar Pruebas Automatizadas:**
   ```bash
   DEVELOPER_DIR="/Applications/Xcode14_2.app/Contents/Developer" xcodebuild test \
     -scheme PokeDex \
     -destination 'platform=iOS Simulator,OS=16.2,name=iPhone 14' \
     CODE_SIGNING_ALLOWED=NO -quiet
   ```
   *Todas las pruebas deben finalizar en `** TEST SUCCEEDED **`.*

2. **Ejecutar Linter y Formato:**
   ```bash
   # Revisar estado de formato y estilo
   ./lint.sh

   # Corregir automáticamente violaciones de estilo detectadas
   ./lint.sh --fix
   ```

3. **Revisión de Git:**
   Asegurarse de que no queden archivos temporales o de depuración sin rastrear.

---

## 5. Gestión Centralizada de Configuración y Red

- **Cero URLs Hardcodeadas:** Está estrictamente prohibido escribir URLs, endpoints, timeouts o límites directamente en el código de Swift.
- Todas las constantes de red y entorno deben residir en [`PokeDex/Resources/config.json`](file:///Users/carlos/Documents/GitHub/Pokedex-ios/PokeDex/Resources/config.json).
- El acceso debe realizarse a través de la capa tipada [`AppConfig.shared`](file:///Users/carlos/Documents/GitHub/Pokedex-ios/PokeDex/Config/AppConfig.swift).

---

## 6. Estándares de Código Swift

- **Versión de Swift:** Swift 5.0 compatible con iOS 16.2+.
- **Sin Force Unwrapping:** Evitar el uso de `!` (`force unwrap` o `force cast`), excepto en `XCTUnwrap` o `@IBOutlet` si aplicase. Usar siempre `guard let`, `if let` o valores por defecto.
- **Concurrencia Moderna:** Priorizar `async/await` estructurado sobre completion handlers con closures.
- **Inmutabilidad:** Usar `let` por defecto; recurrir a `var` únicamente cuando la mutación sea indispensable.
