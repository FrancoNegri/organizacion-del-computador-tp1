#include "lista.h"


// Completar las funciones en C

lista *generar_selecciones( lista *l ){
	// COMPLETAR AQUI EL CODIGO
}




// Funciones ya implementadas en C 

lista *filtrar_jugadores (lista *l, tipo_funcion_cmp f, nodo *cmp){
	lista *res = lista_crear();
	nodo *n = l->primero;
    while(n != NULL){
		if (f (n->datos, cmp->datos)){
			jugador *j = (jugador *) n->datos;
			nodo *p = nodo_crear ( (void *) crear_jugador (j->nombre, j->pais, j->numero, j->altura) );
			insertar_ultimo (res, p);
		}
		n = n->sig;
	}
	return res;
}

void insertar_ultimo (lista *l, nodo *nuevo){
	nodo *ultimo = l->ultimo;
	if (ultimo == NULL){
		l->primero = nuevo;
	}
	else{
		ultimo->sig = nuevo;
	}
	nuevo->ant = l->ultimo;
	l->ultimo = nuevo;
}

