%option yylineno

%{

#include <stdio.h>

#include <string.h>

#include "robot.tab.h"

%}





%%



 /* single character ops */

"("     { return OB; }

")"     { return CB; }

"{"     { return FOB; } 

"}"     { return FCB; }



 /* keywords */

"if"    { return IF; }

"then"  { return THEN; }

"else"  { return ELSE; }

"while" { return WHILE; }

"do"    { return DO; }

"cut down" { return CD; }

"dress up" { return DU; }

"remove cat from" { return RCF; }



 /*names*/

[0-9]+    { yylval.i = atoi(yytext); return STEPS; }

"left"    { return LEFT; }

"right"   { return RIGHT; }

"up"      { return UP; }

"down"    { return DOWN; }

"stone"   { return STONE; }

"tree"    { return TREE; }

"fir"     { return FIR; }

"time" |

"times"   { return TIMES; }

"free"    { return FREE; }

"true"    { return TRUE; }

"false"   { return FALSE; }

[ \t\n]+	; /* skip whitespaces and EOL*/



%%
