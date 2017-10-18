-module(e93).
-export([zip/2, zip_with/3]).

zip(_, []) -> [];
zip([], _) -> [];
zip([X|Xs], [Y|Ys]) ->
    [{X, Y}|zip(Xs, Ys)].

zip_with(F, X, Y) ->
    [F(A, B) || {A, B} <- zip(X, Y)].
