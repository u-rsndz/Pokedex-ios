#!/bin/bash

# ==============================================================================
# Script de revisión y formateo de código para iOS (SwiftLint & SwiftFormat)
# Compatible con Swift 5.0 y entornos Xcode / Terminal / CI
# ==============================================================================

# Incluir rutas estándar: local bin, Homebrew (Apple Silicon e Intel) y Mint
export PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:$HOME/.mint/bin:$PATH"

# Asegurar DEVELOPER_DIR hacia Xcode si xcode-select apunta a CommandLineTools
if [ -z "$DEVELOPER_DIR" ]; then
    if [ -d "/Applications/Xcode14_2.app/Contents/Developer" ]; then
        export DEVELOPER_DIR="/Applications/Xcode14_2.app/Contents/Developer"
    elif [ -d "/Applications/Xcode.app/Contents/Developer" ]; then
        export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
    fi
fi

# Opción: Instalar hook de pre-commit
if [ "$1" == "--install-hook" ]; then
    HOOK_DIR=".git/hooks"
    HOOK_FILE="$HOOK_DIR/pre-commit"
    if [ ! -d "$HOOK_DIR" ]; then
        echo "❌ No se encontró el directorio .git/hooks. Asegúrate de estar en la raíz de un repositorio Git."
        exit 1
    fi

    cat << 'EOF' > "$HOOK_FILE"
#!/bin/bash
echo "🔍 Ejecutando pre-commit hook (SwiftLint & SwiftFormat)..."
./lint.sh
RESULT=$?
if [ $RESULT -ne 0 ]; then
    echo "❌ Falló la verificación de estilo/formato. Corrige los problemas o ejecuta './lint.sh --fix' antes de hacer commit."
    exit 1
fi
EOF

    chmod +x "$HOOK_FILE"
    echo "✅ Hook de pre-commit instalado en $HOOK_FILE"
    exit 0
fi

MODE="lint"
if [ "$1" == "--fix" ] || [ "$1" == "-f" ] || [ "$1" == "format" ]; then
    MODE="fix"
fi

SWIFTFORMAT_EXIT=0
SWIFTLINT_EXIT=0

echo "=========================================="
echo " 🚀 Verificación de Código (Swift 5)"
echo " Modo: $([ "$MODE" == "fix" ] && echo "Corregir formato (--fix)" || echo "Solo revisión (--lint)")"
echo "=========================================="

# 1. SwiftFormat
if command -v swiftformat >/dev/null 2>&1; then
    echo "▶ Ejecutando SwiftFormat..."
    if [ "$MODE" == "fix" ]; then
        swiftformat .
        SWIFTFORMAT_EXIT=$?
    else
        swiftformat --lint .
        SWIFTFORMAT_EXIT=$?
    fi
else
    echo "⚠️  [SwiftFormat] No está instalado."
    echo "   Instálalo con: brew install swiftformat"
    if [ -n "$XCODE_VERSION_ACTUAL" ]; then
        echo "warning: SwiftFormat no instalado. Ejecuta 'brew install swiftformat' en tu terminal."
    fi
fi

echo ""

# 2. SwiftLint
if command -v swiftlint >/dev/null 2>&1; then
    echo "▶ Ejecutando SwiftLint..."
    if [ "$MODE" == "fix" ]; then
        swiftlint --fix
        swiftlint
        SWIFTLINT_EXIT=$?
    else
        swiftlint
        SWIFTLINT_EXIT=$?
    fi
else
    echo "⚠️  [SwiftLint] No está instalado."
    echo "   Instálalo con: brew install swiftlint"
    if [ -n "$XCODE_VERSION_ACTUAL" ]; then
        echo "warning: SwiftLint no instalado. Ejecuta 'brew install swiftlint' en tu terminal."
    fi
fi

echo ""
echo "=========================================="
if [ $SWIFTFORMAT_EXIT -ne 0 ] || [ $SWIFTLINT_EXIT -ne 0 ]; then
    echo "❌ Se encontraron observaciones en el código."
    echo "💡 Puedes intentar corregir la mayoría automáticamente ejecutando:"
    echo "   ./lint.sh --fix"
    echo "=========================================="
    exit 1
else
    echo "✅ Todo el código cumple con las reglas establecidas."
    echo "=========================================="
    exit 0
fi
