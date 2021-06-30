%{
#include <stdio.h>
#include <string.h>
#define NUM  1
#define PAL  2
#define PESQ 3
#define PDIR 4
void recT(int s);
void recList();
void recREList();
void recSExp();
int t; // variavel global para o simbolo T em analise
%}
%option noyywrap
%%

"("         {return PESQ;}
")"         {return PDIR;}
[0-9]+      {return NUM;}
[a-zA-Z]+   {return PAL;}
.|\n        {;}
%%


void recT(int s){
    if (t==s){t=yylex();}
    else {printf("erro: foi lido %d quando se esperava%d\n",t,s);}
}
void recList(){
    if(t==NUM || t==PAL || t== PESQ){recSExp();recREList();}
    else {printf("erro sintatico\n");}
}

void recREList(){
    if(t==NUM || t==PAL || t== PESQ){recList();}
    else{
        if(t==PDIR){;}
        else {printf("erro sintatico\n");}
    }
    
}

void recSExp(){
    if(t==NUM){recT(NUM);}
    else {
        if (t==PAL){recT(PAL);}
        else{
            if(t==PESQ){recT(PESQ); recList(); recT(PDIR);}
            else {printf("erro sintatico\n");}
        }
    }
}

int main(){
    t=yylex();
    printf("inicio do parcing\n");
    recSExp();
    printf("fim do parcing\n");
    return 0;
}