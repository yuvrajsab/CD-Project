%{
    #include <stdio.h>
    #include <stdlib.h>
    int yylex();
    int yyerror();  
    int yyrestart();
    FILE* yyin;
    void success();
%}

%token UPDATE SET WHERE AND OR IS NOT ID LIKE BETWEEN END 
%token NULL_VAL STR_VAL NUM_VAL DEFAULT_VAL BOOL_VAL
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
    | BOOL_VAL
    | NUM_VAL
    | '-' NUM_VAL
    | '~' NUM_VAL
    | MAX_FUNC '(' func_value ')'
    | MIN_FUNC '(' func_value ')'
    | AVG_FUNC '(' func_value ')'
    | SUM_FUNC '(' func_value ')'
    | ABS_FUNC '(' func_value ')'
    | CEIL_FUNC '(' func_value ')'
    | FLOOR_FUNC '(' func_value ')'
    | UPPER_FUNC '(' func_value ')'
    | LOWER_FUNC '(' func_value ')'
    | value airth_op value
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
    | '~'
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
    | ID LIKE STR_VAL
    | ID NOT LIKE STR_VAL
    ;
condition: '(' condition ')'
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
}

int yyerror(const char* msg) {
    fprintf(stderr, "Error: %s\n", msg);
    return 2;
}

int main() {
    FILE *fin, *fout;
    char* line = NULL;
    size_t len = 0;
    ssize_t read;
    int DELIM_ASCII = 59;       // ascii value of ';'

    fin = fopen("tests.txt", "r");
    
    if (fin == NULL)
        exit(0);

    printf("\nRunning all tests...\n\n");

    int test_num = 1;
    while ((read = getdelim(&line, &len, DELIM_ASCII, fin)) != -1) {
        printf("\n\nTest: %d\n\n", test_num++);
        printf("%s\n", line);

        // writing current read query into another file
        fout = fopen("query.txt", "w");
        fwrite (line , sizeof(char), read, fout);
        fclose(fout);

        yyin = fopen("query.txt", "r");
        yyparse();
        yyrestart();
    }

    fclose(fin);


    return 0;
}
