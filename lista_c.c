#include "lista.h"


// Completar las funciones en C.

lista *generar_selecciones(lista *l){
	// COMPLETAR AQUI EL CODIGO
}



// Funcion ya implementada en C 

void insertar_ultimo(lista *l, nodo *nuevo){
	nodo *ultimo = l->ultimo;
	if(ultimo == NULL){
		l->primero = nuevo;
	}
	else{
		ultimo->sig = nuevo;
	}
	nuevo->ant = l->ultimo;
	l->ultimo = nuevo;
}


