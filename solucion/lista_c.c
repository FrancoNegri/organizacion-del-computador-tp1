#include "lista.h"

bool jugadores_del_mismo_pais(void * j1, void* j2);
seleccion *crear_seleccion_map(void *dato);
// Completar las funciones en C

lista *generar_selecciones( lista *l )
{

	lista *res = lista_crear();
	nodo *cmp = l->primero;
	lista *listas_de_listas_de_jugadores = lista_crear();

	insertar_ultimo (res, cmp);
	while(cmp != NULL)
	{
		nodo *n = cmp->sig;
		while(n != NULL)
	    {
			if (jugadores_del_mismo_pais(n->datos, cmp->datos))
			{
				jugador *j = (jugador *) n->datos;
				nodo *p = nodo_crear ((void *) crear_jugador (j->nombre, j->pais, j->numero, j->altura) );
				insertar_ultimo (res, p);
			}
			n = n->sig;
		}
		cmp = cmp->sig;
	}
	    


	res = mapear(listas_de_listas_de_jugadores, (tipo_funcion_mapear)&crear_seleccion_map);
	return ordenar_lista(res, (tipo_funcion_cmp)&menor_seleccion);
}

seleccion *crear_seleccion_map(void *dato)
{
	lista *jugadores = dato;
	jugadores = mapear(jugadores, (tipo_funcion_mapear)&normalizar_jugador);
	nodo *unNodo = jugadores->primero;
	jugador *unJugador = unNodo->datos;
	return crear_seleccion(unJugador->pais, altura_promedio(jugadores), jugadores);
}


bool jugadores_del_mismo_pais(void * j1, void* j2)
{
	jugador *jug1, *jug2;
	jug1 = j1;
	jug2 = j2;

	if( *jug1->pais == *jug2->pais)
		return true; 
	return false;
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

