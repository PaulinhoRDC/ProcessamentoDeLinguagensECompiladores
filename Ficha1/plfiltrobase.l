%{
/* Declaracoes C diversas */
#include <stdio.h>
#include <strings.h>
int cnt=0;
float saldo=0.0;
%}

digito [0-9]
inteiro (\-|\+)?{digito}+
real {inteiro}\.{digito}+
%%
(\-|\+)?{digito}+\.[0-9]{2}   {cnt++; saldo +=atof(yytext); }
.|\n      { ; }
%%


int yywrap()
{ return(1); }

int main()
{ 
	yylex(); 
		printf("encontrei %d numeros\n", cnt);
		printf("o saldo é: %f \n", saldo); 
	return 0; 
}

/*
flex plfiltrobase.l
gcc -o numeros lae.yy.c
./numeros
...

ctrl+d {para terminar yylex(),}
*/

