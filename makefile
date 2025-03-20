# Makefile for practica_1

# Compiler and interpreter
GHC = ghc
PYTHON = python3

# Source files
HS_SRC = practica_1.hs
PY_SRC = practica_1.py

# Executables
HS_EXE = practica_1_hs
PY_EXE = $(PY_SRC)

# Default target
all: haskell python

# Haskell targets
haskell: $(HS_EXE)

$(HS_EXE): $(HS_SRC)
	$(GHC) -o $@ $<

# Python targets
python: $(PY_EXE)

$(PY_EXE): $(PY_SRC)
	chmod +x $@

# Run targets
run-haskell: $(HS_EXE)
	./$(HS_EXE)

run-python: $(PY_EXE)
	$(PYTHON) $(PY_EXE)

# Clean target
clean:
	rm -f $(HS_EXE) *.hi *.o
	chmod -x $(PY_EXE)

# Phony targets
.PHONY: all haskell python run-haskell run-python clean