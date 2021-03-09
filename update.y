%{
    #include <stdio.h>
    #include <stdlib.h>
    int yylex();
    int yyerror();  
    FILE* yyin;
    void success();
%}

%token UPDATE SET WHERE AND OR IS NOT ID LIKE BETWEEN END 
%token NULL_VAL STR_VAL NUM_VAL DEFAULT_VAL BOOL_VAL
%token MAX_FUNC MIN_FUNC AVG_FUNC SUM_FUNC ABS_FUNC CEIL_FUNC FLOOR_FUNC UPPER_FUNC LOWER_FUNC

// Not need for associativty
%left '(' ')'
%right '~' UMINUS UPLUS
%left '*' '/' '%'
%left '+' '-'
%left '&'
%left '^'
%left '|'

%%
start: UPDATE ID SET columns clause END       { success(); }
    ;
columns: ID '=' col_val ',' columns
    | ID '=' col_val
    ;
col_val: value
    | DEFAULT_VAL
    ;
value: NULL_VAL next_val
    | STR_VAL next_val
    | BOOL_VAL next_val
    | pre_num NUM_VAL next_val
    | MAX_FUNC '(' func_value ')' next_val
    | MIN_FUNC '(' func_value ')' next_val
    | AVG_FUNC '(' func_value ')' next_val
    | SUM_FUNC '(' func_value ')' next_val
    | ABS_FUNC '(' func_value ')' next_val
    | CEIL_FUNC '(' func_value ')' next_val
    | FLOOR_FUNC '(' func_value ')' next_val
    | UPPER_FUNC '(' func_value ')' next_val
    | LOWER_FUNC '(' func_value ')' next_val
    ;
pre_num: '+' %prec UPLUS pre_num
    | '-' %prec UMINUS pre_num
    | '~' pre_num
    |
    ;
next_val: airth_op value
    |
    ;
func_value: value
    | ID
    ;
airth_op: '+'
    | '-'
    | '*'
    | '/'
    | '%'
    | '&'
    | '|'
    | '^'
    ;
clause: WHERE where_stmt
    |
    ;
where_stmt:
    | condition
    | condition AND condition
    | condition OR condition
    | ID BETWEEN value AND value
    | ID BETWEEN value OR value
    | ID NOT BETWEEN value AND value
    | ID NOT BETWEEN value OR value
    | ID LIKE STR_VAL
    | ID NOT LIKE STR_VAL
    ;
condition: '(' where_stmt ')'
    | ID relop value
    | ID IS is_val
    | ID IS NOT is_val
    | NOT ID relop value
    ; 
is_val: BOOL_VAL
    | NULL_VAL
    ;
relop: '='
    | '!''='
    | '<''>'
    | '<'
    | '>'
    | '>''='
    | '<''='
    | '<''=''>'
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
