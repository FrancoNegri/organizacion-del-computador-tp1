#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <vector>
#include <stdlib.h>
using namespace std;

int main () {
  string line;
  int contador = 1;
  ifstream myfile ("lista_asm.asm");

  int contadorDePushs = 0;

  vector<string> memoriaPusheada;

  if (myfile.is_open())
  {
    cout << "Corriendo Frankgrind....\n";
    cout << "........................\n\n";
    while ( getline (myfile,line) )
    {
      //line.substr(6,line.find(';',0)); 
      if(line.find("push") != std::string::npos)
        {
           contadorDePushs++;
            memoriaPusheada.push_back(line.substr(6,line.find(' ',0)));
        }
        if(line.find("pop") != std::string::npos)
        {
           contadorDePushs--;
           if(!memoriaPusheada.empty())
           {
            string dirAnterior = memoriaPusheada.back();
            memoriaPusheada.pop_back();
            if(line.substr(5,string::npos).find(dirAnterior))
            {
              cout << "Warning, se pushea en: " << dirAnterior << " pero se popea en: " << line.substr(5,string::npos) << "\n" ;
              cout << "en la linea: " << contador << "\n\n";
            }
           }else
            {
              cout << "Warning, en la linea: " << contador << " se pusea basura \n\n";
            }
           
        }
        if(line.find("sub rsp") != std::string::npos)
        {
          std::istringstream iss(line.substr(6,line.find(',',0)));
          int numero;
          iss >> numero;
          div_t resultado = div(numero,8);
          contadorDePushs += resultado.quot;
        }
        if(line.find("add rsp") != std::string::npos)
        {
          std::istringstream iss(line.substr(6,line.find(',',0)));
          int numero;
          iss >> numero;
          div_t resultado = div(numero,8);
          contadorDePushs -= resultado.quot;
          cout << resultado.quot << "\n";
        }

        if(line.find("call") != std::string::npos)
        {
           if((contadorDePushs-1) % 2== 0)
           {
             cout << "Warning, en la linea: " << contador << " la pila esta desalineada al momento del llamado\n\n" ;
           }
        }
        if(line.find("ret") != std::string::npos)
        {
           if(contadorDePushs != 0)
           {
             cout << "Error, mala posicion de la pila al final de la funcion: " << contador << "\n\n" ;
             contadorDePushs = 0;
             memoriaPusheada.clear();
           }
        }

      contador++;
    }
    myfile.close();
  }
  else {cout << "Unable to open file"; }
  cout << "Fin del analisis!\n";


  return 0;
}