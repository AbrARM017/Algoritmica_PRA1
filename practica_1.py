#!/usr/bin/env python3

import sys
import time
from typing import List, Tuple, Optional, Generator

def time_decorator(func):
    """Decorador para medir el tiempo de ejecución de una función."""
    def wrapper(*args, **kwargs):
        start_time = time.time()
        result = func(*args, **kwargs)
        end_time = time.time()
        print(f"Tiempo de ejecución: {end_time - start_time:.6f} segundos", file=sys.stderr)
        return result
    return wrapper

def leer_archivo(archivo):
    """
    Lee el archivo de entrada y devuelve una lista de tuplas con las relaciones entre los chicos.
    """
    relaciones = []
    if isinstance(archivo, str):
        with open(archivo, 'r') as f:
            for linea in f:
                if linea.strip():
                    chico, enemigo, amigo = linea.strip().split()
                    relaciones.append((chico, enemigo, amigo))
    else:  # stdin
        for linea in archivo:
            if linea.strip():
                chico, enemigo, amigo = linea.strip().split()
                relaciones.append((chico, enemigo, amigo))
    return relaciones

def es_valida_posicion(posicion: int, chico: str, enemigo: str, amigo: str, 
                       fila_actual: List[str]) -> bool:
    """
    Verifica si un chico puede estar en una posición específica de la fila.
    Un chico puede estar en una posición si:
    1. No ve a su enemigo detrás de él (o su amigo está antes que su enemigo)
    """
    # Si es la primera posición, siempre es válida
    if posicion == 0:
        return True
    
    # Buscar las posiciones del enemigo y amigo en la fila actual
    enemigo_pos = -1
    amigo_pos = -1
    
    for i, otro_chico in enumerate(fila_actual):
        if otro_chico == enemigo:
            enemigo_pos = i
        if otro_chico == amigo:
            amigo_pos = i
    
    # Si el enemigo no está en la fila actual, no hay problema
    if enemigo_pos == -1:
        return True
    
    # Si el enemigo está detrás del chico actual, necesitamos verificar
    # si el amigo está antes que el enemigo
    if enemigo_pos > posicion:
        # Si el amigo no está en la fila actual, no es válido
        if amigo_pos == -1:
            return False
        # Si el amigo está después del enemigo o después de la posición actual, no es válido
        if amigo_pos > enemigo_pos or amigo_pos > posicion:
            return False
    
    return True

def generar_filas_validas(relaciones: List[Tuple[str, str, str]]) -> Generator[List[str], None, None]:
    """
    Genera todas las filas válidas según las condiciones del problema.
    Usa un enfoque iterativo con una pila para explorar el espacio de soluciones.
    """
    if not relaciones:
        yield []
        return
    
    # Crear diccionarios para acceder rápidamente a los enemigos y amigos
    chicos = [relacion[0] for relacion in relaciones]
    enemigos = {relacion[0]: relacion[1] for relacion in relaciones}
    amigos = {relacion[0]: relacion[2] for relacion in relaciones}
    
    # Inicializar la pila con un estado vacío
    stack = [([], set())]  # (fila_actual, chicos_usados)
    
    while stack:
        fila_actual, chicos_usados = stack.pop()
        
        # Si ya hemos colocado a todos los chicos, tenemos una solución
        if len(fila_actual) == len(chicos):
            yield fila_actual
            continue
        
        posicion = len(fila_actual)
        
        # Intentar añadir cada chico no utilizado a la fila actual
        for chico in chicos:
            if chico not in chicos_usados:
                # Verificar si el chico puede estar en esta posición
                if es_valida_posicion(posicion, chico, enemigos[chico], amigos[chico], fila_actual):
                    # Añadir este chico a la fila y continuar con el siguiente nivel
                    nueva_fila = fila_actual + [chico]
                    nuevos_usados = chicos_usados.union({chico})
                    stack.append((nueva_fila, nuevos_usados))

@time_decorator
def buscar_solucion(relaciones: List[Tuple[str, str, str]]) -> Optional[List[str]]:
    """
    Busca una solución para la fila de chicos que satisfaga las condiciones.
    """
    # Generar filas válidas
    filas_validas = generar_filas_validas(relaciones)
    
    # Devolver la primera fila válida que encontremos
    try:
        return next(filas_validas)
    except StopIteration:
        return None

def main():
    if len(sys.argv) > 1:
        archivo = sys.argv[1]
    else:
        archivo = sys.stdin

    relaciones = leer_archivo(archivo)
    solucion = buscar_solucion(relaciones)

    if solucion:
        print(' '.join(solucion))
    else:
        print('impossible')

if __name__ == '__main__':
    main()