#include "lista.h"
#include <stdio.h>

int main(void) {
    testSizes();
    return 0;
}

int testSizes()
{
    int * puntero;
    int entero;
    char caracter;
    printf("Test de tamaños para gcc \n");
    printf("Entero: %d \n",sizeof(entero));
    printf("Puntero: %d \n",sizeof(puntero));
    printf("Caracter: %d \n",sizeof(caracter));
    return 0;
  
}
