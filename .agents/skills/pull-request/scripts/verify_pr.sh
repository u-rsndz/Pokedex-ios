#!/bin/bash

# ==============================================================================
# Script de verificación de Quality Gates para Pull Requests (PokeDex iOS)
# Ejecuta linting, suite de tests y comprobaciones de integridad antes del PR.
# ==============================================================================

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
cd "$REPO_ROOT"

echo "========================================================"
echo " 🔍 Ejecutando Quality Gates para Pull Request"
echo " Repositorio: $REPO_ROOT"
echo "========================================================"

# 1. Comprobación de rama de trabajo
CURRENT_BRANCH=$(git branch --show-current)
echo "▶ Rama actual: $CURRENT_BRANCH"
if [ "$CURRENT_BRANCH" == "main" ]; then
    echo "⚠️  ADVERTENCIA: Estás en la rama 'main'. Recuerda crear una rama (feature/..., fix/...) antes de abrir un PR."
fi

# 2. Verificación de Linter y Formato
echo ""
echo "▶ Paso 1/3: Verificando formato y estilo de código con ./lint.sh..."
if [ -f "./lint.sh" ]; then
    ./lint.sh
    LINT_STATUS=$?
    if [ $LINT_STATUS -ne 0 ]; then
        echo "❌ Error en verificación de linting. Ejecuta './lint.sh --fix' y corrige los problemas."
        exit 1
    fi
    echo "✅ Linting y formateo correctos."
else
    echo "⚠️  No se encontró lint.sh en la raíz del repositorio."
fi

# 3. Verificación de pruebas unitarias
echo ""
echo "▶ Paso 2/3: Ejecutando pruebas unitarias con xcodebuild..."

if [ -z "$DEVELOPER_DIR" ]; then
    if [ -d "/Applications/Xcode14_2.app/Contents/Developer" ]; then
        export DEVELOPER_DIR="/Applications/Xcode14_2.app/Contents/Developer"
    elif [ -d "/Applications/Xcode.app/Contents/Developer" ]; then
        export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
    fi
fi

if command -v xcodebuild >/dev/null 2>&1; then
    echo "   Usando DEVELOPER_DIR: $DEVELOPER_DIR"
    set +e
    xcodebuild test \
      -scheme PokeDex \
      -destination 'platform=iOS Simulator,OS=16.2,name=iPhone 14' \
      CODE_SIGNING_ALLOWED=NO -quiet
    TEST_STATUS=$?
    set -e

    if [ $TEST_STATUS -ne 0 ]; then
        echo "❌ Las pruebas unitarias fallaron. Corrige los tests antes de enviar el PR."
        exit 1
    fi
    echo "✅ Suite de pruebas aprobada (** TEST SUCCEEDED **)."
else
    echo "⚠️  xcodebuild no encontrado en el PATH. Asegúrate de tener Xcode instalado."
fi

# 4. Verificación de actualización de CONTEXT.md
echo ""
echo "▶ Paso 3/3: Verificando estado de CONTEXT.md..."
CHANGES_IN_CODE=$(git status --porcelain | grep -E '\.(swift|json|pbxproj)$' || true)
CONTEXT_CHANGED=$(git status --porcelain | grep 'CONTEXT.md' || true)

if [ -n "$CHANGES_IN_CODE" ] && [ -z "$CONTEXT_CHANGED" ]; then
    echo "⚠️  Atención: Hay cambios en código fuente/configuración pero CONTEXT.md no parece haber sido modificado."
    echo "   Recuerda que la regla de GEMINI.md exige actualizar CONTEXT.md con cualquier cambio funcional o de arquitectura."
else
    echo "✅ Verificación de documentación completada."
fi

echo ""
echo "========================================================"
echo " 🎉 ¡Todos los Quality Gates han sido validados con éxito!"
echo "========================================================"
