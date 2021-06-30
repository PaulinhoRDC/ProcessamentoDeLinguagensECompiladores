%option noyywrap

%%
(?i:lista)      {return (LISTA);}
[0-9]+          {yylval.valI=atoi(yytext); return(NUMERO);}
[a-zA-Z]+       {yylval.valS=strdup(yytext);return(PAL);}
\.              {return('.');}
\,              {return(',');}
\#              {return('#');}
.|\n            {;}
%%