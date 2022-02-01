%{

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;
//i think everything 
void yyerror(const char* s);
%}

%left LEFT_PAREN RIGHT_PAREN MINUS MULT DIV PLUS MODULO LEFT_BRACK RIGHT_BRACK COLON ASSIGN LESSER GREATER NUM IDENT 
%left LTE GTE NOTEQ ARR FUNC BPARAM EPARAM BLOCAL ELOCAL BBODY EBODY INT OF IF THEN ENDIF ELSE WHILE DO BLOOP ELOOP CONT BREAK READ
%left NOT T F RET FOR
%type <number> NUM
%type <ident> IDENT 
%token EQUALSCOLON
%start beginP 
%union{
  char ident[20];
  int number;
}

%%
beginP: functions {printf("beginP -> functions\n");}
functions: function functions
          | %empty
function: FUNC IDENT SCOLON BPARAM declarations EPARAM BLOCAL declarations ELOCAL BBODY lines EBODY {printf("function -> stuff\n");}
lines: line lines {printf("lines -> line\n");}
      | %empty {printf("lines -> epsilon\n");}
line: If
    | returns

If: IF condition THEN action SCOLON EIf ENDIF SCOLON

EIf: ELSE IF condition Then action EIf
    | ELSE action 
    | %empty

returns: RET val

val: func
    |math
math: NUM
    | val op val

func: 

op: ADD
    |SUB
    |MULT
    |DIV
    |MODULO
declarations: declaration declarations
            | %empty
declaration: IDENT COLON INT SCOLON

;

%%

int main() {
  yyin = stdin;

  do {
    printf("Parse.\n");
    yyparse();
  } while(!feof(yyin));
  printf("valid expression!\n");
  return 0;
}

void yyerror(const char* s) {
  fprintf(stderr, "invalid: %s. unacceptable!\n", s);
  exit(1);
}

