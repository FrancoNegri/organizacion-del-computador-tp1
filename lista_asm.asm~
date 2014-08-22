extern malloc, free, printf


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

;Entero: 4 
;Puntero: 8 
;Caracter: 1 
;Doble: 8 

;dword = 4
;word = 2
;qword = 8


%define NODO_SIZE      24; 3 punteros (8*3)
%define LISTA_SIZE     16; 2 punteros (8*2)
%define JUGADOR_SIZE   21 ; 2 punteros (8*2) + char(1) + entero(4)
%define SELECCION_SIZE 24 ; 2 punteros (8*2) + double (8)

%define OFFSET_DATOS 0 ; primer elemento, offset 0
%define OFFSET_SIG   8 ; segundo elemento, offset 0 + puntero
%define OFFSET_ANT   16 ; tercer elemento, offset 0 + puntero + puntero

%define OFFSET_PRIMERO 0 ; offset 0
%define OFFSET_ULTIMO  8 ; offset 0 + puntero

%define OFFSET_NOMBRE_J 0 ; 0
%define OFFSET_PAIS_J   8 ; 0 + puntero
%define OFFSET_NUMERO_J 16 ; 0 + puntero + puntero
%define OFFSET_ALTURA_J 17 ; 0 + puntero + puntero + char


%define OFFSET_PAIS_S      0 ; 0
%define OFFSET_ALTURA_S    8 ; 0 + puntero
%define OFFSET_JUGADORES_S 16 ; 0 + puntero + double


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
	pop qword[rax + OFFSET_DATOS]
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

;rdi rsi rdx rcx
;jugador *crear_jugador (char *nombre, char *pais, char numero, unsigned int altura)


%define PUNTERO_A_JUGADOR R13
crear_jugador:
	push rbp
	mov rbp, rsp
	sub rsp, 46; para que quede alineada me pido un multiplo de 16 y fue
	
	mov qword [rbp+ 16 + OFFSET_NOMBRE_J], rdi
	mov qword [rbp+ 16 + OFFSET_PAIS_J], rsi
	mov byte [rbp+ 16 + OFFSET_NUMERO_J], dl
	mov dword [rbp+ 16 + OFFSET_ALTURA_J], ecx

	mov rdi, JUGADOR_SIZE
	call malloc
	
	mov PUNTERO_A_JUGADOR, rax
	
	mov rdi , [rbp + 16 + OFFSET_NOMBRE_J]
	call copiar_cadena
	mov [PUNTERO_A_JUGADOR + OFFSET_NOMBRE_J], rax
	
	
	mov rdi, [rbp + 16 + OFFSET_PAIS_J]
	call copiar_cadena
	mov [PUNTERO_A_JUGADOR + OFFSET_PAIS_J], rax
	
	mov byte al, [rbp+ 16 + OFFSET_NUMERO_J]; byte
	mov [PUNTERO_A_JUGADOR + OFFSET_NUMERO_J], al
	
	mov dword eax, [rbp+ 16 + OFFSET_ALTURA_J];dword
	mov [PUNTERO_A_JUGADOR + OFFSET_ALTURA_J], eax	
	
	add rsp,46
	
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

%define CONTADOR R15

;copiar cadena toma registro rdi, y genera una copia que devuelve por rax, no modifica R13, convencion FN
copiar_cadena:
	push rbp
	mov rbp, rsp
	mov qword R14, rdi
	
	mov qword CONTADOR, 0
loop:	cmp byte [rdi + CONTADOR],0
	jz fin_cadena
	add qword CONTADOR,1
	jmp loop
fin_cadena:	
	add CONTADOR, 5 ; ver si lo puedo sacar
	mov qword rdi, CONTADOR
	call malloc
	sub CONTADOR, 4
copiando:
	mov dl ,[R14 + CONTADOR]
	mov byte [rax + CONTADOR], dl
	sub qword CONTADOR, 1
	jz copiando
	
	;mov rdi, rax
	;call printf
	
	pop rbp
	ret
	;rbp            0x7fffffffcdc2	0x7fffffffcdc2
	;
	
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
	pop qword [rax + OFFSET_ALTURA_S]; ver cuanto mide un double
	
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

