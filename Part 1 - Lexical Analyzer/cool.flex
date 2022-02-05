/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>
#include <string.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;
int string_len;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */
int nestCount, bracketCount;


%}

/*
 * Define names for regular expressions here.
 */

DARROW          	=>
ASSIGN			<-
LE			<=


CLASS			(?i:class)
ELSE			(?i:else)
IF			(?i:if)
FI			(?i:fi)
THEN			(?i:then)
IN			(?i:in)
INHERITS		(?i:inherits)
ISVOID			(?i:isvoid)
LET			(?i:let)
LOOP			(?i:loop)
POOL			(?i:pool)
WHILE			(?i:while)
CASE			(?i:case)
ESAC			(?i:esac)
NEW			(?i:new)
OF			(?i:of)
NOT			(?i:not)

TRUE			[t](?i:rue)
FALSE			[f](?i:alse)

DIGITS			[0-9]+


%x INLINECOMMENT NESTEDCOMMENT STRING

%%


 /*
  *  The single-character operators.
  */
"="			{ return ('='); }
"+"			{ return ('+'); }
"-"			{ return ('-'); }
"*"			{ return ('*'); }
"/"			{ return ('/'); }
"~"			{ return ('~'); }
"<"			{ return ('<'); }
","			{ return (','); }
":"			{ return (':'); }
";"			{ return (';'); }
"@"			{ return ('@'); }
"."			{ return ('.'); }
"("			{ return ('('); }
")"			{ return (')'); }
"{"			{ return ('{'); }
"}"			{ return ('}');	}





 /* Single-line comments */
"--"			{ BEGIN (INLINECOMMENT); }	/* Start comment when -- is found */
<INLINECOMMENT>.	{ }				/* Eat up anything in the middle */
<INLINECOMMENT><<EOF>>	{ BEGIN (INITIAL); }		/* Exit comment if end of file */
<INLINECOMMENT>\n	{ 
			  curr_lineno++;	/* Increment line number upon newline */
			  BEGIN (INITIAL);		/* Exit comment if end of line */
			}




 /*
  *  Nested comments
  */
"(*"			{ 
			  nestCount = 0;		/* Initialize nested comment count */
			  BEGIN (NESTEDCOMMENT); 	/* Start comment condition */
			}

<NESTEDCOMMENT>.	{ }				/* Eat up anything in the middle */

<NESTEDCOMMENT>\n	{ curr_lineno++; }		/* Increment line number upon newline */

<NESTEDCOMMENT>"(*"	{ nestCount++; }		/* If another (* is found within, increment nested comment count */

 /* If EOF while in <NESTEDCOMMENT>, throw error */
<NESTEDCOMMENT><<EOF>>	{
			  cool_yylval.error_msg = "EOF in comment";
			  BEGIN (INITIAL);
			  return (ERROR);
			}

<NESTEDCOMMENT>"*)"	{ if (nestCount) nestCount--; else BEGIN (INITIAL); }	/* If within nested comment, decrement nest count. Else exit comment */

 /* If *) is found outside of <NESTEDCOMMENT> throw error */
"*)"			{
			  cool_yylval.error_msg = "Unmatched *)";
			  BEGIN (INITIAL);
			  return (ERROR);
			}




 /*
  *  The multiple-character operators.
  */
{DARROW}		{ return (DARROW); }
{ASSIGN}		{ return (ASSIGN); }
{LE}			{ return (LE); }


 /*
  * Keywords are case-insensitive except for the values true and false,
  * which must begin with a lower-case letter.
  */
{CLASS}				{ return (CLASS); }
{ELSE}				{ return (ELSE); }
{IF}				{ return (IF); }
{FI}				{ return (FI); }
{THEN}				{ return (THEN); }
{IN}				{ return (IN); }
{INHERITS}			{ return (INHERITS); }
{ISVOID}			{ return (ISVOID); }
{LET}				{ return (LET); }
{LOOP}				{ return (LOOP); }
{POOL}				{ return (POOL); }
{WHILE}				{ return (WHILE); }
{CASE}				{ return (CASE); }
{ESAC}				{ return (ESAC); }
{NEW}				{ return (NEW); }
{OF}				{ return (OF); }
{NOT}				{ return (NOT); }


 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */

 /* Upon finding a " begin assembling string literal */
"\""				{ 
				  BEGIN (STRING);				/* Enter STRING condition */
				  string_buf_ptr = &(string_buf[0]);		/* Reset pointer to the beginning of string buffer */
				  memset(string_buf, 0, MAX_STR_CONST);		/* Flush the string buffer */
				  string_len = 0;				/* Reset string length counter to zero */
				}

 /* Assemble escape characters */
<STRING>\\.			{ 
				  if (string_len >= MAX_STR_CONST) {
					cool_yylval.error_msg = "String constant too long";
					BEGIN (INITIAL);
					return (ERROR);
				  }

				  switch (*(yytext+1)) {
					case 'b':
				  		*(string_buf_ptr++) = '\b';
						break;

					case 'f':
				  		*(string_buf_ptr++) = '\f';
						break;

					case 'n':
				  		*(string_buf_ptr++) = '\n';
						break;

					case 't':
				  		*(string_buf_ptr++) = '\t';
						break;

					case '0':
				  		*(string_buf_ptr++) = '0';
						break;
					
					default:
						*(string_buf_ptr++) = *(yytext+1);

				  }

				  string_len++;		/* Increment string length */
				}


 /* Assemble normal string literal characters */
<STRING>[^\n\t\b\f\0\"]		{ 
				  if (string_len >= MAX_STR_CONST) {
					cool_yylval.error_msg = "String constant too long";
					BEGIN (INITIAL);
					return (ERROR);
				  }

				  *(string_buf_ptr++) = *yytext; 
				  string_len++;
				}

 /* String cannot contain unescaped newline chars */
<STRING>\n			{
				  curr_lineno++;	/* Increment line number upon newline */

				  cool_yylval.error_msg = "Unterminated string constant";
				  BEGIN (INITIAL);
				  return (ERROR);
				}


 /* String literal cannot contain null char */
<STRING>\0			{
				  cool_yylval.error_msg = "String contains null character";
				  BEGIN (INITIAL);
				  return (ERROR);
				}


 /* ASK ABOUT THIS: Lexer should eat escaped newline(?) */
 /* If escaped newline is found, add newline to string literal */
<STRING>\\[\n]			{ 
				  curr_lineno++;	/* Increment line number upon newline */
						
				  if (string_len >= MAX_STR_CONST) {
					cool_yylval.error_msg = "String constant too long";
					BEGIN (INITIAL);
					return (ERROR);
				  }

				  *(string_buf_ptr++) = '\n';
 
				  string_len++;
				}

<STRING><<EOF>>		{
			  cool_yylval.error_msg = "EOF in string constant";
			  BEGIN (INITIAL);
			  return (ERROR);
			}
		

 /* At end of string literal, return string to parser and exit string condition */
<STRING>"\""			{ 				

				  cool_yylval.symbol = stringtable.add_string(string_buf);	/* Set yylval with string value */

				  BEGIN (INITIAL); 	/* Return to original condition state */		  

				  return (STR_CONST);
				}



 /* Boolean literals (true, false) */
{TRUE}				{
				  cool_yylval.boolean = true;
				  return (BOOL_CONST);
				}

{FALSE}				{
				  cool_yylval.boolean = false;
				  return (BOOL_CONST);
				}

 /* Integer literals */
{DIGITS}			{
				  cool_yylval.symbol = inttable.add_string(yytext);
				  return (INT_CONST);
				}


 /* Type and Object Identifiers */
[A-Z][a-zA-Z0-9_]+			{
				  cool_yylval.symbol = stringtable.add_string(yytext);
				  return (TYPEID);
				}

[a-z][a-zA-Z0-9_]+			{
				  cool_yylval.symbol = stringtable.add_string(yytext);
				  return (OBJECTID);
				}
				


 /* Eat up any whitespace */
[ \n\r\f\t\v]			{ if (*yytext == '\n') curr_lineno++; }		/* Increment line number upon newline */


 /* Handle any invalid characters */
.				{
				  cool_yylval.error_msg = yytext;
				  return (ERROR);
				}

%%
