%{
    #include <stdio.h>
    #include <stdlib.h>
    int yylex();
    int yyerror();  
    FILE* yyin;
    void success();
%}

%token UPDATE SET WHERE AND OR IS NOT ID END NULL_VAL STR_VAL NUM_VAL DEFAULT_VAL

%%
start: UPDATE ID SET columns clause END       { success(); }
    ;
columns: ID '=' value ',' columns
    | ID '=' value
    ;
value: NULL_VAL
    | STR_VAL
    | NUM_VAL
    | DEFAULT_VAL
    ;
clause: WHERE condition
    |
    ;
condition: '(' ID op value ')'
    | ID op value
    | '(' ID op value ')' AND condition
    | ID op value AND condition
    | '(' ID op value ')' OR  condition
    | ID op value OR condition
    ; 
op: '='
    | '!''='
    | IS
    | IS NOT
    | '<''>'
    | '<'
    | '>'
    | '>''='
    | '<''='
    ;
%%

void success() {
    printf("Query is Valid!\n");
    exit(0);
}

int yyerror(const char *s) {
    printf("Query is Invalid!\n");
    return 1;
}

int main() {
    printf("Enter a SQL update query:\n");
    printf("SQL: ");
    yyin = fopen("file.txt", "r");
    
    yyparse();
    
    return 0;
}
