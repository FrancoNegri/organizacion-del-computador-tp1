global nodo_crear
global lista_crear
global lista_borrar
global lista_imprimir
global lista_imprimir_f
global crear_jugador
global menor_jugador
global normalizar_jugador
global pais_jugador
global borrar_jugador
global imprimir_jugador
global crear_seleccion
global menor_seleccion
global primer_jugador
global borrar_seleccion
global imprimir_seleccion
global insertar_ordenado
global filtrar_jugadores
global mapear
global ordenar_lista_jugadores
global altura_promedio
extern insertar_ultimo


; SE RECOMIENDA COMPLETAR LOS DEFINES CON LOS VALORES CORRECTOS
%define NULL 0
%define TRUE 1
%define FALSE 0

%define NODO_SIZE      24; 3 punteros 
%define LISTA_SIZE     16; 2 punteros
%define JUGADOR_SIZE   0 ; 2 punteros (16) + char(1) + entero(4)
%define SELECCION_SIZE 0 

%define OFFSET_DATOS 0
%define OFFSET_SIG   0 
%define OFFSET_ANT   0 

%define OFFSET_PRIMERO 0
%define OFFSET_ULTIMO  0 

%define OFFSET_NOMBRE_J 0
%define OFFSET_PAIS_J   0 
%define OFFSET_NUMERO_J 0 
%define OFFSET_ALTURA_J 0 

%define OFFSET_PAIS_S      0
%define OFFSET_ALTURA_S    0 
%define OFFSET_JUGADORES_S 0 


section .rodata


section .data


section .text

; FUNCIONES OBLIGATORIAS. PUEDEN CREAR LAS FUNCIONES AUXILIARES QUE CREAN CONVENIENTES

nodo_crear:
	; COMPLETAR AQUI EL CODIGO

lista_crear:
	; COMPLETAR AQUI EL CODIGO

lista_borrar:
	; COMPLETAR AQUI EL CODIGO

lista_imprimir:
	; COMPLETAR AQUI EL CODIGO

lista_imprimir_f:
	; COMPLETAR AQUI EL CODIGO

crear_jugador:
	; COMPLETAR AQUI EL CODIGO

menor_jugador:
	; COMPLETAR AQUI EL CODIGO

normalizar_jugador:
	; COMPLETAR AQUI EL CODIGO

pais_jugador:
	; COMPLETAR AQUI EL CODIGO

borrar_jugador:
	; COMPLETAR AQUI EL CODIGO

imprimir_jugador:
	; COMPLETAR AQUI EL CODIGO

crear_seleccion:
	; COMPLETAR AQUI EL CODIGO

menor_seleccion:
	; COMPLETAR AQUI EL CODIGO

primer_jugador:
	; COMPLETAR AQUI EL CODIGO

borrar_seleccion:
	; COMPLETAR AQUI EL CODIGO

imprimir_seleccion:
	; COMPLETAR AQUI EL CODIGO

insertar_ordenado:
	; COMPLETAR AQUI EL CODIGO

altura_promedio:
	; COMPLETAR AQUI EL CODIGO

ordenar_lista_jugadores:
	; COMPLETAR AQUI EL CODIGO

filtrar_jugadores:
	; COMPLETAR AQUI EL CODIGO

mapear:
	; COMPLETAR AQUI EL CODIGO

