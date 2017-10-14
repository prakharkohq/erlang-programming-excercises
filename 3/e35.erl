-module(e35).
-export([filter/2, reverse/1, concatinate/1, flatten/1]).

filter([], _) -> [];
filter([H|T], M) when H =< M -> [H|filter(T, M)];
filter([_|T], M) -> filter(T, M).

reverse(L) -> reverse(L, []).
reverse([], Acc) -> Acc;
reverse([H|T], Acc) -> reverse(T, [H|Acc]).

concatinate([]) -> [];
concatinate([H|T]) -> H ++ concatinate(T).

flatten([]) -> [];
flatten([H|T]) when is_list(H) ->
    concatinate([flatten(H), flatten(T)]);
flatten([H|T]) -> [H|flatten(T)].
