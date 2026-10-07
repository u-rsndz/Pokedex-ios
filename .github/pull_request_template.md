<!-- ======================================================== -->
<!-- BLUEPRINT DE PULL REQUEST - POKEDEX IOS                 -->
<!-- ======================================================== -->

## 📌 1. Resumen y Contexto
<!-- Proporciona una explicación concisa del cambio y su motivación -->
- **¿Qué resuelve este PR?**: 
- **Ticket / Issue relacionado**: Fixes #
- **Tipo de cambio**:
  - [ ] 🚀 Nueva funcionalidad (Feature)
  - [ ] 🐛 Corrección de error (Bug fix)
  - [ ] 🔨 Refactorización (sin cambios funcionales)
  - [ ] 🧪 Pruebas automatizadas (Unit / UI Tests)
  - [ ] 📝 Documentación / Configuración

---

## 🏛️ 2. Alineación Arquitectónica (MVVM + Clean Architecture)
<!-- Marca las capas afectadas y describe brevemente la separación de responsabilidades -->
- [ ] **Presentation**: SwiftUI Views y/o ViewModels (`@MainActor`, `@Published`, llamadas exclusivas a Use Cases).
- [ ] **Domain**: Casos de uso (`UseCaseProtocol`), entidades de dominio, contratos de repositorios.
- [ ] **Data**: Repositorios concretos, `RemoteDataManager` (URLSession) o DTOs.
- [ ] **Config / Resources**: Centralizado en `config.json` y expuesto mediante `AppConfig.shared`.

*Detalle de componentes creados/modificados:*
- **Caso de uso**: 
- **ViewModel**: 
- **Otros**: 

---

## 🛡️ 3. Checklist de Verificación de Calidad (Obligatorio)
<!-- Todos los elementos deben cumplirse antes de fusionar según GEMINI.md -->

- [ ] **Clean Architecture & Inversión de Dependencias**: Dependencias inyectadas como protocolos en constructores (`init`).
- [ ] **Pruebas Unitarias Obligatorias**: Se añadieron pruebas unitarias para cada ViewModel, Caso de Uso o Servicio modificado/creado usando Mocks.
- [ ] **Xcode Tests Exitosos**: La suite completa pasa en verde (`** TEST SUCCEEDED **` en iPhone 14 / iOS 16.2).
- [ ] **Formato y Estilo**: `./lint.sh` ejecutado sin errores (SwiftLint y SwiftFormat respetados).
- [ ] **Mantenimiento de CONTEXT.md**: `CONTEXT.md` actualizado con el nuevo estado funcional/arquitectónico.
- [ ] **Cero URLs Hardcodeadas**: Toda URL/endpoint/parámetro proviene de `AppConfig.shared`.
- [ ] **Seguridad de Tipos**: Sin `force unwrap` (`!`) ni `force cast` innecesarios; concurrencia moderna (`async/await`).

---

## 📸 4. Evidencia y Pruebas
<!-- Adjunta evidencia visual para cambios de UI y logs de ejecución de tests -->

### Pruebas Unitarias
```text
** TEST SUCCEEDED ** [Total tests ejecutados y aprobados]
```

### Capturas de Pantalla / Video (Si aplica a UI en SwiftUI)
| Estado Inicial | Nuevo Estado |
| :---: | :---: |
| *(Captura antes / N/A)* | *(Captura después / GIF)* |
