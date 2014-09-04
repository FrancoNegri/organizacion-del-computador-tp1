extern malloc, free, fprintf, fopen, fclose
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
global compararStrings
global ordenar_lista

extern filtrar_jugadores
extern insertar_ultimo


; SE RECOMIENDA COMPLETAR LOS DEFINES CON LOS VALORES CORRECTOS
%define NULL 0
%define TRUE 1 ; es size 1 bite!!!
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
	msg:  DB '%s %s %c %u', 10,0
	dbug:  DB 'borro un nodo', 10,0
	lista_esta_vacia: DB '<vacia>', 10, 0

section .text


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; FUNCIONES AUXILIARES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;void normalizar_string(char*)
normalizar_string:
	push rbp
	mov rbp, rsp
	push r15
	push r14
	mov r15, 0

	xor r14, r14
.normalizando:
	mov r14b, [rdi + R15]
	cmp byte r14b , 0
	jz .finNormalizacion
	cmp byte r14b,97
	js .incrementar
	cmp byte r14b, 122
	jns .incrementar
	sub byte [rdi + R15], 32
.incrementar:
	INC qword R15
	jmp .normalizando
.finNormalizacion:
	pop r14
	pop r15
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

.chekeando:
	xor R14,R14
	xor R15, r15
	mov byte R15b, [RDI + R13]
	mov byte R14b, [RSI + R13]
	cmp byte R15b,R14b 
	jnz .letraDistinta
	INC R13

	cmp byte R15b, 0
	jz .rdiEsCero

	cmp byte R14b, 0
	jz .rsiEsCero

	jmp .chekeando

.letraDistinta:
	js .rdiMayor
	mov rax, 1
	jmp .fin_fun_comparar
.rdiMayor:
	mov rax, 0
	jmp .fin_fun_comparar

.rdiEsCero:
	cmp byte R14b, 0
	jz .ambosCero
	;si no son amobos cero, RSI es mayor
	mov rax, 1
	jmp .fin_fun_comparar
.rsiEsCero:
	;RDI no es 0 y RSI si, RDI mayor
	mov rax, 0
	jmp .fin_fun_comparar

.ambosCero: 
	mov rax, 2
	jmp .fin_fun_comparar

.fin_fun_comparar:
	pop R14
	pop R15
	pop R13
	pop rbp
	ret

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

.contarCaracteres:	
	cmp byte [R14 + CONTADOR],0
	jz .fin_contarCaracteres
	INC qword CONTADOR
	jmp .contarCaracteres
.fin_contarCaracteres:
	INC qword CONTADOR
	mov qword rdi, CONTADOR
	call malloc

	mov qword CONTADOR, 0

.copiando:
	xor rdx, rdx
	mov dl ,[R14 + CONTADOR]
	mov byte [rax + CONTADOR], dl
	cmp byte [R14 + CONTADOR],0
	jz .fin_fun_copiar
	INC CONTADOR
	jmp .copiando
		
.fin_fun_copiar:

	pop R15
	pop R14
	pop rbp	
	ret


;jugador* copiar_jugador(jugador *unJugador)
copiar_jugador:
	push rbp
	mov rbp, rsp
	push RBX
	push R12
	push R13
	push R14
	push R15

	mov R15, rdi

	;Copio el nombre
	mov rdi, [R15+ OFFSET_NOMBRE_J]
	call copiar_cadena
	mov qword RBX, rax ;NOMBRE

	;copio el pais
	mov rdi, [R15+ OFFSET_PAIS_J]
	call copiar_cadena
	mov qword R12, rax ;pais

	;copia el resto
	xor R13, R13
	mov byte R13b, [R15+ OFFSET_NUMERO_J];Numero
	
	xor r14, r14
	mov dword R14d,[R15+ OFFSET_ALTURA_J]  ; altura

	mov rdi, JUGADOR_SIZE
	call malloc

	mov qword [rax+ OFFSET_NOMBRE_J], RBX ;NOMBRE
	mov qword [rax+ OFFSET_PAIS_J], R12 ;pais
	mov byte [rax+ OFFSET_NUMERO_J], R13b ;Numero
	mov dword [rax+ OFFSET_ALTURA_J], R14d  ; altura	

	pop R15
	pop R14
	pop R13
	pop R12
	pop RBX
	pop rbp
	ret


;nodo* nodo_borrar(nodo *n, tipo_funcion_borrar f)
nodo_borrar:
    push rbp
    mov rbp, rsp
    push qword [rdi + OFFSET_SIG]
    push rdi
    
    ;elimino el elemento
    mov rdi, [rdi + OFFSET_DATOS]
    call rsi
    ;elimino el nodo
    pop rdi
    sub rsp, 8
    call free
    add rsp, 8
    ;pongo el nodo siguiente en rax para devolverlo
    pop rax
    pop rbp
    ret



;void normalizar_altura(*int altura)
normalizar_altura:
	push rbp
	mov rbp, rsp
	push r15
	sub rsp, 8

	xor r15, r15
	mov r15d, 0

.normalizando_altura:
	sub dword [rdi], 30
	js .finNormalizacionAltura
	INC dword r15d
	jmp .normalizando_altura

.finNormalizacionAltura:
	mov [rdi], r15d

	add rsp, 8
	pop r15
	pop rbp
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;FIN FUNCIONES AUXILIARES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;void lista_borrar(lista *l, tipo_funcion_borrar f)
lista_borrar:
	push rbp
	mov rbp, rsp
	push r15
	push rdi
	mov r15, rsi

	mov rdi, [rdi + OFFSET_PRIMERO]
.LOOP_N:
	cmp qword rdi, NULL
	JZ .FIN
	mov rsi, r15
	call nodo_borrar
	mov rdi, rax
	JMP .LOOP_N
.FIN:
	pop rdi
	pop r15
	call free
	pop rbp
	ret

;void lista_imprimir(lista *l, char *nombre_archivo, tipo_funcion_imprimir f)
lista_imprimir:
	push rbp
	mov rbp, rsp
	push rdi
	push rdx

	mov rdi, rsi
	mov rsi, 'a'
	call fopen

	pop rdx
	pop rdi
	push rax
	sub rsp, 8
	mov rsi, rax

	call lista_imprimir_f
	
	add rsp,8
	pop rdi
	call fclose

	pop rbp
	ret

;void lista_imprimir_f(lista *l, FILE *file, tipo_funcion_imprimir f)
lista_imprimir_f:
	push rbp
	mov rbp, rsp
	push r15; fun_imprimit(void, FILE)
	push r14; nodo
	push r13; FILE
	sub rsp, 8

	mov r15, rdx
	mov r13, rsi

	mov r14, [rdi + OFFSET_PRIMERO]
	cmp r14, 0
	jz .listaVacia
.loop:
	mov rdi, [r14 +OFFSET_DATOS]
	mov rsi, r13
	call r15
	mov r14, [r14 + OFFSET_SIG]
	cmp r14, 0
	jz .fin
	jmp .loop

.listaVacia:
	mov rdi, rsi ;FILE
	mov rsi, r13
	mov rsi, lista_esta_vacia
	call fprintf

.fin:
	add rsp, 8
	pop r13
	pop r14
	pop r15
	pop rbp
	ret


%define PUNTERO_A_JUGADOR R15
crear_jugador:
	push rbp
	mov rbp, rsp
	push R15
	push RBX
	push R12
	push R13
	push R14
	
	xor R13, R13
	xor R14, R14
	
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

;bool menor_jugador(jugador *j1, jugador *j2)
menor_jugador:
	push rbp
	mov rbp, rsp
	push rdi
	push rsi

	mov RSI, [RSI + OFFSET_NOMBRE_J]
	mov rdi, [RDI + OFFSET_NOMBRE_J]
	call compararStrings

	pop rsi
	pop rdi

	cmp rax , 0
	jz .j1Mayor

	cmp rax , 1
	jz .j2Mayor

	;si paso estos dos chequeos, entonces es igual, tengo que desempatar por altura.
	
	
	
	xor eax, eax
	
	mov dword eax, [RDI + OFFSET_ALTURA_J]
	xor rdi, rdi
	mov edi, eax
	
	mov dword eax, [RSI + OFFSET_ALTURA_J]
	xor rsi, rsi
	mov esi, eax
	
	cmp dword edi , esi 
	jns .j1Mayor
	jmp .j2Mayor


.j1Mayor:
	xor rax, rax
	mov eax, FALSE
	jmp .fin_fun_menor
.j2Mayor:
	xor rax, rax
	mov eax, TRUE
	jmp .fin_fun_menor
.fin_fun_menor:
	pop rbp
	ret



;jugador *normalizar_jugador(jugador *j)
normalizar_jugador:
	push rbp
	mov rbp, rsp
	push R15
	sub rsp, 8

	call copiar_jugador

	mov R15, rax

	lea rdi, [R15 + OFFSET_ALTURA_J]
	call normalizar_altura

	mov rdi, [R15 + OFFSET_NOMBRE_J]
	call normalizar_string

	mov rax, r15

	add rsp, 8
	pop r15
	pop rbp
	ret



pais_jugador:
	push rbp
	mov rbp, rsp

	mov RSI, [RDI + OFFSET_PAIS_J]
	mov rdi, [RDI + OFFSET_PAIS_J]

	call compararStrings

	cmp rax, 2
	jz .pais_jugador_true
	xor eax, eax
	mov eax, FALSE
	jmp .fin_pais_jugador
.pais_jugador_true:
	xor eax, eax
	mov eax, TRUE
.fin_pais_jugador:
	pop rbp
	ret


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
	push rbp
	mov rbp, rsp
	
	xor r8, r8
	xor r9, r9

	mov qword rdx, [rdi + OFFSET_NOMBRE_J]
	mov qword rcx, [rdi + OFFSET_PAIS_J]
	mov byte r8b, [rdi + OFFSET_NUMERO_J]
	mov dword r9d, [rdi + OFFSET_ALTURA_J]
	mov rdi, rsi ;FILE
	mov rsi, msg ;string
	call fprintf

	pop rbp
	ret

;seleccion *crear_seleccion(char *pais, double alturaPromedio, lista *jugadores)
crear_seleccion:
	push rbp
	mov rbp, rsp
	
	push r15;d
	push r14;a
	push r13;d
	push r12;a
	
	mov r14, rdi
	mov r13, rsi
	mov r12, rdx
	
	
	mov rdi, SELECCION_SIZE
	call malloc
	mov r15, rax
	
	mov [r15 + OFFSET_JUGADORES_S], r12
	mov [r15 + OFFSET_ALTURA_S], r13
	
	mov rdi, r14
	call copiar_cadena
	
	mov [r15 + OFFSET_PAIS_S], rax
	mov rax, r15
	
	pop r12
	pop r13
	pop r14
	pop r15
	pop rbp
	ret

menor_seleccion:
	push rbp
	mov rbp, rsp
	; COMPLETAR AQUI EL CODIGO
	pop rbp
	ret

;jugador *primer_jugador(seleccion *s)
primer_jugador:
	push rbp
	mov rbp, rsp

	mov rdi, [rdi + OFFSET_JUGADORES_S]; me muevo a la lista
	lea rdi, [rdi + OFFSET_PRIMERO]; me muevo al primer jugador
	call copiar_jugador

	pop rbp
	ret

;void borrar_seleccion(seleccion *s)
borrar_seleccion:
	push rbp
	mov rbp, rsp
	
	push r15;D
	sub rsp,8;A
	
	mov r15, rdi
	
	mov rdi, [r15 + OFFSET_JUGADORES_S]
	mov rsi, borrar_jugador
	call lista_borrar

	mov rdi, [r15 + OFFSET_PAIS_S]
	call free
	
	mov rdi, r15
	call free
	
	add rsp,8;D
	pop rdi;A
	pop rbp
	ret



imprimir_seleccion:
	push rbp
	mov rbp, rsp
	; COMPLETAR AQUI EL CODIGO
	pop rbp
	ret

;void insertar_ordenado(lista *l, void *datos, tipo_funcion_cmp f)
insertar_ordenado:
	push rbp
	mov rbp, rsp
	push R15; *l
	push R14; *datos y luego de agregoElNodo nodo siguiente
	push R13; funcion menor_jugador
	push R12; nodo anterior 
	push r11; nuevo nodo
	sub rsp, 8

	mov r15, rdi
	mov r14, rsi
	mov r13, rdX

	mov rdi, rsi
	call nodo_crear
	mov r11, rax

	mov R12, [R15 + OFFSET_PRIMERO]
	cmp R12, NULL
	jnz .buscarLugarParaInsertar
	;lista vacia, lo seteo como primero y ultimo y listo
	mov [R15 + OFFSET_PRIMERO], r11
	mov [R15 + OFFSET_ULTIMO], r11
	jmp .finIncercion

.buscarLugarParaInsertar:
	mov rdi, [R12 + OFFSET_DATOS]
	mov rsi, r14
	call r13 ; es el nodo en que estoy parado mas chico que el que quiero agregar?
	cmp rax, 0
	jz  .agregoElNodo;no, entonces lo agrego
	mov r12, [r12 + OFFSET_SIG]
	jmp .buscarLugarParaInsertar
.agregoElNodo:
	mov [r11 + OFFSET_ANT], r12
	
	push qword [r12 + OFFSET_SIG]
	pop qword [r11 + OFFSET_SIG]
	
	mov [r12 + OFFSET_SIG], r11
	
	mov r14 ,[r11 + OFFSET_SIG]
	mov [r11 + OFFSET_ANT], r11
	
	
.finIncercion:
	mov rax, 0
	add rsp, 8
	pop r11
	pop R12
	pop R13
	pop R14
	pop R15
	pop rbp
	ret

;double altura_promedio(lista *l)
altura_promedio:
	push rbp
	mov rbp, rsp
	
	push r15;suma de alturas
	push r14;nodo
	push r13;contador
	sub rsp, 8

	xor r15, r15
	xor r13,r13
	mov r14, [rdi + OFFSET_PRIMERO]
	cmp r14, 0
	jz .listaVacia
.loop:
	mov rdi, [r14 +OFFSET_DATOS]
	call obtenerAltura
	add r15d, eax
	inc r13
	mov r14, [r14 + OFFSET_SIG]
	cmp r14, 0
	jz .finLoop
	jmp .loop
.finLoop:
	movq xmm0, r15
	movq xmm1, r13
	DIVPD xmm0, xmm1
	jmp .fin
.listaVacia:
	PXOR xmm0, xmm0
.fin:
	add rsp, 8
	pop r13
	pop r14
	pop r15
	pop rbp
	ret

;int obtenerAltura(jugador*)
obtenerAltura:
	push rbp
	mov rbp, rsp
	mov eax, [rdi + OFFSET_ALTURA_J]
	pop rbp
	ret


;lista* ordenar_lista(lista*, tipo_funcion_cmp)
ordenar_lista:
	push rbp
	mov rbp, rsp
	push r15
	push r14
	push r13
	sub rsp, 8

	mov r15, [rdi + OFFSET_PRIMERO]
	mov r14, rsi
	
	call lista_crear
	mov r13, rax

.loop:
	cmp r15, 0
	jz .finLoop
	mov rdi, r13
	mov rsi, [r15 + OFFSET_DATOS]
	mov rdx, r14
	call insertar_ordenado
	mov r15, [r15 + OFFSET_SIG]
	jmp .loop
.finLoop:

	add rsp, 8
	pop r13
	pop r14
	pop r15
	pop rbp
	ret

;lista *ordenar_lista_jugadores(lista *l)
ordenar_lista_jugadores:
	push rbp
	mov rbp, rsp
	
	mov rsi, menor_jugador
	call ordenar_lista

	pop rbp
	ret

;lista *mapear(lista *l, tipo_funcion_mapear f)
mapear:
	push rbp
	mov rbp, rsp
	push r15; tipo_funcion_mapear f
	push r14; nodo de la lista vieja
	push r13; *lista_nueva
	push r12; nodo nuevo anterior

	mov r15, rsi
	mov r14, [rdi + OFFSET_PRIMERO]

	call lista_crear
	mov r13, rax


	;el primer nodo lo creo aparte para poder setear el primer elemento de la lista
	cmp r14, 0
	jz .fin
	mov rdi, [r14 + OFFSET_DATOS]
	call r15
	mov rdi, rax
	call nodo_crear
	mov [r13 + OFFSET_PRIMERO], rax
	mov r12, rax
	; hasta ahora tengo un nodo nuevo, ahora empiezo a loopear


	;r14 -> nodo que quiero mapear
	;r12 -> nodo mapeado anterior
.loop:
	mov r14, [r14 + OFFSET_SIG]
	cmp r14, 0
	jz .finLoop
	mov rdi, [r14 + OFFSET_DATOS]
	call r15
	mov rdi, rax
	call nodo_crear
	mov [r12 + OFFSET_SIG], rax
	mov [rax + OFFSET_ANT], r12
	mov r12, rax
	jmp .loop

.finLoop:
	mov [r13 + OFFSET_ULTIMO], RAX

.fin:
	mov rax, r13
	pop r12
	pop r13
	pop r14
	pop r15
	pop rbp
	ret