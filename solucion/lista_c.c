#include "lista.h"
#include <string.h>

seleccion *crear_seleccion_map(void *dato);
// Completar las funciones en C

lista *generar_selecciones( lista *l )
{
	lista *listas_de_listas_de_jugadores = lista_crear();
	lista *listas_de_jugadores = mapear(l, (tipo_funcion_mapear)&normalizar_jugador);
	
	nodo *unNodo= listas_de_jugadores->primero;
	lista *jugadoresDelMismoPais = lista_crear();
	insertar_ultimo (jugadoresDelMismoPais,unNodo);
	nodo *nodoViejo = unNodo;
	unNodo = unNodo->sig;
	while(unNodo != NULL)
	{
		jugador *j1,*j2;
		j1 = unNodo->datos;
		j2 = nodoViejo->datos;
		if(/*pais_jugador(j1,j2)*/ strncmp(j1->pais,j2->pais, 100) == 0)
		{
			insertar_ultimo (jugadoresDelMismoPais,unNodo);
		}else
		{
			insertar_ultimo (listas_de_listas_de_jugadores,nodo_crear ( (void *)jugadoresDelMismoPais));
			jugadoresDelMismoPais = lista_crear();
			insertar_ultimo (jugadoresDelMismoPais,unNodo);
		}

		nodoViejo = unNodo;
		unNodo = unNodo->sig;
	}


	lista *res = mapear(listas_de_listas_de_jugadores, (tipo_funcion_mapear)&crear_seleccion_map);
	return ordenar_lista(res, (tipo_funcion_cmp)&menor_seleccion);
}

void*normalizar( void * dato)
{
	return normalizar_jugador(dato);
}


seleccion *crear_seleccion_map(void *dato)
{
	lista *jugadores = dato;
	//jugadores = mapear(jugadores, (tipo_funcion_mapear)&);
	nodo *unNodo = jugadores->primero;
	jugador *unJugador = unNodo->datos;
	return crear_seleccion(unJugador->pais, altura_promedio(jugadores), jugadores);
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

