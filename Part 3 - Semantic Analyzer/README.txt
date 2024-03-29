README file for Programming Assignment 4 (C++ edition)
======================================================

Your directory should now contain the following files:

 Makefile
 README
 ast-lex.cc		-> [cool root]/src/PA4/ast-lex.cc
 ast-parse.cc		-> [cool root]/src/PA4/ast-parse.cc
 bad.cl
 cgen			-> [cool root]/etc/../lib/.i
 cool-tree.cc		-> [cool root]/src/PA4/cool-tree.cc
 cool-tree.h
 cool-tree.handcode.h
 dumptype.cc		-> [cool root]/src/PA4/dumptype.cc
 good.cl
 handle_flags.cc	-> [cool root]/src/PA4/handle_flags.cc
 mycoolc		-> [cool root]/src/PA4/mycoolc
 mysemant		-> [cool root]/src/PA4/mysemant
 semant-phase.cc	-> [cool root]/src/PA4/semant-phase.cc
 semant.cc
 semant.h
 stringtab.cc		-> [cool root]/src/PA4/stringtab.cc
 symtab_example.cc	-> [cool root]/src/PA4/symtab_example.cc
 tree.cc		-> [cool root]/src/PA4/tree.cc
 utilities.cc		-> [cool root]/src/PA4/utilities.cc
 *.d			  dependency files

The include (.h) files for this assignment can be found in 
[cool root]/include/PA4

	The Makefile contains targets for compiling and running your
	program. DO NOT MODIFY.

	The README contains this info. Part of the assignment is to fill
	the README with the write-up for your project. You should
	explain design decisions, explain why your code is correct, and
	why your test cases are adequate. It is part of the assignment
	to clearly and concisely explain things in text as well as to
	comment your code.  Just edit this file.

	good.cl and bad.cl test a few features of the semantic checker.
	You should add tests to ensure that good.cl exercises as many
	legal semantic combinations as possible and that bad.cl
	exercises as many kinds of semantic errors as possible.

	semant.h contains declarations and definitions for the semantic
	analyzer.  Place class definitions for the structures you will
	use here.

	cool-tree.aps contains the definitions for the tree language
	which you use to construct the abstract syntax tree (AST).
	From this file, cool-tree.h and cool-tree.cc are automatically 
        generated by a utility that compiles the specification into
        C++ functions for producing and consuming the tree nodes.
        This file is provided for your reference.  DO NOT MODIFY.

        tree.{cc|h} contain definitions used by the tree package.  DO
        NOT MODIFY.

        cool-tree.h, and cool-tree.handcode.h specify and give an
        implementation of Cool ASTs (see the README for PA3 and the
        "Cool Tour").  In this assignment, you will need to add
        functions to the AST classes to store, fetch, and compute
        information about the AST.  Note that cool-tree.handcode.h
        differs slightly from the file supplied for PA3.

   	You should NOT remove any definitions that are already present
	in cool-tree.h and cool-tree.handcode.h.  These functions and
	data members are required for the system to function properly.

        You should add any fields and methods to the classes you need to 
	perform semantic analysis.  You	will need to add, for example, 
	methods which traverse the expressions of the tree and implement 
	the type-checking rules.

	cool-tree.cc contains definitions of the provided methods,
	and instantiations of the template for the list handling functions.
	You should not modify this file, but place definitions of all
	methods you add to cool-tree.h or cool-tree.handcode.h in semant.cc.
	DO NOT MODIFY cool-tree.cc

	semant.cc is the file in which you should write your semantic
	analyzer.  The main() procedure calls the method `semant'
	on `ast_root', the root of the abstract syntax tree generated by
	the parser.  There are methods supplied that you should use to report 
	errors. You are relatively free in how you decide to structure the 
	semantic checker, but don't modify the error printing routines.

	ast-lex.cc and ast-parse.cc implement a lexer and a parser for
	reading text representation of ASTs from console in the format
	produced by the parser phase. DO NOT MODIFY.

	semant-phase.cc contains a test driver for semantic analysis.
	The main program reads an AST in text form from standard input,
	parses it, and then produces a type-annotated AST on standard
	output.  The script mycoolc can pass any of the standard flags
	to the semantic analyzer as well; for this assignment, -s
	(semantic analysis debug) may be useful as it sets a global
	variable semant_debug to true (1).  If you want your semantic
	checker to print debug information when the option is set, write
	your debug code in the following format:

	      if (semant_debug)
	      {
		...
	      }

	semant_debug is provided as a convenience. You don't need to use
	the debugging flags if you don't want to. DON'T MODIFY
	semant-phase.cc

	symtab.h contains a symbol table implementation. Read the
	comments in the file, the "Cool Tour", and look at the example
	in symtab_example.cc.  You are not required to use this code,
	but you may find it useful. DO NOT MODIFY.

Instructions
------------

	To compile the example use of the symbol table, type

	% make symtab_example
        % ./symtab_example

	To compile your semantic analyzer program type:

	% make semant

	To test your semantic checker, type:

        % ./mysemant good.cl

	mysemant is a version of mycoolc that omits code generation.
	mysemant parses all the cool files given on the command line and
	builds a single abstract syntax tree containing all class
	definitions appearing in the input files. Your semantic checker
	is then called on this abstract syntax tree.  If there are no
	errors, the program produces a type-annotated abstract syntax
	tree as output.

	To run your checker on the files good.cl and bad.cl type:

	% make dotest

	If you think your semantic checker is correct and behaves like
	the one we wrote, you can try to run mycoolc using your checker,
	your parser and also your lexical analyzer if you choose (see
	below for instructions).  Remember if your lexer, parser or
	checker behaves in an unexpected manner, you may get errors
	anywhere.

	If you change architectures you must issue

	% make clean

	when you switch from one type of machine to the other.
	If at some point you get weird errors from the linker,	
	you probably forgot this step.

	GOOD LUCK!

---8<------8<------8<------8<---cut here---8<------8<------8<------8<---

Write-up for PA4
----------------
Group 06: 	E/17/018 (I.S Balasuriya)
			E/17/296 (R.H Rupasinghe)

All methods are in semant.h.

In Semant.cc::

ClassTable::ClassTable(Classes classes) : semant_errors(0) , error_stream(cerr) {} -- This is the constructor

A scope is defined before adding to the classes, symbol and method tables and basic classes were installed.

We need to traverse the list at least twice.
Pass 1-
The class list was traversed and the necessary class rules were checked; a class cannot be declared as SELF_TYPE,
a class cannot be redefined.
If they pass all the rules, then they were added to the classes_table.

Pass 2-
An inheritance tree was defined to avoid cycles among many other errors.
The following were checked:
Classes cannot inherit from undefined parent classes. 
Cannot inherit from SELF_TYPE, Int, Bool and Str.
Check for inheritance cycles.
The classes, starting from the Object class, were declared and typechecked.
Throw an error if the Main method is not found.

decl_class:
The scope was defined for the symbol_table and the method_table.
Each feature in the class were analyzed and were declared using a for loop.
The method_table and the symbol_table were added to the respective maps.
The child classes of the current class were recursively declared. Exit scope.

decl_attr:
The type of the current attribute was taken and it was checked whether it has been declared and whether the attribute name
is not self.
The previous definitions were checked to see whether the attribute is not redefined. Errors were thrown if necessary.
It was checked whether the class is trying to redefine an existing method name as attribute and necessary errors were thrown.
If the attribure is valid, they were added to the symbol_table.

decl_method:
The formals of the current method were obtained and for each formal, it was checked whether the formal name is self or not, 
whether it has several arguments with that name. If valid, they were added to the vector array holding the valid
formals. It was checked whether the current class was declared or not and whether
the current class is trying to redefine the attribute. Then, the method was declared and it was checked whether
the current class was trying to redefine the method with the same name or not.
 


Type checking functions:
1 - type_check_class: The name of the current class was obtained and it was checked whether it is either Object, Int, Str, IO or Bool.
The feature list was obtained and the attributes and the methods in the class were type-checked. Then the children classes were type-checked.
 
2 - type_check_attr: The initialized expression was type-checked.

3 - type_check_method: The expression of the method body and the expected return type of the method were obtained and the current
scope was started. The formal parameter list was iterated and their identifiers were added to the symbol table. Finally, the 
expression was typchecked with the expected return type. Exit scope.

4 - type_check_expression: The expression type was stored and type checking was done using a switch-case
block. The return Symbol from the appropriate type checking function was compared with the expected type.
It was checked whether the final type is of no_type and whether it is a descendant of the expected type, and errors were thrown if necessary.
The expression type was updated and the final type was returned.

5 - type_check_eq: For checking equality, both the left and right sides of the equal sign need to either have
the same type Int, String or Bool OR they could be of any type.

6 - type_check_assign: The validity of the identifier was checked; it cannot assign to self, need to check whether it was previously declared
in this scope. If the identifier is valid, the expression was typechecked and the corresponding expression type was returned.

7 - type_check_cond: First it was checked whether the predicate is of type Boolean. Then, a search was performed for the type of the lowest common ancestor
of the 'then' and 'else' expression types using the type_union function, and finally that type was returned.

8 - type_check_typcase: First the expression was typechecked. The case list was iterated and each branch was evaluated to get the identifier and the type. After
getting the type of each branch, it was checked whether it exists in the classes table. Then it was checked whether several branches exist with the same
type and errors were thrown if necessary. The valid branch type was added to the vector table, the scope was started, the identifier was added to the symbol_table. Exit scope.
The branch expression was type checked. Then finally the type union of all the branch types was returned.

9 - type_check_let: The scope of let was started. The type of the identifier was obtained. It was checked whether the type in let binding is defined and whether the identifier is
not of self type and the identifier was added to the symbol_table. The initialization expression and the body expression were typechecked. Exit scope. Finally the
type of the body was returned.

10 - type_check_dispatch: First the object type expression was typechecked, the dispatch was handled(uses handle_dispatch for this) and the return type of the method was obtained. 
If the return type of the method is of SELF_TYPE, then the return type was set to the object type found previously. Else, the return type of the method was returned.

11 - type_check_static_dispatch: The static type was obtained and it was checked whether it exists as a class. The return type of the method call was obtained using handle_dispatch.
The object expression in static dispatch was typechecked and the object type was obtained. If the return type of the method is of SELF_TYPE, then the return type 
was set to the object type found previously. Else, he return type of the method was returned.

12 - type_check_block: The expressions inside the block were typechecked and the type of the last expression was returned.

13 - type_check_object: It was checked whether the identifier exists in the current scope and the type was returned.

14 - type_check_new: If the class name used in the new expression is of SELF_TYPE, then SELF_TYPE was returned. Else, it was checked
whether the class name exists and the type of that class was returned.

15 - type_check_loop: The predicate (should be Bool) and the expression were typechecked.

type_union:
The inheritance chains of both types were considered and the common ancestor was found starting from the top of the chain. This function 
uses get_inheritance_chain. In get_inheritance_chain, the inheritance chain is added to a list and that 
path is returned. 






