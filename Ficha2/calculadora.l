%{
# include<ctype.h>
%}
%option noyywrap

%%
[+\-*/()\n=]            {return yytext[0];}
(?i:EQ|==)              {return EQ;}
(?i:NE|!=)              {return NE;}
(?i:LT|<)               {return LT;}
(?i:LE|<=)              {return LE;}
(?i:GT|>)               {return GT;}
(?i:GE|>=)              {return GE;}
(?i:TRUE)               {return TRUE;}
(?i:FALSE)              {return FALSE;}
(?i:OU)                 {return OU;}
(?i:E)                  {return E;}    
[A-Za-z]                {yylval.valC=toupper(yytext[0]);return ID;}
[0-9]+("."[0-9]*)?      {yylval.valN=atof(yytext); return(NUM);}
[. \n]                   {;}
%%
