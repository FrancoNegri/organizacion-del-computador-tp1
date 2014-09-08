#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <vector>
#include <stdlib.h>
#include <algorithm> 
#include <functional> 
#include <cctype>
#include <locale>
using namespace std;

int chequeo_push(string line);
int chequeo_pop(string line);
int chequeo_sub_and_add_rsp(string line);
int chequeo_ret_valido(string line);
int chequeo_call_alineado(string line);
static inline std::string &trim(std::string &s);


int contador = 0;
int contadorDePushs = 0;
int nErrores = 0;
int nWarnings = 0;
int nNotas = 0;
vector<string> memoriaPusheada;



int main () {
  string line;
  ifstream myfile ("lista_asm.asm");

  if (myfile.is_open())
  {
    cout << "==3220== Frankgrind detector automatico de errores asam" << endl;
    cout << "==3220==" << endl;
    cout << "==3220== Errores = Extremadamente posible que este codigo no ande como devería" << endl;
    cout << "==3220== Warnings = codigo peligroso" << endl;
    cout << "==3220== Notas = codigo que puede o no andar, queda en manos del programador verificarlo" << endl;
    cout << "==3220==" << endl;
    cout << "==3220==" << endl;
    cout << "==3220== Iniciando análisis..." << endl;
    cout << "==3220==" << endl;

    while ( getline (myfile,line) )
    {
      contador++;
      line = line.substr(0,line.find(';',0));
      trim(line);
      for (std::string::iterator it = line.begin(); it != line.end(); ++it)
            *it = static_cast<char>(std::tolower(static_cast<unsigned char>(*it)));
      if(line.find("qword") != std::string::npos)
        line.erase(line.find(" qword"), 6);
      if(line.find("dword") != std::string::npos)
        line.erase(line.find(" dword"), 5);
      if(line.find("word") != std::string::npos)
        line.erase(line.find(" word"), 5);
      if(line.find("byte") != std::string::npos)
        line.erase(line.find(" byte"), 5);

      if(chequeo_push(line))
        continue;
      if(chequeo_pop(line))
        continue;
      if(chequeo_call_alineado(line))
        continue;
      if(chequeo_ret_valido(line))
        continue;
      if(chequeo_sub_and_add_rsp(line))
        continue;
      
    }
    myfile.close();
  }
  else {cout << "Unable to open file"; }
  cout << "==3220== Fin del analisis!" << endl;
  cout << "==3220== Errores: " << nErrores << endl;
  cout << "==3220== Warnings: " << nWarnings << endl;
  cout << "==3220== Notas: " << nNotas << endl;

  return 0;
}


int chequeo_push(string line)
{
  if(line.find("push") != std::string::npos)
  {
      contadorDePushs++;
      int primerEspacio = line.find(' ',0);
      string dirPush = line.substr(primerEspacio + 1,string::npos);
      memoriaPusheada.push_back(dirPush);
      return 1;
  }
  return 0;
}

int chequeo_pop(string line)
{
  if(line.find("pop") != std::string::npos)
  {
     contadorDePushs--;
     if(!memoriaPusheada.empty())
     {
      string dirAnterior = memoriaPusheada.back();
      memoriaPusheada.pop_back();
      
      int primerEspacio = line.find(' ',0);

      string dirPopeada = line.substr(primerEspacio + 1,string::npos);
      if(dirPopeada.find(dirAnterior))
      {
        if((dirPopeada.find("r15") != string::npos || dirPopeada.find("r14") != string::npos || dirPopeada.find("r13") != string::npos || dirPopeada.find("r12") != string::npos || dirPopeada.find("rbx") != string::npos) && dirPopeada.find("[") == string::npos )
        {
          cout << "==3220== Warning, Linea: " << contador  << ", push en: " << dirAnterior << " pero pop en: " << dirPopeada << endl ;
          cout << "==3220== \t Posiblemente no se esta respentando la convención C x86" << endl;
          cout << "==3220==" << endl;
          nWarnings++;
        }else{
          cout << "==3220== Notar, Linea: " << contador  << ", push en: " << dirAnterior << " pero pop en: " << dirPopeada << "\n==3220==\n" ;
          nNotas++;  
        }
      }
     }else
      {
        cout << " ==3220== Warning, Linea: " << contador << ", se hace pop de basura \n==3220==\n";
        nWarnings++;
      }
     return 1;
  }
  return 0;
}

int chequeo_sub_and_add_rsp(string line)
{
   if( (line.find("sub rsp") != std::string::npos) || (line.find("add rsp") != std::string::npos))
        {
            int posDeLaComa = line.find(',',0);
            std::istringstream iss( line.substr(posDeLaComa + 1, std::string::npos));
            int numero;
            iss >> numero;
            div_t resultado = div(numero,8);
            if(line.find("sub rsp") != std::string::npos)
            {                
                contadorDePushs += resultado.quot;
            }
          if(line.find("add rsp") != std::string::npos)
          {
                contadorDePushs -= resultado.quot;
          }
          return 1;
        }
      return 0;
}

int chequeo_call_alineado(string line)
{
  if(line.find("call") != std::string::npos)
  {
     if((contadorDePushs + 1) % 2 != 0)
     {
       cout << "==3220== Warning, linea: " << contador << ", la pila esta desalineada al momento del call\n==3220==\n" ;
       nWarnings++;
     }
     return 1;
  }
  return 0;
}
int chequeo_ret_valido(string line)
{
  if(line.find("ret") != std::string::npos)
  {
     if(contadorDePushs != 0)
     {
       cout << "==3220== Error, mala posicion de la pila al final de la funcion: " << contador << "\n==3220==\n" ;
       contadorDePushs = 0;
       memoriaPusheada.clear();
       nErrores++;
     }
     return 1;
  }
  return 0;
}


static inline std::string &ltrim(std::string &s) {
        s.erase(s.begin(), std::find_if(s.begin(), s.end(), std::not1(std::ptr_fun<int, int>(std::isspace))));
        return s;
}

// trim from end
static inline std::string &rtrim(std::string &s) {
        s.erase(std::find_if(s.rbegin(), s.rend(), std::not1(std::ptr_fun<int, int>(std::isspace))).base(), s.end());
        return s;
}

// trim from both ends
static inline std::string &trim(std::string &s) {
        return ltrim(rtrim(s));
}