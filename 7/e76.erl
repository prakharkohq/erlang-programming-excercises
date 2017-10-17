-module(e76).
-export([test/0]).

-ifdef(show).
  -define(SHOW_EVAL(Expr),
	  (fun(R) -> io:format("~p = ~p~n", [??Expr, R]), R end)(Expr)).
-else.
  -define(SHOW_EVAL(Expr), Expr).
-endif.

test() -> ?SHOW_EVAL(1 + 1).
