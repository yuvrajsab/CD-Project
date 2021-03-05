%{
	#include <stdio.h>
	#include "y.tab.h"
%}

id [A-Za-z_]+[A-Za-z0-9_]*
digit [0-9]

%%
[uU][pP][dD][aA][tT][eE]				return UPDATE;
[sS][eE][tT]					    	return SET;
[wW][hH][eE][rR][eE]           	    	return WHERE;
[aA][nN][dD]					    	return AND;
[oO][rR]								return OR;
[iI][sS]								return IS;
[nN][oO][tT]							return NOT;
"NULL"									return NULL_VAL;
"DEFAULT"                               return DEFAULT_VAL;
['].*[']								return STR_VAL;
["].*["]								return STR_VAL;
{digit}+(\.{digit}+)?   				return NUM_VAL;
{id}									return ID;
[(]										return *yytext;
[)]										return *yytext;
[,]										return *yytext;
(!)?[=]									return *yytext;
[<>](=)?								return *yytext;
"<>"                					return *yytext;
;										return END;
\n				    					{ printf("  -> "); }
[ \t]+			    	                /* ignore whitespace */;
%%

int yywrap() {
	return 1;
}
