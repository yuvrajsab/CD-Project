%{
	#include <stdio.h>
	#include "y.tab.h"
%}

id [A-Za-z_]+[A-Za-z0-9_]*
backticksid [`][A-Za-z_]+[A-Za-z0-9_ ]*[`]
digit [0-9]

%%
[uU][pP][dD][aA][tT][eE]					return UPDATE;
[sS][eE][tT]					    		return SET;
[wW][hH][eE][rR][eE]           	    		return WHERE;
[aA][nN][dD]					    		return AND;
[oO][rR]									return OR;
[iI][sS]									return IS;
[nN][oO][tT]								return NOT;
[bB][eE][tT][wW][eE][eE][nN]				return BETWEEN;
"NULL"										return NULL_VAL;
"DEFAULT"                               	return DEFAULT_VAL;
"MAX("{id}")"								return MAX_FUNC;
"MIN("{id}")"								return MIN_FUNC;
"AVG("{id}")"								return AVG_FUNC;
"SUM("{id}")"								return SUM_FUNC;
"ABS("({digit}+(\.{digit}+)?|{id})")"		return ABS_FUNC;
"CEIL("({digit}+(\.{digit}+)?|{id})")"		return CEIL_FUNC;
"FLOOR("({digit}+(\.{digit}+)?|{id})")"		return FLOOR_FUNC;
"UPPER("(['].*[']|["].*["]|{id})")"			return UPPER_FUNC;
"LOWER("(['].*[']|["].*["]|{id})")"			return LOWER_FUNC;
['].*[']									return STR_VAL;
["].*["]									return STR_VAL;
{digit}+(\.{digit}+)?   					return NUM_VAL;
{backticksid}								return ID;
{id}										return ID;
[+]											return *yytext;
[-]											return *yytext;
[*]											return *yytext;
[/]											return *yytext;
[%]											return *yytext;
[(]											return *yytext;
[)]											return *yytext;
[,]											return *yytext;
(!)?[=]										return *yytext;
[<>](=)?									return *yytext;
"<>"                						return *yytext;
;											return END;
\n				    						{ printf("  -> "); }
[ \t]+			    	                	/* ignore whitespace */;
%%

int yywrap() {
	return 1;
}
