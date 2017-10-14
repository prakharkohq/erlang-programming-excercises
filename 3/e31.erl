-module(e31).
-export([sum/1, sum/2]).

sum(N) -> sum(1, N).

sum(N, M) when is_integer(N),
	       is_integer(M),
	       N =< M -> sum(N, M, M).

sum(M, M, Acc) -> Acc;
sum(N, M, Acc) -> sum(N+1, M, Acc+N).
