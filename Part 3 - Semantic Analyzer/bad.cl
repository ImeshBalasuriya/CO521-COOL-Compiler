class C {
	a : Int;
	b : Bool;
	c : Bool;
	init(x : Int, y : Bool) : C {
           {
		a <- x;
		b <- y;
		self;
           }
	};

	fdd(): Int {dss()};
};

Class Mau {
	main():C {
	 {
	  (new C).init(1,false);
	  (new C).init(1,true,3);
	  (new C).iinit(1,true);
	  (new C);
	 }
	};
};

class A{
};

