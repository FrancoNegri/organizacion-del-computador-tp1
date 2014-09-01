#include "lista.h"
#include <stdio.h>

int testSizes();
int testJugador();
int testNodo();
int testJugador2(); 
int testLista();
int testJugador3();
int testJugador4();

int main(void) {

    testSizes();
    testNodo();
    testJugador();
    testJugador2();
    testJugador3();
    testJugador4();
    testLista();

    return 0;
}

int testNodo()
{
	int hola = 1;
	printf("Creando Nodo...\n");
	nodo *miNodo = nodo_crear(&hola);
	printf("Ok!\n");
	printf("Dato: %d \n", *(int*)miNodo->datos);
	return 0;
}

int testJugador()
{
    char *nombre = "pepe";
    char *nombre2 = "papo";
    char *pais = "pepe";
    printf("Creando jugador...\n");
    jugador *pepe = crear_jugador(nombre,pais,'4',30);
    jugador *papo = crear_jugador(nombre2,pais,'4',30);
    printf("Ok!\n");
    printf("numero: %c \n",pepe->numero);
    printf("Nombre: %s \n",pepe->nombre);
    printf("Pais: %s \n",pepe->pais);
    printf("Altura: %u \n",(unsigned int)pepe->altura);

    if(menor_jugador(pepe,papo))
    {
        printf("Menor jugador, papo\n");
    }
    borrar_jugador(papo);
    borrar_jugador(pepe);
    return 0;
}


int testJugador2()
{
    char *nombre = "pepe";
    char *nombre2 = "pepe";
    char *pais = "pepe";
    printf("Creando jugador...\n");
    jugador *pepe = crear_jugador(nombre ,pais,'4',30);
    jugador *pepe2 = crear_jugador(nombre2 ,pais,'4',40);
    printf("Ok!\n");

    if(menor_jugador(pepe,pepe2))
    {
        printf("Menor jugador, pepe\n");
    }
    if(pais_jugador(pepe,pepe2))
    {
        printf("Pertenecen al mismo pais\n");
    }
    borrar_jugador(pepe2);
    borrar_jugador(pepe);
    return 0;
}


int testJugador3()
{
    char *nombre = "pepe";
    char *pais = "pepe";
    printf("Creando jugador...\n");
    jugador *pepe = crear_jugador(nombre ,pais,'4',30);
    printf("Ok!\n");
    FILE* target = fopen("mitest.txt","a");
    imprimir_jugador(pepe, target);
    imprimir_jugador(pepe, target);
    borrar_jugador(pepe);
    fclose(target);
    return 0;
}

int testJugador4()
{
    char *nombre = "Pepe";
    char *pais = "pepe";
    printf("Creando jugador...\n");
    jugador *pepe = crear_jugador(nombre ,pais,'4',196);
    printf("Ok!\n");

    jugador *pepeNormalizado = normalizar_jugador(pepe);
    printf("numero: %c \n",pepeNormalizado->numero);
    printf("Nombre: %s \n",pepeNormalizado->nombre);
    printf("Pais: %s \n",pepeNormalizado->pais);
    printf("Altura: %u \n",(unsigned int)pepeNormalizado->altura);
    borrar_jugador(pepeNormalizado);
    borrar_jugador(pepe);
    return 0;
}



int testLista()
{
    lista *miLista;
    printf("Creando Lista...\n");
    miLista = lista_crear();
    printf("Borrando Lista...\n");
    lista_borrar(miLista, NULL);
    printf("Ok!\n");
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
