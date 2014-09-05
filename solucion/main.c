#include "lista.h"
#include <stdio.h>

int testSizes();
int testJugador();
int testNodo();
int testJugador2(); 
int testLista();
int testJugador3();
int testJugador4();
int testCompararStrings();
int compararStrings(char *s1, char *s2);
int testJugadores();
int testSeleccion();

int main(void) {

 //   testSizes();
 //   testNodo();
 //  testJugador();
 //   testJugador2();
 //   testJugador3();
 //  testJugador4();
 //   testLista();

 //   testCompararStrings();

 //   testJugadores();

    testSeleccion();

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
    char *nombre = "pepe";
    char *pais = "pepe";
    printf("Creando jugador...\n");
    jugador *pepe = crear_jugador(nombre ,pais,'4',196);
    printf("Ok!\n");

    jugador *pepeNormalizado = normalizar_jugador(pepe);
    printf("NORMALIZADO\n");
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
    char *nombre = "aaa";
    char *pais = "pepe";
    jugador *pepe = crear_jugador(nombre ,pais,'4',196);
    
    char *nombre2 = "ccc";
    char *pais2 = "pepe";
    jugador *pepe2 = crear_jugador(nombre2 ,pais2,'4',196);
    
    char *nombre3 = "bbb";
    char *pais3 = "pepe";
    jugador *pepe3 = crear_jugador(nombre3 ,pais3,'4',196);
    
    lista *miLista;

    printf("Creando Lista...\n");
    miLista = lista_crear();
     
    printf("Insertando jugador 1\n");
    insertar_ordenado(miLista,(void*)pepe, (tipo_funcion_cmp)&menor_jugador);
    
    printf("Insertando jugador 2\n");
    insertar_ordenado(miLista,(void*)pepe2, (tipo_funcion_cmp)&menor_jugador);

    printf("Insertando jugador 3\n");
    insertar_ordenado(miLista,(void*)pepe3, (tipo_funcion_cmp)&menor_jugador);

    nodo *unNodo = miLista->primero;
    jugador *unj = unNodo->datos;
    printf("Nombre: %s \n",unj->nombre);

    unNodo = miLista->primero->sig;
    unj = unNodo->datos;
    printf("Nombre: %s \n",unj->nombre);

    unNodo = miLista->primero->sig->sig;
    unj = unNodo->datos;
    printf("Nombre: %s \n",unj->nombre);

    lista* B = mapear(miLista, (tipo_funcion_mapear)&normalizar_jugador);

    printf("Borrando Lista...\n");
    lista_borrar(B, (tipo_funcion_borrar)&borrar_jugador);
    lista_borrar(miLista, (tipo_funcion_borrar)&borrar_jugador);
    printf("Ok!\n");
    return 0;
}

int testCompararStrings()
{
    char *s1 = "b";
    char *s2 = "a";
    if(compararStrings(s1,s2) == 2)
        printf("exito! \n");
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

int testJugadores()
{
    lista* A = lista_crear();
    jugador* Gino = crear_jugador("Ginobili", "Argentina", 6, 198);
    jugador* GinoPies = normalizar_jugador(Gino);
    insertar_ordenado(A, (void*)GinoPies, (tipo_funcion_cmp)&menor_jugador);
    borrar_jugador(Gino);
    Gino = A->primero->datos;
    printf("NORMALIZADO\n");
    printf("numero: %c \n",Gino->numero);
    printf("Nombre: %s \n",Gino->nombre);
    printf("Pais: %s \n",Gino->pais);
    printf("Altura: %u \n",(unsigned int)Gino->altura);
    lista_borrar(A, (tipo_funcion_borrar)&borrar_jugador);
    return 0;
}


int testSeleccion()
{
    lista* A = lista_crear();
    jugador* Gino = crear_jugador("Ginobili", "Argentina", 6, 198);
    jugador* GinoPies = normalizar_jugador(Gino);
    jugador* Gino2 = crear_jugador("Ginobili", "Argentina", 6, 198);
    jugador* GinoPies2 = normalizar_jugador(Gino);
    insertar_ordenado(A, (void*)GinoPies, (tipo_funcion_cmp)&menor_jugador);
    insertar_ordenado(A, (void*)Gino, (tipo_funcion_cmp)&menor_jugador);
    insertar_ordenado(A, (void*)GinoPies2, (tipo_funcion_cmp)&menor_jugador);
    insertar_ordenado(A, (void*)Gino2, (tipo_funcion_cmp)&menor_jugador);
    seleccion* w = crear_seleccion("Argentina", altura_promedio(A), A);
    
    

    lista* B = lista_crear();
    jugador* a = crear_jugador("a", "Argentina", 6, 143);
    jugador* b = normalizar_jugador(Gino);
    jugador* c = crear_jugador("b", "Argentina", 6, 400);
    jugador* d= normalizar_jugador(Gino);
    insertar_ordenado(B, (void*)a, (tipo_funcion_cmp)&menor_jugador);
    insertar_ordenado(B, (void*)b, (tipo_funcion_cmp)&menor_jugador);
    insertar_ordenado(B, (void*)c, (tipo_funcion_cmp)&menor_jugador);
    insertar_ordenado(B, (void*)d, (tipo_funcion_cmp)&menor_jugador);
    seleccion* j = crear_seleccion("Argentina", altura_promedio(B), B);

    lista *listaDeSelecciones = lista_crear();
    insertar_ordenado(listaDeSelecciones, w, (tipo_funcion_cmp)menor_seleccion);
    insertar_ordenado(listaDeSelecciones, j, (tipo_funcion_cmp)menor_seleccion);


    lista_borrar(listaDeSelecciones, (tipo_funcion_borrar)borrar_seleccion);
    printf("OK\n");
    return 0;
}