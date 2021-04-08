%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <stdbool.h> 

    int yylex();
    int yyerror();  
    int yyrestart();
    FILE* yyin;
    void test();
    int success();

    bool isTestMode = false;
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
pre_num: '+' pre_num
    | '-' pre_num
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

int success() {
    printf("Query is Valid!\n");
    if (!isTestMode)
        exit(0);
    return 0;
}

int yyerror(const char* msg) {
    fprintf(stderr, "Error: %s\n", msg);
    return 2;
}

void test() {
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
    while ((read = getdelim(&line, &len, DELIM_ASCII, fin)) != -1 && read > 1) {
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
}

int main(int argc, char* argv[]) {
    if (argc > 1 && strcmp(argv[1], "TEST") == 0) {    
        isTestMode = true;
        test();
        return 0;
    }

    printf("Enter a SQL update query:\n");
    printf("SQL: ");
    yyparse();

    return 0;
}
