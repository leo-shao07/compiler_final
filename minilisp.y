%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
void yyerror(const char *);

int yylex();
int getVarIndex(char *);

enum treeTypes {
    plu_op, sub_op, mut_op, div_op, mod_op,
    and_op, or_op, not_op, equ_op,gre_op,sma_op, num_no, 
    var_no
};


typedef struct node{
    enum treeTypes type;
    char *name; //for var
    int val; //for para
    struct node *l;
    struct node *r;
}N;

typedef struct var{
    char* name;
    int val;
    struct node *tree;
}V;

N *CreateNode(enum treeTypes NodeType,int V,char *Name);
int CalculateTree(N *tree);

V va[200];
int varCount=-1;
%}

%union{
    int num;
    char* id;
	struct node *nd;
}

%start prog
%token <num> NUMBER
%token <id> ID
%token PRINTNUM
%token PRINTBOOL
%token LAMBDA
%token IF
%token DEFINE
%token <num> BOOL

%type <nd> exp variable num_op logical_op if_exp
%type <nd> exps_a exps_e exps_mu exps_o exps_p
%type <nd> and_op or_op not_op
%type <nd> test_exp then_exp else_exp
%type <nd> divide modulus greater smaller equal plus minus multiply

%%
prog: stmts             {;}
    ;
stmts
    :stmts stmt
    |stmt
    ;
stmt: exp                   {;}
    | def_stmt              {;}
    | print_stmt            {;}
    ;
    
print_stmt
    : '(' PRINTNUM exp ')' {printf("%d\n",CalculateTree($3));}
    | '(' PRINTBOOL exp ')'{
								int res=CalculateTree($3);
                                if(res==0)     printf("#f\n");
                                else if(res==1) printf("#t\n");
                            }
    ;
    
exp : BOOL                  {
								N *newNode=CreateNode(num_no,$1,"");
								$$=newNode;
							}
    | NUMBER                {
								N *newNode=CreateNode(num_no,$1,"");
								$$=newNode;
							}
    | variable              {$$=$1;}
    | if_exp                {$$=$1;}
    | logical_op            {$$=$1;}
    | num_op                {$$=$1;}
    ;
    
num_op
    : plus                  {$$=$1;}
    | multiply              {$$=$1;}
    | minus                 {$$=$1;}
    | divide                {$$=$1;}
    | modulus               {$$=$1;}
    | greater               {$$=$1;}
    | smaller               {$$=$1;}
    | equal                 {$$=$1;}
    ;
    plus: '(' '+' exp exps_p ')'   {						
				
				N *newNode=CreateNode(plu_op,0,"");
										
				newNode->l=$3;
				newNode->r=$4;
										
				$$=newNode;
		}
	|'(' '+' ')' 		{printf("Need 2 arguments, but got 0.  \n");exit(1);}
	|'(' '+' exp ')'	{printf("Need 2 arguments, but got 1.  \n");exit(1);}
        ;
        exps_p
            : exp                       {$$=$1;}
            | exps_p exp        {
					N *newNode=CreateNode(plu_op,0,"");
					newNode->l=$1;
					newNode->r=$2;
					$$=newNode;
				}
            ;
    minus
        : '(' '-' exp exp ')'   {
					N *newNode=CreateNode(sub_op,0,"");
					newNode->l=$3;
					newNode->r=$4;
					$$=newNode;
				}
	  |'(' '-' ')' 			{printf("Need 2 arguments, but got 0.  \n");exit(1);}
	  |'(' '-' exp ')'		{printf("Need 2 arguments, but got 1.  \n");exit(1);}
        ;
    multiply
        : '(' '*' exp exps_mu ')'   {
					N *newNode=CreateNode(mut_op,0,"");
					newNode->l=$3;
					newNode->r=$4;
					$$=newNode;
				    }
	  |'(' '*' ')' 	        	{printf("Need 2 arguments, but got 0.  \n");exit(1);}
	  |'(' '*' exp ')'		{printf("Need 2 arguments, but got 1.  \n");exit(1);}
        ;
        exps_mu
            : exp                   {$$=$1;}
            | exps_mu exp           {
					N *newNode=CreateNode(mut_op,0,"");
					newNode->l=$1;
					newNode->r=$2;
					$$=newNode;
				    }
            ;
    divide
        : '(' '/' exp exp ')'       {
					N *newNode=CreateNode(div_op,0,"");
					newNode->l=$3;
					newNode->r=$4;
					$$=newNode;
				    }
	  |'(' '/' ')' 		{printf("Need 2 arguments, but got 0.  \n");exit(1);}
	  |'(' '/' exp ')'		{printf("Need 2 arguments, but got 1.  \n");exit(1);}
        ;
    modulus
        : '(' 'm' exp exp ')'       {
					N *newNode=CreateNode(mod_op,0,"");
					newNode->l=$3;
					newNode->r=$4;
					$$=newNode;
		    		    }
	  |'(' 'm' ')' 			{printf("Need 2 arguments, but got 0.  \n");exit(1);}
	  |'(' 'm' exp ')'		{printf("Need 2 arguments, but got 1.  \n");exit(1);}
        ;
    greater
        : '(' '>' exp exp ')'       {
					N *newNode=CreateNode(gre_op,0,"");
					newNode->l=$3;
					newNode->r=$4;
					$$=newNode;
				    }
	  |'(' '>' ')'			{printf("Need 2 arguments, but got 0.  \n");exit(1);}
	  |'(' '>' exp ')'		{printf("Need 2 arguments, but got 1.  \n");exit(1);}
        ;
    smaller
        : '(' '<' exp exp ')'       {
					N *newNode=CreateNode(sma_op,0,"");
					newNode->l=$3;
					newNode->r=$4;
					$$=newNode;
		    		    }
	  |'(' '<' ')' 			{printf("Need 2 arguments, but got 0.  \n");exit(1);}
	  |'(' '<' exp ')'		{printf("Need 2 arguments, but got 1.  \n");exit(1);}
        ;
    equal
        : '(' '=' exp exps_e ')'    {
					N *newNode=CreateNode(equ_op,0,"");
					newNode->l=$3;
					newNode->r=$4;
					$$=newNode;
				    }
	  |'(' '=' ')' 			{printf("Need 2 arguments, but got 0.  \n");exit(1);}
	  |'(' '=' exp ')'		{printf("Need 2 arguments, but got 1.  \n");exit(1);}
        ;
        exps_e
            : exp                   {$$=$1;}
            | exps_e exp            {
					N *newNode=CreateNode(equ_op,0,"");
					newNode->l=$1;
					newNode->r=$2;
					$$=newNode;
				    }
            ;
    
logical_op
    : and_op                        {$$=$1;}
    | or_op                         {$$=$1;}
    | not_op                        {$$=$1;}
    ;
    and_op
        : '(' 'a' exp exps_a ')'    {
					N *newNode=CreateNode(and_op,0,"");
					newNode->l=$3;
					newNode->r=$4;
					$$=newNode;
				    }
	  |'(' 'a' ')' 			{printf("Need 2 arguments, but got 0.  \n");exit(1);}
	  |'(' 'a' exp ')'		{printf("Need 2 arguments, but got 1.  \n");exit(1);}
        ;
        exps_a
            : exp                   {$$=$1;}
            | exps_a exp            {
					N *newNode=CreateNode(and_op,0,"");
					newNode->l=$1;
					newNode->r=$2;
					$$=newNode;
			  	    }
            ;
        
    or_op
        : '(' 'o' exp exps_o ')'    {
					N *newNode=CreateNode(or_op,0,"");
					newNode->l=$3;
					newNode->r=$4;
					$$=newNode;
				    }
	  |'(' 'o' ')' 			{printf("Need 2 arguments, but got 0.  \n");exit(1);}
	  |'(' 'o' exp ')'		{printf("Need 2 arguments, but got 1.  \n");exit(1);}
        ;
        exps_o
            : exp                   {$$=$1;}
            | exps_o exp            {
					N *newNode=CreateNode(or_op,0,"");
					newNode->l=$1;
					newNode->r=$2;
					$$=newNode;
				    }
            ;
    not_op
        : '(' 'n' exp ')'           {
					N *newNode=CreateNode(not_op,0,"");
					newNode->l=$3;
					$$=newNode;
				    }
	  |'(' 'n' ')' 			{printf("Need 1 arguments, but got 0.  \n");exit(1);}
        ;

def_stmt
    : '(' DEFINE variable exp')'    {
					va[getVarIndex($3->name)].val=CalculateTree($4);
					va[getVarIndex($3->name)].tree=$4;
				    }
    ;
    
variable
    : ID                            {
					int index=getVarIndex($1); 
					if(index==-1){
						varCount++;
						va[varCount].name=$1;
						va[varCount].val=0;
					}
					N *newNode=CreateNode(var_no,0,$1);
					$$=newNode;
				    }
    ;
    

if_exp
    : '(' IF test_exp then_exp else_exp ')'  {
						if(CalculateTree($3)==0){
						    $$=$5;
						}
						else if(CalculateTree($3)==1){
					    	    $$=$4;
						}
					     }
    ;

test_exp
    : exp                       {$$=$1;}
    ;
then_exp
    : exp                       {$$=$1;}
    ;
else_exp
    : exp                       {$$=$1;}
    ;


%%

void yyerror(const char *message) {
	printf("syntax errors");
}

int getVarIndex(char *n){
	for(int i=0;i<=varCount;i++){
		if(strcmp(n,va[i].name)==0){return i;}
	}
	return -1;
}

N* CreateNode(enum treeTypes NodeType,int V,char *Name){
    N* NewNode = (N*) malloc(sizeof(N));
    NewNode->type = NodeType;
    NewNode->val = V;
    NewNode->name = Name;
    NewNode->l = NULL;
    NewNode->r = NULL;
    return NewNode;
}

int CalculateTree(N* tree){
    if(tree==NULL){return 0;}
    if(tree->type<=10 && tree->type>=0 ){
	int left=0,right=0;
	left=CalculateTree(tree->l);
	right=CalculateTree(tree->r);

	switch(tree->type){
	case plu_op:	
	    return left+right;
	case sub_op:    
	    return left-right;
	case mut_op:    
	    return left*right;
	case div_op:    
	    return left/right;
	case mod_op:    
	    return left % right;
	case and_op:    
	    return left&&right;
	case or_op:    
	    return left||right;
	case not_op:
	    return !left;
	case equ_op:    
	    return left == right;
	case gre_op:    
	    return left>right;
	case sma_op:    
	    return left<right;
	default:
	    return 0;
	}
  }
  else{
      int index=-1;
      switch(tree->type){
      case num_no:
          return tree->val;
      case var_no:
          index=getVarIndex(tree->name);
	  return va[index].val;
      default:
	  return 0;
      }
  }
}

int main (){
    yyparse();
    return 0;
}
