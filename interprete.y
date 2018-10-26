%{
#define YYSTYPE int
%}

%union{
        int val;
        char *text;
}


%token 	<val>INTEGER
%token 	MAS MENOS
%token 	PARENT_IZQ 		PARENT_DER
%token 	ASIGNACION
%token 	COMA
%token 	FIN_SENTENCIA
%token 	INICIO 			FIN
%token 	LEER 			ESCRIBIR
%token  ID

%left 	MAS 			MENOS

%type<val>Expresion
%type<val>Primaria
%type<text>ID


%start 	Input

%%

Input:  INICIO Lista_Sentencias FIN
				;

Lista_Sentencias:	Sentencia
					      | Sentencia Lista_Sentencias
					      ;

Sentencia:  ID ASIGNACION Expresion FIN_SENTENCIA  { declaracionOAsignacion($1,$3); }
					| LEER PARENT_IZQ Lista_Ids PARENT_DER {}
					| ESCRIBIR PARENT_IZQ Lista_Expr PARENT_DER {}
					;

Lista_Ids:  ID { leer($1); }
					| ID COMA Lista_Ids { leer($1); }
					;

Lista_Expr:	Expresion { escribir($1); }
					| Expresion COMA Lista_Expr {  escribir($1);  }
					;

Expresion:	Primaria { $$=$1; }
					| Primaria MAS Primaria { $$ = $1 + $3; }
          | Primaria MENOS Primaria { $$ = $1 - $3; }
					;

Primaria:		ID { $$ = buscarValor($1); }
					| INTEGER { $$ = $1 }
					| PARENT_IZQ Expresion PARENT_DER { $$ = $2}
					;

%%
#define SIZE 100

struct identificador{
    char nombre[33];
    int valor;
}identificadores[SIZE];

int yyerror(char *s){
  printf("Error en la compilacion. %s\n",s);
}

int main(int argc,int **argv) {
    inicializarVectorNombre();
    if(argc==1){
        yyparse();
    } else if(argc==2){
        yyin = fopen(argv[1], "r");
        if(!yyin){
            printf("ERROR: no se pudo abrir el archivo. Ingrese otro.");
            return -1;
          }
        yyparse();

        }
    } else { printf("ERROR: Parametros incorrectos. Por favor ingrese la cantidad de parametros correcta."); }
    return 0;
}

void inicializarVectorNombre(){
    for (int i=0;i<SIZE;i++)
      identificadores[i].nombre[0]='\0';
}

int existeID(char *nombre,int *i){
    for(*i;*i<SIZE && identificadores[*i].nombre[0]!='\0';(*i)++) if (!strcmp(identificadores[*i].nombre,nombre)) return 1;
    return 0;
}

void declaracionOAsignacion(char *nombre,int valor){
    int i = 0;
    if(!existeID(nombre,&i)){ // Si no existe el ID (Declaracion y asignacion)
      strcpy(identificadores[i].nombre,nombre);
      identificadores[i].valor=valor;
    } else{ // Existe el ID (Asignacion)
      identificadores[i].valor=valor;
    }
    return;
}

void leer(char *nombre){
    int valor;
    printf("\n%s = ",nombre);
    scanf("%d",&valor);
    declaracionOAsignacion(nombre,valor);
}

void escribir(int valor){
    printf("\n%d\n",valor);
}

int buscarValor(char *nombre){
    int i=0;
    existeID(nombre,&i);
    return identificadores[i].valor;
}
