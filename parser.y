%{
    //在此处声明
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#include <unistd.h>

enum Datatype{
    UNDEFINED_T,
    INTEGER_T,
    BOOL_T,
    CHAR_T
};

struct IdNode{
char* name;
enum Datatype type;
union{
    int ivalue;
    bool bvalue;
    char* cvalue;
} data;
struct IdNode* next;
};
void FreeIdNode(struct IdNode* node)
{
    if(node == NULL) {
        /* test */ printf("node == NULL. Free Process done. \n"); 
        return;}
    if(node->type == 3)
    {
        if(node->data.cvalue != NULL)
        free(node->data.cvalue);
        /* test */
        printf("Successfully free cvalue! \n");
    }
    if(node->name != NULL)
    {
    free(node->name);
    /* test */
        printf("Successfully free name! \n");
    }
    free(node);
    /* test */
    printf("Successfully free node! \n");
    return;
}
struct IdNode* Id_list;

struct Action{
int serial_number;
int operator_id;
enum Datatype type_arg1,type_arg2,type_result;
union{
    int ivalue;
    bool bvalue;
    char* cvalue;
} data1,data2,data_result;
struct Action* next;
};
struct Action* Action_slot;
struct Action* Action_slot_tail;
struct Action* arithmetic_expression_slot;
struct Action* Find_tail(struct Action* slot);
struct Action** Action_slot_pointer;
void Attach_Action_slot(struct Action* new_Action, struct Action** slot, struct Action** tail);
void Attach_Multiple_Action_slot(struct Action* new_Action, struct Action** slot, struct Action** tail);

void Declare_new_Identifier(char* name);
void Attach_type_to_Identifier(char* type);
bool Bool_Comparision(int A,int B,int operator);
char* Temp_creator();

int counter;
char T[2];

struct Action* new_Action(int operator_id);
struct IdNode* Search_Identifier(char* target_name);
void Id0_start(struct Action* operation_action,char* name);
void Output_Id0_start(struct Action* operation_action);
void Id1_jump(struct Action* operation_action,bool flag);
void Output_Id1_jump(struct Action* operation_action);
void Id2_assign(struct Action* operation_action,char* name,char* temp);
void Output_Id2_assign(struct Action* operation_action);
void Id3_TIMES(struct Action* operation_action,char* arg1,char* arg2,char* temp);
void Output_Id3_TIMES(struct Action* operation_action);
void Output_Id4_DIVIDE(struct Action* operation_action);
void Output_Id5_PLUS(struct Action* operation_action);
void Output_Id6_MINUS(struct Action* operation_action);
void Id7_NE(struct Action* operation_action,char* arg1,char* arg2);
void Output_Id7_NE(struct Action* operation_action);
void Output_Id8_EQ(struct Action* operation_action);
void Output_Id9_LT(struct Action* operation_action);
void Output_Id10_LE(struct Action* operation_action);
void Output_Id11_MT(struct Action* operation_action);
void Output_Id12_ME(struct Action* operation_action);
void Id13_end(struct Action* operation_action);
void Output_Id13_end(struct Action* operation_action);

void Output(struct Action* slot)
{
    // /*test*/ printf("\nOutput is in use!\n");
    // if(slot==NULL) printf("Error in module Output! slot is NULL \n");
    int length = 0;
    for(struct Action* temp0 = slot;temp0 != NULL; temp0 = temp0->next)
    {
        length++;
    }
    Action_slot_pointer = (struct Action**) malloc(sizeof(struct Action*) * length);
    for(struct Action* temp1 = slot;temp1 != NULL; temp1 = temp1->next)
    {
        Action_slot_pointer[temp1->serial_number] = temp1;
    }
    int temp_jump_aim = 0;

    for(struct Action* temp = slot;temp != NULL; temp = temp->next)
    {
        // /*test*/ printf("currently: serial_number:%d operator_id: %d \n",temp->serial_number,temp->operator_id);
    switch(temp->operator_id)
    {
        case 0: Output_Id0_start(temp);
        continue;
        case 1: 
        for(struct Action* temp2 = temp;temp2->operator_id == 1;)
        {
            temp_jump_aim = temp2->data_result.ivalue + temp2->serial_number;
            temp2 = Action_slot_pointer[temp_jump_aim];
             //  /*test*/ printf("checkpoint 001: \n serial_number:%d operator_id: %d \n",temp2->serial_number,temp2->operator_id);
        }
        if(temp_jump_aim != temp->data_result.ivalue + temp->serial_number)
        {temp->data_result.ivalue = temp_jump_aim - temp->serial_number;
        // /*test*/ printf("checkpoint 002: \n serial_number:%d operator_id: %d \n",temp->serial_number,temp->operator_id);
        }
        Output_Id1_jump(temp);
        continue;
        case 2: Output_Id2_assign(temp);
        continue;
        case 3: Output_Id3_TIMES(temp);
        continue;
        case 4: Output_Id4_DIVIDE(temp);
        continue;
        case 5: Output_Id5_PLUS(temp);
        continue;
        case 6: Output_Id6_MINUS(temp);
        continue;
        case 7: Output_Id7_NE(temp);
        continue;
        case 8: Output_Id8_EQ(temp);
        continue;
        case 9: Output_Id9_LT(temp);
        continue;
        case 10: Output_Id10_LE(temp);
        continue;
        case 11: Output_Id11_MT(temp);
        continue;
        case 12: Output_Id12_ME(temp);
        continue;
        case 13: Output_Id13_end(temp);
        continue;
        case 14: printf("ERROR: encounter operator_id 14! serial_number: %d ! \n",temp->serial_number);
        continue;
        default: printf("ERROR: invalid operator_id! serial_number: %d ! \n",temp->serial_number);
    }
    }

    free(Action_slot_pointer);
}

void yyerror(char *msg);
extern int yylex();

%}

%union {
    char* str;
    int ivalue;
    bool bvalue;
    struct Action* action;
}

%token <str> IDENTIFIER  
%token CONSTANT CHAR_CONSTANT BOOLEAN_CONSTANT
%token AND OR NOT
%token PLUS MINUS TIMES DIVIDE LT LE GT GE EQ NE
%token ASSIGN SEMICOLON COLON COMMA
%token LPAREN RPAREN LBRACKET RBRACKET
%token PROGRAM BEGIN_S END IF THEN ELSE WHILE DO REPEAT UNTIL
%token VAR INTEGER BOOL CHAR
%token PROGRAM_END DOT DOUBLE_DOT

%token ARRAY CALL CASE DIM FALSE FOR INPUT OF OUTPUT PROCEDURE READ REAL SET STOP TO TRUE WRITE

%type <ivalue> CONSTANT comparison_operator
%type <bvalue> BOOLEAN_CONSTANT
%type <str>  character_expression type CHAR_CONSTANT 
%type <str> identifier_list expression arithmetic_expression term factor arithmetic_value 
%type <action> boolean_expression statement statement_sequence if_statement while_statement repeat_statement compound_statement assignment_statement 
%type <action> boolean_item boolean_factor boolean_value 

%%

program: PROGRAM IDENTIFIER SEMICOLON variable_declaration compound_statement DOT { /* 识别主体部分的正则表达式，要输出识别到problem的标识符 */
struct Action* action = new_Action(0); /*起始结点*/
Id0_start(action,$2);
Attach_Action_slot(action,&Action_slot,&Action_slot_tail);
Attach_Multiple_Action_slot($5,&Action_slot,&Action_slot_tail);
action = new_Action(13);/*结束结点，program_end操作id为13*/
Id13_end(action);
Attach_Action_slot(action,&Action_slot,&Action_slot_tail);
// /* test */ printf("The end of the program. \n");

Output(Action_slot);
 }

variable_declaration: VAR variable_definition_list SEMICOLON { /* 声明部分 */  
            /* test */
            // printf("Declaration complete exit 0 \n"); 
            }
                  | /* ε (empty) */ {             
            /* test */
            // printf("Declaration complete, an empty declaration exit1 \n");
            }

variable_definition_list: identifier_list COLON type { /* 递归句子，处理单个 */  Attach_type_to_Identifier($3);}
                      | variable_definition_list identifier_list COLON type { /* 递归句，递归一次处理一个，连续定义 */  Attach_type_to_Identifier($4);}

identifier_list: IDENTIFIER { Declare_new_Identifier($1);
    /* 同上，对于单个标识符的具体定义 */ }
              | identifier_list COMMA IDENTIFIER { Declare_new_Identifier($3); }

type: INTEGER { $$ = "integer"; }
    | BOOL { $$ = "bool"; }
    | CHAR { $$ = "char"; }

 /*以下几行是关于语句的定义，第一句是总定义，statement_sequence递归识别，最终识别具体语句*/
compound_statement: BEGIN_S statement_sequence END {         
    $$ = NULL;
    Attach_Multiple_Action_slot($2,&$$,&$$);
    // /* test */ printf("Compound_statement complete exit 0 \n"); 
    }

statement_sequence: statement { 
    $$ = NULL;
    Attach_Multiple_Action_slot($1,&$$,&$$);
    // /* test */ printf("Single statement complete exit 0 \n");Output($$);
    }
        | statement_sequence SEMICOLON statement { 
    $$=NULL;
    struct Action* tail =Find_tail($1);
    // /*test*/ printf("now in statement_sequence checkpoint 1 \n \n \n");
    // Output($1);
    // printf("\n \n \n");
    // Output($3);
    // printf("\n \n \n");
    Attach_Multiple_Action_slot($3,&$1,&tail);
    // /*test*/ printf("now in statement_sequence checkpoint 2 \n");
    Attach_Multiple_Action_slot($1,&$$,&$$);
    // /* test */ printf("Multiple statement complete exit 0 \n");Output($$); 
    }

statement: assignment_statement { $$ = $1; // /* test */ printf("Assign statement complete exit 0 \n");Output($$); 
}
        | if_statement { $$ = $1;// /* test */ printf("if statement complete exit 0 \n");Output($$); 
        }
        | while_statement { $$ = $1; // /* test */ printf("while statement complete exit 0 \n");Output($$);
        }
        | repeat_statement { $$ = $1; // /* test */ printf("repeat statement complete exit 0 \n");Output($$);
        }
        | compound_statement { $$ = $1; // /* test */ printf("compound statement complete exit 0 \n");Output($$);
        }

assignment_statement: IDENTIFIER ASSIGN expression { 
    struct Action* action = new_Action(2);
    Id2_assign(action,$1,$3);
     
    if(arithmetic_expression_slot != NULL)
    {
        struct Action* arithmetic_expression_slot_tail = Find_tail(arithmetic_expression_slot);
        Attach_Action_slot(action,&arithmetic_expression_slot,&arithmetic_expression_slot_tail);
        $$ = arithmetic_expression_slot;
        arithmetic_expression_slot = NULL;
    }
    else
    {$$ = action;}
 }



/* 条件判断语句 */
if_statement: IF boolean_expression THEN statement { 
    // /*test*/ printf("now in if then statement! \n");
    $$ = NULL;
    struct Action* arg1_tail = Find_tail($2);
    struct Action* arg2_tail = Find_tail($4);

    arg1_tail->data_result.ivalue = 2;
    arg1_tail->type_result = 0;
    /*创建假出口结点*/
    struct Action* temp = malloc(sizeof(struct Action));
    temp->serial_number = arg1_tail->serial_number + 1;
    temp->operator_id = 1;
    temp->data_result.ivalue = arg2_tail->serial_number + 2;
    /*链接*/
    arg1_tail->next = temp;
    temp->next = $4;
    Attach_Multiple_Action_slot($4,&$2,&temp);

    Attach_Multiple_Action_slot($2,&$$,&$$);
 }
           | IF boolean_expression THEN statement ELSE statement { 
    // /*test*/ printf("now in if then else statement! \n");
     $$ = NULL;
    struct Action* arg1_tail = Find_tail($2);
    struct Action* arg2_tail = Find_tail($4);
    struct Action* arg3_tail = Find_tail($6);

    arg1_tail->data_result.ivalue = 2;
    arg1_tail->type_result = 0;
    /*创建假出口结点*/
    struct Action* temp = malloc(sizeof(struct Action));
    temp->serial_number = arg1_tail->serial_number + 1;
    temp->operator_id = 1;
    temp->data_result.ivalue = arg2_tail->serial_number + 3;
    /*链接*/
    arg1_tail->next = temp;
    temp->next = $4;
     Attach_Multiple_Action_slot($4,&$2,&temp);
    /*创建真出口执行后的跳转结点*/
    temp = malloc(sizeof(struct Action));
    temp->serial_number = arg2_tail->serial_number + 1;
    temp->operator_id = 1;
    temp->data_result.ivalue = arg3_tail->serial_number + 2;
     /*链接*/
    arg2_tail->next = temp;
    temp->next = $6;
     Attach_Multiple_Action_slot($6,&$4,&temp);

    Attach_Multiple_Action_slot($2,&$$,&$$);
            }

while_statement: WHILE boolean_expression DO statement { 
    // /*test*/ printf("now in while statement! \n");
    $$ = NULL;
    struct Action* arg1_tail = Find_tail($2);
    struct Action* arg2_tail = Find_tail($4);

    arg1_tail->data_result.ivalue = 2;
    arg1_tail->type_result = 0;
    /*创建假出口结点*/
    struct Action* temp = malloc(sizeof(struct Action));
    temp->serial_number = arg1_tail->serial_number + 1;
    temp->operator_id = 1;
    temp->data_result.ivalue = arg2_tail->serial_number + 3;
    /*链接*/
    arg1_tail->next = temp;
    temp->next = $4;
    Attach_Multiple_Action_slot($4,&$2,&temp);
    /*执行成功后返回入口*/
    temp = malloc(sizeof(struct Action));
    temp->serial_number = arg2_tail->serial_number + 1;
    temp->operator_id = 1;
    /*链接*/
    temp->data_result.ivalue = -(arg2_tail->serial_number + 1);
    arg2_tail->next = temp;
    temp->next = NULL;

    Attach_Multiple_Action_slot($2,&$$,&$$);
 }

repeat_statement: REPEAT statement UNTIL boolean_expression { 
    // /*test*/ printf("now in repeat statement! \n");
    $$ = NULL;
    struct Action* arg1_tail = Find_tail($2);
    struct Action* arg2_tail = Find_tail($4);

    // /*test*/ Output($2);Output($4);

    /*跳转*/
    arg2_tail->data_result.ivalue = 2;
    arg2_tail->type_result = 0;

    struct Action* action = new_Action(1);
    action->data_result.ivalue=-(arg1_tail->serial_number + arg2_tail->serial_number + 2);

    /*链接*/
    // arg1_tail->next = $4; ???后期看意义不明
    Attach_Multiple_Action_slot($4,&$2,&arg1_tail);
    Attach_Action_slot(action,&$2,&arg1_tail);
   

    Attach_Multiple_Action_slot($2,&$$,&$$);
 }






 /*表达式*/
expression: arithmetic_expression {  
$$ = $1;
}
 /*       | boolean_expression { 
            $$ = $1;
           } */

 /*算数表达式，term进行乘除法运算，这里直接处理加减法。处理优先级的巧妙方法*/
arithmetic_expression: arithmetic_expression PLUS term {     
    char* temp = Temp_creator();
    struct Action* action = new_Action(5);
    Id3_TIMES(action,$1,$3,temp);
    struct Action* arithmetic_expression_slot_tail = Find_tail(arithmetic_expression_slot);
    Attach_Action_slot(action,&arithmetic_expression_slot,&arithmetic_expression_slot_tail);
    $$ = temp;  // /* test */ printf("PLUS oparation completed! \n"); 
    }
        | arithmetic_expression MINUS term {     
    char* temp = Temp_creator();
    struct Action* action = new_Action(6);
    Id3_TIMES(action,$1,$3,temp);
    struct Action* arithmetic_expression_slot_tail = Find_tail(arithmetic_expression_slot);
    Attach_Action_slot(action,&arithmetic_expression_slot,&arithmetic_expression_slot_tail);
    $$ = temp;
     // /* test */ printf("MINUS oparation completed! \n"); 
     }
        | term { $$ = $1; // /* test */ printf("arithmetic_expression: Directly dirive from term! \n"); 
        }

term: term TIMES factor { 
    char* temp = Temp_creator();
    struct Action* action = new_Action(3);
    Id3_TIMES(action,$1,$3,temp);
    struct Action* arithmetic_expression_slot_tail = Find_tail(arithmetic_expression_slot);
    Attach_Action_slot(action,&arithmetic_expression_slot,&arithmetic_expression_slot_tail);
    $$ = temp; }
    | term DIVIDE factor {     
    char* temp = Temp_creator();
    struct Action* action = new_Action(4);
    Id3_TIMES(action,$1,$3,temp);
    struct Action* arithmetic_expression_slot_tail = Find_tail(arithmetic_expression_slot);
    Attach_Action_slot(action,&arithmetic_expression_slot,&arithmetic_expression_slot_tail);
    $$ = temp; }
    | factor { $$ = $1; }

factor: arithmetic_value { $$ = $1; // /* test */ printf("factor: Directly dirive from value! \n"); 
}
      | MINUS factor { 
        if($2[0]=='-') {
            for(int n = 1;n < 20;n++)
            {
                if($2[n]=='\0')
                {
                    for(int t = 0;t < t;t++)
                    $2[t] = $2[t+1];
                    /*test*/printf("factor: value: %s \n",$2);
                }
                break;
            }
        }
        else if('0'<=$2[0]&&'9'>=$2[0])
        {
            for(int n = 1;n < 20;n++)
            {
                if($2[n]=='\0')
                {
                    for(int t = n;t > 0;t--)
                    $2[t+1] = $2[t];
                    /*test*/printf("factor: value: %s \n",$2);
                }
                $2[0] = '-';
                break;
            }
        }
        $$ = $2; /* test */ printf("Negative oparation completed! value: %d \n",$$); }

 /*运算数的定义，标识符常量或带括号的运算数*/
arithmetic_value: IDENTIFIER { 
    $$ = $1;
 }
              | CONSTANT { 
                char* char_number = malloc(20);
                sprintf(char_number, "%d", $1);
                // /*test*/ printf("indentify constant! \n");
                $$ = char_number; }
              | LPAREN arithmetic_expression RPAREN { $$ = $2; }






/* 布尔表达式 处理or */
boolean_expression: boolean_expression OR boolean_item { 
    // /*test*/ printf("now in boolean_expression \n");
    struct Action* arg1_tail = Find_tail($1);
    struct Action* arg2_tail = Find_tail($3);
    arg1_tail->data_result.ivalue = arg2_tail->serial_number + 2;
    arg2_tail->data_result.ivalue = 2;
    Attach_Multiple_Action_slot($3,&$1,&arg1_tail);
    struct Action* action =new_Action(1);
    Id1_jump(action,true);
    action->data_result.ivalue = 2;
    Attach_Action_slot(action,&$1,&arg2_tail);
    action = new_Action(1);
    Id1_jump(action,true);
    Attach_Action_slot(action,&$1,&(arg2_tail->next));

    $$ = $1;
 }
                | boolean_item { 
                        // /*test*/ printf("now in boolean_expression \n");
                    $$ = $1; }

/* 布尔项 处理and */
boolean_item: boolean_item AND boolean_factor { 
      //  /*test*/ printf("now in boolean_item \n");
    struct Action* arg1_tail = Find_tail($1);
    struct Action* arg2_tail = Find_tail($3);
    arg1_tail->data_result.ivalue = 2;
    arg2_tail->data_result.ivalue = 2;
    struct Action* action =new_Action(1);
    Id1_jump(action,true);
    action->data_result.ivalue = arg2_tail->serial_number + 2;
    Attach_Action_slot(action,&$1,&arg1_tail);
    Attach_Multiple_Action_slot($3,&$1,&action);
    action =new_Action(1);
    Id1_jump(action,true);
    action->data_result.ivalue = 2;
    Attach_Action_slot(action,&$1,&arg2_tail);
    action =new_Action(1);
    Id1_jump(action,true);
    Attach_Action_slot(action,&$1,&arg2_tail);
    $$ = $1;
 }
           | boolean_factor { 
            // /*test*/ printf("now in boolean_item \n");
            $$ = $1; }
/* 布尔因子 处理not */
boolean_factor: NOT boolean_factor { 
    $$ = $2;
 }
             | boolean_value { $$ = $1;
             // /* test */ printf("boolean_factor : Directly derive from boolean_value \n"); 
             }
/* 布尔量 */
boolean_value: BOOLEAN_CONSTANT { 
    char* temp = malloc(6);
    if($1==1) temp = "true";
    else temp = "false";
    struct Action* action = new_Action(15);
    action->type_result = 3;
    action->data_result.cvalue = temp;
    $$ = action;
 }
            | arithmetic_expression comparison_operator arithmetic_expression { 
                    struct Action* action = NULL;
    switch($2)
    {
        case 0: action = new_Action(7);
                break;
        case 1: action = new_Action(8);
                break;
        case 2: action = new_Action(9);
                break;
        case 3: action = new_Action(10);
                break;
        case 4: action = new_Action(11);
                break;
        case 5: action = new_Action(12);
                break;
       default: printf("ERROR in boolean_value: invalid comparison_operator : %d! \n",$2);
    }
    Id7_NE(action,$1,$3);
    $$ = action;
             }
            | LPAREN boolean_expression RPAREN { $$ = $2; }

comparison_operator: EQ { /* equal等于 */ $$ = 1; }
                 | NE { /* not equal不等于 */ $$ = 0; }
                 | LT { /* less than小于 */ $$ = 2; }
                 | LE { /* less than or equal to小于等于 */ $$ = 3; }
                 | GT { /* greater than大于 */ $$ = 4; }
                 | GE { /* greater than or equal to大于等于 */ $$ = 5; }

character_expression: CHAR_CONSTANT { $$ = $1; }
                  | IDENTIFIER { 
    for(struct IdNode* temp_Node = Id_list;;temp_Node = temp_Node->next)
    {
        if(temp_Node == NULL) {
            /* test */
            printf("Fail to find identifier in character_expression Exit 0 \n");
            break;
            }
        else if(strcmp(temp_Node->name,$1)==0)
        {
            if(temp_Node->type != 3){
                printf("Error in character_expression, the type of indentifier %s is not char! \n",temp_Node->name);
            }
            $$ = strdup(temp_Node->data.cvalue);
            /* test */
            printf("Successfully get the value of Identifier %s, value:%s \n",temp_Node->name,temp_Node->data.cvalue);
            break;
        }
        else {
            /* test */
            printf("character_expression : Search for %s, currently it is %s \n",$1,temp_Node->name);
            break;
            }
    }
    /* test */
    printf("character_expression process completed. \n");
                   }

%%
void Declare_new_Identifier(char* name)
{
    // printf("Module Declare_new_Identifier is used! \n");
    struct IdNode* new_node = malloc(sizeof(struct IdNode));
    if(new_node==NULL) printf("内存空间不足！\n");
    new_node->name = strdup(name);
    new_node->type = UNDEFINED_T;
    new_node->next = Id_list;
    Id_list = new_node;
    /* test */
    // printf("A room is created for %s , from Declare_new_Identifier. \n", name);
    /* sleep(1); */
    return;
}
void Attach_type_to_Identifier(char* type)
{
    // printf("Module Attach_type_to_Identifier is used! \n");
    enum Datatype temp = UNDEFINED_T;
    if(strcmp(type,"integer")==0)  temp = INTEGER_T;
    else if(strcmp(type,"bool")==0) temp = BOOL_T;
    else if(strcmp(type,"char")==0) temp = CHAR_T;    
    for(struct IdNode* temp_Node = Id_list;;temp_Node = temp_Node->next)
    {
        if(temp_Node == NULL) {
            /* test */
            // printf("Type assignment completed Exit 0 \n");
            break;
            }
        else if(temp_Node->type == UNDEFINED_T)
        {
            temp_Node->type = temp;
            /* test */
            // printf("Identifier %s type assigned as %d \n",temp_Node->name,temp_Node->type);
        }
        else {
            /* test */
            // printf("Type assignment completed Exit 2 \n");
            break;
            }
    }
    /* test */
    /* sleep(1); */
    return;
}
bool Bool_Comparision(int A,int B,int operator){
switch(operator)
{
    case 0 : return A != B;
    case 1 : return A == B;
    case 2 : return A < B;
    case 3 : return A <= B;
    case 4 : return A > B;
    case 5 : return A >= B;
    default:{
        printf("Error in module Bool_Comparision! invalid operator : %d! \n",operator );
        return false;
    }
}

}

/* 行为栈操作函数 */
/*对于单个、连续的action:链接并赋序号*/
void Attach_Action_slot(struct Action* new_Action, struct Action** slot, struct Action** tail)
{
if(*slot==NULL)
{
    *slot = new_Action;
    new_Action->serial_number = 0;
}
else
{
    if((*slot)->operator_id == 14)
    {
        (*slot)->data_result.ivalue++;
    }
    (*tail)->next = new_Action;
    new_Action->serial_number = (*tail)->serial_number + 1;
}
*tail = new_Action;
/*test*/
if(*slot==NULL)
printf("Attach_Action_slot : slot is NULL \n");
if(*tail==NULL)
printf("Attach_Action_slot : tail is NULL \n");
//Output(*slot);
}
/*对于由statement_start引领一段action:根据相对序号调整好序号，传入new_Action不能为NULL*/
void Attach_Multiple_Action_slot(struct Action* new_Action, struct Action** slot, struct Action** tail)
{
if(*slot==NULL)
{
    *slot = new_Action;
    new_Action->serial_number = 0;
    *tail = new_Action;
}
else
{
    struct Action* temp = NULL;
    if((*slot)->operator_id == 14)
    {
        (*slot)->data_result.ivalue++;
    }
    if(new_Action->operator_id == 14)
    {(*tail)->next = new_Action->next;
    temp = new_Action->next;
    }
    else {
        //printf("module Attach_Multiple_Action_slot receive new_Action that doesn't start with statement_start! \n");
    (*tail)->next = new_Action;
    temp = new_Action;}

    for(;;temp = temp->next)
    {
        // /*test*/ Output(temp); 
        temp->serial_number = (*tail)->serial_number + temp->serial_number + 1;
    if(temp->next==NULL)
    {
        *tail = temp;
        break;
    }

    }
}

/*test*/
if(*slot==NULL)
printf("Attach_Multiple_Action_slot : slot is NULL \n");
if(*tail==NULL)
printf("Attach_Multiple_Action_slot : tail is NULL \n");
//Output(*slot);
return;
}


struct Action* Find_tail(struct Action* slot)
{
    if(slot==NULL)
    {
        // printf("Might be an ERROR in module Find_tail! Slot is NULL! \n");
        return NULL;
    }
    else /*循环至找到末尾*/
    {
    struct Action* temp = NULL;
    for( temp = slot; temp->next!=NULL; temp = temp->next) 
    ;// /*test*/ printf("Module Find_tail in use. Current relative id:%d \n",temp->serial_number);
    return temp;
    }
}

char* Temp_creator()
{
    counter++;
    int result_length = snprintf(NULL, 0, "%s%d", T, counter);
    char *result_string = malloc(result_length + 1);
    sprintf(result_string, "%s%d", T, counter);
    return result_string;
}





struct Action* new_Action(int operator_id)
{
    struct Action* operation_action = malloc(sizeof(struct Action));
    operation_action->operator_id = operator_id;
    operation_action->type_arg1 = 0;
    operation_action->type_arg2 = 0;
    operation_action->type_result = 0;
    operation_action->data1.ivalue = 0;
    operation_action->data2.ivalue = 0;
    operation_action->data_result.ivalue = 0;
    operation_action->next = NULL;
    operation_action->serial_number = 0;
    return operation_action;
}

struct IdNode* Search_Identifier(char* target_name)
{
    /* 访问Id_list遍历获得标识符名 */
    for(struct IdNode* temp_Node = Id_list;;temp_Node = temp_Node->next)
    {
        if(temp_Node == NULL) {
            /* test */
            printf("Fail to find identifier in module Search_Identifier Exit 0 \n");
            break;
            }
        else if(strcmp(temp_Node->name,target_name)==0)
        {
            /* test */
            printf("Module Search_Identifier Successfully get the Identifier %s \n",temp_Node->name);
            return temp_Node;
            break;
        }
        else {
            /* test */
            printf("Module Search_Identifier : Search for %s, currently it is %s \n",target_name,temp_Node->name);
            }
    }
    /* test */
    printf("Search_Identifier process failed. \n");
    return NULL;
}

void Id0_start(struct Action* operation_action,char* name)
{
    operation_action->type_arg1 = 3;
    operation_action->data1.cvalue = name;
    operation_action->serial_number = 0;
    return;
}
void Output_Id0_start(struct Action* operation_action)
{
    printf("(%d) (program,%s,-,-) \n",operation_action->serial_number,operation_action->data1.cvalue);
    return;
}

void Id1_jump(struct Action* operation_action,bool flag)
{
    /* !flag 为false 表示是假出口且需要跳过下一个表达式， true表示跳转的相对距离已确定 */
if(!flag) {
    operation_action->type_arg1 = 1;
}
return;
}

void Output_Id1_jump(struct Action* operation_action)
{
    printf("(%d) (j,-,-,%d) \n",operation_action->serial_number,operation_action->data_result.ivalue+operation_action->serial_number);
    return;
}

void Id2_assign(struct Action* operation_action,char* name,char* temp)
{
operation_action->type_arg1=3;
operation_action->type_result=3;
operation_action->data1.cvalue=temp;
operation_action->data_result.cvalue=name;
return;
}
void Output_Id2_assign(struct Action* operation_action)
{
    printf("(%d) (:=,%s,-,%s) \n",operation_action->serial_number,operation_action->data1.cvalue,operation_action->data_result.cvalue);
    return;
}

void Id3_TIMES(struct Action* operation_action,char* arg1,char* arg2,char* temp)
{
    operation_action->type_arg1 = 3;
    operation_action->data1.cvalue = arg1;
    operation_action->type_arg2 = 3;
    operation_action->data2.cvalue = arg2;
    operation_action->type_result = 3;
    operation_action->data_result.cvalue = temp;
    return;
}
void Output_Id3_TIMES(struct Action* operation_action)
{
    printf("(%d) (*,%s,%s,%s) \n",operation_action->serial_number,operation_action->data1.cvalue,operation_action->data2.cvalue,operation_action->data_result.cvalue);
    return;
}

void Id4_DIVIDE(struct Action* operation_action,char* arg1,char* arg2,char* temp)
{
    operation_action->type_arg1 = 3;
    operation_action->data1.cvalue = arg1;
    operation_action->type_arg2 = 3;
    operation_action->data2.cvalue = arg2;
    operation_action->type_result = 3;
    operation_action->data_result.cvalue = temp;
    return;
}
void Output_Id4_DIVIDE(struct Action* operation_action)
{
    printf("(%d) (/,%s,%s,%s) \n",operation_action->serial_number,operation_action->data1.cvalue,operation_action->data2.cvalue,operation_action->data_result.cvalue);
    return;
}


void Id5_PLUS(struct Action* operation_action,char* arg1,char* arg2,char* temp)
{
    operation_action->type_arg1 = 3;
    operation_action->data1.cvalue = arg1;
    operation_action->type_arg2 = 3;
    operation_action->data2.cvalue = arg2;
    operation_action->type_result = 3;
    operation_action->data_result.cvalue = temp;
    return;
}
void Output_Id5_PLUS(struct Action* operation_action)
{
    printf("(%d) (+,%s,%s,%s) \n",operation_action->serial_number,operation_action->data1.cvalue,operation_action->data2.cvalue,operation_action->data_result.cvalue);
    return;
}

void Id6_MINUS(struct Action* operation_action,char* arg1,char* arg2,char* temp)
{
    operation_action->type_arg1 = 3;
    operation_action->data1.cvalue = arg1;
    operation_action->type_arg2 = 3;
    operation_action->data2.cvalue = arg2;
    operation_action->type_result = 3;
    operation_action->data_result.cvalue = temp;
    return;
}
void Output_Id6_MINUS(struct Action* operation_action)
{
    printf("(%d) (-,%s,%s,%s) \n",operation_action->serial_number,operation_action->data1.cvalue,operation_action->data2.cvalue,operation_action->data_result.cvalue);
    return;
}

void Id7_NE(struct Action* operation_action,char* arg1,char* arg2)
{
    operation_action->type_arg1 = 3;
    operation_action->data1.cvalue = arg1;
    operation_action->type_arg2 = 3;
    operation_action->data2.cvalue = arg2;
    operation_action->type_result = 1;
    operation_action->data_result.ivalue = 0;
    return;
}
void Output_Id7_NE(struct Action* operation_action)
{
    printf("(%d) (j!=,%s,%s,%d) \n",operation_action->serial_number,operation_action->data1.cvalue,operation_action->data2.cvalue,operation_action->data_result.ivalue+operation_action->serial_number);
    return;
}


void Id8_EQ(struct Action* operation_action,char* arg1,char* arg2)
{
    operation_action->type_arg1 = 3;
    operation_action->data1.cvalue = arg1;
    operation_action->type_arg2 = 3;
    operation_action->data2.cvalue = arg2;
    operation_action->type_result = 1;
    operation_action->data_result.ivalue = 0;
    return;
}
void Output_Id8_EQ(struct Action* operation_action)
{
    printf("(%d) (j=,%s,%s,%d) \n",operation_action->serial_number,operation_action->data1.cvalue,operation_action->data2.cvalue,operation_action->data_result.ivalue + operation_action->serial_number);
    return;
}

void Id9_LT(struct Action* operation_action,char* arg1,char* arg2)
{
    operation_action->type_arg1 = 3;
    operation_action->data1.cvalue = arg1;
    operation_action->type_arg2 = 3;
    operation_action->data2.cvalue = arg2;
    operation_action->type_result = 1;
    operation_action->data_result.ivalue = 0;
    return;
}
void Output_Id9_LT(struct Action* operation_action)
{
    printf("(%d) (j<,%s,%s,%d) \n",operation_action->serial_number,operation_action->data1.cvalue,operation_action->data2.cvalue,operation_action->data_result.ivalue + operation_action->serial_number);
    return;
}

void Id10_LE(struct Action* operation_action,char* arg1,char* arg2)
{
    operation_action->type_arg1 = 3;
    operation_action->data1.cvalue = arg1;
    operation_action->type_arg2 = 3;
    operation_action->data2.cvalue = arg2;
    operation_action->type_result = 1;
    operation_action->data_result.ivalue = 0;
    return;
}
void Output_Id10_LE(struct Action* operation_action)
{
    printf("(%d) (j<=,%s,%s,%d) \n",operation_action->serial_number,operation_action->data1.cvalue,operation_action->data2.cvalue,operation_action->data_result.ivalue + operation_action->serial_number);
    return;
}

void Id11_MT(struct Action* operation_action,char* arg1,char* arg2)
{
    operation_action->type_arg1 = 3;
    operation_action->data1.cvalue = arg1;
    operation_action->type_arg2 = 3;
    operation_action->data2.cvalue = arg2;
    operation_action->type_result = 1;
    operation_action->data_result.ivalue = 0;
    return;
}
void Output_Id11_MT(struct Action* operation_action)
{
    printf("(%d) (j>,%s,%s,%d) \n",operation_action->serial_number,operation_action->data1.cvalue,operation_action->data2.cvalue,operation_action->data_result.ivalue + operation_action->serial_number);
    return;
}


void Id12_ME(struct Action* operation_action,char* arg1,char* arg2)
{
    operation_action->type_arg1 = 3;
    operation_action->data1.cvalue = arg1;
    operation_action->type_arg2 = 3;
    operation_action->data2.cvalue = arg2;
    operation_action->type_result = 1;
    operation_action->data_result.ivalue = 0;
    return;
}
void Output_Id12_ME(struct Action* operation_action)
{
    printf("(%d) (j>=,%s,%s,%d) \n",operation_action->serial_number,operation_action->data1.cvalue,operation_action->data2.cvalue,operation_action->data_result.ivalue + operation_action->serial_number);
    return;
}

void Id13_end(struct Action* operation_action)
{
    if(Action_slot_tail != NULL)
    operation_action->serial_number = Action_slot_tail->serial_number + 2;
    else printf("ERROR in Id13_end: Action_slot_tail == NULL ! \n");
    return;
}
void Output_Id13_end(struct Action* operation_action)
{
    printf("(%d) (sys,-,-,-) \n",operation_action->serial_number);
    return;
}


int main() {
    extern FILE *yyin;
    yyin = stdin;
    Id_list = NULL;
    Action_slot = NULL;
    Action_slot_tail = NULL;
    arithmetic_expression_slot = NULL;
    counter = 0;
    T[0] = 'T';
    T[1] = '\0';
    printf("Huang Qijia;Computer Science Class Two;202230441206 \n");
    yyparse();

    printf("Parsing completed. Add your additional code here or wait for user input.\n");
    getchar();
    sleep(30);
    return 0;
}
// Linux 下注释掉这个函数
void yyerror(char *msg) {
    printf("Error encountered: %s \n", msg);
}
// Linux 下注释掉这个函数
int yywrap(){
    return 1;
}
