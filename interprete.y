%{
#include <stdio.h> 
#define YYSTYPE int
}%

%union{
        int val;
        char text[32];
}


%token 	<val>INTEGER 
%token 	MAS MENOS 
%token 	PARENT_IZQ 		PARENT_DER
%token 	ASIGNACION
%token 	COMA
%token 	FIN_SENTENCIA
%token 	INICIO 			FIN
%token 	LEER 			ESCRIBIR

%left 	MAS 			MENOS

%start 	Input

%%

//@Queda ver si ejecutamos codigo C aca

Input:				INICIO Lista_Sentencias FIN
					;

Lista_Sentencias:	Sentencia
					| Sentencia Lista_Sentencias
					;

Sentencia:			ID ASIGNACION Expresion FIN_SENTENCIA
					| LEER PARENT_IZQ Lista_Ids PARENT_DER
					| ESCRIBIR PARENT_IZQ Lista_Expr PARENT_DER
					;

Lista_Ids:			ID
					| ID COMA Lista_Ids
					;

Lista_Expr:			Expresion
					| Expresion COMA Lista_Expr
					;

Expresion:			Inicial
					| Inicial Operador_Aditivo Inicial
					;

Inicial:			ID
					| INTEGER
					| PARENT_IZQ Expresion PARENT_DER
					;

Operador_Aditivo:	MAS
					| MENOS
					;

%%

int yyerror(char *s){
  printf("Error en la expresion. %s\n",s);
}

int main() {
  yyparse();
}