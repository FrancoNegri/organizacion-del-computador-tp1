extern malloc, free, printf
;rdi rsi rdx rcx

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
global mapear
global ordenar_lista_jugadores
global altura_promedio
global nodo_borrar

extern filtrar_jugadores
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


;void debugPrint(char* c, int long)
debugPrint:
	push rbp
	mov rbp, rsp
	push rax
	push rbx 
	push rcx
	push rdx

	mov rax, 4     ; funcion 4
   	mov rbx, 1     ; stdout
   	mov rcx, rdi
   	mov rdx, rsi
   	int 0x80

	pop rdx
	pop rcx
	pop rbx
	pop rax
	pop rdX
	ret

%define CONTADOR R15
;copiar cadena toma registro rdi, y genera una copia que devuelve por rax
copiar_cadena:
	push rbp
	mov rbp, rsp
	push R14
	push R15
	mov qword R14, rdi
	
	mov qword CONTADOR, 0

contarCaracteres:	
	cmp byte [R14 + CONTADOR],0
	jz fin_contarCaracteres
	INC qword CONTADOR
	jmp contarCaracteres
fin_contarCaracteres:
	INC qword CONTADOR
	mov qword rdi, CONTADOR
	call malloc

	mov qword CONTADOR, 0

copiando:	
	mov dl ,[R14 + CONTADOR]
	mov byte [rax + CONTADOR], dl
	cmp byte [R14 + CONTADOR],0
	jz fin_fun_copiar
	INC CONTADOR
	jmp copiando
	
	
fin_fun_copiar:

	;debugin
	;mov rdi, rax
	;mov rsi, CONTADOR;
	;call debugPrint

	pop R15
	pop R14
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


; FUNCIONES OBLIGATORIAS. PUEDEN CREAR LAS FUNCIONES AUXILIARES QUE CREAN CONVENIENTES

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

lista_crear:
	push rbp
	mov rbp, rsp
	
	mov rdi, LISTA_SIZE
	call malloc
	mov qword [rax + OFFSET_PRIMERO], NULL
	mov qword[rax + OFFSET_ULTIMO], NULL
	
	pop rbp
	ret

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
	; COMPLETAR AQUI EL CODIGO

lista_imprimir_f:
	; COMPLETAR AQUI EL CODIGO


%define PUNTERO_A_JUGADOR R15
crear_jugador:
	push rbp
	mov rbp, rsp
	push R15
	push RBX
	push R12
	push R13
	push R14
	
	mov qword RBX, rdi ;NOMBRE
	mov qword R12, rsi ;Pais
	mov byte R13b, dl ;Numero
	mov dword R14d, ecx ; altura

	mov rdi, JUGADOR_SIZE
	call malloc
	
	mov PUNTERO_A_JUGADOR, rax
	
	mov rdi , RBX
	call copiar_cadena
	mov [PUNTERO_A_JUGADOR + OFFSET_NOMBRE_J], rax
	
	mov rdi, R12
	call copiar_cadena
	mov [PUNTERO_A_JUGADOR + OFFSET_PAIS_J], rax
	
	mov [PUNTERO_A_JUGADOR + OFFSET_NUMERO_J], R13b
	
	mov [PUNTERO_A_JUGADOR + OFFSET_ALTURA_J], R14d

	mov RAX, PUNTERO_A_JUGADOR; SI NO DEVUELVO LO QUE TENGO QUE DEVOLVER CLARO QUE ME VA A DAR SIGFOULT!!!!

	pop R14
	pop R13
	pop R12
	pop RBX
	pop R15
	pop rbp
	ret

menor_jugador:
	push rbp
	mov rbp, rsp
	push rdi
	push rsi

	mov RSI, [RDI + OFFSET_NOMBRE_J]
	mov rdi, [RDI + OFFSET_NOMBRE_J]
	call compararStrings

	pop rsi
	pop rdi

	cmp rax , 0
	jz j1Mayor

	cmp rax , 1
	jz j2Mayor

	;si paso estos dos chequeos, entonces es igual, tengo que desempatar por altura.
	mov dword edi,[RDI + OFFSET_ALTURA_J]
	mov dword esi, [RSI + OFFSET_ALTURA_J]
	cmp dword rdi , rsi 
	js j1Mayor
	jmp j2Mayor


j1Mayor:
	mov rax, FALSE
	jmp fin_fun_menor
j2Mayor:
	mov rax, TRUE
	jmp fin_fun_menor
fin_fun_menor:
	pop rbp
	ret

; devuelve:
;			0 -> RDI mayor
;			1 -> RSI mayor
;			2 -> iguales
compararStrings:
	push rbp
	mov rbp, rsp
	push R13
	push R15
	push R14

	mov R13, 0

chekeando:
	mov byte R15b, [RDI + R13]
	mov byte R14b, [RSI + R13]
	cmp byte R15b,R14b 
	jnz letraDistinta
	INC R13

	cmp byte R15b, 0
	jz rdiEsCero

	cmp byte R14b, 0
	jz rsiEsCero

	jmp chekeando

letraDistinta:
	js rdiMayor
	mov rax, 1
	jmp fin_fun_comparar
rdiMayor:
	mov rax, 0
	jmp fin_fun_comparar

rdiEsCero:
	cmp byte R14b, 0
	jz ambosCero
	;si no son amobos cero, RSI es mayor
	mov rax, 1
	jmp fin_fun_comparar
rsiEsCero:
	;RDI no es 0 y RSI si, RDI mayor
	mov rax, 0
	jmp fin_fun_comparar

ambosCero: 
	mov rax, 2
	jmp fin_fun_comparar

fin_fun_comparar:
	pop R14
	pop R15
	pop R13
	pop rbp
	ret

normalizar_jugador:
	; COMPLETAR AQUI EL CODIGO

pais_jugador:
	; COMPLETAR AQUI EL CODIGO

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

;void imprimir_jugador(jugador *j, FILE *file)
imprimir_jugador:
	; COMPLETAR AQUI EL CODIGO

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

mapear:
	; COMPLETAR AQUI EL CODIGO

