%{
#include <stdio.h>
#include <stdbool.h>
#include "y.tab.h"

int yywrap(void);
int yylex(void);//这个是lex生成的词法分析函数，yacc的yyparse()里会调用它，如果这里不声明，生成的yacc.tab.c在编译时会找不到该函数


%}



letter      [A-Za-z]
digit       [0-9]
s_delimiter : '+' | '-' | '*' | '/' | '=' | '<' | '>' | '(' | ')' | '[' | ']' | ':' | '.' | ';' | ',' | '\''| "'"

wordset     {reserved_word}|{d_delimiter}|{identifier}|{constant}|{s_delimiter}

reserved_word   and|array|begin|bool|call|case|char|constant|dim|do|else|end|false|for|if|input|integer|not|of|or|output|procedure|program|read|real|repeat|set|stop|then|to|true|until|var|while|write
d_delimiter     <>|<=|>=|:=|\/\*|\*\/|\.\.
identifier      {letter}({letter}|{digit})*
constant        {integer_constant}|{boolean_constant}|{char_constant}
integer_constant         {digit}+
/* boolean_constant true|false */
char_constant   '[^']+'
type integer | bool | char

%%
[ \t\r\a]+     ; // 空白字符
[\n]           ; // 换行符
and return AND;
array return ARRAY;
begin return BEGIN_S;
bool return BOOL;
call return CALL;
case return CASE;
char return CHAR;
constant return CONSTANT;
dim return DIM;
do return DO;
else return ELSE;
end return END;
false {
    yylval.bvalue = false;
    return FALSE;}
for return FOR;
if return IF;
input return INPUT;
integer return INTEGER;
not return NOT;
of return OF;
or return OR;
output return OUTPUT;
procedure return PROCEDURE;
program      return PROGRAM;
read return READ;
real return REAL;
repeat return REPEAT;
set return SET;
stop return STOP;
then return THEN;
to return TO;
true {
    yylval.bvalue = true;
    return TRUE;}
until return UNTIL;
var return VAR;
while return WHILE;
write return WRITE;


{identifier} {yylval.str = strdup(yytext);return IDENTIFIER;} // 标识符
{integer_constant} {yylval.ivalue = atoi(yytext);return CONSTANT;} // 整数
"\'"{char_constant}+"\'" {yylval.str = strdup(yytext); return CHAR_CONSTANT;} // 字符



"(" return LPAREN;
")" return RPAREN;
"*" return TIMES;

"+" return PLUS;
"," return COMMA;
"-" return MINUS;
"." return DOT;
".." return DOUBLE_DOT;
"/" return DIVIDE;

":"  return COLON;
":=" return ASSIGN;
";"  return SEMICOLON;
"<" return LT;
"<=" return LE;
"<>" return NE; //not equal
"=" return EQ;
">" return GT;
">=" return GE;
"[" return LBRACKET;
"]" return RBRACKET;
 

"\'"{char_constant} {
    printf("Character constant missing the closing single quote: '%s'\n", yytext);
}


"/*" {
    int comment_level = 1;
    int c;
    while ((c = input()) != EOF) {
        if (c == '/' && (c = input()) == '*') {
            comment_level++;
        } else if (c == '*' && (c = input()) == '/') {
            comment_level--;
            if (comment_level == 0) {
                break;
            }
        }else if(c == '\n'){
        printf("Comment section missing the closing right delimiter '*/'\n");
        break;
    }
    }
    
}

 [^A-Za-z0-9 \t\r\a\n]|"0"+{digit} {
    printf("Invalid characters: '%s'\n", yytext);
}


%%




