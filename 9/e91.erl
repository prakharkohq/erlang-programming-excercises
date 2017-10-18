-module(e91).
-export([print/1, filter/2, even/1, concat/1, sum/1]).

print(N) when is_number(N) ->
    print(lists:seq(1, N));
print(Seq) ->
    lists:map(fun(X) -> io:format("~p~n", [X]) end, Seq),
    ok.

filter(Seq, N) ->
    lists:filter(fun(X) -> X =< N end, Seq).

even(N) ->
    print(lists:filter(fun(X) -> X rem 2 == 0 end,
		       lists:seq(1, N))).

concat(Seq) ->
    lists:foldl(fun(X, Acc) -> Acc ++ X end, [], Seq).

sum(Seq) ->
    lists:foldl(fun(X, Acc) -> Acc + X end, 0, Seq).
