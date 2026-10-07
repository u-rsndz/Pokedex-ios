---
name: pull-request
description: >-
  Prepara, valida y crea Pull Requests asegurando el cumplimiento de Clean Architecture,
  ejecución de pruebas unitarias, linteo con ./lint.sh, actualización de CONTEXT.md
  y generación del cuerpo del PR según el blueprint oficial. Usar siempre que el usuario
  solicite abrir, subir o preparar un Pull Request o PR.
---

# Procedimiento de Creación de Pull Requests (PokeDex iOS)

Este skill define el procedimiento estricto para preparar, validar y publicar Pull Requests en el proyecto PokeDex iOS, garantizando las normas de arquitectura, pruebas y calidad establecidas en [`GEMINI.md`](../../../GEMINI.md).

## Flujo de Ejecución

### Fase 1: Auditoría de Estado y Rama de Trabajo
1. Ejecuta `git status` y `git branch --show-current`.
2. **Validación de rama**: Nunca abras un PR directo desde la rama `main`.
   - Si estás en `main`, crea y cambia a una rama de trabajo adecuada:
     - `feature/<nombre-descriptivo>`
     - `fix/<nombre-descriptivo>`
     - `refactor/<nombre-descriptivo>`
     - `test/<nombre-descriptivo>`
     - `docs/<nombre-descriptivo>`
3. Analiza los cambios pendientes (`git diff --stat`) para determinar el alcance del PR.

### Fase 2: Quality Gates Obligatorios (GEMINI.md)
Ejecuta las validaciones de calidad antes de realizar commits o push. Puedes utilizar el script auxiliar `./.agents/skills/pull-request/scripts/verify_pr.sh` o ejecutar los pasos individualmente:

1. **Linter y Formato**:
   - Ejecuta `./lint.sh`.
   - Si se detectan violaciones corregibles automáticamente, ejecuta `./lint.sh --fix` y vuelve a validar.
2. **Pruebas Unitarias Obligatorias**:
   - Revisa si hay nuevos componentes o componentes modificados (ViewModels, Use Cases, Repositorios, Servicios).
   - Verifica que cada uno cuente con pruebas unitarias en `PokeDexTests` utilizando Mocks basados en protocolos.
   - Ejecuta la suite de pruebas del proyecto:
     ```bash
     DEVELOPER_DIR="/Applications/Xcode14_2.app/Contents/Developer" xcodebuild test \
       -scheme PokeDex \
       -destination 'platform=iOS Simulator,OS=16.2,name=iPhone 14' \
       CODE_SIGNING_ALLOWED=NO -quiet
     ```
   - Confirma que la salida finalice en `** TEST SUCCEEDED **`.
3. **Mantenimiento Obligatorio de CONTEXT.md**:
   - Verifica si los cambios introducen nuevas pantallas, casos de uso, configuraciones, endpoints o dependencias.
   - Si hubo modificaciones, actualiza [`CONTEXT.md`](../../../CONTEXT.md) antes de continuar.
4. **Validaciones de Código**:
   - Confirma que no existan URLs o parámetros hardcodeados (usar `AppConfig.shared` y `config.json`).
   - Confirma la ausencia de force unwraps (`!`).

### Fase 3: Commit y Publicación Git
1. Agrupa y agrega los archivos modificados con `git add`.
2. Realiza commits atómicos siguiendo el estándar de **Conventional Commits**:
   - `feat(...)`: Nueva funcionalidad.
   - `fix(...)`: Corrección de un error.
   - `refactor(...)`: Cambios en la estructura interna sin alteración funcional.
   - `test(...)`: Incorporación o mejora de pruebas unitarias.
   - `docs(...)`: Actualización de documentación (ej. CONTEXT.md, README).
3. Publica la rama en el repositorio remoto:
   ```bash
   git push -u origin <nombre-rama>
   ```

### Fase 4: Creación del Pull Request según el Blueprint
1. Utiliza el blueprint definido en [`.github/pull_request_template.md`](../../../.github/pull_request_template.md) como estructura obligatoria para el contenido del PR.
2. Completa cada sección con información precisa del cambio realizado:
   - Resumen y contexto del cambio.
   - Capas afectadas en MVVM + Clean Architecture.
   - Checklist de verificación completada.
   - Evidencia de ejecución de pruebas unitarias (`** TEST SUCCEEDED **`).
3. **Publicación del PR**:
   - **Opción A (GitHub CLI disponible)**:
     Si `gh auth status` es válido:
     ```bash
     gh pr create --title "[TIPO]: Breve descripción" --body "<cuerpo-completado>"
     ```
   - **Opción B (Fallback Web URL)**:
     Si `gh` no está disponible:
     1. Genera la URL directa de comparación en GitHub:
        `https://github.com/u-rsndz/Pokedex-ios/compare/main...<nombre-rama>?expand=1`
     2. Muestra al usuario el cuerpo completo del PR formateado según el Blueprint para que lo pegue en GitHub.
