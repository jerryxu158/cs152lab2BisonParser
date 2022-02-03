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
%left WRITE NOT T F RET 
%token EQUAL SCOLON
%start beginP 


%%
beginP: functions {printf("beginP -> functions\n");}
functions: function functions
          | %empty
function: FUNC IDENT SCOLON BPARAM declarations EPARAM BLOCAL declarations ELOCAL BBODY lines EBODY {printf("function -> stuff\n");}

declarations: IDENT COLON INT
            | IDENT COLON ARR LEFT_BRACK NUM RIGHT_BRACK OF INT

lines: line lines {printf("lines -> line lines\n");}
      | %empty {printf("lines -> epsilon\n");}
line: assignment
    | ifThen
    | loop
    | read
    | write
    | CONT
    | BREAK
    | returns

assignment: IDENT ASSIGN val

ifThen: IF condition THEN lines SCOLON EIf ENDIF SCOLON

condition: val comp val
          | NOT val comp val

comp: LTE
    |GTE
    |GREATER
    |LESSER
    |NOTEQ
    |EQUAL

EIf: ELSE IF condition THEN lines EIf
    | ELSE lines 
    | %empty

loop: WHILE condition BLOOP lines ELOOP
    | DO BLOOP lines ELOOP WHILE condition

read: READ IDENT

write: WRITE IDENT

returns: RET val SCOLON

val: func
    |math

math: NUM
    | IDENT
    | val op val

func: IDENT LEFT_PAREN val RIGHT_PAREN

op: PLUS
    |MINUS
    |MULT
    |DIV
    |MODULO
declarations: declaration declarations
            | %empty
declaration: IDENT COLON INT SCOLON
            | IDENT COLON ARR LEFT_BRACK NUM RIGHT_BRACK OF INT

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

