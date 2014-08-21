#include "lista.h"
#include <stdio.h>

int testSizes();

int main(void) {
    testSizes();
    return 0;
}

int testSizes()
{
    int * puntero;
    int entero;
    char caracter;
    double doble;
    printf("Test de tamaños para gcc \n");
    printf("Entero: %d \n",sizeof(entero));
    printf("Puntero: %d \n",sizeof(puntero));
    printf("Caracter: %d \n",sizeof(caracter));
    printf("Doble: %d \n",sizeof(doble));
    return 0;
  
}
