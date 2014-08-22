#include "lista.h"
#include <stdio.h>

int testSizes();
int testJugador();
int testNodo();
int main(void) {

    testSizes();
    testNodo();
    testJugador();
    
    return 0;
}

int testNodo()
{
	int *hola = 1;
	printf("Creando Nodo...\n");
	nodo *miNodo = nodo_crear(hola);
	printf("Ok!\n");
	printf("Dato: %d \n",(int) miNodo->datos);
	return 0;
}

int testJugador()
{
    char *nombre = "pepe \n \0";
    char *pais = "pepe \n \0";
    printf("Creando jugador...\n");
    jugador *pepe = crear_jugador(nombre,pais,'4',30);
    printf("Ok!\n");
    //printf("Altura: %d \n",pepe->numero);
    //printf("Nombre: %s \n",pepe->nombre);
    //printf("Pais: %s \n",pepe->pais);
    borrar_jugador(pepe);
    return 0;
}

int testSizes()
{
    int * puntero;
    int entero;
    char caracter;
    double doble;
    printf("Test de tamaños para gcc \n");
    printf("Entero: %d \n",(int)sizeof(entero));
    printf("Puntero: %d \n",(int)sizeof(puntero));
    printf("Caracter: %d \n",(int)sizeof(caracter));
    printf("Doble: %d \n",(int)sizeof(doble));
    return 0;
  
}
