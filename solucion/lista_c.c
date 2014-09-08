#include "lista.h"
#include <string.h>

seleccion *crear_seleccion_map(void *dato);
void *nombrePorPais(void *j1);
bool jugadores_de_paises_distintos(jugador *j1, jugador *j2);
bool jugadores_del_mismo_pais(jugador *j1, jugador *j2);
// Completar las funciones en C

lista *generar_selecciones( lista *l )
{
	lista *listas_de_jugadores = mapear(l, (tipo_funcion_mapear)&normalizar_jugador);
	
	lista *listaDeSelecciones = lista_crear();
	
	while(listas_de_jugadores->primero != NULL)
	{
		lista *listaDeJugadoresDelMismoPais = filtrar_jugadores(listas_de_jugadores, (tipo_funcion_cmp)&jugadores_del_mismo_pais ,listas_de_jugadores->primero);
		
		lista *listaDeJugadoresDelMismoPaisOrdenados = ordenar_lista_jugadores(listaDeJugadoresDelMismoPais);
		
		lista_borrar(listaDeJugadoresDelMismoPais, (tipo_funcion_borrar)&borrar_jugador);

		jugador *j = listaDeJugadoresDelMismoPaisOrdenados->primero->datos;
		
		char *paisActual = j->pais;
		
		insertar_ordenado(listaDeSelecciones,crear_seleccion(paisActual, altura_promedio(listaDeJugadoresDelMismoPaisOrdenados), listaDeJugadoresDelMismoPaisOrdenados),(tipo_funcion_cmp)&menor_seleccion);
		
		lista *listas_de_jugadores_old = listas_de_jugadores;

		listas_de_jugadores = filtrar_jugadores(listas_de_jugadores, (tipo_funcion_cmp)&jugadores_de_paises_distintos ,listas_de_jugadores->primero);
	
		lista_borrar(listas_de_jugadores_old, (tipo_funcion_borrar)&borrar_jugador);
	}

	return listaDeSelecciones;
}

bool jugadores_del_mismo_pais(jugador *j1, jugador *j2)
{
	if(compararStrings(j1->pais,j2->pais) == 2)
		return true;
	return false;
}

bool jugadores_de_paises_distintos(jugador *j1, jugador *j2)
{

	if(compararStrings(j1->pais,j2->pais) != 2)
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

