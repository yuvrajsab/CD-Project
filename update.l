%{
	#include <stdio.h>
	#include "y.tab.h"
	#include <stdbool.h> 

	extern bool isTestMode;
%}

id [A-Za-z_]+[A-Za-z0-9_]*
backticks_id [`][A-Za-z_]+[A-Za-z0-9_ ]*[`]
digit [0-9]
number {digit}+(\.{digit}+)?
string_literal (['](\\\'|[^'])*['])|(["](\\\"|[^"])*["])

%%
[uU][pP][dD][aA][tT][eE]					return UPDATE;
[sS][eE][tT]					    		return SET;
[wW][hH][eE][rR][eE]           	    		return WHERE;
[aA][nN][dD]					    		return AND;
[oO][rR]									return OR;
[iI][sS]									return IS;
[nN][oO][tT]								return NOT;
[lL][iI][kK][eE]							return LIKE;
[bB][eE][tT][wW][eE][eE][nN]				return BETWEEN;
[nN][uU][lL][lL]							return NULL_VAL;
[dD][eE][fF][aA][uU][lL][tT]				return DEFAULT_VAL;
[tT][rR][uU][eE]							return BOOL_VAL;
[fF][aA][lL][sS][eE]						return BOOL_VAL;
[mM][aA][xX]								return MAX_FUNC;
[mM][iI][nN]								return MIN_FUNC;
[aA][vV][gG]								return AVG_FUNC;
[sS][uU][mM]								return SUM_FUNC;
[aA][bB][sS]								return ABS_FUNC;
[cC][eE][iI][lL]							return CEIL_FUNC;
[fF][lL][oO][oO][rR]						return FLOOR_FUNC;
[uU][pP][pP][eE][rR]						return UPPER_FUNC;
[lL][oO][wW][eE][rR]						return LOWER_FUNC;
{string_literal}							return STR_VAL;
{number}   									return NUM_VAL;
{backticks_id}								return ID;
{id}										return ID;
[+]											return *yytext;
[-]											return *yytext;
[*]											return *yytext;
[/]											return *yytext;
[%]											return *yytext;
[&]											return *yytext;
[~]											return *yytext;
[|]											return *yytext;
[\^]										return *yytext;
[(]											return *yytext;
[)]											return *yytext;
[,]											return *yytext;
(!)?[=]										return *yytext;
[<>](=)?									return *yytext;
"<>"                						return *yytext;
"<=>"										return *yytext;
;											return END;
\n				    						{ 
												if (!isTestMode)
													printf("  -> ");
											};
[ \t]+			    	                	/* ignore whitespace */;
%%

int yywrap() {
	return 1;
}
