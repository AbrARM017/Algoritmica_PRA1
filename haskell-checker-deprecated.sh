#!/bin/bash

# Configuración
HASKELL_PROGRAM="practica_1.hs"
EXECUTABLE="illa"
TESTS_DIR="tests"
TEMP_OUTPUT="output.txt"
TOTAL_TESTS=0
PASSED_TESTS=0

# Compilar programa
echo "Compilando programa Haskell..."
ghc -O2 -o $EXECUTABLE $HASKELL_PROGRAM

if [ $? -ne 0 ]; then
    echo "Error de compilación"
    exit 1
fi

echo "Iniciando tests..."
echo "-------------------------------"

# Buscar tests desde 1-8 hasta 0-1
for x in {1..8}; do
    for y in {0..1}; do
        INPUT_FILE="$TESTS_DIR/input${x}-${y}.txt"
        EXPECTED_OUTPUT="$TESTS_DIR/output${x}-${y}.txt"
        
        if [ -f "$INPUT_FILE" ] && [ -f "$EXPECTED_OUTPUT" ]; then
            ((TOTAL_TESTS++))
            
            # Ejecutar programa
            ./$EXECUTABLE "$INPUT_FILE" > $TEMP_OUTPUT 2>&1
            
            # Verificar resultado
            if diff -w $TEMP_OUTPUT $EXPECTED_OUTPUT &>/dev/null; then
                echo "✅ Test $x-$y: PASS"
                ((PASSED_TESTS++))
            else
                echo "❌ Test $x-$y: FAIL"
                echo "   Diferencias:"
                diff -w $TEMP_OUTPUT $EXPECTED_OUTPUT | sed 's/^/   /'
            fi
        fi
    done
done

echo "-------------------------------"
echo "Resultados: $PASSED_TESTS/$TOTAL_TESTS tests superados"
rm -f $TEMP_OUTPUT *.hi *.o