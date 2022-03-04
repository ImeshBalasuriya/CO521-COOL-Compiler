
(*
 *  execute "coolc bad.cl" to see the error messages that the coolc parser
 *  generates
 *
 *  execute "myparser bad.cl" to see the error messages that your parser
 *  generates
 *)

(* no error *)
class A {
};

(* error:  b is not a type identifier *)
Class b inherits A {
};

(* error: Ravisha is not a valid object identifier (Invalid Attribute) *)
Class C inherits A {
    imesh:Int <- 5;

    Ravisha:Int;
};


(* error: sleep() is not a valid method *)
Class C inherits A {
    imesh:Int <- 5;

    sleep():String { };
};


(* error: second and last let bindings are incorrect *)
Class C inherits A {
    imesh:Int <- 5;

    sleep():String {
	let a:Int <- 3, b:int <- 5, c:string, d:boolean <- 1 in abc
    };
};


(* error: second block expression is invalid *)
Class C inherits A {
    imesh:Int <- 5;

    sleep():String {
    {
	5 + 3;
	true < true < false;
	dsfdsf();
    }
    };
};



(* error:  a is not a type identifier *)
Class C inherits a {
};

(* error:  keyword inherits is misspelled *)
Class D inherts A {
};

(* error:  closing brace is missing *)
Class E inherits A {
;

