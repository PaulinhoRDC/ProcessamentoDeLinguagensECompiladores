%{
/* Declaracoes C diversas */

#include <stdio.h>
#include <string.h>
#define Max 50
char entrevistador[Max];
char entrevistado[Max];
%}
%x rentrevistador rentrevistado
        /* Abreviaturas de ER */
digito    [0-9]
acentos   \xc3[\x80-\xbf]       
letra     [a-zA-Z]|{acentos}       
palavra   {letra}+         
     
%%  
 //^[eE][uU][=].+        {strcpy(entrevistador,yytext+3);} fica com ponto
 //^[eE][uU][=][^.]+          {strcpy(entrevistador,yytext+3);}

^[eE][uU][' ']*(=)[' ']*        { BEGIN rentrevistador;}
<rentrevistador>[^.]+           {strcpy(entrevistador,yytext);}
<rentrevistador>\.\n            {BEGIN INITIAL;}

^[eE][Ll][eE][' ']*[=][' ']*    { BEGIN rentrevistado;}
<rentrevistado>[^.]+            {strcpy(entrevistado,yytext);}
<rentrevistado>\.\n             {BEGIN INITIAL;}

^[eE][uU][' ']*\:               {printf("%s: ",entrevistador); }
^[eE][Ll][eE][' ']*\:           {printf("%s: ",entrevistado);}

 /*
 "//" .*\n  {;}

 "/*"  {BEGIN COM;}
 <COM>"" {BEGIN INITIAL;}
 <COM>
 
 */







%%

int yywrap()
{ return(1); }

int main()
{
 yylex();
 return 0;
 }
