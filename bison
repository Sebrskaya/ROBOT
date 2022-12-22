%{

#include <stdio.h>

#include <string.h>

#include <stdlib.h>

#include "robot1.tab.h"



int yylex();



char yywrap(){

        return 1;

}



extern int yylineno;

void yyerror(char *str){

        fprintf(stderr,"error: %s in line %d", str, yylineno);

        exit(1);

}



extern FILE* yyin;

extern FILE* yyout;



extern char *yytext;

void readingEnviromentFile(FILE* enviromentFile);

//void add(char);

//int checkRepetitions(char *);

//struct node* addNode(struct node *left, struct node *right, char *token);



//symbol table

/*struct dataType {

        char * idName;

        char * dataType;

        char * type;

} symbolTable[20];



int count = 0;

int checker;

char type[10];*/



/* node types

 *  s statement

 *  e elsee

 *  F FREE

 *  f FIR

 *  T direction

 *  a action

 *  u up

 *  d down

 *  l left

 *  r right

 *  C cut down

 *  D dress up

 *  R remove cat from

 *  I IF statement

 *  W WHILE statement

 */ 



// craete nodes in AST

struct ast{

        int nodetype;

        struct ast *l;

        struct ast *r;

};



struct numval{

        int nodetype;			/* type K */

        int number;

};



struct flow{

  int nodetype;			/* type I or W */

  struct ast *cond;		/* condition */

  struct ast *tl;		/* then or do list */

  struct ast *el;		/* optional else list */

};





// build an AST

struct ast *newAst(int nodetype, struct ast *l, struct ast *r);

struct ast *newNum(int i);

struct ast *newFlow(int nodetype, struct ast *cond, struct ast *tl, struct ast *el);



// evaluate an AST

int eval(struct ast *);



// delete and free an AST

void treeFree(struct ast *);



//robot's coordinates

int robot[2];



%}



%union{

        struct ast *a;

        int i;

}



%token <i> VALUE

%token <a> LEFT RIGHT UP DOWN STONE TREE FIR EOL TIMES FREE TRUE FALSE

%token <a> IF THEN ELSE WHILE DO CD DU RCF OB CB FOB FCB



%type <a> body condition elsee statement direction action value



%%



commands: // nothing 

| commands body { printf("= %d\n", eval($2)); treeFree($2); printf("> "); }

;

	

body: IF OB condition CB FOB body FCB elsee { $$ = newFlow('I', $3, $6, $8); }

| IF OB condition CB FOB body body FCB { $$ = newFlow('I', $3, $6, NULL); }

| WHILE OB condition CB FOB body FCB { $$ = newFlow('W', $3, $6, NULL); }

| statement { $$ = newAst('s', $1, NULL); }

| body statement

;



elsee: ELSE FOB body FCB { $$ = newAst('e', $1, NULL); }

;



condition: direction FREE { $$ = newAst('F', $1, $2); }

| direction FIR { $$ = newAst('f', $1, $2); }

/*| TRUE { $$ = newAst("t", $1, NULL); }

| FALSE { $$ = newAst("", $1, NULL); }*/

;



statement: direction value TIMES { $$ = newAst('T', $1, $2); }

| action FIR { $$ = newAst('a', $1, NULL); }

;



direction: UP { $$ = newAst('u', $1, NULL); }

| DOWN { $$ = newAst('d', $1, NULL); }

| LEFT { $$ = newAst('l', $1, NULL); }

| RIGHT { $$ = newAst('r', $1, NULL); }

;



action: CD { $$ = newAst('C', $1, NULL); }

| DU { $$ = newAst('D', $1, NULL); }

| RCF { $$ = newAst('R', $1, NULL); }

;



value: VALUE { $$ = newNum($1); }

;



/* commands:

| commands prog_body 

;



prog_body:  IF '(' condition ')' prog_body

| IF '(' condition ')' prog_body ELSE prog_body

| WHILE '(' condition ')' prog_body

| statement 

;



statement: direction value TIMES 

| action object 

;



condition: direction EMPTY 

| direction BOX 

| TRUE

| FALSE

;



direction: UP

| DOWN

| LEFT

| RIGHT

;



object: BOX

| PRODUCT

| PRODUCT_BOX

;



action: PICK_UP 

| PUT_DOWN

| DESTROY

;



value: VALUE;*/



/*statement: RIGHT STEPS TIMES { robot[0] += $2; printf("робот сместился направо на (%d,%d), шаг равен %d\n", robot[0], robot[1], $2); }

| LEFT STEPS TIMES { robot[0] -= $2; printf("робот сместился влево на (%d,%d), шаг равен %d\n", robot[0], robot[1], $2); }

| UP STEPS TIMES { robot[1] += $2; printf("робот сместился вверх на (%d,%d), шаг равен %d\n", robot[0], robot[1], $2); }

| DOWN STEPS TIMES { robot[1] -= $2; printf("робот сместился вниз на (%d,%d), шаг равен %d\n", robot[0], robot[1], $2); }*/



/*printf("робот сместился направо на (%d,%d), шаг равен %d\n", robot[0], robot[1], $2);

printf("робот сместился влево на (%d,%d), шаг равен %d\n", robot[0], robot[1], $2);

printf("робот сместился вверх на (%d,%d), шаг равен %d\n", robot[0], robot[1], $2);

printf("робот сместился вниз на (%d,%d), шаг равен %d\n", robot[0], robot[1], $2);*/



/*fprintf(yyout, "робот сместился направо на (%d,%d), шаг равен %d\n", robot[0], robot[1], $2);

fprintf(yyout, "робот сместился влево на (%d,%d), шаг равен %d\n", robot[0], robot[1], $2);

fprintf(yyout, "робот сместился вверх на (%d,%d), шаг равен %d\n", robot[0], robot[1], $2);

fprintf(yyout, "робот сместился вниз на (%d,%d), шаг равен %d\n", robot[0], robot[1], $2);*/



%%



int main(){

        char *programmFileName = "action_programm1.txt";

	FILE* programmFile = fopen(programmFileName, "r");

        if (programmFile == NULL){

                printf("Can't open file %s", programmFileName);

                exit(1);

        }

        



        char *enviromentFileName = "enviroment1.txt";

        FILE* enviromentFile = fopen(enviromentFileName, "r");

        if (enviromentFile == NULL){

                printf("Can't open file %s", enviromentFileName);

                exit(1);

        }



        char *logFileName = "log1.txt";

        FILE* logFile = fopen(logFileName, "w");



        yyin = programmFile;

        yyout = logFile;

        readingEnviromentFile(enviromentFile);

 

	printf("\n-----begin parsing\n");

	yyparse();

	printf("\n-----end parsing\n");



        /*printf("\nSYMBOL   DATATYPE   TYPE   LINE NUMBER \n");

	printf("_______________________________________\n\n");

	int i = 0;

	for(i = 0 ; i < count; i++) {

		printf("%s\t%s\t%s\t\n", symbolTable[i].idName, symbolTable[i].dataType, symbolTable[i].type);

	}

	for(i = 0; i < count; i++) {

		free(symbolTable[i].idName);

		free(symbolTable[i].type);

	}

	printf("\n\n");*/



	fclose(yyin);

        fclose(enviromentFile);

        fclose(yyout);



	return 0;

}



/*int checkObjectName(char *bufferName){

        if (strcmp(bufferName, "robot") == 0){

                return 0;

        }

        if (strcmp(bufferName, "tree") == 0){

                return 1;

        }fscanf(enviromentFile, "%s", bufferName);

        if (strcmp(bufferName, "fir") == 0){

                return 2;

        }

}*/



void readingEnviromentFile(FILE* enviromentFile){

        printf("начал читать файл со средой\n");

        int numberOfRows = 0;

        fseek(enviromentFile, 0, SEEK_SET);

        while (!feof(enviromentFile)){

                if (fgetc(enviromentFile) == '\n'){

                        numberOfRows++;

                }

        }

        int numberOfRowsFir = numberOfRows - 2;

        int fir[numberOfRowsFir][2];

        printf("Количество строк в массиве %d\n", numberOfRowsFir);



        char *bufferName;

        fseek(enviromentFile, 0, SEEK_SET);

        while (!feof(enviromentFile)){

                printf("мы в while\n");

                fscanf(enviromentFile, "%s", bufferName);

                char *robotName = "robot";

                printf("%s\n", bufferName);

                printf("после scanf\n");

                if (strcmp(bufferName, robotName) == 0){

                        for (int i = 0; i < 2; i++){

                                fscanf(enviromentFile, "%d,", &robot[i]);

                                printf("значение %d ячейки массива %d\n", i, robot[i]);

                        }

                }

                else{

                        printf("зашли  в else\n");

                        for (int i = 0; i < numberOfRowsFir; i++){

                                for (int j = 0; j < 2; j++){

                                        fscanf(enviromentFile, "%d,", &fir[i][j]);

                                }

                        }

                        printf("вышли с else\n");

                }

        }

        //проверка массива

        /*printf("после while\n");

        printf("массив для ёлки:\n");

        for (int i = 0; i < numberOfRowsFir; i++){

                for (int j = 0; j < 2; j++){

                        printf("%d", fir[i][j]);

                }

                printf("\n");

        }*/



        /*switch checkObjectName(bufferName){

                case 0:

                        for (int i = 0; i < 2; i++){

                                fscanf(enviromentFile, "%d,", &robot[i]);

                                printf("значение %d ячейки массива %d\n", i, robot[i]);

                        }

                        break;

                case 1:

                        for (int i = 0; checkObjectName(bufferName); i++){

                                for (int j = 0; j < 2; j++){

                                        fscanf(enviromentFile, "%d,", &)

                                }

                        }

        }*/   



        printf("закончил чтение файла со средой\n");        

}

//логгирование

/*void logging(FILE* yyout, char *actionName){

        char *movementFirst = {"right", "left"};

        char *movementSecond = {"up", "down"};

        char *action = {"cut down fir", "dress up fir", "remove cat from fir"};

        for (int i = 0; i < 7; i++){

                if ()

        }

}*/





//добавление в таблицу символов

/*void add(char c) {

  checker = checkRepetitions(yytext);

  if(!checker) {

    if (c == 'K'){

      symbolTable[count].idName = strdup(yytext);

      symbolTable[count].dataType = strdup("N/A");

      symbolTable[count].type = strdup("Keyword");   

      count++;  

    }

    }  else if(c == 'C') {

      symbolTable[count].idName = strdup(yytext);

      symbolTable[count].dataType = strdup("CONST");

      symbolTable[count].type = strdup("Constant");   

      count++;  

    }

}*/



//чтобы избежать повторение символов

/*int checkRepetitions(char *type) { 

    int i; 

    for(i = count-1; i >= 0; i--) {

        if(strcmp(symbolTable[i].idName, type) == 0) {   

            return -1;

            break;  

        }

    } 

    return 0;

}*/



struct ast *newAst(int nodetype, struct ast *l, struct ast *r){

        struct ast *a = malloc(sizeof(struct ast));



        if (!a){

                yyerror("out of space");

                exit(0);

        }

        a->nodetype = nodetype;

        a->l = l;

        a->r = r;

        return a;

}



struct ast *newNum(int i){

        struct numval *a = malloc(sizeof(struct numval));



        if (!a){

                yyerror("out of space");

                exit(0);

        }

        a->nodetype = 'K';

        a->number = i;

        return (struct ast *)a;

}



struct ast *newFlow(int nodetype, struct ast *cond, struct ast *tl, struct ast *el){

        struct flow *a = malloc(sizeof(struct flow));



        if(!a) {

                yyerror("out of space");

                exit(0);

        }

        a->nodetype = nodetype;

        a->cond = cond;

        a->tl = tl;

        a->el = el;

        return (struct ast *)a;

}



int eval(struct ast *a){

        int v;



        switch(a->nodetype){

                case 'K': v = ((struct numval *)a)->number; break;



                case '+': v = eval(a->l) + eval(a->r); break;

                case '-': v = eval(a->l) - eval(a->r); break;

                case '*': v = eval(a->l) * eval(a->r); break;

                case '/': v = eval(a->l) / eval(a->r); break;

                case '|': v = eval(a->l); if(v < 0) v = -v; break;

                case 'M': v = -eval(a->l); break;        

                case 'I': 

                        if(eval(((struct flow *)a)->cond) != 0) {

                                if(((struct flow *)a)->tl) {

                                        v = eval( ((struct flow *)a)->tl);

                                } 

                                else {

                                        v = 0; /* a default value */

                        	}	

                        } 

                        else {

                                if(((struct flow *)a)->el) {

                                        v = eval(((struct flow *)a)->el);

                                } 

                                else {

                                        v = 0; /* a default value */

                                }		

                        }

                        break;



                case 'W':

                        v = 0;		/* a default value */



                        if( ((struct flow *)a)->tl) {

                                while(eval(((struct flow *)a)->cond) != 0){

                                        v = eval(((struct flow *)a)->tl);       /* last value is value */

                                }

                        }

                        break;

        }

        return v;

}



void treeFree(struct ast *a){

        switch(a->nodetype){

                /* two subtrees */

                case '+':

                case '-':

                case '*':

                case '/':

                        treeFree(a->r);



                /* one subtree */

                case '|':

                case 'M':

                        treeFree(a->l);



                /* no subtree */

                case 'K':

                break;



                case 'I': 

                case 'W':

                        free( ((struct flow *)a)->cond);

                        if( ((struct flow *)a)->tl) free( ((struct flow *)a)->tl);

                        if( ((struct flow *)a)->el) free( ((struct flow *)a)->el);

                        break;



                default: printf("internal error: free bad node %c\n", a->nodetype);

        }

}
