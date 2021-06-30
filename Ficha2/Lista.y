%{
#include <stdio.h>
#include <string.h>
int conta;
int contaN=0;
float soma=0;
float media;
char* max;
%}
%union {int valI;char* valS;}
%token LISTA
%token <valS> PAL
%token <valI> NUMERO
%type <valI> elemento elementos
%%
Entrada: Listas '#'

Listas: Lista 
      | Lista Listas '#'
      ;
      
Lista: LISTA elementos '.'              {printf("comprimento = %d\n",conta);
                                        media=contaN? soma / contaN : 0;printf("A media é: %f\n",media);
                                        conta=contaN=soma=0;
                                        printf("A maior palavra é: %s\n",max);
                                        max=strdup("");
                                        printf("o somatorio = %d\n",$2);}
     ;

elementos: elemento                     {conta=1;$$=$1;}
         | elementos ',' elemento       {conta++;$$=$1+$3;}
         ;

elemento: NUMERO                        {contaN++;soma+= $1;$$=$1;}
        | PAL                           {if(strcmp($1,max)>0){max=strdup($1);};$$=0;}
        ;
%% 

#include "lex.yy.c"

int yyerror(char* s){
        printf("Frase invalida:%s\n",s);
}


int main(){
        max=strdup("");
                printf("Inicio do parsing\n");
        yyparse();
                printf("Fim do parsing\n");
        return 0;
}