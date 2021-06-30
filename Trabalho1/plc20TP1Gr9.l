%{
/* Declaracoes C diversas */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char buf[2000];
typedef struct commentThread{
        char* id;
        char* user;
        char* date;
        char* commentText;
        int nlikes;
        int nReplies;
        struct commentThread* replies;
        struct commentThread* next;
}*CommentThread;

extern FILE *yyin, *yyout;
CommentThread inicio, next;
CommentThread a[20];
int i=-1;
int depth,aux;
int id=200;
%}


%option stack

%x HID  USERT HUSER HDATE HCOMMENT HLIKES 
%x HREPLIES
       
     
%%
data\-message\-depth\=\"                               {yy_push_state(HREPLIES);}
<HREPLIES>\"                            {yy_pop_state();}
<HREPLIES>[0-9]+                        {
                                                                                depth=atoi(yytext);
                                                                                next=malloc(sizeof(struct commentThread));
                                                                                next->nlikes=0;
                                                                                next->nReplies=0;
                                                                                if (depth<=i){
                                                                                        if(depth<i){
                                                                                                for(;depth!=i;i--){
                                                                                                       a[(20+i-1)%20]->nReplies+=a[(20+i)%20]->nReplies; 
                                                                                                }
                                                                                                a[(20+i-1)%20]->nReplies+=a[(20+i)%20]->nReplies; 
                                                                                        }

                                                                                       a[(20+i)%20]->next=next;
                                                                                       a[(20+i)%20]=a[(20+i)%20]->next; 
                                                                                }else{
                                                                                        if(depth==(i+1)){
                                                                                        a[(20+i)%20]->replies=next;
                                                                                        a[(i+1)%20]=a[(20+i)%20]->replies;
                                                                                        i++;
                                                                                        
                                                                                }
                                                                                       
                                                                                }
                                                                                a[(20+i-1)%20]->nReplies+=1;
                                                                             }
data\-spot\-im\-class\=\"message-username\"" "tabindex\=\"[0-9]*\"\>        {yy_push_state(HUSER);}
<HUSER>\<\/span>                                                            {yy_pop_state();}
<HUSER>[^<]+                                                                {a[(20+i)%20]->user=strdup(yytext);}


"data-spot-im-class="\""message-timestamp"\"\>                              {yy_push_state(HDATE);}
<HDATE>\<\/time\>                                                           {a[(20+i)%20]->date=strdup(buf);buf[0]='\0';yy_pop_state();}
<HDATE>&nbsp;                                                               {;}
<HDATE>[^(<|;|&)]+                                                          {strcat(buf,yytext);strcat(buf," \0");}


data\-spot\-im\-class\=\"message-text\"\>(\<ul" "class\=\"spcv_ul\"\>)?      {yy_push_state(HCOMMENT);}
class\=\"spcv\_is\-deleted\"\>\<span\>                                       {yy_push_state(HCOMMENT);}
<HCOMMENT>(\<\/div\>)                                                        {a[(20+i)%20]->commentText=strdup(buf);buf[0]='\0';yy_pop_state();} 
<HCOMMENT>(\<\/?strong\>|\<\/?span[^>]*\>|\<\/?li\>|\<\/ul\>|\<\/?em\>)      {;}
<HCOMMENT>\"              {strcat(buf,"\\\"\0");}
<HCOMMENT>[^(<|\n|\")]+                                                      {strcat(buf,yytext);}
                                                                                        


class\=\"spcv\_number\-of\-votes\"\>                                         {yy_push_state(HLIKES);}
<HLIKES>Likes?\<\/span\>                                                      {yy_pop_state();}
<HLIKES>[0-9]+                                                              {a[(20+i)%20]->nlikes=atoi(yytext);}

id\=\"comment\-description\-                                                 {yy_push_state(HID);}      
<HID>\-?[0-9]+                                                               {a[(20+i)%20]->id=strdup(yytext);}
<HID>\"                                                                      {yy_pop_state();}

<*>(.|\n)                                                                        {;}






%%


int yywrap()
{ return(1); }





void writejson(FILE* yyout,CommentThread s)
{
        while (s!=NULL)              //enquanto houver elementos na lista
        {
                fprintf(yyout,"{\n");
                if(s->id==NULL){
                        fprintf(yyout,"\"id\": \"%d\",\n",id++);
                }else{
                        fprintf(yyout,"\"id\": \"%s\",\n",s->id);
                }
                fprintf(yyout,"\"user\": \"%s\",\n",s->user);
                fprintf(yyout,"\"date\": \"%s\",\n",s->date);
                fprintf(yyout,"\"timestamp\": \"NA\",\n");
                fprintf(yyout,"\"commentText\": \"%s\",\n",s->commentText);
                fprintf(yyout,"\"likes\": %d,\n",s->nlikes);
                if (s->nReplies==0){
                        fprintf(yyout,"\"hasReplies\": false,\n");
                        fprintf(yyout,"\"numberOfReplies\": 0,\n");
                        fprintf(yyout,"\"replies\": []\n");
                }else{
                        fprintf(yyout,"\"hasReplies\": true,\n");
                        fprintf(yyout,"\"numberOfReplies\": %d,\n",s->nReplies);
                        fprintf(yyout,"\"replies\": [\n");
                        writejson(yyout,s->replies);
                        fprintf(yyout,"]\n");
                }
                if (s->next==NULL){
                        fprintf(yyout,"}\n");
                }else{
                    fprintf(yyout,"},\n");    
                }
                next=s;
                s=s->next;
                free(next);
        }
}

int main(int argc,char* argv[])
{
        buf[0]='\0';
        if (argc>1){strcpy(buf,argv[1]);}
        else{strcpy(buf,"exp.html");}
        yyin=fopen(buf,"r"); 
        

        inicio=malloc(sizeof(struct commentThread));
        buf[0]='\0';
        inicio->nlikes=0;
        a[20-1%20]=inicio;

        yylex();
        buf[0]='\0';
        if (argc>2){strcpy(buf,argv[2]);}
        else{strcpy(buf,"out.json");}
        yyout=fopen(buf,"w"); 
        fprintf(yyout,"{\n\"commentThread\": [\n");
        writejson(yyout,inicio->replies);
        free(inicio);
        fprintf(yyout,"]\n}\n");

        return 0;
}

