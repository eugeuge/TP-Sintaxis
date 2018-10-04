%{
#include <stdlib.h>
#include <stdio.h>
//incluir el header que crea bison
}%
%option noyywrap

espacio         [ \t\n]+
identificador	[a-zA-z][a-zA-Z0-9]{0,31}
integer		[0-9]+
%%

{espacio}		{}
{integer}	{
				yylval.val=atoi(yytext); //@capaz funca
				return INTEGER
				}
{identificador}	{
				strcpy(yylval.text,yytext);
				return ID
				}

"+"				return(MAS);
"-"				return(MENOS);
"("				return(PARENT_IZQ);
")"				return(PARENT_DER);
":="			return(ASIGNACION);
","				return(COMA);
";"				return(FIN_SENTENCIA);

"inicio"		return(INICIO);
"fin"			return(FIN);
"leer"			return(LEER);
"escribir"		return(ESCRIBIR);

%%
