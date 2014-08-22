extern malloc, free


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

;size(puntero) = 
;size(char) = 
;size(double) = 
;size(entero) =

%define NODO_SIZE      24; 3 punteros 
%define LISTA_SIZE     16; 2 punteros
%define JUGADOR_SIZE   0 ; 2 punteros + char + entero
%define SELECCION_SIZE 0 ; 2 punteros + double

%define OFFSET_DATOS 0 ; primer elemento, offset 0
%define OFFSET_SIG   0 ; segundo elemento, offset 0 + puntero
%define OFFSET_ANT   0 ; tercer elemento, offset 0 + puntero + puntero

%define OFFSET_PRIMERO 0 ; offset 0
%define OFFSET_ULTIMO  0 ; offset 0 + puntero

%define OFFSET_NOMBRE_J 0 ; 0
%define OFFSET_PAIS_J   0 ; 0 + puntero
%define OFFSET_NUMERO_J 0 ; 0 + puntero + puntero
%define OFFSET_ALTURA_J 0 ; 0 + puntero + puntero + char

%define OFFSET_PAIS_S      0 ; 0
%define OFFSET_ALTURA_S    0 ; 0 + puntero
%define OFFSET_JUGADORES_S 0 ; 0 + puntero + double


section .rodata


section .data



section .text

; FUNCIONES OBLIGATORIAS. PUEDEN CREAR LAS FUNCIONES AUXILIARES QUE CREAN CONVENIENTES

;nodo *nodo_crear (void *datos);
; stdlib
nodo_crear:
	push rbp
	mov rbp, rsp
	push rdi; PILA DESALINEADA, OMFWTF
	;... OK... no entres en panico... que haría superman?
	sub rsp, 8
	mov rdi, NODO_SIZE
	call malloc
	add rsp, 8
	push qword[rax + OFFSET_DATOS]
	mov qword [rax + OFFSET_SIG], NULL
	mov qword [rax + OFFSET_ANT], NULL
	pop rbp
	ret

;lista *lista_crear (void);
lista_crear:
	push rbp
	mov rbp, rsp
	
	mov rdi, LISTA_SIZE
	call malloc
	mov qword [rax + OFFSET_PRIMERO], NULL
	mov qword[rax + OFFSET_PRIMERO], NULL
	
	pop rbp
	ret

;nodo nodo_borrar(nodo *n, tipo_funcion_borrar f)
nodo_borrar:
    push rbp
    mov rbp, rsp
    push qword [rdi + OFFSET_SIG]
    push rdi
    ;elimino el elemento
    mov rdi, rdi + OFFSET_DATOS 
    call rsi
    ;elimino el nodo
    pop rdi
    call free
    ;pongo el nodo siguiente en rax para devolverlo
    pop rax
    pop rbp
    ret
	
;void lista_borrar (lista *l, tipo_funcion_borrar f);
lista_borrar:
	push rbp
	mov rbp, rsp

	push rdi
	sub rsp, 8
	mov rdi, [rdi]
	
LOOP_N:	cmp qword [rdi], NULL
	JZ FIN
	call nodo_borrar
	mov rdi, rax
	JMP LOOP_N
FIN:	
	add rsp, 8
	pop rdi
	call free; libero la lista
	
	pop rbp
	ret

	
lista_imprimir:
	

lista_imprimir_f:
	; COMPLETAR AQUI EL CODIGO

;jugador *crear_jugador (char *nombre, char *pais, char numero, unsigned int altura)
crear_jugador:
	push rbp
	mov rbp, rsp
	
	mov rdi, JUGADOR_SIZE
	call malloc
	mov [rax + OFFSET_NOMBRE_J], RDI 
	mov [rax + OFFSET_PAIS_J], RSI
	mov byte [RAX + OFFSET_NUMERO_J], CL
	mov word [RAX + OFFSET_ALTURA_J], DX; ver cuanto mide una int!!!!
	
	pop rbp
	ret

menor_jugador:
	; COMPLETAR AQUI EL CODIGO

normalizar_jugador:
	; COMPLETAR AQUI EL CODIGO

pais_jugador:
	; COMPLETAR AQUI EL CODIGO

;void borrar_jugador(jugador *j)
borrar_jugador:
	
	push rbp
	mov rbp, rsp
	
	push rdi ;DESALINEADA
	sub rsp, 8;Alineada
	mov rdi,[rdi + OFFSET_NOMBRE_J]
	call free
	add rsp, 8;DESALINEADA
	
	pop rdi;ALINEADA
	push rdi;DESALINEADA
	sub rsp, 8;ALINEADA
	mov rdi,[rdi + OFFSET_PAIS_J]
	call free
	
	add rsp, 8;DESALINEADA
	pop rdi;ALINEADA
	call free
	
	pop rbp
	ret

imprimir_jugador:
	; COMPLETAR AQUI EL CODIGO

	
;void copiar_cadena(char* cadenaOriginal, char* cadenaCopiada)
copiar_cadena:
	
	
	
;seleccion *crear_seleccion(char *pais, double alturaPromedio, lista *jugadores)
crear_seleccion:
	push rbp
	mov rbp, rsp
	
	push RDI;D
	push rsi;D
	push rdx;A
	
	sub rsp,8;A
	
	mov rdi, SELECCION_SIZE
	call malloc
	
	add rsp, 8
	pop qword [rax + OFFSET_JUGADORES_S] 
	pop [rax + OFFSET_ALTURA_S]; ver cuanto mide un double
	
	pop rdi
	mov rsi, rax
	call copiar_cadena
	
	pop rbp
	ret

menor_seleccion:
	; COMPLETAR AQUI EL CODIGO

primer_jugador:
	; COMPLETAR AQUI EL CODIGO

;void borrar_seleccion(seleccion *s)
borrar_seleccion:
	push rbp
	mov rbp, rsp
	
	push rdi;D
	sub rsp,8;A
	
	mov rdi, [rdi + OFFSET_PAIS_S]
	call free
	
	add rsp,8;D
	pop rdi;A
	call free
	
	pop rbp
	ret


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

