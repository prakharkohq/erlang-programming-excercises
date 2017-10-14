-module(e23).
-export([b_not/1, b_and/2, b_or/2, b_nand/2]).

b_not(false) -> true;
b_not(_) -> false.

b_and(false, _) -> false;
b_and(_, false) -> false;
b_and(_, _) -> true.

b_or(false, false) -> false;
b_or(_, _) -> true.

b_nand(A, B) -> b_not(b_and(A, B)).
