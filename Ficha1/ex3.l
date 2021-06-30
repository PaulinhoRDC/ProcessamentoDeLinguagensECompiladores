%{
/* Declaracoes C diversas */
#include <stdio.h>
#include <strings.h>

%}

digito [0-9]
inteiro (\-|\+)?{digito}+
real {inteiro}\.{digito}+
%%

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

