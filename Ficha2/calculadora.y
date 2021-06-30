%{
#include <stdio.h>
#include <string.h>
float TabId[26];
%}
%union{float valN;char valC;}
%token <valN> NUM
%token <valC> ID
%token TRUE FALSE
%token EQ NE LT LE GT GE
%token E OU
%type <valN> Expr Termo Fator ExprR

%%
Exprs : Ex
      | Exprs Ex
      ;

Ex : Atrib
   | ExprR '\n'                 {printf("->%f\n",$1);}
   ;

Atrib : ID  '=' ExprR '\n'      {TabId[$1-'A']= $3;printf("->%f\n",$3);}
      ;

ExprR : Expr                    {$$ = $1;}
      | ExprR EQ ExprR          {$$ = ($1==$3);}
      | ExprR NE ExprR          {$$ = ($1!=$3);}
      | ExprR LT ExprR          {$$ = ($1<$3);}
      | ExprR LE ExprR          {$$ = ($1<=$3);}
      | ExprR GT ExprR          {$$ = ($1>$3);}
      | ExprR GE ExprR          {$$ = ($1>=$3);}
      ;

Expr : Termo                    {$$ = $1;}
     | Expr '+' Termo           {$$ = $1 + $3;}
     | Expr '-' Termo           {$$ = $1 - $3;}
     | Expr OU Termo            {$$ = $1 || $3;}
     ;

Termo : Fator                   {$$ = $1;}
      | Termo '*' Fator         {$$ = $1 * $3;}
      | Termo '/' Fator         {$$ = $1 / $3;}
      | Termo E Fator           {$$ = $1 && $3;}
      ;

Fator : NUM                     {$$ = $1;}
      | '-' NUM                 {$$ = (-1) * $2;}
      | ID                      {$$ = TabId[$1-'A'];}
      | TRUE                    {$$ = 1;}
      | FALSE                   {$$ = 0;}
      | '('Expr')'              {$$ = $2;}
      ;

%% 

#include "lex.yy.c"

int yyerror(char* s){
        printf("Frase invalida:%s\n",s);
}


int main(){
                printf("Inicio do parsing\n");
        yyparse();
                printf("Fim do parsing\n");
        return 0;
}