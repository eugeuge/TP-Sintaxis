%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "interprete.tab.h"
%}
%option noyywrap

espacio         [ \t\n]+
inicio inicio
fin fin
leer leer
escribir escribir
identificador	[a-zA-z][a-zA-Z0-9]{0,31}
integer		[0-9]+

%%

{espacio}		{}
{inicio}	{ return INICIO;}
{fin}	{ return FIN; }
{leer}	{return LEER;}
{escribir}	{return ESCRIBIR;}
{integer}	{
				yylval.val=atoi(yytext);
				return INTEGER;
				}
{identificador}	{
				strcpy(yylval.text,yytext);
				return ID;
				}


"+"					return(MAS);
"-"					return(MENOS);
"("					return(PARENT_IZQ);
")"					return(PARENT_DER);
":="				return(ASIGNACION);
","					return(COMA);
";"					return(FIN_SENTENCIA);

%%
