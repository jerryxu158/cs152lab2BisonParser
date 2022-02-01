%{

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;
//i think everything 
void yyerror(const char* s);
%}

%left LEFT_PAREN RIGHT_PAREN MINUS MULT DIV PLUS NUM IDENT
%type <number> NUM
%type <ident> IDENT 
%token EQ
%start expr 
%union{
  char ident[20];
  int number;
}

%%

expr: factor op factor Exprs eq
keyword: 
ident:
operators:
Exprs: factor op factor Exprs
      | 
factor: NUM 
      | paren 
paren: LEFT_PAREN paren RIGHT_PAREN paren 
    | expr
op: PLUS
    | MINUS
    | MULT
    | DIV
eq: EQ
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

