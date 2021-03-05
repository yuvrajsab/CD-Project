%{
    #include <stdio.h>
    #include <stdlib.h>
    int yylex();
    int yyerror();  
    FILE* yyin;
    void success();
%}

%token UPDATE SET WHERE AND OR IS NOT ID BETWEEN END 
%token NULL_VAL STR_VAL NUM_VAL DEFAULT_VAL
%token MAX_FUNC MIN_FUNC AVG_FUNC SUM_FUNC ABS_FUNC CEIL_FUNC FLOOR_FUNC UPPER_FUNC LOWER_FUNC

%%
start: UPDATE ID SET columns clause END       { success(); }
    ;
columns: ID '=' col_val ',' columns
    | ID '=' col_val
    ;
col_val: value
    | DEFAULT_VAL
    ;
value: NULL_VAL
    | STR_VAL
    | NUM_VAL
    | NUM_VAL '+' NUM_VAL
    | NUM_VAL '-' NUM_VAL
    | NUM_VAL '*' NUM_VAL
    | NUM_VAL '/' NUM_VAL
    | NUM_VAL '%' NUM_VAL
    | MAX_FUNC
    | MIN_FUNC
    | AVG_FUNC
    | SUM_FUNC
    | ABS_FUNC
    | CEIL_FUNC
    | FLOOR_FUNC
    | UPPER_FUNC
    | LOWER_FUNC
    ;
clause: WHERE where_stmt
    |
    ;
where_stmt: '(' where_stmt ')'
    | condition
    | condition AND condition
    | condition OR condition
    | ID BETWEEN value AND value
    | ID BETWEEN value OR value
    | ID NOT BETWEEN value AND value
    | ID NOT BETWEEN value OR value
    ;
condition: '(' condition ')'
    | ID op value
    | NOT ID op value
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

int yyerror(const char* msg) {
    fprintf(stderr, "Error: %s\n", msg);
    return 2;
}

int main() {
    printf("Enter a SQL update query:\n");
    printf("SQL: ");
    yyin = fopen("file.txt", "r");
    
    yyparse();
    
    return 0;
}
