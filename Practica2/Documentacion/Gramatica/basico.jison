%lex



lexic [lL][eE][xX]

termin [tT][eE][rR][mM][iI][nN][aA][lL]

nterm [nN][oO]"_"[tT][eE][rR][mM][iI][nN][aA][lL]

wiss [W][i][s][o][n]

syntaxis [sS][yY][nN][tT][aA][xX]

initialSIM [iI][nN][iI][tT][iI][aA][lL]"_"[sS][iI][mM]

int  "-"?([0-9]|[1-9][0-9]+)

exp  [eE][-+]?[0-9]+

frac  "."[0-9]+

letras [a-zA-Z]+

espacio [\s|\n|\t|\r]+

identificador [a-zA-Z0-9]+([a-zA-Z]|[0-9]+)*

especial [á-ü]|[«#$%&/()=*.+-]





%x string



%x coment

%%

{wiss}              return 'WISON'

"¿"                   return 'QUESTIONMARK_L'

{lexic}                 return 'LEXX'

"{:"                  return 'INICIO_LEXICO'

{termin}            return 'TERMINAL'

{nterm}            return 'NO_TERMINAL'

{syntaxis}             return 'SYNTAX_INI'

{initialSIM}            return 'INITIAL_SYM'

"{{:"                 return 'INICIO_SYNTAX'

"<-"                  return 'MENORQ_MENOS'

"<="                  return 'MENORQ_IGUAL'

";"                  return 'PUNTO_COMA'

"|"                  return 'O'

"$_"({identificador}|"_")+   return 'NOMBRE_TERMINAL'

"%_"({identificador}|"_")+   return 'NOMBRE_NOTERMINAL'

// MANEJO DE COMILLAS DESCRITO EN LA DOCUMENTACION DE JISON

("'"|"‘")             this.begin("string");

<string>[^'’]+       return "CARACTER";

<string>("'"|"’")     this.popState();

"[aA-zZ]"             return 'TODAS'

"[0-9]"               return 'NUMEROS'

"*"                   return 'ESTRELLA'

"+"                   return 'CERRADURA'

"?"                   return 'QUESTIONMARK_D'

":}}"                  return 'FIN_SYNTAX'

":}"                  return 'FIN_LEXICO'

{int}{frac}?\b        return 'NUMBER'

{letras}              return 'LETRAS'

("#")                 this.begin("coment");

<coment>[^\n\r]+        //return "COMENTARIO";

<coment>[\n]          this.popState();



{espacio}             //ignora el espacio en blanco

[/][*][*][^*]*[*]+([^/*][^*]*[*]+)*[/]             { /*ignorar comentario de bloque*/}

<<EOF>>               return 'EOF'

.                     return 'INVALID'



/lex





////////////JAMES ANALIZADOR SINTACTICO///////////////////

/*asociacion de operadores y precedencia*/

%start ini



%{

//codigo javascript insertados y/o incustrado



%}



//separador de area

%%

ini: analizador EOF



;



analizador : 

    WISON QUESTIONMARK_L

    LEXX INICIO_LEXICO

    terminales

    FIN_LEXICO

    SYNTAX_INI INICIO_SYNTAX

    no_terminales

    bloque_producciones

    FIN_SYNTAX

    QUESTIONMARK_D WISON

    | error {

		console.log('Este es un error: '+yytext+

		', en la linea: '+ (this._$.first_line+1)+

		', en la columna: '+(this._$.first_column+1));

		}

    

    

    

    

;

terminales:

    TERMINAL NOMBRE_TERMINAL MENORQ_MENOS caracteres PUNTO_COMA terminales

    | TERMINAL NOMBRE_TERMINAL MENORQ_MENOS caracteres PUNTO_COMA

    

;

caracteres:

      TODAS

     | NUMEROS

     | CARACTER

     | identificador 

     | TODAS ejecucion

     | NUMEROS ejecucion

     | CARACTER ejecucion

     | identificador ejecucion 



;

ejecucion:

    ESTRELLA 

    | CERRADURA

    | QUESTIONMARK_D



;

//DEFINO LA GRAMTICA DEL SINTACTICO DE WISON



no_terminales:

    NO_TERMINAL NOMBRE_NOTERMINAL PUNTO_COMA no_terminales

    

    | NO_TERMINAL NOMBRE_NOTERMINAL PUNTO_COMA 



   

;

bloque_producciones:

    INITIAL_SYM NOMBRE_NOTERMINAL PUNTO_COMA

    producciones

;

producciones:

    NOMBRE_NOTERMINAL MENORQ_IGUAL gramatica PUNTO_COMA producciones

    | NOMBRE_NOTERMINAL MENORQ_IGUAL gramatica PUNTO_COMA



;

gramatica:

    NOMBRE_NOTERMINAL gramatica

    | NOMBRE_TERMINAL gramatica

    | NOMBRE_NOTERMINAL 

    | NOMBRE_TERMINAL



;